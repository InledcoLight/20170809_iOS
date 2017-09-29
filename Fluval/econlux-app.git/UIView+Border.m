//
//  UIView+Border.m
//  MU by Peugeot
//
//  Created by Michael Müller on 13.10.14.
//  Copyright (c) 2014 Michael Müller. All rights reserved.
//

#import "UIView+Border.h"

@implementation UIView(Border)

- (void)addTopBorderWithColor:(UIColor *)color andWidth:(CGFloat) borderWidth {
	CALayer *border = [CALayer layer];
	border.backgroundColor = color.CGColor;
	
	border.frame = CGRectMake(0, 0, self.frame.size.width*10, borderWidth);
	[self.layer addSublayer:border];
}

- (void)addBottomBorderWithColor:(UIColor *)color andWidth:(CGFloat) borderWidth {
	CALayer *border = [CALayer layer];
	border.backgroundColor = color.CGColor;
	
	border.frame = CGRectMake(0, self.frame.size.height - borderWidth, self.frame.size.width * 10, borderWidth);
	[self.layer addSublayer:border];
}

- (void)addLeftBorderWithColor:(UIColor *)color andWidth:(CGFloat) borderWidth {
	CALayer *border = [CALayer layer];
	border.backgroundColor = color.CGColor;
	
	border.frame = CGRectMake(0, 0, borderWidth, self.frame.size.height*10);
	[self.layer addSublayer:border];
}

- (void)addRightBorderWithColor:(UIColor *)color andWidth:(CGFloat) borderWidth {
	CALayer *border = [CALayer layer];
	border.backgroundColor = color.CGColor;
	
	border.frame = CGRectMake(self.frame.size.width - borderWidth, 0, borderWidth, self.frame.size.height*10);
	[self.layer addSublayer:border];
}

@end
