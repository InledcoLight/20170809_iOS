//
//  APRadialColorPickerViewController.m
//  EconluxApp
//
//  Created by Michael Müller on 07.01.15.
//  Copyright (c) 2015 AppPilots GbR. All rights reserved.
//

#import "APRadialColorPickerViewController.h"

@interface APRadialColorPickerViewController ()


@end

@implementation APRadialColorPickerViewController

// ################################################

- (void)viewDidLoad {

	self.title = APLocString(@"PHASE_DETAIL_CHOOSE_COLOR");
	self.colorPicker.backgroundColor = CONTAINER_COLOR;
	self.colorPicker.color = self.color;
	self.view.backgroundColor = CONTAINER_COLOR;
	
	self.colorTagView.layer.cornerRadius = self.colorTagView.width/2;
	self.colorTagView.layer.masksToBounds = YES;
	self.colorTagView.backgroundColor = self.color;
	
	[self.colorPicker setDidChangeColorBlock:^(UIColor *color) {
	
		self.colorTagView.backgroundColor = color;
		self.color = color;
	}];
}

// ################################################

- (IBAction)save:(id)sender {
	
	if(self.selection)
		self.selection(self.color);
	
	[self.navigationController popViewControllerAnimated:YES];

}

// ################################################

@end
