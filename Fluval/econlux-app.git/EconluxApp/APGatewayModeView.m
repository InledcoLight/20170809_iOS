//
//  APGatewayModeView.m
//  EconluxApp
//
//  Created by Michael Müller on 27.02.15.
//  Copyright (c) 2015 AppPilots GbR. All rights reserved.
//

#import "APGatewayModeView.h"

@implementation APGatewayModeView


// #####################################################

- (IBAction)didChangeSwitch:(id)sender {
    
    NSLog(@"Did change gateway mode");
    
	[[APConnectionManager sharedInstance] commitGatewayMode:self.switchStatus.isOn? APGatewayModeAutomatic : APGatewayModeManual completion:^(BOOL success) {
        
        if(!success) {
            [APAlert( APLocString(@"ALERT_ERROR"), APLocString(@"ALERT_COMITING_GW"), APLocString(@"ALERT_OK")) show];
            return;
        }
        
		[[APGateway currentGateway] setRunningModeValue:self.switchStatus.isOn? APGatewayModeAutomatic : APGatewayModeManual];
        [[[APGateway currentGateway] managedObjectContext] save:nil];
        [self setNeedsLayout];
        
    }];
    
}

// #####################################################

- (void)layoutSubviews {

	[super layoutSubviews];
	
    [self.switchStatus setOn:[[APGateway currentGateway] runningModeValue] != APGatewayModeManual];
    [self.labelStatus setText:[NSString stringWithFormat:APLocString(@"GATEWAY_MODE"), self.switchStatus.isOn? APLocString(@"GATEWAY_MODE_AUTOMATIC") : APLocString(@"GATEWAY_MODE_MANUAL")]];
}

// #####################################################

@end
