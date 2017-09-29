//
//  APControlScrollViewController.h
//  EconluxApp
//
//  Created by Michael Müller on 16/07/14.
//  Copyright (c) 2014 AppPilots GbR. All rights reserved.
//

#import "APBaseViewController.h"

@interface APControlScrollViewController : APBaseViewController
<
	UIScrollViewDelegate
>

@property (nonatomic, strong) APChannel *channel;

@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *view;

@end
