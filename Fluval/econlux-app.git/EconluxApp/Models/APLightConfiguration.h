//
//  APLightConfiguration.h
//  EconluxApp
//
//  Created by Michael Müller on 18.02.15.
//  Copyright (c) 2015 AppPilots GbR. All rights reserved.
//

#import "APJSONModel.h"
#import "APChannel.h"

@interface APLightConfiguration : APJSONModel

@property (nonatomic, strong) NSNumber *identifier;
@property (nonatomic, strong) NSNumber *type;
@property (nonatomic, strong) NSString *label;
@property (nonatomic, strong) NSArray *channels;

+ (NSArray *) getConfigurations;
+ (APLightConfiguration *) configurationByIdentifier:(int)identifier;

@end
