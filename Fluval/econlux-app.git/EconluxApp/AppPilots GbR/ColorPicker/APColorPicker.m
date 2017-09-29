//
//  DEMOViewController.m
//  MLPFlatColorsDemo
//
//  Created by Eddy Borja on 4/10/13.
//  Copyright (c) 2013 Mainloop LLC. All rights reserved.
//

#import "APColorPicker.h"
#import "UIColor+MLPFlatColors.h"
#import <QuartzCore/QuartzCore.h>

@implementation APColorPicker

// #####################################################

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell;
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ColorCell" forIndexPath:indexPath];
	
    [cell setBackgroundColor:[self colorForRow:indexPath.row]];
    [cell.layer setShadowColor:[[UIColor blackColor] CGColor]];
    [cell.layer setShadowOffset:CGSizeMake(0, 1)];
    [cell.layer setShadowOpacity:0.4];
    [cell.layer setShadowPath:CGPathCreateWithRect(cell.bounds, NULL)];
    
    return cell;
}

// #####################################################

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 15;
}

// #####################################################

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"ColorCell"];
	
	// SETTING UP TABLEVIEW
	[[self collectionView] setBackgroundColor:CONTAINER_COLOR];
	
	// CUSTOM STUFF
	// MODIFY BACK BUTTON
	self.navigationController.navigationBar.topItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
	self.title = APLocString(@"PHASE_DETAIL_CHOOSE_COLOR");
	
}

// #####################################################

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

	if(self.onColorSelection)
		self.onColorSelection([self colorForRow:indexPath.row]);
}

// #####################################################

- (UIColor *)colorForRow:(NSInteger)row
{
 
	NSArray *color = @[[UIColor flatRedColor], [UIColor flatDarkRedColor],
					   [UIColor flatBlueColor], [UIColor flatDarkBlueColor],
					   [UIColor flatOrangeColor], [UIColor flatDarkOrangeColor],
					   [UIColor flatYellowColor], [UIColor flatDarkYellowColor],
					   [UIColor flatBlackColor], [UIColor flatDarkBlackColor],
					   [UIColor flatGreenColor], [UIColor flatDarkGreenColor],
					   [UIColor flatGrayColor], [UIColor flatDarkGrayColor],
					   [UIColor flatDarkWhiteColor]];
	
	return color[row];
 
}

// #####################################################


@end
