//
//  APGatewayConnector.m
//  EconluxApp
//
//  Created by Michael Müller on 11/07/14.
//  Copyright (c) 2014 AppPilots GbR. All rights reserved.
//


#import "APConnectionViewController.h"
#import "APGatewayConnector.h"
#import "GCDAsyncSocket.h"
#import "NSLinkedList.h"


@interface APGatewayConnector()

@property (nonatomic, strong) GCDAsyncSocket *asyncSocket;
@property (nonatomic, assign) BOOL isReady;

@property (nonatomic, strong) NSError *error;
@property (nonatomic, strong) NSMutableArray *commandQueue;

@property (nonatomic, strong) NSMutableString *receiverBuffer;
@property (nonatomic, copy) void (^onConnection) (BOOL);

@end

@implementation APGatewayConnector

static NSString * const terminator = @"\r\n";

static APGatewayConnector *sharedInstance;

// ################################################

+ (instancetype)sharedInstance {

	if(!sharedInstance) {
		sharedInstance = [APGatewayConnector new];
	}
	
	return sharedInstance;
}

// ################################################

- (BOOL)isConnected {
	return self.asyncSocket.isConnected;
}

// ################################################

static NSError *errorWithMessage(NSString *message, NSString *reason)
{
	NSMutableDictionary *info = [NSMutableDictionary dictionary];
	if(message)
	{
		info[NSLocalizedDescriptionKey] = message;
	}
	if(reason)
	{
		info[NSLocalizedFailureReasonErrorKey] = message;
	}
	NSDictionary *userInfo = [NSDictionary dictionaryWithDictionary:info];
	return [NSError errorWithDomain:@"Dali board controller" code:0 userInfo:userInfo];
}

// ################################################

- (BOOL)connected
{
	return self.asyncSocket ? YES : NO;
}

// ################################################

- (void)checkNextRequest
{
	if([self.asyncSocket isConnected])
	{
		APCommand *cmdObj = [self.commandQueue firstObject];
		NSString *cmd = cmdObj.command;
		
		if(cmd)
		{
			self.isReady = NO;
			DLog(@"REQUESTING: %@", cmdObj);

			[self.asyncSocket writeData:[cmd dataUsingEncoding:NSASCIIStringEncoding] withTimeout:-1.0 tag:0];
			self.isReady = YES;
		}
	}
}

// ################################################

- (void)queueCommand:(NSString *)command completion:(GatewayConnectorBlock)completion
{
	if(!self.commandQueue) {
		[APAlert(APLocString(@"ALERT_ERROR"), APLocString(@"ALERT_NO_CONNECTION"), APLocString(@"ALERT_OK")) show];
	}
	
	if(!completion || !command.length) {
		DLog(@"INVALID COMPLETION BLOCK ON QUEUE COMMAND!!");
		return;
	}
	
	APCommand *newCommand = [APCommand new];
	[newCommand setCommand:command ? [command stringByAppendingString:terminator] : terminator];
	[newCommand setCompletionBlock:completion];

    // PUSH DIRECT CONTROL CONTENT
    if(self.directControlMode && !self.commandQueue.count) {
        
        DLog(@"SENDING DIRECT");
        [self.asyncSocket writeData:[[command stringByAppendingString:terminator] dataUsingEncoding:NSASCIIStringEncoding] withTimeout:-1.0 tag:0];
        
    } else {

        // ONLY CALL IF QUEUE WAS EMPTY BEFORE
        [self.commandQueue addObject:newCommand];
        if(self.commandQueue.count == 1)
            [self checkNextRequest];
        
    }
    
}

// ################################################

- (void)connectError:(NSError *)error
{
	[APAlert(@"ERROR", error.description, @"Ok") show];
}

// #####################################################

- (void)connectToHost:(NSString *)host port:(int)port onCompletion:(void(^)(BOOL success))onCompletion
{
	NSError *error;
    self.onConnection = onCompletion;
    
	if(self.asyncSocket)
	{
		error = errorWithMessage(NSLocalizedString(@"Socket already connected", ""), nil);
		[self connectError:error];
		[self disconnect];
		
		onCompletion(false);
	}
	else if(port < 0 || port > 0xFFFF)
	{
		error = errorWithMessage([NSString stringWithFormat:NSLocalizedString(@"Invalid port number %d", ""), port], nil);
		[self connectError:error];
		onCompletion(false);
	}
	else
	{
		self.asyncSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
		self.commandQueue = [[NSMutableArray alloc] init];
		self.receiverBuffer = [[NSMutableString alloc] init];
		
		if(![self.asyncSocket connectToHost:host onPort:(uint16_t)port withTimeout:5.0 error:&error] || error)
		{
			[self connectError:error];
			if(onCompletion)
				onCompletion(NO);
		}
	}
}

// ################################################

- (void)disconnect
{
	if(self.asyncSocket)
	{
		[self.asyncSocket disconnect];
	}
}

// ################################################

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
	//[self.commandQueue pushBack:terminator];
	if(self.onConnection)
		self.onConnection(YES);
    
    // RESET AFTER 2 SECS, BECAUSE THE GATEWAY IS KICKING OUT AFTER CONNECT
    // ISNT CALLBACKED ANYMORE WITHOUT STORED BLOCK
    [self performSelector:@selector(setOnConnection:) withObject:nil afterDelay:2.0f];
	
	self.isReady = YES;
	[self.asyncSocket readDataWithTimeout:-1.0 tag:0];
}

// ################################################

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{

	DLog(@"Did disconnect from host: %@\n%@", sock.connectedAddress, err);
    
    NSString *error = [NSString stringWithFormat:@"%@",err];
    APConnectionManager* mng = [[APConnectionManager alloc] init];
    APConnectionViewController* cvc = [[APConnectionViewController alloc] init];
    
    NSLog([NSString stringWithFormat:@" %ld ", err.code]);
    
    // TODO catch ALL the errors:
    
    
    
    [mng logout];
    switch (err.code) {
        case 0:
            NSLog(@"at 0");
            break;
        case 57: //APP lost connection to the GW / out of range
            [APAlert(APLocString(@"ALERT_WIFI_ERROR"), APLocString(@"ALERT_CONNECTION_LOST"), APLocString(@"ALERT_OK")) show];
            break;
        case 51://7 //Network is unreachable / WLAN not active / no IP yet
            // TODO check for iOS standard IP (169.x.x.x)
            // TODO retry 15 times after that give a hint on the login screen
            [[cvc labelError] setText:APLocString(@"LOGIN_ERROR_RESTART_WIFI")];
            [[cvc labelError] setHidden:NO];
            [[cvc loginButton] setEnabled:NO];
            [[cvc loginButton] setAlpha:0.3];
            break;
        case 3: //timed out / maybe wrong IP
            // TODO refresh IP and give a hint on the login screen
            [[cvc labelError] setText:APLocString(@"LOGIN_ERROR_RESTART_WIFI")];
            [[cvc labelError] setHidden:NO];
            [[cvc loginButton] setEnabled:NO];
            [[cvc loginButton] setAlpha:0.3];
            break;
        case 7:
            [[cvc labelError] setText:APLocString(@"LOGIN_ERROR_RESTART_WIFI")];
            [[cvc labelError] setHidden:NO];
            [[cvc loginButton] setEnabled:NO];
            [[cvc loginButton] setAlpha:0.3];
            break;
        default: //Throw error at the user, ideally this would never happen.
            //[APAlert(APLocString(@"ALERT_WIFI_ERROR"), error, APLocString(@"ALERT_OK")) show];
            [[cvc labelError] setText:APLocString(@"LOGIN_ERROR_RESTART_WIFI")];
            [[cvc labelError] setHidden:NO];
            [[cvc loginButton] setEnabled:NO];
            [[cvc loginButton] setAlpha:0.3];
            break;
    }
    self.isReady = NO;
	self.asyncSocket = nil;
	self.commandQueue = nil;
	self.receiverBuffer = nil;
    
    if(self.onConnection)
        self.onConnection(false);
}

// #####################################################

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
	static NSString * const CRLF = @"\r\n";

	NSString *str = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
	[self.receiverBuffer appendString:str];

	NSRange crlf = [self.receiverBuffer rangeOfString:CRLF];
	while(crlf.location != NSNotFound)
	{
        str = [self.receiverBuffer substringToIndex:crlf.location];
        DLog(@"RESPONSE: %@", str);
        
		if(self.commandQueue.count) {

			
			APCommand *cmd = [self.commandQueue firstObject];
			GatewayConnectorBlock block = [cmd completionBlock];
			if(block) {
				block(str);
			}

			//DLog(@">>>>>>>> (%d) %@", self.commandQueue.count, str);
			
			[self.commandQueue removeObject:cmd];
			[self checkNextRequest];
		}
		
		[self.receiverBuffer deleteCharactersInRange:NSMakeRange(0, crlf.location + crlf.length)];
		crlf = [self.receiverBuffer rangeOfString:CRLF];
	}

	[self.asyncSocket readDataWithTimeout:-1.0 tag:0];
}

// #####################################################

@end
