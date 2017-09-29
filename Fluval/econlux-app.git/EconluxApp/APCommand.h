//
//  APCommand.h
//  EconluxApp
//
//  Created by Michael Müller on 04.02.15.
//  Copyright (c) 2015 AppPilots GbR. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^GatewayConnectorBlock)(NSString *response);


@interface APCommand : NSObject

@property (nonatomic, copy) GatewayConnectorBlock completionBlock;
@property (nonatomic, strong) NSString *command;

@end
