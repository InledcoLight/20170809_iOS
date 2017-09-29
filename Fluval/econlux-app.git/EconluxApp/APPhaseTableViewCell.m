//
//  APPhaseTableViewCell.m
//  EconluxApp
//
//  Created by Michael Müller on 22.06.14.
//  Copyright (c) 2014 AppPilots GbR. All rights reserved.
//

#import "APPhaseTableViewCell.h"
#import <UIColor+HexString.h>

@interface APPhaseTableViewCell()
@property (nonatomic, strong) RMDownloadIndicator *indicator;
@end

@implementation APPhaseTableViewCell

- (void)layoutSubviews {

	// SETTING COLOR TAG
	UIColor *color = [UIColor colorWithHexString:self.phase.color];
	self.labelColorTag.backgroundColor = color;
	
	// SETTING TEXT LABELS
	self.labelTitle.text = self.phase.name;
	self.labelTitle.textColor = TITLE_COLOR;
	
	// CREATE THE DATE STRING
	NSString *dateString = NSLocalizedString(@"UNDEFINED", nil);
	
	if(self.phase.timeFrom && self.phase.timeTo) {
		
		if(self.phase != [self.phases lastObject]) {
			dateString = [NSString stringWithFormat:@"%@ - %@", self.phase.timeFromAsString, self.phase.timeToAsString];
		}
		else { // HANDLE LAST PHASE
			
			APPhase *firstPhase = [self.phases firstObject];
			if(firstPhase.timeFrom) {
				dateString = [NSString stringWithFormat:@"%@ - %@", self.phase.timeFromAsString, firstPhase.timeFromAsString];
			}
		}
		
	}
	
	
	// SETTING TIME COMPONENTS
	self.labelTime.text = dateString;
	self.labelTime.textColor = self.phase.isValid? MAIN_COLOR : [UIColor redColor];

	if(!self.indicator) {
        self.progressContainerView.backgroundColor = CELL_BACKGROUND_COLOR;
		self.indicator = [[RMDownloadIndicator alloc]initWithFrame:self.progressContainerView.bounds type:kRMMixedIndictor];
        [self.indicator setBackgroundColor:CELL_BACKGROUND_COLOR];
        [self.indicator setFillColor:MAIN_COLOR];
		[self.indicator setStrokeColor:MAIN_COLOR];
		[self.indicator setBackgroundColor:CELL_BACKGROUND_COLOR];
		[self.indicator setClosedIndicatorBackgroundStrokeColor:MAIN_COLOR];
		self.indicator.radiusPercent = 0.45;
		[self.progressContainerView addSubview:self.indicator];
		[self.indicator loadIndicator];
        self.indicator.alpha = .55;
	}

	[self.indicator updateWithTotalBytes:100 downloadedBytes:self.phase.valueValue];

	// HANDLE INDICATOR VISIBILITY
	self.indicator.hidden = !(self.phase.timeFrom && self.phase.timeTo);

}

@end
