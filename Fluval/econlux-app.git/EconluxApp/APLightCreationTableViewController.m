//
//  APLightCreationTableViewController.m
//  EconluxApp
//
//  Created by Michael Müller on 07.02.15.
//  Copyright (c) 2015 AppPilots GbR. All rights reserved.
//

#import "APLightCreationTableViewController.h"
#import "APListSelectionViewController.h"
#import "APLightConfiguration.h"

@interface APLightCreationTableViewController ()

@property (assign) int slotType;
@property (assign) int productType;

@property (assign) BOOL isInProgress;

@end

@implementation APLightCreationTableViewController

- (void)viewDidLoad {
	
    [super viewDidLoad];
	[self refreshDisplay];
    
    self.labelTitleName.text = APLocString(@"SLOT_SETTINGS_NAME");
    self.labelTitleSlot.text = APLocString(@"SLOT_SETTINGS_SLOT");
    self.labelTitleProduct.text = APLocString(@"SLOT_SETTINGS_PRODUCT");
    self.labelTitleSave.text = APLocString(@"SLOT_SETTINGS_SAVE");
    self.NewLight.title = APLocString(@"SLOT_SETTINGS_TITLE");
	
	// COLOR THE TABLE
	[self.tableView setBackgroundColor:CONTAINER_COLOR];
	[self.tableView setSeparatorColor:CONTAINER_COLOR];
}

// #####################################################

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.textName.text = nil;
    self.slotType = -1;
    self.productType = -1;
    
    [self refreshDisplay];
}
// ################################################

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

	// DISABLE TEXT INPUT
	[[self textName] resignFirstResponder];
	[tableView deselectRowAtIndexPath:indexPath animated:YES];

    // NEEDED FOR SOCKET TITLES
    APLight *tempLight = [[APGateway currentGateway] lightForSlot:0];
    
	if(indexPath.row == 1 || indexPath.row == 2) {
		
		static APListSelectionViewController *selectionViewCtl;
		
		if(!selectionViewCtl)
			selectionViewCtl = [[UIStoryboard storyboardWithName:[[APListSelectionViewController class] description] bundle:nil] instantiateInitialViewController];
		
		if(indexPath.row == 1)
			[selectionViewCtl setValues:tempLight.socketTitles];
		else
			[selectionViewCtl setValues:tempLight.typeTitles];
		
		[selectionViewCtl viewDidLoad];
		[selectionViewCtl hide:NO completion:nil];
		[self.tableView setScrollEnabled:NO];
		
		// HANDLE SELECTION
		[selectionViewCtl setOnSelection:^(NSString *value, int idx) {
			
			if (indexPath.row == 1) {
				self.slotType = idx;
			} else {
				
				APLightConfiguration *config = [[APLightConfiguration getConfigurations] objectAtIndex:idx];
				self.productType = config.identifier.intValue;
			}
			
			[self refreshDisplay];
			
			// RESET PARENT VIEW
			[selectionViewCtl.view removeFromSuperview];
			[self.tableView setScrollEnabled:YES];
			[self.tableView reloadData];
		}];
		
		[[[[UIApplication sharedApplication] windows] firstObject] addSubview:selectionViewCtl.view];
		selectionViewCtl.view.frame = self.view.superview.bounds;
		[selectionViewCtl show:YES];

	}
	
	if(indexPath.row == 3) {
		[self commit];
	}
}

// ################################################

- (void) refreshDisplay {

    // NEEDED FOR SOCKET TITLES
    APLight *tempLight = [[APGateway currentGateway] lightForSlot:0];
    self.textSlot.text = self.slotType >= 0? tempLight.socketTitles[self.slotType] : @"";
    self.textProduct.text = self.productType >= 0? [[APLightConfiguration configurationByIdentifier:self.productType] label] : @"";
}

// ################################################

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return YES;
}

// ################################################

- (void) commit {
	
	
	// EARLY RETURN ON ALREADY GIVEN SLOT VALUES
//	for(APLight *light in [[APGateway currentGateway] lig thts]) {
//		
//		if([light slotValue] == self.light.slotValue && light.typeValue >= 0 && light != self.light) {
//			
//			[APAlert(@"Error", @"There is already a light configured for this slot. Please choose another one", @"Ok") show];
//			return;
//		}
//	}
    
    if(self.isInProgress)
        return;
    self.isInProgress = YES;
    
    if(!self.textName.text.length) {
        [APAlert(APLocString(@"ALERT_WARNING"), APLocString(@"ALERT_INVALID_NAME"), APLocString(@"ALERT_OK")) show];
        return;
    }
    
    if(self.productType < 0) {
        [APAlert(APLocString(@"ALERT_WARNING"), APLocString(@"ALERT_INVALID_PRODUCT_TYP"), APLocString(@"ALERT_OK")) show];
        return;
    }

    APLight *realLight = [[APGateway currentGateway] lightForSlot:self.slotType];
    realLight.slotValue = self.slotType;
    realLight.typeValue = self.productType;
    realLight.name = self.textName.text;
    
    DLog(@"Commiting name: %@", realLight.name);
	[[APConnectionManager sharedInstance] commitName:realLight.name forLight:realLight.slotValue completion:^{

        DLog(@"Commiting type: %d", realLight.typeValue);
		[[APConnectionManager sharedInstance] commitType:realLight.typeValue forLight:realLight.slotValue completion:^(BOOL flag) {
			
            if(flag) {
                
                DLog(@"Creating light successfully ended! Popping view controller");
                [MOC save:nil];
                [self.navigationController popViewControllerAnimated:YES];
                
            } else {
                
                [APAlert(APLocString(@"ALERT_ERROR"), APLocString(@"ALERT_LIGHT_NOT_SAVED"), APLocString(@"ALERT_OK")) show];
                [MOC deleteObject:realLight];
                [MOC save:nil];
            }
            
            self.isInProgress = NO;
            
		}];
		
	}];
    
}

// ################################################

@end
