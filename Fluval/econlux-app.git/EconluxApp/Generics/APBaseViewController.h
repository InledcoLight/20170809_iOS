//
//  APBaseViewController.h
//  FanEver
//
//  Created by Michael Müller on 26.03.14.
//  Copyright (c) 2014 AppPilots GbR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface APBaseViewController : UIViewController

@property (nonatomic, strong) UIView *loadingView;

- (void) showLoadingScreenWithMessage:(NSString *)msg;
- (void) hideLoadingScreen;

- (void) showNavigationSpinner;
- (void) hideNavigationSpinner;

@end
