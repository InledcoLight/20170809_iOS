//
//  APBaseViewController.m
//  FanEver
//
//  Created by Michael Müller on 26.03.14.
//  Copyright (c) 2014 AppPilots GbR. All rights reserved.
//

#import "APBaseViewController.h"
#import <RZSquaresLoading/RZSquaresLoading.h>





//#import "SLEmbossedInfoView.h"

@interface APBaseViewController ()

//@property (nonatomic, strong) SLEmbossedInfoView *errorView;

@end

@implementation APBaseViewController


// #####################################################

- (void) viewWillAppear:(BOOL)animated
{
        self.navigationController.navigationBar.topItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
}

// #####################################################

- (void) showLoadingScreenWithMessage:(NSString *)msg
{
    if(self.loadingView)
        return;
    
    UIView *loadingView = [[UIView alloc] initWithFrame:self.view.bounds];
    [loadingView setBackgroundColor: DARK_BACKGROUND_COLOR];
    
    RZSquaresLoading *squareLoading = [[RZSquaresLoading alloc] initWithFrame:CGRectMake(0, 0, 36, 36)];
    squareLoading.x = (CGRectGetWidth(self.view.frame)-36) / 2;
    squareLoading.y = (CGRectGetHeight(self.view.frame)-36) / 2;
    squareLoading.color = MAIN_COLOR;
	
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.height * 0.6, self.view.width, 40)];
	[label setText:msg];
	[label setTextColor:MAIN_COLOR];
	[label setTextAlignment:NSTextAlignmentCenter];
	[label setFont:[UIFont systemFontOfSize:14]];

	[loadingView addSubview:squareLoading];
	[loadingView addSubview:label];
	
    [self.view addSubview:loadingView];
    self.loadingView = loadingView;
}

// #####################################################

- (void) hideLoadingScreen
{
    [UIView animateWithDuration:.35f animations:^{
        self.loadingView.alpha = .0f;
    } completion:^(BOOL finished) {
        [self.loadingView removeFromSuperview];
        self.loadingView = nil;
    }];
}

// #####################################################

- (void) showNavigationSpinner
{
    UIActivityIndicatorView *activityIndicator =
    [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    UIBarButtonItem * barButton =
    [[UIBarButtonItem alloc] initWithCustomView:activityIndicator];
    
    // Set to Left or Right
    [[self navigationItem] setRightBarButtonItem:barButton];
    [activityIndicator startAnimating];
}

// #####################################################

- (void) hideNavigationSpinner
{
    [[self navigationItem] setRightBarButtonItem:nil];
}

//// #####################################################
//
//- (void) showErrorMessage:(NSString *)message detailedMessage:(NSString *)detailedText
//{
//    if(!self.errorView)
//    {
//        self.errorView = [[SLEmbossedInfoView alloc] initWithFrame:self.view.bounds];
//        [self.view addSubview:self.errorView];
//    }
//    
//    self.errorView.text = message;
//    self.errorView.detailedText = detailedText;
//}
//
//// #####################################################
//
//- (void) showErrorMessage:(NSString *)message
//{
//    [self showErrorMessage:message detailedMessage:nil];
//}
//
//// #####################################################

@end
