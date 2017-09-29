//
//  APConnectionManager.m
//  EconluxApp
//
//  Created by Michael Müller on 06.07.14.
//  Copyright (c) 2014 AppPilots GbR. All rights reserved.
//

#import "APConnectionManager.h"
#import "APGatewayConnector.h"
#import "APChannel.h"
#import "APPhase.h"
#import "APGateway.h"
#import "APConnectionViewController.h"

@implementation APConnectionManager

static APConnectionManager *sharedInstance;

+ (instancetype) sharedInstance {

	if(!sharedInstance) {
		sharedInstance = [APConnectionManager new];
		sharedInstance.dummyConnectionFlag = NO;
	}

	return sharedInstance;
}

// #####################################################

- (BOOL) login {
	
	if(!self.dummyConnectionFlag) {
		self.dummyConnectionFlag = YES;
		
		// COMMAND TO SHOW LOGIN FORM
		[NDC postNotificationName:NOTE_SHOW_LOGIN_SCREEN object:nil];

		return NO;
	}
	
	// TELL THE APP THAT THERE IS A GATEWAY CONNECTED
	[NDC postNotificationName:NOTE_GATEWAY_CONNECTED object:nil];
	return YES;
	
}

// #####################################################

- (void) logout {
    
    [[APGatewayConnector sharedInstance] disconnect];

    // SHOW LOGIN SCREEN ON INITIAL START
    APConnectionViewController *ctl = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateInitialViewController];
    [[[[[UIApplication sharedApplication] windows] firstObject] rootViewController] presentViewController:ctl animated:YES completion:nil];

}

// #####################################################


#pragma mark -
#pragma mark Gateway Endpoints

// #####################################################

- (void) requestGatewayType:(void (^)(APGateway *))completion {
	
	[[APGatewayConnector sharedInstance] queueCommand:@"gateway get info" completion:^(NSString *response) {
        
        response = [response stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
		NSArray *comps = [response componentsSeparatedByString:@" "];
        
		if(comps.count == 3) {
			
            NSString *typeStr = comps[0];
			NSString *name = comps[2];
            APGatewayMode mode = [[comps[1] uppercaseString] isEqualToString:@"A"]? APGatewayModeAutomatic : APGatewayModeManual;
			GatewayType type = [typeStr isEqualToString:@"5CH"]? GATEWAY_5CH : GATEWAY_2CH;
			
			DLog(@"GatewayInfo: %@ %@ %@", name, comps[1], comps[0]);
			
			APGateway *gateway = [APGateway currentGateway];
			gateway.name = name;
            gateway.typeValue = type;
            gateway.runningModeValue = mode;
			[[gateway managedObjectContext] save:nil];
			
			if(completion) {
				completion(gateway);
			}
		}
		else
		if(completion) {
			completion(nil);
		}
		
	}];

}

// ################################################

- (void) requestGatewayRenamingWithName:(NSString *)newName completion:(void (^)(BOOL))completion {

	[[APGatewayConnector sharedInstance] queueCommand:[NSString stringWithFormat:@"gateway set name %@", newName] completion:^(NSString *response) {
		
		if([response isEqualToString:@"OK"]) {
			if(completion) {
				completion(YES);
			}
			
			// SAVE NAME TO CORE DATA
			[[APGateway currentGateway] setName:newName];
			[MOC save:nil];
			return;
		}
		
		if(completion)
			completion(NO);
	}];
}

// ################################################

- (void) commitGatewayReset:(void (^)(BOOL))completion {
	
	[[APGatewayConnector sharedInstance] queueCommand:@"gateway factory reset" completion:^(NSString *response) {
		
		if([response isEqualToString:@"OK"]) {
			if(completion) {
				completion(YES);
			}
			return;
		}
		
		if(completion)
			completion(NO);
	}];
}

// #####################################################

- (void) commitGatewayMode:(APGatewayMode)mode completion:(void (^)(BOOL))completion {
    
    
    NSString *modeString = mode == APGatewayModeAutomatic? @"A" : @"M";
    [[APGatewayConnector sharedInstance] queueCommand:[NSString stringWithFormat:@"gateway set mode %@", modeString]  completion:^(NSString *response) {
        
        if([response isEqualToString:@"OK"]) {
            if(completion) {
                completion(YES);
            }
            return;
        }
        
        if(completion)
            completion(NO);
    }];
}

// #####################################################





#pragma mark -
#pragma mark Login Endpoints

// ################################################

- (void) loginWithPassword:(NSString *)password completion:(void (^)(BOOL))completion {
	
	[[APGatewayConnector sharedInstance] queueCommand:[NSString stringWithFormat:@"login %@", password] completion:^(NSString *response) {
		
		if(![response isEqualToString:@"OK"]) {
			if(completion) {
				completion(false);
			}
			return;
		}

		if(completion) {
			completion(YES);
		}

		
	}];
}

// ################################################

- (void) commitNewPassword:(NSString *)password completion:(void (^)(BOOL))completion {

	[[APGatewayConnector sharedInstance] queueCommand:[NSString stringWithFormat:@"login change %@", password] completion:^(NSString *response) {
		
		if(![response isEqualToString:@"OK"]) {
			if(completion) {
				completion(false);
			}
			return;
		}
		
		if(completion) {
			completion(YES);
		}
		
	}];
}

// ################################################


#pragma mark -
#pragma mark Name Requests


// #####################################################

- (void) requestNameForLight:(int)lightIndex completion:(void (^)(NSString *))completion {
	
	[[APGatewayConnector sharedInstance] queueCommand:[NSString stringWithFormat:@"light get name %02d", lightIndex] completion:^(NSString *response) {

		NSString *name = response;
		
		// CREATE CHANNEL WITH ATTRIBUTE
//		APLights *light = [APChannel insertInManagedObjectContext:MOC];
//		[channel setIndexValue:channelIdx];
//		[channel setName:name];
//		
//		[MOC save:nil];
	
		if(completion) {
			completion(name);
			return;
		}
	}];
}


// #####################################################

- (void) commitName:(NSString *)name forLight:(int)lightIndex completion:(void (^)(void))completion {

	// EARLY RETURN
	if(!name) {
		DLog(@"ERROR: No channel name was provided! Early returning...");
		if(completion)
			completion();
		return;
	}
	
	// SETUP COMMAND
	[[APGatewayConnector sharedInstance] queueCommand:[NSString stringWithFormat:@"light set name %02d %@", lightIndex, name] completion:^(NSString *response) {

		if(![[response uppercaseString] isEqualToString:@"OK"]) {
			[APAlert(APLocString(@"ALERT_ERROR"), APLocString(@"ALERT_LIGHT_NAME_NOT_SAVED"), APLocString(@"ALERT_OK")) show];
		}

		if(completion)
			completion();
		
	}];

}





#pragma mark -
#pragma mark Phases Requests

// ################################################

- (void) requestPhasesForChannel:(APChannel *)channel index:(int)index completion:(void (^)(NSArray *))completion {
	
	//
	// CREATE THE COMAND
	NSDateFormatter *hourFormatter = [NSDateFormatter new];
	[hourFormatter setDateFormat:@"HHmm"];

	[[APGatewayConnector sharedInstance] queueCommand:[NSString stringWithFormat:@"channel get graph %02d", index] completion:^(NSString *response) {
		
		NSMutableArray *components = [[response componentsSeparatedByString:@" "] mutableCopy];
		NSMutableArray *localPhases = [NSMutableArray new];
		
		// LOAD PHASES CONFIG FROM FILE
		NSString *path = [[NSBundle mainBundle] pathForResource:@"phases_config" ofType:@"json"];
		NSArray *phases = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:path] options:0 error:nil];

		// REMOVE OLD PHASES
		NSArray *oldPhases = channel.phases.allObjects;
		for(APPhase *phase in oldPhases) {
			phase.channel = nil;
		}
		
		// CREATE CORE DATA PHASES FROM JSON
		for(NSDictionary *phaseConfig in phases)
		{
			APPhase *phase = [APPhase insertInManagedObjectContext:MOC];
			
			phase.color = phaseConfig[@"color"];
			phase.startsLinear = phaseConfig[@"startsLinear"];
			phase.stopsLinear = phaseConfig[@"stopsLinear"];
			phase.sortValue = [phaseConfig[@"sort"] intValue];
			phase.isNeeded = phaseConfig[@"isNeeded"];
			phase.isBreak = phaseConfig[@"isBreak"];
			NSString *str = [NSString stringWithFormat:@"PHASE_%d", phase.sortValue+1];
			phase.name = APLocString(str);
			[channel addPhasesObject:phase];
			[localPhases addObject:phase];
		}

		[MOC save:nil];

		// RETURN EMPTY ARRAY
		if(components.count != 12) {
			DLog(@"Invalid number of phases. Returning clean phases list");
			if(completion)
				completion(localPhases);
			return;
		}
		
		// FILL PHASES
		[localPhases[0] setTimeFrom:[hourFormatter dateFromString:components[0]]];
		[localPhases[0] setTimeTo:[hourFormatter dateFromString:components[1]]];
		[localPhases[0] setValueValue:[components[3] intValue]];
		
		[localPhases[1] setTimeFrom:[hourFormatter dateFromString:components[4]]];
		[localPhases[1] setTimeTo:[hourFormatter dateFromString:components[5]]];
		[localPhases[1] setValueValue:[components[7] intValue]];

		// CREATE A VALID FREE BREAK
		if([components[4] intValue] == 0 && [components[5] intValue] == 0) {
			[localPhases[1] setTimeFrom:nil];
			[localPhases[1] setTimeTo:nil];
			[localPhases[1] setValueValue:0];
		}

		[localPhases[2] setTimeFrom:[hourFormatter dateFromString:components[8]]];
		[localPhases[2] setTimeTo:[hourFormatter dateFromString:components[9]]];
		[localPhases[2] setValueValue:[components[11] intValue]];

		[MOC save:nil];
        
        NSLog(@"%@", localPhases[0]);
		
		if(completion)
			completion(localPhases);
	}];
}

// ################################################

- (void) commitPhases:(NSArray *)rawPhases
		   forChannel:(int)channelIdx
		   completion:(void (^)(NSString *))completion {


	//
	// CREATE THE COMAND
	NSDateFormatter *hourFormatter = [NSDateFormatter new];
	[hourFormatter setDateFormat:@"HHmm"];
	
	NSMutableString *command = [@"channel set graph " mutableCopy];
	[command appendString:[NSString stringWithFormat:@"%02d", channelIdx]];
	
	// REMOVE META-MOON PHASE
	NSMutableArray *phases = [rawPhases mutableCopy];
	[phases removeLastObject];
	
	APPhase *phaseBefore = [phases lastObject];
    APPhase *firstPhase = [phases firstObject];
    int firstValue = firstPhase.valueValue;
    int i=0;
    for(APPhase *phase in phases) {
		
		// ADD FROM TIME
		NSString *time = [hourFormatter stringFromDate:phase.timeFrom];
		if(!time)
			time = @"0000";
		[command appendString:@" "];
		[command appendString:time];
		
		// ADD TO TIME
		time = [hourFormatter stringFromDate:phase.timeTo];
		if(!time)
			time = @"0000";
		[command appendString:@" "];
		
//		// THE LAST PHASE MUST END AT 24 NOT 00
//		if(phase == [phases lastObject]) {
//			time = @"2400";
//		}

		[command appendString:time];
		//ADD FROM VALUE
        if(i>=2){
            [command appendFormat:@" %03d", firstValue];
            [command appendFormat:@" %03d", phase.valueValue];
        }
        else{
            [command appendFormat:@" %03d", phaseBefore.valueValue];
            [command appendFormat:@" %03d", phase.valueValue];
        }
		phaseBefore = phase;
        i++;
	}
	
	[[APGatewayConnector sharedInstance] queueCommand:command completion:^(NSString *response) {
		
		NSArray *comps = [response componentsSeparatedByString:@" "];
		if(comps.count == 3) {
			
			NSString *name = comps[2];
			
			// CREATE CHANNEL WITH ATTRIBUTE
			APChannel *channel = [APChannel insertInManagedObjectContext:MOC];
			[channel setIndexValue:channelIdx];
			[channel setName:name];
			[MOC save:nil];
			
			if(completion) {
				completion(name);
				return;
			}
		}
		
		if(completion) {
			completion(@"");
		}
		
		
	}];
	
}

// ################################################






#pragma mark -
#pragma mark Channel Requests

// ################################################

- (void) requestValueForChannel:(int)channelIdx completion:(void (^)(int))completion {
	
	// SETUP COMMAND
	[[APGatewayConnector sharedInstance] queueCommand:[NSString stringWithFormat:@"channel get light %02d", channelIdx] completion:^(NSString *response) {
	
		int value = [response intValue];
		
		if(completion)
			completion(value);
	}];
}

// ################################################

- (void) commitValue:(int)value forChannel:(int)channelIdx completion:(void (^)(void))completion {

	// SETUP COMMAND
	[[APGatewayConnector sharedInstance] queueCommand:[NSString stringWithFormat:@"channel set light %02d %03d", channelIdx, value] completion:^(NSString *response) {
		
		if(![[response uppercaseString] isEqualToString:@"OK"]) {
			[APAlert(APLocString(@"ALERT_ERROR"), APLocString(@"ALERT_VALUE_NOT_SAVED"), APLocString(@"ALERT_OK")) show];
		}
		
		if(completion)
			completion();
	}];
}


// ################################################





#pragma mark -
#pragma mark Light Endpoints

- (void) requestTypeForLight:(int)slotIndex completion:(void (^)(int))completion {
	
	// SETUP COMMAND
	[[APGatewayConnector sharedInstance] queueCommand:[NSString stringWithFormat:@"light get type %02d", slotIndex] completion:^(NSString *response) {
		
		int type = [response intValue];
		if(completion)
			completion(type);
	}];
	
}

// ################################################

- (void) commitType:(int)type forLight:(int)slotIndex completion:(void (^)(BOOL))completion {
	
	// SETUP COMMAND
	[[APGatewayConnector sharedInstance] queueCommand:[NSString stringWithFormat:@"light set type %02d %d", slotIndex, type] completion:^(NSString *response) {
        
		if(![response isEqualToString:@"OK"]) {
			if(completion)
				completion(NO);
			DLog(@"ERROR: During light type set");
			return;
		}
		
		if(completion)
			completion(YES);
	}];
	
}


#pragma mark -
#pragma mark Utility Methods

- (void) commitTime:(void (^)(BOOL))completion {
	
	
	NSDate *date = [NSDate date];
	NSDateFormatter *formatter = [NSDateFormatter new];
	[formatter setDateFormat:@"HH:mm"];
	NSString *timeString = [formatter stringFromDate:date];
	
	// SETUP COMMAND
	[[APGatewayConnector sharedInstance] queueCommand:[NSString stringWithFormat:@"time set %@", timeString] completion:^(NSString *response) {
		
		if([response isEqualToString:@"OK"]) {
			if(completion)
				completion(YES);
			return;
		}
		
		if(completion)
			completion(NO);
	}];
}



@end
