//
//  TemperatureView.m
//  Windhager
//
//  Created by Hannes Jung on 17/02/14.
//  Copyright (c) 2014 LOOP. All rights reserved.
//

#import "APDimmingSwitch.h"
#import "APImageManipulationFactory.h"
#import "APRotationGestureRecognizer.h"


#define START_COLOR [UIColor colorWithRed:0.30 green:0.30 blue:0.30 alpha:1.000]
#define END_COLOR [UIColor colorWithRed:1.00 green:1.00 blue:1.00 alpha:1]
#define LINE_BEHIND_COLOR [UIColor colorWithRed:0.229 green:0.228 blue:0.221 alpha:1.000]
//#define START_COLOR [UIColor colorWithRed:0.591 green:0.790 blue:0.987 alpha:1.000]
//#define END_COLOR [UIColor colorWithRed:0.09 green:0.43 blue:0.78 alpha:1]
//#define LINE_BEHIND_COLOR [UIColor colorWithRed:0.71 green:0.75 blue:0.79 alpha:1]

#define LINE_WEIGHT 15

@interface APDimmingSwitch()

@property (nonatomic, strong) UIColor *startColor;
@property (nonatomic, strong) UIColor *endColor;

@end
@implementation APDimmingSwitch

// ################################################

- (id)initWithCoder:(NSCoder *)aDecoder {

	self = [super initWithCoder:aDecoder];
    
    if (self) {
	
		// SETUP GESTURE RECOGNIZER
		APRotationGestureRecognizer *rotationRecognizer = [[APRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
		[rotationRecognizer setDelegate:self];
		[self addGestureRecognizer:rotationRecognizer];
		
		_startColor = START_COLOR;
		_endColor = END_COLOR;
		
		int size = self.width > self.height? self.width : self.height;
		radiusOuterLines = size / 2 - size * 0.05;
		radiusInnerLines = radiusOuterLines - LINE_WEIGHT;
		
        cx = CGRectGetMidX(self.bounds);
        cy = CGRectGetMidY(self.bounds);
        
        lines = 1500;
		
        deltaAlphaLines = 2 * M_PI / (CGFloat)lines;
		
        pTarget = 0;
        pCurrent = 0;
        
    }
	
    return self;
}

// ################################################

- (void)setProgress:(CGFloat)progress {
	_progress = progress >= 0? progress : 100 + progress;
	[self setNeedsDisplay];
	self.percentLabel.text = [NSString stringWithFormat:@"%d%%", _progress > 99? 100 : (int)_progress];
}

// ################################################

- (void)awakeFromNib {
	
	// SETUP UI
	self.percentLabel.textColor = END_COLOR;
	self.textLabel.textColor = END_COLOR;
	self.textLabel.text = APLocString(@"REMOTE_DIMMER_SUBTITLE");
	self.progress = .1f;
	
	[self setNeedsDisplay];
}

// ################################################

- (void)handleGesture:(APRotationGestureRecognizer *)gesture {

	CGFloat p = gesture.touchAngle / (2 * M_PI);
	CGFloat value = kMinTemp + (kMaxTemp - kMinTemp) * p;
	
	value -= 50;

	self.progress = value;
	float percent = self.progress;
	
	if (percent < 1 || percent > 99) {
		gesture.enabled = NO;
		gesture.enabled = YES;
	}

}

// ################################################



#pragma mark -
#pragma mark - UI Drawing

// ################################################

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineCap(context, kCGLineCapSquare);
    CGContextSetLineWidth(context, 1.0);
	
    //inner dots
    CGFloat alpha = M_PI * 2;

	const CGFloat *startComponents = CGColorGetComponents(_startColor.CGColor);
	const CGFloat *endComponents = CGColorGetComponents(_endColor.CGColor);

	
	// GRAY LINE BEHIND
	alpha = M_PI * 2;
	for (NSInteger i=0; i<lines; i++) {
		
		CGFloat p1x = cx + sinf(alpha) * (-1) * radiusInnerLines;
		CGFloat p1y = cy + cosf(alpha) * (-1) * radiusInnerLines;
		CGFloat p2x = cx + sinf(alpha) * (-1) * radiusOuterLines;
		CGFloat p2y = cy + cosf(alpha) * (-1) * radiusOuterLines;
		
		UIColor *drawColor = LINE_BEHIND_COLOR;
		
		//draw line
		drawLine(context, CGPointMake(p1x, p1y), CGPointMake(p2x, p2y), drawColor, 1.0);
		
		alpha -= deltaAlphaLines;
	}

	// GET THE PERCENT VALUE
	int percent = self.progress;
	int maxNumLines = (int)lines/100 * percent;
	
    // DRAW THE
    alpha = M_PI * 2;
    for (NSInteger i=0; i<lines; i++) {
		
		if(i>maxNumLines)
			break;
		
		CGFloat p1x = cx + sinf(alpha) * (-1) * radiusInnerLines;
        CGFloat p1y = cy + cosf(alpha) * (-1) * radiusInnerLines;
        CGFloat p2x = cx + sinf(alpha) * (-1) * radiusOuterLines;
        CGFloat p2y = cy + cosf(alpha) * (-1) * radiusOuterLines;

		float red = startComponents[0] + (((endComponents[0] - startComponents[0]) / lines) * i);
		float green = startComponents[1] + (((endComponents[1] - startComponents[1]) / lines) * i);
		float blue = startComponents[2] + (((endComponents[2] - startComponents[2]) / lines) * i);
		
		UIColor *drawColor = [[UIColor alloc] initWithRed:red green:green blue:blue alpha:1.0f];

		//draw line
        drawLine(context, CGPointMake(p1x, p1y), CGPointMake(p2x, p2y), drawColor, 1.0);
        
        alpha -= deltaAlphaLines;
    }
 
	// DRAW THE BUMPER
	percent = self.progress;
	alpha = M_PI * 2 - ((M_PI * 2 / 100) * percent);
	int width = 30;
	
	CGFloat p1x = cx + sinf(alpha) * (-1) * (radiusInnerLines + LINE_WEIGHT/2);
	CGFloat p1y = cy + cosf(alpha) * (-1) * (radiusInnerLines + LINE_WEIGHT/2);
	
	UIImage *img = [UIImage imageNamed:@"dimmer_knopf"];
	img = [APImageManipulationFactory imageWithImage:img scaledToSize:CGSizeMake(width, width)];

	[img drawInRect:CGRectMake(p1x-width/2, p1y-width/2, width, width)];
	
}

// ################################################

void drawLine(CGContextRef context, CGPoint startPoint, CGPoint endPoint, UIColor *color, CGFloat width) {
    CGContextSaveGState(context);
    CGContextSetLineCap(context, kCGLineCapSquare);
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGContextSetLineWidth(context, width);
    CGContextMoveToPoint(context, startPoint.x, startPoint.y);
    CGContextAddLineToPoint(context, endPoint.x, endPoint.y);
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
}

// ################################################

@end
