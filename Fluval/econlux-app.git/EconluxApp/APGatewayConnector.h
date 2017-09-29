//
//  APGatewayConnector.h
//  EconluxApp
//
//  Created by Michael Müller on 11/07/14.
//  Copyright (c) 2014 AppPilots GbR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDAsyncSocket.h"
#import "APCommand.h"


@protocol APGatewayConnector <NSObject>
-(void)showError;
@property (nonatomic, weak) id <APGatewayConnector> delegate;
@end


@interface APGatewayConnector : NSObject
<
	GCDAsyncSocketDelegate
>

@property (nonatomic, assign) BOOL directControlMode;
@property (strong, nonatomic) UIWindow *window;

+ (instancetype)sharedInstance;

- (void)connectToHost:(NSString *)host port:(int)port onCompletion:(void(^)(BOOL success))onCompletion;
- (BOOL)isConnected;
- (void)disconnect;


- (void)queueCommand:(NSString *)command completion:(void (^)(NSString *))completion;

@end

