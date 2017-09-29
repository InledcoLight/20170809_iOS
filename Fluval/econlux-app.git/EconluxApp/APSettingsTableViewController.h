//
//  APSettingsTableViewController.h
//  EconluxApp
//
//  Created by Michael Müller on 05.02.15.
//  Copyright (c) 2015 AppPilots GbR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface APSettingsTableViewController : UITableViewController
<UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *labelVersion;
@property (nonatomic, weak) IBOutlet UISwitch *switchStatus;
@property (weak, nonatomic) IBOutlet UILabel *labelRenameGW;
@property (weak, nonatomic) IBOutlet UILabel *labelResetGW;
@property (weak, nonatomic) IBOutlet UILabel *labelChangePW;
@property (weak, nonatomic) IBOutlet UINavigationItem *Settings;
@property (weak, nonatomic) IBOutlet APBaseTableViewCell *cloudModeCell;
@property (weak, nonatomic) IBOutlet UILabel *labelCloudMode;

@end
