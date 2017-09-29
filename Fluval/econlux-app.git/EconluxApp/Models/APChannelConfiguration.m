//
//  APChannelConfiguration.m
//  EconluxApp
//
//  Created by Michael Müller on 18.02.15.
//  Copyright (c) 2015 AppPilots GbR. All rights reserved.
//

#import "APChannelConfiguration.h"

@implementation APChannelConfiguration

- (NSArray *)indizesAsArray {
	
	return [self.indizes componentsSeparatedByString:@","];
}


@end
