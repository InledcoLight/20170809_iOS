//
//  APRemoteViewController.h
//  EconluxApp
//
//  Created by Michael Müller on 08/07/14.
//  Copyright (c) 2014 AppPilots GbR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APBaseViewController.h"
#import "APDimmingSwitch.h"

@interface APRemoteViewController : APBaseViewController

@property (weak, nonatomic) IBOutlet UIImageView *imageViewEdisonOn;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewEdisonOff;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewSwitch;
@property (weak, nonatomic) IBOutlet UIView *remoteControlPicker;

@property (weak, nonatomic) IBOutlet UILabel *labelOn;
@property (weak, nonatomic) IBOutlet UILabel *labelOff;

@property (weak) IBOutlet APDimmingSwitch *dimmingSwitch;
@property (weak) IBOutlet UIView *switchContainerView;
@property (weak) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (nonatomic, strong) APChannel *channel;
@property (nonatomic, strong) NSArray *channelIndizes;


@end
