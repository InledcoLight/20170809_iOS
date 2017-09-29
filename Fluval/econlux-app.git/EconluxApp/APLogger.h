//
//  APLogger.h
//  EconluxApp
//
//  Created by Michael Müller on 23.02.15.
//  Copyright (c) 2015 AppPilots GbR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface APLogger : NSObject
<
	MFMailComposeViewControllerDelegate
>

+ (instancetype) sharedInstance;

- (void) log:(NSString *)message;
- (void) emailLogs;

@end
