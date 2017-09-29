//
//  APBaseTableViewCell.m
//  EconluxApp
//
//  Created by Michael Müller on 07.02.15.
//  Copyright (c) 2015 AppPilots GbR. All rights reserved.
//

#import "APBaseTableViewCell.h"

@implementation APBaseTableViewCell

- (void)awakeFromNib {
	[self setBackgroundColor:CELL_BACKGROUND_COLOR];
	
	for(UIView *v in self.contentView.subviews) {
		if([v isKindOfClass:[UILabel class]]) {
			[(UILabel *)v setTextColor:MAIN_COLOR];
		} else if([v isKindOfClass:[UITextField class]]) {
			[(UITextField *)v setTextColor:TEXT_FIELD_COLOR];
		}
	}
}

@end
