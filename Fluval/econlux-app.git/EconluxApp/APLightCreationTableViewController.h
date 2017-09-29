//
//  APLightCreationTableViewController.h
//  EconluxApp
//
//  Created by Michael Müller on 07.02.15.
//  Copyright (c) 2015 AppPilots GbR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface APLightCreationTableViewController : UITableViewController
<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *labelTitleName;
@property (weak, nonatomic) IBOutlet UILabel *labelTitleSlot;
@property (weak, nonatomic) IBOutlet UILabel *labelTitleProduct;
@property (weak, nonatomic) IBOutlet UILabel *labelTitleSave;
@property (weak, nonatomic) IBOutlet UINavigationItem *NewLight;

@property (weak, nonatomic) IBOutlet UITextField *textName;
@property (weak, nonatomic) IBOutlet UITextField *textSlot;
@property (weak, nonatomic) IBOutlet UITextField *textProduct;




@end
