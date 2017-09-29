//
//  APSettingsTableViewController.m
//  EconluxApp
//
//  Created by Michael Müller on 05.02.15.
//  Copyright (c) 2015 AppPilots GbR. All rights reserved.
//

#import "APSettingsTableViewController.h"
#import "APGateway.h"
#import "APGatewayConnector.h"
#import "APConnectionManager.h"

@interface APSettingsTableViewController ()

@end

@implementation APSettingsTableViewController

// ################################################

- (void)viewDidLoad {
    
    //TODO make a slide bar for cloud mode on CON2
    if(ECONLUX==1){
        self.cloudModeCell.hidden = true;
    }

    
    [super viewDidLoad];
    self.tableView.backgroundColor = CONTAINER_COLOR;
    [self.tableView setSeparatorColor:CONTAINER_COLOR];
    
    self.labelChangePW.text = APLocString(@"SETTINGS_CHANGE_PW");
    self.labelResetGW.text = APLocString(@"SETTINGS_RESET_GW");
    self.labelRenameGW.text = APLocString(@"SETTINGS_RENAME_GW");
    self.Settings.title = APLocString(@"SETTINGS_TITLE");
    
    [[APGatewayConnector sharedInstance] queueCommand:@"cloud get" completion:^(NSString *response) {
        if([response isEqualToString:@"00"]){
            [self.switchStatus setOn:false];
            [self.labelCloudMode setText:[NSString stringWithFormat:APLocString(@"SETTINGS_CLOUD_MODE"), APLocString(@"SETTINGS_CLOUD_MODE_OFF")]];
        }
        else if ([response isEqualToString:@"01"]){
            [self.labelCloudMode setText:[NSString stringWithFormat:APLocString(@"SETTINGS_CLOUD_MODE"), APLocString(@"SETTINGS_CLOUD_MODE_ON")]];
            [self.switchStatus setOn:true];
        }
    }];
    //[self.labelCloudMode setText:[NSString stringWithFormat:APLocString(@"SETTINGS_CLOUD_MODE"), self.switchStatus.isOn? APLocString(@"SETTINGS_CLOUD_MODE_ON") : APLocString(@"SETTINGS_CLOUD_MODE_OFF")]];
}

// ################################################

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.labelVersion.text = [self version];
}

// ################################################

- (void)changePassword {
    
    // SHOW RENAME POPUP
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:APLocString(@"SETTINGS_CHANGE") message:APLocString(@"SETTINGS_CHANGE_PW_INFO")
                                                       delegate:self cancelButtonTitle:APLocString(@"SETTINGS_CANCEL") otherButtonTitles:APLocString(@"SETTINGS_SET"), nil] ;
    alertView.alertViewStyle = UIAlertViewStyleSecureTextInput;
    alertView.tag = 1;
    [alertView show];
}

// ################################################

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    
    // HANDLE PASSWORD ALERT VIEW
    if(alertView.tag == 1) {
        
        if(buttonIndex) {
            
            // CHECK THE PASSWORD ENTRY
            NSString *newPassword = [[alertView textFieldAtIndex:0] text];
            if(!newPassword.length) {
                [APAlert(APLocString(@"ALERT_ERROR"), APLocString(@"INVALID_PW"), APLocString(@"ALERT_OK")) show];
                return;
            }
            
            // COMMIT THE CHANGES
            [[APConnectionManager sharedInstance] commitNewPassword:newPassword completion:^(BOOL success) {
                
                if(!success) {
                    [APAlert(APLocString(@"ALERT_ERROR"), APLocString(@"CHANGE_PW_ERROR"), APLocString(@"ALERT_OK")) show];
                }
            }];
            
        }
    }
    
    // HANDLE GATEWAY RENAMING
    else if(alertView.tag == 2) {
        
        if(buttonIndex) {
            
            UITextField *alertTextField = [alertView textFieldAtIndex:0];
            
            if(!alertTextField.text.length) {
                [APAlert(APLocString(@"ALERT_WARNING"), APLocString(@"ALERT_GATEWAY_NOT_RENAMED_NO_NAME"), APLocString(@"ALERT_OK")) show];
                return;
            }
            
            [[APConnectionManager sharedInstance] requestGatewayRenamingWithName:[alertTextField.text stringByReplacingOccurrencesOfString:@" " withString:@"-"] completion:^(BOOL success) {
                
                APGateway *gateway = [APGateway currentGateway];
                if(success) {
                    [gateway setName:alertTextField.text];
                    [[self tableView] reloadData];
                } else {
                    [APAlert(APLocString(@"ALERT_ERROR"), APLocString(@"ALERT_GATEWAY_NOT_RENAMED"), APLocString(@"ALERT_OK")) show];
                }
                
            }];
            
        }
        
    }
    
    
}

// #####################################################

- (NSString*) version {
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *build = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    return [NSString stringWithFormat:@"%@ build %@", version, build];
}

// ################################################

- (IBAction)cloudModeDidChange:(id)sender {
    
    NSLog(@"Cloud Mode did change");
    if([self.switchStatus isOn]){
        [[APGatewayConnector sharedInstance] queueCommand:@"cloud set" completion:^(NSString *response) {
            
            [[APGateway currentGateway] setRunningModeValue:self.switchStatus.isOn? APGatewayModeManual : APGatewayModeAutomatic];
            [[[APGateway currentGateway] managedObjectContext] save:nil];
        }];
    }
    else{
        [[APGatewayConnector sharedInstance] queueCommand:@"cloud reset" completion:^(NSString *response) {
            
            [[APGateway currentGateway] setRunningModeValue:self.switchStatus.isOn? APGatewayModeManual : APGatewayModeAutomatic];
            [[[APGateway currentGateway] managedObjectContext] save:nil];
        }];
    }
    [self.labelCloudMode setText:[NSString stringWithFormat:APLocString(@"SETTINGS_CLOUD_MODE"), self.switchStatus.isOn? APLocString(@"SETTINGS_CLOUD_MODE_ON") : APLocString(@"SETTINGS_CLOUD_MODE_OFF")]];
}

// ################################################


- (void) resetGateway {
    
    [[APConnectionManager sharedInstance] commitGatewayReset:^(BOOL success) {}];
//    [MOC deleteObject:[APGateway currentGateway]];
//    [[APConnectionManager sharedInstance] logout];
}

// ################################################


#pragma mark -
#pragma mark UITableViewDataSource & Delegate

// ################################################

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // HANDLE PASSWORD
    if(indexPath.row == 0) {
        [self changePassword];
        return;
    }
    
    // HANDLE GATEWAY RESET
    if(indexPath.row == 1) {
        [self resetGateway];
        return;
    }
    
    if(indexPath.row == 2) {
        // SHOW RENAME POPUP
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:APLocString(@"SETTINGS_RENAME_GW") message:APLocString(@"SETTINGS_RENAME_GW_INFO")
                                                           delegate:self cancelButtonTitle:APLocString(@"SETTINGS_CANCEL") otherButtonTitles:APLocString(@"SETTINGS_SET"), nil] ;
        alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
        alertView.tag = 2;
        [alertView show];
        return;
    }
    
    // SEND LOGS VIA MAIL (DEVELOPMENT ONLY)
    if(indexPath.row == 4) {
        
        [[APLogger sharedInstance] emailLogs];
        return;
    }
    
}

@end
