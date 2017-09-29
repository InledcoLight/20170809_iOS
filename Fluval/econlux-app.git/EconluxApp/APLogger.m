//
//  APLogger.m
//  EconluxApp
//
//  Created by Michael Müller on 23.02.15.
//  Copyright (c) 2015 AppPilots GbR. All rights reserved.
//

#import "APLogger.h"

@interface APLogger()

@property (nonatomic, strong) NSMutableString *loggings;

@end

@implementation APLogger


// #####################################################

+ (instancetype) sharedInstance {
	
	static APLogger *logger;
	if(!logger) {
		logger = [APLogger new];
		logger.loggings = [NSMutableString new];
	}
	
	return logger;
}

// #####################################################

- (void) log:(NSString *)message {
	
	[self.loggings appendFormat:@"%@\n", message];
	NSLog(@"%@", message);
}

// #####################################################

- (void) emailLogs {
	
	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	
	if ([MFMailComposeViewController canSendMail]) {
		picker.mailComposeDelegate = self;
		[picker setToRecipients:@[@"michael.mueller@app-pilots.de"]];
		[picker setMessageBody:self.loggings isHTML:NO];
		[picker setSubject:@"Econlux # Logfiles"];
		[[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:picker animated:YES completion:nil];
	}
	
}

// #####################################################



@end
