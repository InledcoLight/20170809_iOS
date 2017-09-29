//
//  KPViewController.h
//  KPTimePickerExample
//
//  Created by Kasper Pihl Tornøe on 15/11/13.
//  Copyright (c) 2013 Pihl IT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KPTimePicker.h"

@interface APTimePickerViewController : UIViewController

@property (nonatomic, assign) int tag;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, copy) void (^onSelection)(int tag, NSDate *date);

@property (nonatomic,strong) KPTimePicker *timePicker;

@end
