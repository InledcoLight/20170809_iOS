//
//  DEMOViewController.h
//  MLPFlatColorsDemo
//
//  Created by Eddy Borja on 4/10/13.
//  Copyright (c) 2013 Mainloop LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface APColorPicker : UIViewController
<
	UICollectionViewDataSource, UICollectionViewDelegate
>

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (copy) void (^onColorSelection)(UIColor *);

@end
