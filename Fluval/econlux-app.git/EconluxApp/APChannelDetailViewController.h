//
//  APChannelDetailViewController.h
//  EconluxApp
//
//  Created by Michael Müller on 06.06.14.
//  Copyright (c) 2014 AppPilots GbR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface APChannelDetailViewController : UITableViewController
<
	UITableViewDelegate
>

// SET FROM THE OUTSIDE
@property (nonatomic, strong) APPhase *phaseBefore;
@property (nonatomic, strong) APPhase *phase;
@property (nonatomic, assign) BOOL isLastPhase;

@property (weak, nonatomic) IBOutlet UILabel *labelDateTo;
@property (weak, nonatomic) IBOutlet UILabel *labelDateFrom;
@property (weak, nonatomic) IBOutlet UILabel *labelGivenValue;
@property (weak, nonatomic) IBOutlet UILabel *labelChannel;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UIView *viewColorTag;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *buttonReset;

@property (weak, nonatomic) IBOutlet UILabel *labelTitleStart;
@property (weak, nonatomic) IBOutlet UILabel *labelTitleStop;
@property (weak, nonatomic) IBOutlet UILabel *labelTitleGivenValue;
@property (weak, nonatomic) IBOutlet UILabel *labelTitleChanel;

@property (weak, nonatomic) IBOutlet UILabel *labelChangeColor;
@property (weak, nonatomic) IBOutlet UILabel *labelSave;
@property (weak, nonatomic) IBOutlet UILabel *labelCancel;

@end
