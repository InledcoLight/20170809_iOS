//
//  APControlScrollViewController.m
//  EconluxApp
//
//  Created by Michael Müller on 16/07/14.
//  Copyright (c) 2014 AppPilots GbR. All rights reserved.
//

#import "APControlScrollViewController.h"
#import "APRemoteViewController.h"

@interface APControlScrollViewController ()

@property (nonatomic, strong) NSArray *controllers;
@property (weak, nonatomic) IBOutlet UIPageControl *pageViewIndicator;
@property (weak, nonatomic) IBOutlet UILabel *lableTitle;

@end

@implementation APControlScrollViewController

// ################################################

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.scrollView setBackgroundColor:CONTAINER_COLOR];
    
    //[self.closeButton setImage:[UIImage imageNamed:@"round_backarrow_big"] forState:UIControlStateNormal];
    //[self.closeButton setImage:[UIImage imageNamed:@"round_backarrow_big-high"] forState:UIControlStateHighlighted];
    
	APRemoteViewController *ctl = [self.storyboard instantiateViewControllerWithIdentifier:@"APRemoteViewController"];
	[ctl setChannel:self.channel];
	[ctl setChannelIndizes:[self.channel.configuration indizesAsArray]];
	
	[self addChildViewController:ctl];

	// ADD AN POSITION THE VIEW
	[self.scrollView addSubview:ctl.view];
	ctl.view.frame = CGRectMake(0 * self.scrollView.width, 0, self.scrollView.width, self.scrollView.height);

	// MANAGE SCROLL VIEW
	self.scrollView.contentSize = CGSizeMake(0 * self.scrollView.width, self.scrollView.height);
	self.scrollView.pagingEnabled = YES;
	self.scrollView.showsHorizontalScrollIndicator = NO;
	self.scrollView.showsVerticalScrollIndicator = NO;
	self.scrollView.delegate = self;
	self.pageViewIndicator.numberOfPages = 1;
	
	self.lableTitle.text = APLocString(@"REMOTE_TITLE");
	self.scrollView.contentOffsetX = 0;
}

// ################################################

- (IBAction)close:(id)sender {
	
	[self dismissViewControllerAnimated:YES completion:nil];
}

// ################################################

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	
	[scrollView setContentOffset: CGPointMake(scrollView.contentOffset.x, 0)];
	self.pageViewIndicator.currentPage = (scrollView.contentOffset.x + scrollView.width/2) / scrollView.width;
}

// ################################################

@end
