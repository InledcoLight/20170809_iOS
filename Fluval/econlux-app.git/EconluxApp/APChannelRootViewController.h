//
//  APChannelRootViewController.h
//  EconluxApp
//
//  Created by Michael Müller on 10.04.14.
//  Copyright (c) 2014 AppPilots GbR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APGraphView.h"
#import "APBaseViewController.h"
#import "APListSelectionViewController.h"

typedef enum {
	SECTION_PHASES = 0,
	SECTION_COLOR = 1,
	SECTION_SWITCH = 97,
	SECTION_BUTTONS = 2
} SectionTypes;

@interface APChannelRootViewController : APBaseViewController
<
	UITableViewDataSource,
	UITableViewDelegate,
	UITextFieldDelegate
>


// SET FROM THE OUTSIDE
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet APGraphView *graphView;
@property (nonatomic, weak) UITextField *textFieldName;

@property (nonatomic, weak) APChannel *channel;

@end
