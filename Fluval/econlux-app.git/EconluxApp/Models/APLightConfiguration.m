//
//  APLightConfiguration.m
//  EconluxApp
//
//  Created by Michael Müller on 18.02.15.
//  Copyright (c) 2015 AppPilots GbR. All rights reserved.
//

#import "APLightConfiguration.h"

@implementation APLightConfiguration


+ (NSArray *) getConfigurations {
    // ToDo
    NSString *pathToConfig = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@%@",@"EconluxConfiguration",APLocString(@"LANGUAGE")] ofType:@"json"];
//	NSString *pathToConfig = [[NSBundle mainBundle] pathForResource:@"EconluxConfigurationEnglish" ofType:@"json"];
	NSArray *configurationsRaw = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:pathToConfig] options:0 error:nil];
	NSMutableArray *configurationsNative = [[NSMutableArray alloc] initWithCapacity:configurationsRaw.count];
	
	for(NSDictionary *config in configurationsRaw) {
		APLightConfiguration *lightConfiguration = [[APLightConfiguration alloc] initWithDictionary:config];
		
		if([lightConfiguration.type intValue] == [[APGateway currentGateway] typeValue]) {
			[configurationsNative addObject:lightConfiguration];
		}
	}

	return configurationsNative;
}

// ################################################

+ (APLightConfiguration *) configurationByIdentifier:(int)identifier {
	
	for(APLightConfiguration *config in [APLightConfiguration getConfigurations]) {
		
		if(config.identifier.intValue == identifier) {
			return config;
		}
	}
	
	return nil;
}

// ################################################

@end
