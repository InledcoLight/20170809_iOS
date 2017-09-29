//
//  APChannelRootViewController.m
//  EconluxApp
//
//  Created by Michael Müller on 10.04.14.
//  Copyright (c) 2014 AppPilots GbR. All rights reserved.
//

#import "APChannelRootViewController.h"
#import "APTimePickerViewController.h"
#import "APChannelDetailViewController.h"
#import "APPhaseTableViewCell.h"
#import <AZDateBuilder/NSDate+AZDateBuilder.h>
#import "APControlScrollViewController.h"
#import "APRadialColorPickerViewController.h"
#import "APGateway.h"

@interface APChannelRootViewController ()

@property (nonatomic, strong) NSArray *phases;

@end

@implementation APChannelRootViewController

// #####################################################

- (void)viewDidLoad
{
	// SETTING UP TABLEVIEW
	[self.tableView setBackgroundColor:CONTAINER_COLOR];
	[self.tableView setBackgroundView:nil];
	[self.tableView setSeparatorColor:DARK_COLOR];
	
	// SET TITLE
	self.title = self.channel.configuration.label;
    [self showLoadingScreenWithMessage:@""];
    
	[self.navigationItem.leftBarButtonItem setTintColor:MAIN_COLOR];
	//[self.navigationItem.rightBarButtonItem setTintColor:MAIN_COLOR];
}

// ################################################

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	
	if([[segue destinationViewController] isKindOfClass:[APControlScrollViewController class]]) {
		
		APControlScrollViewController *ctl = [segue destinationViewController];
		[ctl setChannel:self.channel];
	}
}

// #####################################################

- (void) viewWillAppear:(BOOL)animated {
	
	self.graphView.hidden = ![self causalCheck];
    [self refreshLastPhase];
	
	[[self tableView] reloadData];
    
    // REFRESH THE LIGHT VALUE
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self getLightValues];
    });
	
	[[self.graphView superview] setBackgroundColor:CONTAINER_COLOR];
}

// #####################################################

- (void)setChannel:(APChannel *)channel {
	_channel = channel;
	[self loadChannel];
}

// #####################################################

- (void) loadChannel
{
	// DELETE NAV BAR BUTTON ON RGB MODE
	if([self.channel.configuration.type isEqualToString:@"rgb"] || ![[APGateway currentGateway] runningModeValue]) {
		self.navigationItem.rightBarButtonItem = nil;
	}
	
	int index = self.channel.indexOffset + [[self.channel.configuration.indizesAsArray firstObject] intValue];
	
	// GET PHASES FROM BACKEND
	[[APConnectionManager sharedInstance] requestPhasesForChannel:self.channel index:index completion:^(NSArray *phases) {
        
		// INIT VIEW
		self.tableView.hidden = NO;
		self.phases = phases;
		self.phases = [self.phases sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"sort" ascending:YES]]];
		
		[self refreshLastPhase];
		[[self tableView] reloadData];
		
		// UPDATE GRAPH
		self.graphView.channel = self.channel;
		[self.graphView setNeedsDisplay];
	
		// DO THE CAUSAL CHECK
		self.graphView.hidden = ![self causalCheck];

		[self getLightValues];

	}];
	
}

// #####################################################

- (void) refreshLastPhase {
    
    APPhase *lastPhase = [self.phases lastObject];
    NSDate *lastDate = nil;
    NSDate *toDate = [NSDate AZ_dateByUnit:@{AZ_DateUnit.year:@2020, AZ_DateUnit.month:@01, AZ_DateUnit.day:@01, AZ_DateUnit.hour : @23, AZ_DateUnit.minute : @55}];

    // GET THE LAST DATE
    for(APPhase *p in self.phases) {
        if(p.timeTo && ![p isEqual:lastPhase])
            lastDate = p.timeTo;
    }
    
    // CREATE LAST DATE IF THERE IS NO ONE SELECTED
    if(!lastDate) {
        lastDate = [NSDate AZ_dateByUnit:@{AZ_DateUnit.year:@2020, AZ_DateUnit.month:@01, AZ_DateUnit.day:@01, AZ_DateUnit.minute:@00, AZ_DateUnit.hour:@00}];
    }

    lastPhase.timeFrom = lastDate;
    lastPhase.timeTo = toDate;
	
	if(self.phases.count > 1) {
		APPhase *previousPhase = self.phases[self.phases.count - 2];
		lastPhase.valueValue = previousPhase.valueValue;
	}
	
    [[lastPhase managedObjectContext] save:nil];
}

// #####################################################





#pragma mark -
#pragma mark UITableView Delegate/DataSource


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 3;
}

// #####################################################

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	// PHASE CELL
	if(indexPath.section == SECTION_PHASES) {
		
		APPhase *phase = self.phases[indexPath.row];
		APPhaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PhaseCell"];
		[[cell contentView] setBackgroundColor:CELL_BACKGROUND_COLOR];
		[cell setBackgroundColor:[UIColor clearColor]];
		
		[cell setPhase:phase];
		[cell setPhases:self.phases];
		
		// THE LAST PHASE (MOON) - IGNORE TOUCH
		if(indexPath.row == self.phases.count-1) {
			[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
		}
		
		return cell;
	}
	
	// COLOR CELL
	if(indexPath.section == SECTION_COLOR) {

		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ColorCell"];
		[[cell contentView] setBackgroundColor:CELL_BACKGROUND_COLOR];
		[cell setBackgroundColor:[UIColor clearColor]];
		
		// SETUP COLOR TAG
		//DLog(@"COLOR ON DISPLAY: %@", self.channel.lightColor);
		UIView *colorTag = (id)[cell viewWithTag:200];
		[colorTag setBackgroundColor:self.channel.lightColor];
		[[colorTag layer] setCornerRadius:colorTag.width/2];
		[colorTag.layer setMasksToBounds:YES];
		
		// TRANSLATE LABEL
		[(UILabel *)[cell viewWithTag:100] setText:APLocString(@"CDCTL_COLOR")];
		[(UILabel *)[cell viewWithTag:100] setTextColor:TITLE_COLOR];
		[(UILabel *)[cell viewWithTag:300] setTextColor:TITLE_COLOR];
		
		
		return cell;
	}
	

	// SWITCH CELL
	if(indexPath.section == SECTION_SWITCH) {

		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TypeCell"];
		[[cell contentView] setBackgroundColor:CELL_BACKGROUND_COLOR];
		[cell setBackgroundColor:[UIColor clearColor]];
		
		[(UILabel *)[cell viewWithTag:100] setText:APLocString(@"CDCTL_LIGHT_TYPE")];
		[(UILabel *)[cell viewWithTag:100] setTextColor:TITLE_COLOR];
		[(UILabel *)[cell viewWithTag:200] setTextColor:MAIN_COLOR];
		[(UILabel *)[cell viewWithTag:200] setText:[APChannel titleForType:self.channel.lightType]];
		
		return cell;
	}
	
	// COMMIT CELL
	if(indexPath.section == SECTION_BUTTONS) {
		
		if(indexPath.row == 0) {
			
			UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommitCell"];
			[[cell contentView] setBackgroundColor:CELL_BACKGROUND_COLOR];
			[cell setBackgroundColor:[UIColor clearColor]];
			
			[(UITextField *)[cell viewWithTag:200] setTextColor:MAIN_COLOR];
			[(UITextField *)[cell viewWithTag:200] setText:APLocString(@"CDCTL_COMMIT")];
			
			return cell;
		}

		// WORKAROUND FOR MISSING 1px LINE AFTER LAST CELL
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PaddingCell"];

		return cell;

	}
	
	return [UITableViewCell new];

}

// #####################################################

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	// A DYNAMIC CELL WAS TOUCHED
	if(indexPath.section == SECTION_PHASES) {

		APChannelDetailViewController *detailCtl = [self.storyboard instantiateViewControllerWithIdentifier:@"APChannelDetailViewController"];
		
		detailCtl.phase = self.phases[indexPath.row];
		detailCtl.phaseBefore = indexPath.row == 0? [self.phases lastObject] : self.phases[indexPath.row - 1];
        
        // THE LAST PHASE (MOON) - IGNORE TOUCH
		if(indexPath.row == self.phases.count-1) {
			return;
		}

		[[self navigationController] pushViewController:detailCtl animated:YES];
	}
	
	// HANDLING COLOR PICKER PUSH
	if(indexPath.section == SECTION_COLOR) {
		
		APRadialColorPickerViewController *colorPicker = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([APRadialColorPickerViewController class])];
		[self.navigationController pushViewController:colorPicker animated:YES];

		[colorPicker setColor:self.channel.lightColor];
		
		[colorPicker setSelection:^(UIColor *color) {
			
            self.channel.lightColor = color;
            [self lightColor:color];
			DLog(@"COLOR ON SELECTION: %@", self.channel.lightColor);
		}];
	}
	
	// HANDLE TYPE TOUCH
	if(indexPath.section == SECTION_SWITCH) {
		
		static APListSelectionViewController *selectionViewCtl;
		
		if(!selectionViewCtl)
			selectionViewCtl = [[UIStoryboard storyboardWithName:[[APListSelectionViewController class] description] bundle:nil] instantiateInitialViewController];
		
		[selectionViewCtl setValues:@[@"1 channel", @"2 channel"]];
	
		[self addChildViewController:selectionViewCtl];
		[selectionViewCtl viewDidLoad];
		[selectionViewCtl hide:NO completion:nil];
		[self.tableView setScrollEnabled:NO];
		
		// HANDLE SELECTION
		[selectionViewCtl setOnSelection:^(NSString *value, int idx) {
			
			self.channel.lightType = idx;
		
			// RESET PARENT VIEW
			[selectionViewCtl.view removeFromSuperview];
			[self.tableView setScrollEnabled:YES];
			[self.tableView reloadData];
		}];
		
		[self.view addSubview:selectionViewCtl.view];
		selectionViewCtl.view.frame = self.view.bounds;
		[selectionViewCtl show:YES];

	}
	
	// HANDLING COMMIT ACTION
	if(indexPath.section == SECTION_BUTTONS) {
		[self commit];
	}
}

// #####################################################

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if(indexPath.section == SECTION_BUTTONS && indexPath.row == 1) // PADDINGCELL
		return 1;
	
	if(indexPath.section == SECTION_COLOR) {
		
		if([self.channel.configuration.type isEqualToString:@"rgb"]) {
			return 44;
		} else {
			return 0;
		}
	}
	
	
    return 44;
}

// #####################################################

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if(section == SECTION_PHASES)
		return self.phases.count;
	else if (section == SECTION_BUTTONS)
		return 1;
	
	return 1;
}

// #####################################################

- (IBAction)showRemote:(id)sender {
	[self performSegueWithIdentifier:@"RemoteController" sender:self];
}

// ################################################



#pragma mark -
#pragma mark Causal Check

- (BOOL) causalCheck {
	
	NSArray *sortedPhases = [self.channel.phases.allObjects sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"sort" ascending:YES]]];
	NSDateFormatter *formatter = [NSDateFormatter new];
	formatter.dateFormat = @"HHmm";
	BOOL containsErrors = NO;
	
	APPhase *lastPhase = nil;
    NSLog(@"casual Check");
//    for(int i=0; i<sortedPhases.count; i++) {
    if(sortedPhases.count >=3){
        for(int i=0; i<3; i++) {
            APPhase *currentPhase = sortedPhases[i];
		
            // ON FIRST PHASE JUST SKIP
            if(i==0) {
                lastPhase = currentPhase;
                currentPhase.isValid = YES;
                continue;
            }
        
		
            // SKIP ON NON NEEDED PHASES WITH NO CONTENT (eg. BREAK)
            if(!currentPhase.isNeededValue && (!currentPhase.timeFrom && !currentPhase.timeTo)) {
                currentPhase.isValid = YES;
                continue;
            }
		
            int lastEnd = [formatter stringFromDate:lastPhase.timeTo].intValue;
            int curStart = [formatter stringFromDate:currentPhase.timeFrom].intValue;
        
            if(lastEnd >= curStart) {
                currentPhase.isValid = NO;
                containsErrors = YES;
            }
            else {
                currentPhase.isValid = YES;
            }
        
            lastPhase = currentPhase;
        }
    }
	
	return !containsErrors;
}

#pragma mark -
#pragma mark DEBUG FEATURES

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[self becomeFirstResponder];
}

- (BOOL)canBecomeFirstResponder
{
	return YES;
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
	if (motion == UIEventSubtypeMotionShake)
	{
		
		[self.phases[0] setTimeFrom:[NSDate AZ_dateByUnit:@{AZ_DateUnit.hour:@5}]];
		[self.phases[0] setTimeTo:[NSDate AZ_dateByUnit:@{AZ_DateUnit.hour:@6}]];
		[self.phases[0] setValueValue:70];
		
		[self.phases[1] setTimeFrom:[NSDate AZ_dateByUnit:@{AZ_DateUnit.hour:@12}]];
		[self.phases[1] setTimeTo:[NSDate AZ_dateByUnit:@{AZ_DateUnit.hour:@14}]];
		[self.phases[1] setValueValue:10];
		
		[self.phases[2] setTimeFrom:[NSDate AZ_dateByUnit:@{AZ_DateUnit.hour:@19}]];
		[self.phases[2] setTimeTo:[NSDate AZ_dateByUnit:@{AZ_DateUnit.hour:@20}]];
		[self.phases[2] setValueValue:50];
		
		[self refreshLastPhase];
		[[self tableView] reloadData];
		[[self graphView] setNeedsDisplay];
	}
}

#pragma mark -
#pragma mark UITextField Delegate 

// #####################################################

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	
	self.channel.name = textField.text;
	self.title = textField.text;
	[textField resignFirstResponder];
	[[self.channel managedObjectContext] save:nil];
	[NDC postNotificationName:NOTE_RELOAD_CHANNELS object:nil];
	
	return YES;
	
}

// #####################################################



#pragma mark -
#pragma mark Commiting Values

- (void) commit {
    
    // GET THE REAL CHANNEL INDEX FOR GIVEN "LIGHT" CALLED CHANNEL
	int indexOffset = [self.channel indexOffset];
    if([self causalCheck]) {
        if([self.phases[0] valueValue] > [self.phases[2] valueValue]){
            // SENDING NORMAL LIGHT VALUE
            if(![[self.channel.configuration type] isEqualToString:@"rgb"]) {
            
                for(NSString *index in [self.channel.configuration indizesAsArray]) {
				
                    [[APConnectionManager sharedInstance] commitPhases:self.phases forChannel:indexOffset + [index intValue] completion:^(NSString *result) {
					
                        DLog(@"Committing first channels graph is completed");
					
                    }];
                }
            }
		
            // HANDLING RGB COMMIT
            else {
			
                // GET THE COLOR VALUES
                CGFloat r, g, b;
                [self.channel.lightColor getRed:&r green:&g blue:&b alpha:0];
			
                NSArray *indizes = [self.channel.configuration indizesAsArray];
                DLog(@"Writing color: %.2f, %.2f, %.2f", r,g,b);
			
                // SAVE FOR LATER USE
                NSMutableArray *realValues = [NSMutableArray new];
                for(APPhase *phase in self.phases) {
                    [realValues addObject:phase.value];
                }
		
                for(APPhase *phase in self.phases)
                    phase.valueValue = [realValues[[self.phases indexOfObject:phase]] intValue] * r;
                [[APConnectionManager sharedInstance] commitPhases:self.phases forChannel:indexOffset + [indizes[0] intValue] completion:^(NSString *result) {

                    for(APPhase *phase in self.phases)
                        phase.valueValue = [realValues[[self.phases indexOfObject:phase]] intValue] * g;
                    [[APConnectionManager sharedInstance] commitPhases:self.phases forChannel:indexOffset + [indizes[1] intValue]completion:^(NSString *result) {

                        for(APPhase *phase in self.phases)
                            phase.valueValue = [realValues[[self.phases indexOfObject:phase]] intValue] * b;
                        [[APConnectionManager sharedInstance] commitPhases:self.phases forChannel:indexOffset + [indizes[2] intValue]completion:^(NSString *result) {
						
                            DLog(@"RGB values written to gateway!");
                            for(APPhase *phase in self.phases)
                                phase.valueValue = [realValues[[self.phases indexOfObject:phase]] intValue];
                        }];

                    }];

                }];
			
            }
        }else{
            [APAlert(APLocString(@"ALERT_WARNING"), APLocString(@"ALERT_SUNRISE_VALUE_TOO_LOW"), APLocString(@"ALERT_OK")) show];
        }
        
		
    } else {
        //[APAlert(@"title1", @"text", @"button") show];
		[APAlert(APLocString(@"ALERT_WARNING"), APLocString(@"ALERT_INVALID_VALUES"), APLocString(@"ALERT_OK")) show];
		return;
    }
    //APAlert(@"title2", @"text", @"button");

	
}

// ################################################


#pragma mark -
#pragma mark Light/Color Handling 

- (void) getLightValues {
	
	int indexOffset = [self.channel indexOffset];

	if(![[self.channel.configuration type] isEqualToString:@"rgb"]) {
	
		// GET THE CURRENT LIGHT VALUE
        indexOffset += [[[self.channel.configuration indizesAsArray] firstObject] intValue];
		[[APConnectionManager sharedInstance] requestValueForChannel:indexOffset completion:^(int value) {
			
            [self.channel setLightValue:value];
            [self hideLoadingScreen];
			[self.graphView setNeedsDisplay];
		}];
		
	}
	
	// HANDLE RGB VALUES
	else {
		
		// GET RED
		[[APConnectionManager sharedInstance] requestValueForChannel:indexOffset + [[self.channel.configuration indizesAsArray][0] intValue] completion:^(int red) {
			
			// GET GREEN
			[[APConnectionManager sharedInstance] requestValueForChannel:indexOffset + [[self.channel.configuration indizesAsArray][1] intValue] completion:^(int green) {
				
				// GET BLUE
				[[APConnectionManager sharedInstance] requestValueForChannel:indexOffset + [[self.channel.configuration indizesAsArray][2] intValue] completion:^(int blue) {
					
					DLog(@"Got RGB values: %d %d %d", red, green, blue);
					UIColor *color = [UIColor colorWithRed:(red/100.0) green:(green/100.0) blue:(blue/100.0) alpha:1.0];
					DLog(@"%@", color);

                    self.channel.lightColor = color;
                    [self.channel setLightValue:-1];
					[self.tableView reloadData];
                    [self hideLoadingScreen];
                    [self.graphView setNeedsDisplay];

				}];
				
			}];
			
		}];
		
	}
	
	
}


// #####################################################

- (void) lightColor:(UIColor *)color {
    
    int indexOffset = [self.channel indexOffset];
    
    // GET THE COLOR VALUES
    CGFloat r, g, b;
    [self.channel.lightColor getRed:&r green:&g blue:&b alpha:0];
    DLog(@"Writing color: %.2f, %.2f, %.2f", r,g,b);
    
    if(r < 0.05) r = .0f;
    if(g < 0.05) g = .0f;
    if(b < 0.05) b = .0f;
    
    [[APConnectionManager sharedInstance] commitValue:r*100 forChannel:indexOffset + [[self.channel.configuration indizesAsArray][0] intValue] completion:^{
        
        [[APConnectionManager sharedInstance] commitValue:g*100 forChannel:indexOffset + [[self.channel.configuration indizesAsArray][1] intValue] completion:^{
            
            [[APConnectionManager sharedInstance] commitValue:b*100 forChannel:indexOffset + [[self.channel.configuration indizesAsArray][2] intValue] completion:^{
                
                DLog(@"Done commiting color");
                
            }];
            
        }];
        
    }];
}

// #####################################################

@end
