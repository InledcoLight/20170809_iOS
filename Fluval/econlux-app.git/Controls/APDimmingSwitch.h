//
//  TemperatureView.h
//  Windhager
//
//  Created by Hannes Jung on 17/02/14.
//  Copyright (c) 2014 LOOP. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kMinTemp        0
#define kMaxTemp        100

@class TemperatureView;

@interface APDimmingSwitch : UIView <UIGestureRecognizerDelegate> {

    float radiusOuterLines;
    NSInteger radiusInnerLines;
	
    CGFloat cx;
    CGFloat cy;
    
    NSInteger lines;
	
    CGFloat deltaAlphaLines;
	
    CGFloat pCurrent;
    CGFloat pTarget;
}

@property (nonatomic) CGFloat progress;

@property (nonatomic, weak) IBOutlet UILabel *percentLabel;
@property (nonatomic, weak) IBOutlet UILabel *textLabel;

@end
