//
//  APListSelectionViewController.m
//  MU by Peugeot
//
//  Created by Michael Müller on 06.11.14.
//  Copyright (c) 2014 Michael Müller. All rights reserved.
//

#import "APListSelectionViewController.h"
#import <FrameAccessor/FrameAccessor.h>

@interface APListSelectionViewController () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *viewDarkenBackground;
@property (weak, nonatomic) IBOutlet UIView *viewContainer;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contraintBottomSpaceContainer;

@end

@implementation APListSelectionViewController

// ################################################

static APListSelectionViewController *runningInstance;

// #####################################################

+ (instancetype)initSelectionViewControllerOnViewController:(UIViewController *)ctl {

    runningInstance = [APListSelectionViewController selectionViewController];
    [ctl addChildViewController:runningInstance];
    [runningInstance viewDidLoad];
    [ctl.view addSubview:runningInstance.view];
    runningInstance.view.frame = ctl.view.bounds;

    // GET VIEWS IN RANGE
    [runningInstance hide:NO completion:nil];

    return runningInstance;
}

// ################################################

+ (instancetype) selectionViewController {
	
	return [[UIStoryboard storyboardWithName:[[self class] description] bundle:nil] instantiateInitialViewController];
}

// ################################################

- (void)viewDidLoad {
	
	// CREATE THE SENSITIVE 
	UIGestureRecognizer *tap = [[UIGestureRecognizer alloc] initWithTarget:self action:@selector(close)];
	[self.viewDarkenBackground addGestureRecognizer:tap];
	
	self.contraintBottomSpaceContainer.constant = self.viewContainer.height * (-1);
	self.viewDarkenBackground.alpha = .0f;
	
	self.pickerView.delegate 	= self;
	self.pickerView.dataSource 	= self;
}

// ################################################

- (void)show:(BOOL)animated {
	
	[[self pickerView] reloadAllComponents];
	
	[UIView animateWithDuration:animated? .35f : .0f animations:^{
	
		self.contraintBottomSpaceContainer.constant = 0;
		self.viewDarkenBackground.alpha = .7;
		[self.view layoutIfNeeded];
		
	}];
}

// ################################################

- (void)hide:(BOOL)animated completion:(void(^)(void))completion {

	[UIView animateWithDuration:animated? .35f : .0f animations:^{

		self.contraintBottomSpaceContainer.constant = self.viewContainer.height * (-1);
		self.viewDarkenBackground.alpha = .0;
		[self.view layoutIfNeeded];
		
	} completion:^(BOOL finished) {
		if(completion)
			completion();
	}];

}

// ################################################


#pragma mark -
#pragma mark Events

- (void) close {

	[self hide:YES completion:^{
		if(self.onSelection)
			self.onSelection(nil, -1);
	}];
}

// ################################################

- (IBAction)done:(id)sender {
	
	[self hide:YES completion:^{
		if(self.onSelection)
			self.onSelection(self.values[[self.pickerView selectedRowInComponent:0]], (int)[self.pickerView selectedRowInComponent:0]);
	}];
}




#pragma mark -
#pragma mark Picker Delegate

// ################################################

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 1;
}

// ################################################

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	return self.values.count;
}

// ################################################

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	return self.values[row];
}

// ################################################

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	DLog(@"Did select %@", self.values[row]);
}

// ################################################

@end
