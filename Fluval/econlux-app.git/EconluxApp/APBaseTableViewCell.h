//
//  APBaseTableViewCell.h
//  EconluxApp
//
//  Created by Michael Müller on 07.02.15.
//  Copyright (c) 2015 AppPilots GbR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface APBaseTableViewCell : UITableViewCell

@property (nonatomic, assign) IBOutlet UILabel *labelTitle;
@property (nonatomic, assign) IBOutlet UIImageView *imageViewIcon;

@end
