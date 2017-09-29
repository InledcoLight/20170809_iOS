//
//  APLightDetailTableViewController.m
//  EconluxApp
//
//  Created by Michael Müller on 08.02.15.
//  Copyright (c) 2015 AppPilots GbR. All rights reserved.
//

#import "APLightDetailTableViewController.h"
 #import "APChannelRootViewController.h"
#import "APLight.h"
#import "APLightConfiguration.h"
#import "APChannelConfiguration.h"
#import "UIView+Border.h"

@interface APLightDetailTableViewController ()

@property (nonatomic, strong) APLightConfiguration *configuration;

@end

@implementation APLightDetailTableViewController

- (void)viewDidLoad {
	
	[super viewDidLoad];
	self.title = self.light.name;
	
	// COLOR THE TABLE
	[self.tableView setBackgroundColor:CONTAINER_COLOR];
	[self.tableView setSeparatorColor:CONTAINER_COLOR];
	
	// GET CONFIG
	self.configuration = [APLightConfiguration configurationByIdentifier:self.light.typeValue];
}



#pragma mark -
#pragma mark UITableViewDataSource & Delegate

// ################################################

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 2;
}

// ################################################

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

	if(section == 0) {
		return 3;
	}
	
	if(section == 1) {
		return [self numberOfChannels];
	}

	return 0;
}

// ################################################

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InfoCell"];
	UILabel *titleLabel = (UILabel *)[cell viewWithTag:100];
	UILabel *dataLabel = (UILabel *)[cell viewWithTag:200];
	
	if(indexPath.section == 0) {
	
		cell.accessoryType = UITableViewCellAccessoryNone;
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		
		switch (indexPath.row) {
            case 0:
                titleLabel.text = APLocString(@"SLOT_SETTINGS_NAME");
				dataLabel.text = self.light.name;
				break;
            case 1:
                titleLabel.text = APLocString(@"SLOT_SETTINGS_SLOT");
				dataLabel.text = [self.light socketString];
				break;
			case 2:
                titleLabel.text = APLocString(@"SLOT_SETTINGS_PRODUCT");
				dataLabel.text = [self.light typeString];
				break;
        }
	
	}
	
	
	if(indexPath.section == 1) {
		
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		cell.selectionStyle = UITableViewCellSelectionStyleGray;
		
		[self fillCell:cell forChannel:(int)indexPath.row];
	}
	
	return cell;
}

// ################################################

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	if(indexPath.section == 1) {

		APChannel *channel = [self.light channelForIndex:(int)indexPath.row];
		[channel setConfiguration:self.configuration.channels[indexPath.row]];
		
		APChannelRootViewController *ctl = [self.storyboard instantiateViewControllerWithIdentifier:[[APChannelRootViewController class] description]];
		[ctl setChannel:channel];
		[self.navigationController pushViewController:ctl animated:YES];
		
	}
}

// ################################################

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	
	UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 30)];
	[view setBackgroundColor:[UIColor clearColor]];
	[view addBottomBorderWithColor:[UIColor darkGrayColor] andWidth:.5f];
	[view addTopBorderWithColor:[UIColor darkGrayColor] andWidth:.5f];
	
	//TODO: Lokalisierung
	UILabel *label = [[UILabel alloc] initWithFrame:view.bounds];
	label.x = 10;
	[label setText:APLocString(@"CHANNELS")];
	[label setBackgroundColor:[UIColor clearColor]];
	[label setFont:[UIFont fontWithName:@"Roboto-Medium" size:17]];
	[label setTextColor:[UIColor whiteColor]];
	[view addSubview:label];
	
	return view;
}

// ################################################

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

	if(section>0)
		return 30;
	return 0;
}

// ################################################


#pragma mark -
#pragma mark Channel Handling 

- (int) numberOfChannels {
	
	return (int)self.configuration.channels.count;
	
}

// ################################################

- (void) fillCell:(UITableViewCell *)cell forChannel:(int)index {

	UILabel *titleLabel = (UILabel *)[cell viewWithTag:100];
	UILabel *dataLabel = (UILabel *)[cell viewWithTag:200];
	
	APChannelConfiguration *channelConfig = [[self.configuration channels] objectAtIndex:index];
	[titleLabel setText:channelConfig.label];
	[dataLabel setText:@""];
	
}

// ################################################

@end
