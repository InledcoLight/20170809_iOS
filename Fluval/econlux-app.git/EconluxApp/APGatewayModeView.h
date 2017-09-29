//
//  APGatewayModeView.h
//  EconluxApp
//
//  Created by Michael Müller on 27.02.15.
//  Copyright (c) 2015 AppPilots GbR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface APGatewayModeView : UIView

@property (nonatomic, weak) IBOutlet UILabel *labelStatus;
@property (nonatomic, weak) IBOutlet UISwitch *switchStatus;

@end
