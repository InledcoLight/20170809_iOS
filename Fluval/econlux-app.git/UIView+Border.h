//
//  UIView+Border.h
//  MU by Peugeot
//
//  Created by Michael Müller on 13.10.14.
//  Copyright (c) 2014 Michael Müller. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView(Border)

- (void)addBottomBorderWithColor: (UIColor *) color andWidth:(CGFloat) borderWidth;
- (void)addLeftBorderWithColor: (UIColor *) color andWidth:(CGFloat) borderWidth;
- (void)addRightBorderWithColor: (UIColor *) color andWidth:(CGFloat) borderWidth;
- (void)addTopBorderWithColor: (UIColor *) color andWidth:(CGFloat) borderWidth;


@end
