//
//  APConnectionManager.h
//  EconluxApp
//
//  Created by Michael Müller on 06.07.14.
//  Copyright (c) 2014 AppPilots GbR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APChannel.h"
#import "APGateway.h"

typedef enum {
	GATEWAY_2CH,
	GATEWAY_5CH
} GatewayType;

#define NOTE_SHOW_LOGIN_SCREEN @"NOTE_SHOW_LOGIN_SCREEN"
#define NOTE_GATEWAY_CONNECTED @"NOTE_GATEWAY_CONNECTED"
#define NOTE_GATEWAY_DISCONNECTED @"NOTE_GATEWAY_DISCONNECTED"

@interface APConnectionManager : NSObject

@property (nonatomic, assign) BOOL dummyConnectionFlag;

+ (instancetype) sharedInstance;

// LOGIN META REQUESTS
- (BOOL) login;
- (void) loginWithPassword:(NSString *)password completion:(void (^)(BOOL))completion;
- (void) commitNewPassword:(NSString *)password completion:(void (^)(BOOL))completion;
- (void) logout;

// GATEWAY ENDPOINTS
- (void) requestGatewayType:(void (^)(APGateway *))completion;
- (void) requestGatewayRenamingWithName:(NSString *)newName completion:(void (^)(BOOL))completion;
- (void) commitGatewayReset:(void (^)(BOOL))completion;
- (void) commitGatewayMode:(APGatewayMode)mode completion:(void (^)(BOOL))completion;

// CHANNEL NAME
- (void) requestValueForChannel:(int)channelIdx completion:(void (^)(int))completion;
- (void) commitValue:(int)value forChannel:(int)channelIdx completion:(void (^)(void))completion;

// PHASES (GRAPHEN)
- (void) requestPhasesForChannel:(APChannel *)channel index:(int)index completion:(void (^)(NSArray *))completion;
- (void) commitPhases:(NSArray *)phases forChannel:(int)channelIdx completion:(void (^)(NSString *))completion;

// LIGHT VLAUES
- (void) requestTypeForLight:(int)slotIndex completion:(void (^)(int))completion;
- (void) commitType:(int)type forLight:(int)slotIndex completion:(void (^)(BOOL))completion;
- (void) requestNameForLight:(int)lightIndex completion:(void (^)(NSString *))completion;
- (void) commitName:(NSString *)name forLight:(int)lightIndex completion:(void (^)(void))completion;


// UTILITIES
- (void) commitTime:(void (^)(BOOL))completion;

@end
