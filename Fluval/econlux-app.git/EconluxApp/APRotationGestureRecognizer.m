//
//  RotationGestureRecognizer.m
//  Windhager
//
//  Created by Hannes Jung on 18/02/14.
//  Copyright (c) 2014 LOOP. All rights reserved.
//

#import "APRotationGestureRecognizer.h"
#import <UIKit/UIGestureRecognizerSubclass.h>

@implementation APRotationGestureRecognizer

- (id)initWithTarget:(id)target action:(SEL)action {
    self = [super initWithTarget:target action:action];
    
    if(self) {
        self.maximumNumberOfTouches = 1;
        self.minimumNumberOfTouches = 1;
    }
    
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self updateTouchAngleWithTouches:touches];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    [self updateTouchAngleWithTouches:touches];
}

- (void)updateTouchAngleWithTouches:(NSSet *)touches {
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self.view];
    self.touchAngle = [self calculateAngleToPoint:touchPoint];
}

- (CGFloat)calculateAngleToPoint:(CGPoint)point {
    CGPoint centerOffset = CGPointMake(point.x - CGRectGetMidX(self.view.bounds), point.y - CGRectGetMidY(self.view.bounds));
    CGFloat alpha = atan2(centerOffset.y, centerOffset.x) + M_PI + M_PI_2;
    if (alpha > 2 * M_PI) alpha -= 2 * M_PI;
    if (alpha < 0) alpha += 2 * M_PI;
    return alpha;
}

@end
