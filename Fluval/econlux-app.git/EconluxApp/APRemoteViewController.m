//
//  APRemoteViewController.m
//  EconluxApp
//
//  Created by Michael Müller on 08/07/14.
//  Copyright (c) 2014 AppPilots GbR. All rights reserved.
//

#import "APRemoteViewController.h"
#import "APGatewayConnector.h"

#define COLOR_ON [UIColor colorWithRed:1 green:1 blue:1 alpha:1]
#define COLOR_OFF [UIColor colorWithRed:0.62 green:0.62 blue:0.62 alpha:1]


#define SWITCH_X_MIN 2
#define SWITCH_X_MAX 157

@interface APRemoteViewController ()

@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewBackground;
@property (nonatomic, assign) BOOL isOn;

@property (nonatomic, assign) CGPoint lastLocation;
@property (nonatomic, strong) NSDate *lastCommit;

@end

@implementation APRemoteViewController

// ################################################

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.remoteControlPicker setBackgroundColor:CONTAINER_COLOR];
	UIImage *imgOn = [UIImage imageNamed:@"lightbulb_on"];
	imgOn = [imgOn imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
	UIImage *imgOff = [UIImage imageNamed:@"lightbulb_off"];
	imgOff = [imgOff imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
	self.imageViewEdisonOn.image = imgOn;
	self.imageViewEdisonOff.image = imgOff;

	[self.imageViewSwitch addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeSwitch:)]];
	[self.imageViewSwitch addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pannedView:)]];
	
	[self.imageViewSwitch setUserInteractionEnabled:YES];

	self.isOn = YES;
	[self setBinarySwitchToState:YES animated:NO isDragging:NO];
	
	self.labelOn.text = APLocString(@"REMOTE_ON");
	self.labelOff.text = APLocString(@"REMOTE_OFF");
	
	self.labelTitle.text = self.channel.configuration.label;

	[self.dimmingSwitch addObserver:self forKeyPath:@"progress" options:NSKeyValueObservingOptionNew context:nil];
    
    // INITIALLY HIDE ALL UI TILL THE DATA IS LOADED
    self.switchContainerView.alpha = .0f;
    self.dimmingSwitch.alpha = .0f;
}

// ################################################

- (void)viewWillDisappear:(BOOL)animated {
	
	[self.dimmingSwitch removeObserver:self forKeyPath:@"progress"];
    [[APGatewayConnector sharedInstance] setDirectControlMode:NO];
}

// ################################################

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	
	float progress = [self.dimmingSwitch progress];
	//DLog(@"New progress: %.2f", progress);

	if(self.lastCommit && [self.lastCommit timeIntervalSinceDate:[NSDate date]] > -0.10) {
		//DLog(@"Skipping update... to fast!");
	} else {
		DLog(@"Commiting progress...");
		self.lastCommit = [NSDate date];
		[self commitValue:progress];
	}
	
	if((int)progress > 0) {
		[self setBinarySwitchToState:YES animated:YES isDragging:NO];
	} else {
		[self setBinarySwitchToState:NO animated:YES isDragging:NO];
	}
}

// ################################################

- (void)viewWillAppear:(BOOL)animated {
	
	[super viewWillAppear:animated];
	[self loadChannelValue];
}

// ################################################

- (void) loadChannelValue {
	
	int channelOffset = [self.channel indexOffset];
	
	for(NSString *index in self.channelIndizes) {
	
		[[APConnectionManager sharedInstance] requestValueForChannel:channelOffset + [index intValue] completion:^(int value) {
			
			[self.dimmingSwitch setProgress:(float)value];
			[self setBinarySwitchToState:value animated:YES isDragging:NO];
			
            [[APGatewayConnector sharedInstance] setDirectControlMode:YES];

            // ANIMATE CONTROL UI TO BE VISIBLE
            [UIView animateWithDuration:.3f animations:^{
                self.switchContainerView.alpha = 1.0f;
                self.dimmingSwitch.alpha = 1.0f;
                self.activityIndicator.alpha = .0f;
            }];
		}];
	}
	
}


// #####################################################

- (void) commitValue:(int)value {
	
	int channelOffset = [self.channel indexOffset];
	
	for(NSString *index in self.channelIndizes) {
		
		//[[APConnectionManager sharedInstance] commitValue:value forChannel:channelOffset + [index intValue] completion:nil];
        // SETUP COMMAN
        //NSLog(@"%d",value);
        [[APGatewayConnector sharedInstance] queueCommand:[NSString stringWithFormat:@"channel set light %02d %03d", channelOffset + [index intValue], value] completion:^(NSString *response) {
            
        }];
	}
	
}


// ################################################

- (void) setBinarySwitchToState:(BOOL)enabled animated:(BOOL)animated isDragging:(BOOL)isDragging {
	
	[UIView animateWithDuration:.3f animations:^{

		self.imageViewEdisonOn.tintColor = enabled? COLOR_ON : COLOR_OFF;
		self.labelOn.textColor = enabled? COLOR_ON : COLOR_OFF;
		
		self.imageViewEdisonOff.tintColor = enabled? COLOR_OFF : COLOR_ON;
		self.labelOff.textColor = enabled? COLOR_OFF : COLOR_ON;
		
		if(!isDragging)
			self.imageViewSwitch.x = enabled? SWITCH_X_MIN : SWITCH_X_MAX;

	}];
}

// ################################################

- (void) changeSwitch:(UIGestureRecognizer *)recognizer {
	
	self.isOn = !self.isOn;
	[self setBinarySwitchToState:self.isOn animated:YES isDragging:NO];
	self.dimmingSwitch.progress = self.isOn * 100;
}

// ################################################

- (void)setIsOn:(BOOL)isOn {
	
	_isOn = isOn;
	[self setBinarySwitchToState:self.isOn animated:YES isDragging:NO];
	self.dimmingSwitch.progress = self.isOn * 100;
}

// ################################################

- (void) pannedView:(UIPanGestureRecognizer *)recognizer {
	
	CGPoint translation = [recognizer translationInView:recognizer.view];
	CGPoint new = CGPointMake(recognizer.view.center.x + translation.x, recognizer.view.center.y);
	
	recognizer.view.center = new;
	[recognizer setTranslation:CGPointMake(0, 0) inView:recognizer.view];
	
	if(recognizer.view.x < SWITCH_X_MIN)
		recognizer.view.x = SWITCH_X_MIN;
	if(recognizer.view.x > SWITCH_X_MAX)
		recognizer.view.x = SWITCH_X_MAX;
	

	// DO THE SNAPPING
	float ratio = new.x / self.imageViewBackground.width;
	_isOn = ratio < 0.55? YES : NO;

	// DO THE SNAPPING ON END
	if(recognizer.state == UIGestureRecognizerStateEnded) {
		
		[self setBinarySwitchToState:_isOn animated:YES isDragging:NO];
		self.dimmingSwitch.progress = self.isOn * 100;
		
	}
}

// ################################################
@end
