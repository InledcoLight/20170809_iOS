//
//  APRadialColorPickerViewController.h
//  EconluxApp
//
//  Created by Michael Müller on 07.01.15.
//  Copyright (c) 2015 AppPilots GbR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <NKOColorPickerView/NKOColorPickerView.h>

@interface APRadialColorPickerViewController : UIViewController

@property (nonatomic, strong) UIColor *color;

@property (weak) IBOutlet NKOColorPickerView *colorPicker;
@property (weak) IBOutlet UIView *colorTagView;
@property (weak) IBOutlet UIButton *buttonCommit;

@property (copy) void (^selection)(UIColor *selectedColor);

@end
