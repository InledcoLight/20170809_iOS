//
//  ConnectionViewController.h
//  RemoteLights
//
//  Created by Ulf on 16.03.14.
//  Copyright (c) 2014 ISIS-IC GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APGateway.h"
#import "APGatewayConnector.h"

@interface APConnectionViewController : UIViewController <UITextFieldDelegate>


@property (nonatomic, strong) APGateway *gateway;

@property (weak, nonatomic) IBOutlet UITextField *textFieldPassword;
@property (weak, nonatomic) IBOutlet UILabel *labelInfo;
@property (weak, nonatomic) IBOutlet UITextField *textFieldAddress;
@property (weak, nonatomic) IBOutlet UILabel *labelError;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@end
