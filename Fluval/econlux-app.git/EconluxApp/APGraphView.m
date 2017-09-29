//
//  APGraphView.m
//  EconluxApp
//
//  Created by Michael Müller on 05.06.14.
//  Copyright (c) 2014 AppPilots GbR. All rights reserved.
//

#import "APGraphView.h"
#import "APPhase.h"
#import <UIColor+HexString.h>
#import <AZDateBuilder/NSDate+AZDateBuilder.h>

#define PADDING 10

#define IDX_SUNRISE 0
#define IDX_BREAK 1
#define IDX_SUNSET 2
#define IDX_MOON 3

@interface APGraphView()

@property (nonatomic, assign) int xStart, yStart;

@end
@implementation APGraphView


// #####################################################

- (void)drawRect:(CGRect)rect
{
	[super drawRect:rect];

	self.backgroundColor = [UIColor clearColor];
	
	int x = PADDING;
	int width = self.width - PADDING * 2;
	int y = PADDING;
	int height = self.height - PADDING * 2;
	
	int yLineStartX = x + 13;
	int xLineStartY = height - 20;
	self.xStart = yLineStartX;
	self.yStart = xLineStartY;
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetStrokeColorWithColor(context, MAIN_COLOR.CGColor);
	
	// DRAW HORIZONTAL LINE
	CGContextSetLineWidth(context, 1.0f);
	CGContextMoveToPoint(context, x, xLineStartY); //start at this point
	CGContextAddLineToPoint(context, width, xLineStartY); //draw to this point
	CGContextStrokePath(context);
	
	// DRAW VERTICAL LINE
	CGContextSetLineWidth(context, 1.0f);
	CGContextMoveToPoint(context, yLineStartX, y); //start at this point
	CGContextAddLineToPoint(context, yLineStartX, height - 10); //draw to this point
	CGContextStrokePath(context);
	
	
	// DRAW THE HORIZONTAL LEGEND
	int loops = 25;
	int segmentSize = ((self.width - PADDING * 2) - self.xStart) / 24;
	UIFont *font = [UIFont systemFontOfSize:5];
	
	for(int i=0; i<loops; i++)
	{
		CGContextSetStrokeColorWithColor(context, MAIN_COLOR.CGColor);

		int x = yLineStartX + i*segmentSize;
		
		// DRAW THE TIME DOTS
		CGContextSetLineWidth(context, 1.0f);
		CGContextMoveToPoint(context, x, height-20);
		CGContextAddLineToPoint(context, x, height-18);
		CGContextStrokePath(context);
		
		// LABEL TIME DOTS
		
		if(i==0 || i==loops-1)
			continue;
		
		CGFloat fontHeight = font.pointSize;
		CGFloat yOffset = height - 18;
		
		CGRect textRect = CGRectMake(x-3, yOffset, 10, fontHeight);
		
		[[NSString stringWithFormat:@"%2d", i] drawInRect:textRect withAttributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:MAIN_COLOR}];
		
	}

	// DRAW THE VERTICAL LEGEND
	
	loops = 10;
	
	double yMin = self.yStart;
	double yMax = PADDING;
	double yForPercent = (yMin - yMax) / 100;
	
	for(int i=0; i<loops; i++)
	{
		CGContextSetStrokeColorWithColor(context, MAIN_COLOR.CGColor);

		int y = yMin - (100 - i*10) * yForPercent;
		
		// DRAW THE TIME DOTS
		CGContextSetLineWidth(context, 1.0f);
		CGContextMoveToPoint(context, yLineStartX, y);
		CGContextAddLineToPoint(context, yLineStartX - 2, y);
		CGContextStrokePath(context);
		
		//CGFloat fontHeight = font.pointSize;
		CGRect textRect = CGRectMake(0, y - 3, 20, 5);
		
		[[NSString stringWithFormat:@"%d%%", 100-i*10] drawInRect:textRect withAttributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:MAIN_COLOR}];

	}


	// DRAW THE ACTUAL GRAPH
	[self drawPoints:context];
	
}

// #####################################################

- (void) drawPoints:(CGContextRef)ctx {
	
	NSArray *sortedPhases = [self.channel.phases.allObjects
                             sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"sort" ascending:YES]]];
	
	double hourSize = ((self.width - PADDING * 2) - self.xStart) / 24;

	double yMin = self.yStart;
	double yMax = PADDING;
	double yForPercent = (yMin - yMax) / 100;
	
	NSDateFormatter *formatter = [NSDateFormatter new];
	formatter.dateFormat = @"HH";
	NSDateFormatter *formatterSec = [NSDateFormatter new];
	formatterSec.dateFormat = @"mm";
	
	/////
	// DRAW THE CURRENT LIGHT POWER POINT / NOT INCLUDED
	/////
	
    /*if(self.channel.lightValue >= 0) {

        UIFont *font = [UIFont systemFontOfSize:5];
        NSDateFormatter *minutesFormatter = [NSDateFormatter new];
        [minutesFormatter setDateFormat:@"mm"];
        
        int hour = [[formatter stringFromDate:[NSDate date]] intValue];
        int minute = [[minutesFormatter stringFromDate:[NSDate date]] intValue];
        
        int x = self.xStart + hour * hourSize + minute * hourSize/60;
        int y = yMin - 0 * yForPercent;
        int y2 = yMin - 100 * yForPercent;
        
        CGContextSetStrokeColorWithColor(ctx, [UIColor colorWithWhite:0.606 alpha:0.100].CGColor);
        [self drawLineFrom:CGPointMake(x, y) to:CGPointMake(x, y2) inContext:ctx];
        
        // BUBBLE ON TOP
        CGContextSetLineWidth(ctx, 10);
        CGContextSetRGBStrokeColor(ctx,0.8,0.8,0.8,1.0);
        CGContextAddArc(ctx, x, y2 + yForPercent * 4, 5, 0, 2 * M_PI, 0);
        CGContextStrokePath(ctx);
        
        font = [UIFont boldSystemFontOfSize:8];
        CGFloat fontHeight = font.pointSize;
        CGRect textRect = CGRectMake(x-10 + (self.channel.lightValue > 99? 0 : 2), y2 - yForPercent * 2 + 2, 35, fontHeight);
        [[NSString stringWithFormat:@"%2d%%", self.channel.lightValue] drawInRect:textRect withAttributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName: [UIColor darkGrayColor]}];

    }*/
	
	
	/////
	// HANDLE IMPLICIT STARTING FILLING LINE
	/////
	
	APPhase *tempPhase = nil;
	BOOL containsTempPhase = false;
	int hourFirstPhase = [[formatter stringFromDate:[[sortedPhases firstObject] timeFrom]] intValue];
	if(hourFirstPhase > 0) {
		
		tempPhase = [APPhase insertInManagedObjectContext:MOC];
		APPhase *lastPhase = sortedPhases.lastObject;
		tempPhase.color = lastPhase.color;
		tempPhase.timeFrom = [NSDate AZ_dateByUnit:@{AZ_DateUnit.hour:@0}];
		tempPhase.timeTo = [[sortedPhases firstObject] timeFrom];
		tempPhase.valueValue = lastPhase.valueValue;
		containsTempPhase = YES;
		sortedPhases = [@[tempPhase] arrayByAddingObjectsFromArray:sortedPhases];
	}
	
	CGPoint lastPoint = CGPointMake(self.xStart, self.yStart);

	for(int i=0; i<sortedPhases.count; i++) {
		
		APPhase *phase = sortedPhases[i];
		APPhase *lastPhase = i>0? sortedPhases[i-1] : [sortedPhases lastObject];
		
		// SKIP ON PHASES WHICH DONT HAVE ANY TIME ENTRIES
		if(!phase.timeFrom && !phase.timeTo) {
			continue;
		}
		
		// GET/SET THE DRAW COLOR
		UIColor *color = [UIColor colorWithHexString:phase.color];
		if(!color) color = [UIColor blackColor];
	
		// GET Y VALUE
		int value = phase.value.intValue;
		
		// ON SUNSET: OVERWRITE TO VALUE WITH MOON (IMPLICIT)
		if(i-containsTempPhase == IDX_SUNSET) {
			APPhase *moonPhase = sortedPhases[IDX_MOON + containsTempPhase];
			value = moonPhase.valueValue;
		}
		
		int y = yMin - value * yForPercent;
		if(i==0)
			lastPoint.y = yMin - lastPhase.valueValue * yForPercent;
		
		// GET X VALUE
		int timeFromHours	= [[formatter stringFromDate:phase.timeFrom] intValue];
		int timeToHours		= [[formatter stringFromDate:phase.timeTo] intValue];
		int timeFromMins	= [[formatterSec stringFromDate:phase.timeFrom] intValue];
		int timeToMins		= [[formatterSec stringFromDate:phase.timeTo] intValue];

		int xStart = self.xStart + timeFromHours * hourSize + timeFromMins * (hourSize/60);
		int xEnd = self.xStart + timeToHours * hourSize + timeToMins * (hourSize/60);
		
		// EXTENSION OF THE HORIZONTAL LINE IF THERE IS A GAP BETWEEN TWO POINTS
		CGContextSetStrokeColorWithColor(ctx, [UIColor colorWithRed:0.56 green:0.27 blue:0.68 alpha:1].CGColor);
	
		CGPoint p1 = CGPointMake(lastPoint.x, lastPoint.y);
		CGPoint p2 = CGPointMake(xStart, lastPoint.y);
		[self drawLineFrom:p1 to:p2 inContext:ctx];
	
		CGContextSetStrokeColorWithColor(ctx, color.CGColor);
	
		   if(phase.startsLinearValue || phase.stopsLinearValue) {
			
			// DRAW A DIRECT LINEAR (DIAGONAL) LINE
			CGPoint p3 = CGPointMake(xStart, lastPoint.y);
			CGPoint p4 = CGPointMake(xEnd, y);
			[self drawLineFrom:p3 to:p4 inContext:ctx];
			lastPoint = p4;
			
		} else {
		
			// VERTICALLY EXTENSION TO NEW POINT
			CGPoint p3 = CGPointMake(xStart, lastPoint.y);
			CGPoint p4 = CGPointMake(xStart, y);
			[self drawLineFrom:p3 to:p4 inContext:ctx];
			
			// HORIZONTAL VALUE LINE
			CGPoint p5 = CGPointMake(xStart, y);
			CGPoint p6 = CGPointMake(xEnd, y);
			[self drawLineFrom:p5 to:p6 inContext:ctx];
			
			// HANDLE SPECIAL STATE OF A BREAK
			// JUST PUSH UP TO THE START VALUE
			if(phase.isBreakValue) {
				
				// VERTICALLY EXTENSION FOR THE NEW POINT
				CGPoint p1 = CGPointMake(xEnd, y);
				CGPoint p2 = CGPointMake(xEnd, lastPoint.y);
				[self drawLineFrom:p1 to:p2 inContext:ctx];
				lastPoint = p2;
				
			} else {

				lastPoint = p6;
			}
			
			
		}
		

	}
	
}

// #####################################################

- (void) drawLineFrom:(CGPoint)p1 to:(CGPoint)p2 inContext:(CGContextRef)context {

    // DRAW THE TIME DOTS
    CGContextSetLineWidth(context, 1.5f);
    CGContextMoveToPoint(context, p1.x, p1.y);
    CGContextAddLineToPoint(context, p2.x, p2.y);
    CGContextStrokePath(context);
	
}

// #####################################################

@end
