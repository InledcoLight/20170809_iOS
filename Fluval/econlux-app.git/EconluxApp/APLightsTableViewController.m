//
//  APLightsTableViewController.m
//  EconluxApp
//
//  Created by Michael Müller on 07.02.15.
//  Copyright (c) 2015 AppPilots GbR. All rights reserved.
//

#import "APLightsTableViewController.h"
#import "APLight.h"
#import "APConnectionViewController.h"
#import "APGatewayConnector.h"
#import "APLightDetailTableViewController.h"
#import "APLightConfiguration.h"

@interface APLightsTableViewController ()

@property (nonatomic, strong) APGateway *gateway;
@property (nonatomic, strong) NSMutableArray *lights;
@property (nonatomic, strong) NSMutableArray *updatingLights;

@end

@implementation APLightsTableViewController

// ################################################

- (void)viewDidLoad {

	[super viewDidLoad];
	self.tableView.allowsMultipleSelectionDuringEditing = NO;
    
	// COLOR THE TABLE
	[self.tableView setBackgroundColor:CONTAINER_COLOR];
	[self.tableView setSeparatorColor:CONTAINER_COLOR];
	
	// CREATE FOOTER TO DISABLE INFINITE CELL SEPERATORS
	UIView *footer = [UIView new];
	[footer setBackgroundColor:[UIColor clearColor]];
	[self.tableView setTableFooterView:footer];

	// SHOW LOGIN SCREEN ON INITIAL START
	APConnectionViewController *ctl = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateInitialViewController];
	[self presentViewController:ctl animated:NO completion:nil];
	
}

// ################################################

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
	
    // UPDATE THE GATEWAY MODE UI
    [self.gatewayModeView setBackgroundColor:DARK_BACKGROUND_COLOR];
    [self.gatewayModeView layoutSubviews];
    
    // FETCH LIGHT IF CONNECTED
	if([[APGatewayConnector sharedInstance] isConnected])
		[self fetchLightList];
}

// ################################################

- (void) fetchLightList {

    // SHOW THE ACTIVITY INDICATOR
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    UIBarButtonItem * barButton = [[UIBarButtonItem alloc] initWithCustomView:activityIndicator];
    [self navigationItem].leftBarButtonItem = barButton;
    [activityIndicator startAnimating];
    
	self.gateway = [APGateway currentGateway];
	
    self.updatingLights = [NSMutableArray new];
    
	if(!self.gateway) {
		[self.tableView reloadData];
		return;
	}
	
	// GET CHANNEL AMOUNT AND FETCH INFORMATION
	int lightAmount = self.gateway.typeValue == GATEWAY_2CH? 2 : 3;
	__block int iteration = 0;
	
	for(int i=0; i<lightAmount; i++) {
		
		[[APConnectionManager sharedInstance] requestTypeForLight:i completion:^(int lightType) {
			
			APLight *light = [self.gateway lightForSlot:i];
			light.typeValue = lightType;
			[[light managedObjectContext] save:nil];
			
			[self.updatingLights addObject:light];
			
			iteration++;
			if(iteration == lightAmount) {
				
				DLog(@"Light fetching completed! Triggering light name fetching");
				[self fetchLightNames];
			}
			
            // SET GATEWAY NAME AS TITLE
            // TODO add replace the  "|" with a line break
            self.navigationItem.title = [NSString stringWithFormat:@"%@ | %@", APLocString(@"LIGHT_TITLE"),self.gateway.name];
            
		}];
	}
	
}

// ################################################

- (void) fetchLightNames {

	__block int iteration = 0;
	for(int i=0; i<self.updatingLights.count; i++) {
		
		[[APConnectionManager sharedInstance] requestNameForLight:i completion:^(NSString *lightName) {
			
			APLight *light = self.updatingLights[i];
			light.name = lightName;
			
			iteration++;
			if(iteration == self.updatingLights.count) {
				
				DLog(@"Light name fetching completed! Reloading view!");
				
				// CLEAN LIGHTS ARRAY
				NSMutableArray *validLights = [NSMutableArray new];
				for(APLight *light in self.updatingLights) {
					if(light.typeValue >= 0) {
						[validLights addObject:light];
					}
				}
            
				self.lights = validLights;
				[self.tableView reloadData];
                
                // REMOVE LOADING INDICATOR
                self.navigationItem.leftBarButtonItem = nil;
			}
		}];
	}
}

// ################################################

- (void) toggleEmptyMessage:(BOOL)flag {
	
	for(UIView *v in self.view.subviews) {
		if([v tag] == 999) {
			[v removeFromSuperview];
		}
	}
	
	if(flag) {
	
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(50, self.view.height/2-50, self.view.width-100, 100)];
		label.textColor = [UIColor lightGrayColor];
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = NSTextAlignmentCenter;
		label.numberOfLines = 10;
		label.font = [UIFont systemFontOfSize:15];
		label.tag = 999;
		label.text = APLocString(@"NO_LIGHTS_CONFIGURED");
		[self.view addSubview:label];
		
	}
}

// ################################################




#pragma mark - 
#pragma mark Table view data source

// ################################################

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	[self toggleEmptyMessage:self.lights.count == 0];
    return self.lights.count;
}

// ################################################

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

	APBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LightCell" forIndexPath:indexPath];
	
	APLight *light = self.lights[indexPath.row];
	[[cell labelTitle] setText:light.name];
	
    return cell;
}

// ################################################

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	APLightDetailTableViewController *ctl = [self.storyboard instantiateViewControllerWithIdentifier:[[APLightDetailTableViewController class] description]];
	[ctl setLight:self.lights[indexPath.row]];
	[self.navigationController pushViewController:ctl animated:YES];
}


// ################################################

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}

// ################################################

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		
		APLight *light = self.lights[indexPath.row];
		
		// DELETE THE LIGHT
		[[APConnectionManager sharedInstance] commitName:@"Invalid" forLight:light.slotValue completion:^{
			
			[[APConnectionManager sharedInstance] commitType:-1 forLight:light.slotValue completion:^(BOOL flag) {
				
				[MOC deleteObject:light];
				[self fetchLightList];
			}];
			
		}];
	}
}

// ################################################



#pragma mark -
#pragma mark Button Events

- (IBAction)createNewLight:(id)sender {

	UIViewController *ctl = [self.storyboard instantiateViewControllerWithIdentifier:@"APLightCreationTableViewController"];
	[[self navigationController] pushViewController:ctl animated:YES];
	
}


@end
