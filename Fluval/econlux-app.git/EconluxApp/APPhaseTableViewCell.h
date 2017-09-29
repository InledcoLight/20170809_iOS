//
//  APPhaseTableViewCell.h
//  EconluxApp
//
//  Created by Michael Müller on 22.06.14.
//  Copyright (c) 2014 AppPilots GbR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RMDownloadIndicator.h"

@interface APPhaseTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelTime;
@property (weak, nonatomic) IBOutlet UIView *labelColorTag;
@property (weak, nonatomic) IBOutlet UIView *progressContainerView;

@property (nonatomic, strong) APPhase *phase;
@property (nonatomic, strong) NSArray *phases;

@end
