//
//  SMImageManipulationFactory.h
//  Salesman
//
//  Created by Michael Müller on 12/21/12.
//
//

#import <UIKit/UIKit.h>

@interface APImageManipulationFactory : NSObject

// Scales an image to the given size with correct aspect ratio (Size to aspect fit)
// Images which are smaller than the desired size are returned as they are
+ (UIImage *) scaleImage:(UIImage *)src proportionalToSize:(CGSize)size;

// Scales an image to given size and ignores the aspect ratio
+ (UIImage *) imageWithImage:(UIImage *)i scaledToSize:(CGSize)newSize;

// Generates a screenshot from a given UIView as an UIImage
+ (UIImage *) imageFromUIView:(UIView *)anyView;

@end
