//
//  APNavigationController.m
//  EconluxApp
//
//  Created by Michael Müller on 08.02.15.
//  Copyright (c) 2015 AppPilots GbR. All rights reserved.
//

#import "APNavigationController.h"

@interface APNavigationController ()

@end

@implementation APNavigationController


- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
	UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
								   initWithTitle: @""
								   style: UIBarButtonItemStylePlain
								   target: nil action: nil];
	
	[[[self.viewControllers lastObject] navigationItem] setBackBarButtonItem:backButton];
//	[backButton setTintColor:[UIColor colorWithRed:0.071 green:0.489 blue:0.901 alpha:1.000]]; //this made the navigationView Buttons tint dark blue
	[[UIBarButtonItem appearance] setTintColor:backButton.tintColor];
    
	[super pushViewController:viewController animated:animated];
}

@end
