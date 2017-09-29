//
//  APChannelDetailViewController.m
//  EconluxApp
//
//  Created by Michael Müller on 06.06.14.
//  Copyright (c) 2014 AppPilots GbR. All rights reserved.
//

#import "APChannelDetailViewController.h"
#import "APTimePickerViewController.h"
#import "APColorPicker.h"
#import <UIColor+HexString.h>
#import <DateTools/DateTools.h>
#import <AZDateBuilder/NSDate+AZDateBuilder.h>

#define ROW_IDX_CHANEL 1
#define ROW_IDX_START 2
#define ROW_IDX_STOP 3

#define ROW_IDX_COLOR 999
#define ROW_IDX_SEND 5
#define ROW_IDX_CANCEL 6

@interface APChannelDetailViewController ()

@property (nonatomic, strong) NSDate *dateFrom, *dateTo;
@property (nonatomic, strong) UIColor *selectedColor;
@property (nonatomic, assign) BOOL isResetted;

@property (weak, nonatomic) IBOutlet UILabel *labelLastPhaseDescription;

@end

@implementation APChannelDetailViewController


// #####################################################

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.buttonReset.enabled = NO;
    
	self.dateFrom = self.phase.timeFrom;
	self.dateTo = self.phase.timeTo;
	
	if(self.phase.color) {
		self.selectedColor = [UIColor colorWithHexString:self.phase.color];
	} else {
		self.selectedColor = [UIColor blackColor];
	}
	
	// SETTING VALUES
	self.slider.value = (float)self.phase.valueValue;
	self.title = self.phase.name;
	
	// SUNRISE
	if(self.phase.sortValue == 0) {
		
		// SET DEFAULT VALUE FOR SUNRISE AT 6:00
		if(!self.dateFrom) {
			NSDateFormatter *formatter = [NSDateFormatter new];
			[formatter setDateFormat:@"HH:mm"];
			self.dateFrom = [formatter dateFromString:@"06:00"];
		}
		
		self.labelLastPhaseDescription.text = [NSString stringWithFormat:APLocString(@"PREV_PHASE_SUNRISE"), [self.phaseBefore timeToAsString]];
    } else {
        self.labelLastPhaseDescription.text = [NSString stringWithFormat:APLocString(@"PREV_PHASE_SUNSET"), [self.phaseBefore timeToAsString]];
	}

	// HANDLE BREAK
	if(self.phase.sortValue == 1) {
		self.labelLastPhaseDescription.text = [NSString stringWithFormat:APLocString(@"PREV_PHASE_BREAK"), [self.phaseBefore timeFromAsString]];
	}
	
	// SETTING THE TINT COLOR
	self.labelDateTo.textColor = MAIN_COLOR;
	self.labelDateFrom.textColor = MAIN_COLOR;
 	self.labelGivenValue.textColor = MAIN_COLOR;
	self.labelChangeColor.textColor = TITLE_COLOR;
	self.labelSave.textColor = TITLE_COLOR;
	self.labelCancel.textColor = TITLE_COLOR;
	[self.navigationItem.rightBarButtonItem setTintColor:MAIN_COLOR];
	[self.navigationItem.rightBarButtonItem setTitle:APLocString(@"PHASE_DETAIL_RESET")];
	
	// HANDLING LANGUAGES
	self.labelTitleStart.text = APLocString(@"PHASE_DETAIL_START");
	self.labelTitleStop.text = APLocString(@"PHASE_DETAIL_STOP");
	self.labelTitleGivenValue.text = APLocString(@"PHASE_DETAIL_GIVEN_VALUE");
	self.labelTitleChanel.text = APLocString(@"PHASE_DETAIL_CHANNEL");

	self.labelChangeColor.text = APLocString(@"PHASE_DETAIL_CHANGE_COLOR");
	self.labelSave.text = APLocString(@"PHASE_DETAIL_SAVE");
	self.labelCancel.text = APLocString(@"PHASE_DETAIL_CANCEL");
	
	// SETTING UP TABLEVIEW
	self.tableView.backgroundColor = CONTAINER_COLOR;
	
	// MODIFY BACK BUTTON
	self.navigationController.navigationBar.topItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];

	// TINT SLIDER
	[self.slider setTintColor:MAIN_COLOR];
	
	// MODIFIY COLOR TAG
	self.viewColorTag.layer.cornerRadius = self.viewColorTag.width/2;
	
	// RESET HANDLING
	if(self.isLastPhase) {
		[self.navigationItem setRightBarButtonItem:nil];
	}
	
	[self refreshDisplay];
}


// ###################################################

- (void) refreshDisplay
{
	// IF FROM TIME IS NIL JUST TRY TO USE THE TO DATE FROM PREPHASE
	if(!self.dateFrom && !self.isResetted && self.phaseBefore.sortValue != 3) {
		self.dateFrom = self.phaseBefore.timeTo;
	}
	
	NSDateFormatter *formatter = [APPhase dateFormatter];
	
	self.labelGivenValue.text = [NSString stringWithFormat:@"%d%%", (int)self.slider.value];
	self.viewColorTag.backgroundColor = self.selectedColor;
    
    // DISABLE THE INPUT FIELDS ON LAST PHASE (Its implicit)
    self.labelDateFrom.enabled = self.labelDateTo.enabled = !self.isLastPhase;
	self.labelTitleStart.textColor = self.labelTitleStop.textColor = self.isLastPhase? [UIColor lightGrayColor] : TITLE_COLOR;
	self.labelChannel.text = self.phase.channel.name;
	
	// HANDLING LAST CELL
	if(self.isLastPhase) {
		self.labelDateFrom.text = APLocString(@"AUTOMATIC");
		self.labelDateTo.text = APLocString(@"AUTOMATIC");
		self.labelGivenValue.text = APLocString(@"AUTOMATIC");
		self.slider.enabled = NO;
	}
	// HANDLING NORMAL CELLS
    else {
        self.labelDateFrom.text = self.dateFrom? [formatter stringFromDate:self.dateFrom] : APLocString(@"UNDEFINED");
        self.labelDateTo.text = self.dateTo? [formatter stringFromDate:self.dateTo] : APLocString(@"UNDEFINED");
	}
	
}

// #####################################################





#pragma mark -
#pragma mark Handle DateSelection

- (void) didSelectDate:(NSDate *)date withTag:(int)tag
{
	if(!date) return;

	if(tag == 0)
		self.dateFrom = date;
	else
		self.dateTo = date;
	
	[self refreshDisplay];
}






#pragma mark -
#pragma mark UITableView Delegate/DataSource

// #####################################################

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	switch (indexPath.row) {
		case ROW_IDX_START:
		case ROW_IDX_STOP:
            if(!self.isLastPhase) {
                [self loadTimePicker:(int)indexPath.row-2];
            }
			break;
		case ROW_IDX_COLOR:
			[self chooseColor];
			break;
		case ROW_IDX_SEND:
			[self save];
			break;
		case ROW_IDX_CANCEL:
			[self cancel];
			break;
	}
}

// #####################################################





#pragma mark -
#pragma mark Events

// #####################################################

- (void) loadTimePicker:(int)tag
{
	// LOAD THE TIME PICKER
	APTimePickerViewController *timeCtl = [[APTimePickerViewController alloc] initWithNibName:nil bundle:nil];
	[timeCtl view];
	
	timeCtl.tag = tag;
	NSDate *date = tag? self.dateTo : self.dateFrom;
	timeCtl.date = date;
	
	if(!date) {
		timeCtl.date = tag? self.dateFrom : nil;
	}
	
	[timeCtl setOnSelection:^(int tag, NSDate *d) {
		[self didSelectDate:d withTag:tag];
	}];
	
	// CREATE THE TIME PICKER HEADER DESCRIPTION
	NSString *topLabelString = [NSString stringWithFormat:APLocString(@"TIME_TOP_DESC"), tag? APLocString(@"STOP_TIME") : APLocString(@"START_TIME"), self.phase.name, self.phase.timeFromAsString, self.phase.timeToAsString];
	[timeCtl.timePicker.labelTop setText:topLabelString];
	
	[self presentViewController:timeCtl animated:YES completion:nil];
}


// #####################################################

- (void) save {
	
	// CHECK CONSTRAINTS ON AVAILABLE INPUT
	// IF NIL THERE COULD BE A RESET (NIL VALUES ARE ACCEPTED)
	if(self.dateTo || self.dateFrom) {

		// CONSTRAINT CHECK
		if(!self.dateTo || !self.dateFrom) {
			[APAlert(APLocString(@"ALERT_ERROR"), APLocString(@"ALERT_INVALID_START_STOP"), APLocString(@"ALERT_OK")) show];
			return;
		}
        
		if (([self.dateFrom hour]*60 + [self.dateFrom minute]) >= ([self.dateTo hour]*60 + [self.dateTo minute])) {
			[APAlert(APLocString(@"ALERT_ERROR"), APLocString(@"ALERT_INVALID_SORT"), APLocString(@"ALERT_OK")) show];
			return;
        }
        
	}
	
	// SETTING THE PHASE
	self.phase.timeFrom = self.dateFrom;
	self.phase.timeTo = self.dateTo;
	self.phase.valueValue = self.slider.value;
	self.phase.color = [self hexStringFromColor:self.selectedColor];
	self.phase.value = [NSNumber numberWithInt:(int)[self.slider value]];
	
	[self.phase.managedObjectContext save:nil];
	
	// POP CONTROLLEr
	[self.navigationController popViewControllerAnimated:YES];
}

// #####################################################

- (IBAction)reset:(id)sender {
	
	self.dateFrom = nil;
	self.dateTo = nil;
	self.slider.value = .0f;
	self.isResetted = YES;
	
	[self refreshDisplay];
	
}

// #####################################################

- (void) cancel
{
	[self.navigationController popViewControllerAnimated:YES];
}

// #####################################################

- (IBAction)didChangeSlider:(id)sender
{
	[self refreshDisplay];
}

// #####################################################

- (void) chooseColor {
	
	// CREATE THE PICKER CTL
	APColorPicker *picker = [self.storyboard instantiateViewControllerWithIdentifier:@"APColorPicker"];
	[self.navigationController pushViewController:picker animated:YES];

	// HANDLE COLOR SELECTION
	picker.onColorSelection = ^(UIColor *selectedColor) {
	
		self.viewColorTag.backgroundColor = selectedColor;
		self.selectedColor = selectedColor;
		
		DLog(@"%@", selectedColor);
		
		[self.navigationController popViewControllerAnimated:YES];
	};
	
}

// #####################################################

// NEEDED FOR COLOR PICKER CALLBACK
- (NSString *)hexStringFromColor:(UIColor *)color
{
	const CGFloat *components = CGColorGetComponents(color.CGColor);
	
	CGFloat r = components[0];
	CGFloat g = components[1];
	CGFloat b = components[2];
	
	return [NSString stringWithFormat:@"%02lX%02lX%02lX",
			lroundf(r * 255),
			lroundf(g * 255),
			lroundf(b * 255)];
}

// #####################################################

@end
