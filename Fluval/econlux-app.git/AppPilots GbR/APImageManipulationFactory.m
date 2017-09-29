//
//  SMImageManipulationFactory.m
//  Salesman
//
//  Created by Michael Müller on 12/21/12.
//
//

#import "APImageManipulationFactory.h"
#import <QuartzCore/QuartzCore.h>

@implementation APImageManipulationFactory

// ###########################################################

+ (UIImage *)imageWithImage:(UIImage *)i scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    
    [i drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

// ###########################################################

+ (UIImage *) scaleImage:(UIImage *)src proportionalToSize:(CGSize)size
{
    // IF IMAGE IS SMALLER THAN THE WANTED SIZE
    if(src.size.height <= size.height && src.size.width <= size.width)
        return src;
    
    // GET THE RATIOS
    float widthRatio = size.width/src.size.width;
    float heightRatio = size.height/src.size.height;
    
    // CHOOSE THE CURRENT ACTION
    if(widthRatio > heightRatio)
    {
        size = CGSizeMake(src.size.width*heightRatio,src.size.height*heightRatio);
    }
    else
    {
        size = CGSizeMake(src.size.width*widthRatio,src.size.height*widthRatio);
    }
    
    // RETURN IMAGE
    return [APImageManipulationFactory imageWithImage:src scaledToSize:size];
}

// ###########################################################

+ (UIImage *)imageFromUIView:(UIView *)anyView
{
    UIGraphicsBeginImageContext(anyView.bounds.size);
    [anyView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultingImage;
}

// ###########################################################

@end
