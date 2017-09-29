//
//  APChannelConfiguration.h
//  EconluxApp
//
//  Created by Michael Müller on 18.02.15.
//  Copyright (c) 2015 AppPilots GbR. All rights reserved.
//

#import "APJSONModel.h"

@interface APChannelConfiguration : APJSONModel

@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *label;
@property (nonatomic, strong) NSString *indizes;

@property (nonatomic, strong) NSArray *indizesAsArray;


@end
