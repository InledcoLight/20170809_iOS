f//
//  KPViewController.m
//  KPTimePickerExample
//
//  Created by Kasper Pihl Tornøe on 15/11/13.
//  Copyright (c) 2013 Pihl IT. All rights reserved.
//

#import "APTimePickerViewController.h"
#import "KPTimePicker.h"
#import "Categories.h"
@interface APTimePickerViewController () <KPTimePickerDelegate, UIGestureRecognizerDelegate>

@property (nonatomic,weak) IBOutlet UIButton *setTimeButton;
@property (nonatomic,weak) IBOutlet UILabel *statusLabel;
@property (nonatomic,strong) UILongPressGestureRecognizer *longPressGestureRecognizer;
@property (nonatomic,strong) UIPanGestureRecognizer *panRecognizer;

@end

@implementation APTimePickerViewController

// ################################################

- (void)timePicker:(KPTimePicker *)timePicker selectedDate:(NSDate *)date
{
	// HANDLE DATE SELECTION
	[self dismissViewControllerAnimated:YES completion:nil];
	if(self.onSelection)
		self.onSelection(self.tag, date);
}

// ################################################

- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    if([otherGestureRecognizer isEqual:self.panRecognizer] && !self.timePicker) return NO;
    return YES;
}

// ################################################

- (void)panRecognized:(UIPanGestureRecognizer*)sender
{
	if(!self.timePicker) return;
    [self.timePicker forwardGesture:sender];
}

// ################################################

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

// ################################################

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	return self;
}

// ################################################

- (id)initWithCoder:(NSCoder *)aDecoder {

	self = [super initWithCoder:aDecoder];
	return self;
}

// ################################################

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)])
	{
        [self setNeedsStatusBarAppearanceUpdate];
    }
	
    self.timePicker = [[KPTimePicker alloc] initWithFrame:self.view.bounds];
    self.timePicker.delegate = self;

	self.timePicker.pickingDate = self.date? self.date : [[NSDate date] dateAtStartOfDay];	
//    self.timePicker.minimumDate = [self.timePicker.pickingDate dateAtStartOfDay];
//    self.timePicker.maximumDate = [[[self.timePicker.pickingDate dateByAddingMinutes:(60*24)] dateAtStartOfDay] dateBySubtractingMinutes:5];
	self.timePicker.dayLabel.hidden = YES;
	
    [self.setTimeButton addGestureRecognizer:self.longPressGestureRecognizer];
    self.panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panRecognized:)];
	
	[self.view addGestureRecognizer:self.panRecognizer];

	[self.view addSubview:self.timePicker];
	


}
// ################################################

- (void)setDate:(NSDate *)date {
	_date = date;
	self.timePicker.pickingDate = self.date? self.date : [[NSDate date] dateAtStartOfDay];
}

// ################################################

@end
