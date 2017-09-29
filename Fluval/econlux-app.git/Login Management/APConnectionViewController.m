//
//  ConnectionViewController.m
//  RemoteLights
//
//  Created by Ulf on 16.03.14.
//  Copyright (c) 2014 ISIS-IC GmbH. All rights reserved.
//

#import "APConnectionViewController.h"
#import "APGatewayConnector.h"
#import "APGateway.h"
#import "APAppDelegate.h"
#import <QuartzCore/QuartzCore.h>

#include <ifaddrs.h>
#include <arpa/inet.h>

@interface APConnectionViewController ()

@end

@implementation APConnectionViewController

// #####################################################

- (void) showError {
    self.labelError.text = APLocString(@"LOGIN_ERROR_RESTART_WIFI");
    self.labelError.hidden = false;
    self.loginButton.enabled = NO;
    self.loginButton.alpha = 0.3;

}

- (NSString *)getIPAddress {
	NSString *address = @"error";
	struct ifaddrs *interfaces = NULL;
	struct ifaddrs *temp_addr = NULL;
	int success = 0;
	
	// retrieve the current interfaces - returns 0 on success
	success = getifaddrs(&interfaces);
	if (success == 0) {
		// Loop through linked list of interfaces
		temp_addr = interfaces;
		while(temp_addr != NULL) {
			if(temp_addr->ifa_addr->sa_family == AF_INET) {
				// Check if interface is en0 which is the wifi connection on the iPhone
				if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
					// Get NSString from C String
					address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
				}

			}

			temp_addr = temp_addr->ifa_next;
		}
	}
	
	// Free memory
	freeifaddrs(interfaces);
	return address;
}

// ################################################

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"view did load");
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    [self onStartup];
    self.textFieldPassword.delegate = self;
    self.textFieldPassword.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"PASSWORD"];
}

- (void) onStartup {
    
    self.loginButton.enabled = NO;
    self.loginButton.alpha = 0.3;
    
    self.textFieldAddress.text = @"";
    globalIP = @"";
    fetchSuccess = false;
    fetchIpTryCount = 0;
    
    [self getValidIP];
}

- (void) getValidIP {
    self.labelInfo.text = APLocString(@"LOGIN_INFO_FETCHING_IP");
    self.labelInfo.hidden = false;
    self.labelError.hidden = true;
    self.labelError.text = APLocString(@"LOGIN_ERROR_NO_IP");
    self.textFieldAddress.text = @"";
    
    [self timerValidIP];
}

int fetchIpTryCount = 0;
bool fetchSuccess = false;

- (void) timerValidIP {
    //validate IP
    if (fetchIpTryCount<15 && !fetchSuccess) {
        fetchIpTryCount++;
        [NSTimer scheduledTimerWithTimeInterval:2
                                         target:self
                                       selector:@selector(checkIP)
                                       userInfo:nil
                                        repeats:NO
         ];
    }else{
        if(fetchSuccess){
            NSRange range = [globalIP rangeOfString:@"." options:NSBackwardsSearch];
            globalIP = [[globalIP substringToIndex:range.location+1] stringByAppendingString:@"1"];
            
            self.labelInfo.text = APLocString(@"LOGIN_INFO_IP_GOT");
            self.loginButton.enabled = YES;
            self.textFieldAddress.text = globalIP;
            self.loginButton.alpha = 1.0;
        }else{
            self.labelError.hidden = false;
            self.labelInfo.hidden = true;
        }
    }
}

NSString *globalIP;

- (void) checkIP {
    NSString *ipAddress;
    
    ipAddress = [self refreshIP];
    if([ipAddress isEqualToString:@"-1"]){
        
    }else{
        globalIP = ipAddress;
        fetchSuccess = true;
    }
    [self timerValidIP];
}

- (NSString *) refreshIP {
    // GET IP-ADDRESS
    NSString *ipAddress = [self getIPAddress];
    NSLog([NSString stringWithFormat:@"%@ %@", @"current IP:", ipAddress]);
    
    if(!ipAddress || [ipAddress isEqualToString:@"error"] || ![[ipAddress substringToIndex:3] isEqualToString:@"172"]) {
        if([[ipAddress substringToIndex:3] isEqualToString:@"169"]){
            self.labelError.text = APLocString(@"LOGIN_ERROR_RESTART_WIFI");
        }
        return @"-1";
    }
    return ipAddress;
//    return @"172.20.190.6";

}

- (void)appDidBecomeActive:(NSNotification *)notification {
    NSLog(@"did become active notification");
    [self onStartup];
}

- (void)viewDidAppear:(BOOL)animated
{
    NSLog(@"view did appear");
    
    [self.loginButton setBackgroundColor:CELL_BACKGROUND_COLOR];
    [self.textFieldPassword setBackgroundColor:CELL_BACKGROUND_COLOR];
    [[self.textFieldPassword layer] setBorderColor:[CELL_BACKGROUND_COLOR CGColor]];
    [[self.textFieldPassword layer] setBorderWidth:1];
    
	[super viewDidAppear:animated];

}

// ################################################

- (IBAction) connect {
    
    // SHOW THE ACTIVITY INDICATOR
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    UIBarButtonItem * barButton = [[UIBarButtonItem alloc] initWithCustomView:activityIndicator];
    [self navigationItem].leftBarButtonItem = barButton;
    [activityIndicator startAnimating];
    
	// GET OR CREATE GATEWAY
	NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:[APGateway entityName]];
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"host = %@", self.textFieldAddress.text];
	[req setPredicate:predicate];
    if(self.textFieldPassword.text.length<=0){
        [activityIndicator stopAnimating];
        [APAlert(APLocString(@"ALERT_ERROR"), APLocString(@"ALERT_WRONG_PW"), APLocString(@"ALERT_OK")) show];
        return;
    }
    // DISABLE UI
//    self.loginButton.enabled = NO;
    
	DLog(@"Trying connection to: %@:%d", self.textFieldAddress.text, 4000);
	
	APGateway *gateway = [[MOC executeFetchRequest:req error:nil] firstObject];
	if(!gateway)
		gateway = [APGateway insertInManagedObjectContext:MOC];
	[MOC save:nil];
	
	gateway.host = self.textFieldAddress.text;
	gateway.port = [NSString stringWithFormat:@"%d", 4000];
	
	// CONNECT TO GATEWAY
	[[APGatewayConnector sharedInstance] connectToHost:self.textFieldAddress.text port:4000 onCompletion:^(BOOL success) {
		
        [self.navigationItem setLeftBarButtonItem:nil];
        
		if(success) {
			
            // SAVE FOR LATER USE
            [[NSUserDefaults standardUserDefaults] setValue:self.textFieldAddress.text forKey:@"LAST_ADDRESS"];
            
			// SET THE CURRENT TIMESTAMP
			[gateway setLastConnect:[NSDate date]];
			[[gateway managedObjectContext] save:nil];
			
            NSString *password = self.textFieldPassword.text;
//			NSString *password = [[NSUserDefaults standardUserDefaults] valueForKey:@"PASSWORD"];
			if(password.length) {
				[self loginWithPassword:password];
			} else {
				[self showLoginScreen];
			}
			
		} else {
            if(!wrongPW){
                [self showError];
                [APAlert(APLocString(@"ALERT_ERROR"), APLocString(@"ALERT_GATEWAY_UNAVAILABLE"), APLocString(@"ALERT_OK")) show];
                self.loginButton.enabled = YES;
            }else{
                wrongPW = false;
            }
            self.loginButton.enabled = YES;
		}

	}];

}

// ################################################

- (void) showLoginScreen {
	
	// SHOW POPUP
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Password" message:@"Please provide the gateways password."
													   delegate:self cancelButtonTitle:nil otherButtonTitles:@"Login", nil] ;
	alertView.alertViewStyle = UIAlertViewStyleSecureTextInput;
	[alertView show];
}

// ################################################

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	[self loginWithPassword:[alertView textFieldAtIndex:0].text];
}

// ################################################

bool wrongPW = false;

- (void) loginWithPassword:(NSString *)password {
    APGatewayConnector *gwc = [[APGatewayConnector alloc] init];
    APConnectionManager* mng = [[APConnectionManager alloc] init];
    
    // SLEEP A BIT AFTER CONNECT
    [NSThread sleepForTimeInterval:0.25];
    
	// RE SHOW THE LOGIN POPUP IF NO PASSWORD WAS PROVIDED
	if(!password.length) {
        //[self showLoginScreen];
        wrongPW = true;
//        [gwc disconnect];
        [mng logout];
        [APAlert(APLocString(@"ALERT_ERROR"), APLocString(@"ALERT_WRONG_PW"), APLocString(@"ALERT_OK")) show];
        NSLog(@"###### 0");
	}
    NSLog(@"###### 1");
	[[APConnectionManager sharedInstance] loginWithPassword:password completion:^(BOOL success) {
        
        NSLog(@"###### 2");
        if(!success) {
            NSLog(@"###### 3");
//            [gwc disconnect];
            [mng logout];
            wrongPW = true;
            [APAlert(APLocString(@"ALERT_ERROR"), APLocString(@"ALERT_WRONG_PW"), APLocString(@"ALERT_OK")) show];
//			[self showLoginScreen];
			return;
		}
		
		[[NSUserDefaults standardUserDefaults] setValue:password forKey:@"PASSWORD"];
        
        NSLog(@"###### 4");
		// REQUEST GATEWAY NAME
		[[APConnectionManager sharedInstance] requestGatewayType:^(APGateway *gateway) {
            if((ECONLUX == 1 && gateway.typeValue != GATEWAY_5CH) || ECONLUX == 0 && gateway.typeValue != GATEWAY_2CH || !gateway) {
                
                NSLog(@"###### 5");
                [APAlert(APLocString(@"ALERT_ERROR"), APLocString(@"ALERT_GATEWAY_NO_INFO"), APLocString(@"ALERT_OK")) show];
                return;
            }
            
            NSLog(@"###### 6");
			// HIDE THE LOGIN SCREEN AND TELL THE APP, THAT ALL DATA IS LOADED
			[NDC postNotificationName:NOTE_GATEWAY_CONNECTED object:nil];
            [self dismissViewControllerAnimated:YES completion:nil];
            
            NSLog(@"###### 7");
			// COMMIT THE CURRENT TIME (SILENTLY)
			[[APConnectionManager sharedInstance] commitTime:^(BOOL success) {}];

		}];
		
	}];
	
}


// #####################################################

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

// #####################################################

@end

