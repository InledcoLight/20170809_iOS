//
//  CVDownloadOperation.m
//  CVSTorageTools
//
//  Created by Marco Rademacher on 24.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SLDownloadOperation.h"

@interface SLDownloadOperation()
@property(assign) BOOL isExecuting;
@property(assign) BOOL isFinished;
@property(strong, nonatomic) NSMutableData* receivedData;
@property(assign) int statusCode;
@property (nonatomic, strong) NSError *error;

@property (nonatomic, assign) long long expectedContentSize;
@property (nonatomic, assign) float currentProgress;

@end

// Static authentification block
static void (^sharedAuthentificationBlock)(NSURLAuthenticationChallenge *challenge);

@implementation SLDownloadOperation

@synthesize receivedData;

#pragma mark -
#pragma mark Initialization

- (id) initWithRequest:(NSURLRequest*)rq
{
    self = [super init];
    
    if (self)
    {
        request = rq;
        _isExecuting = NO;
        _isFinished = NO;
    }

    return self;
}

// #####################################################

- (void)dealloc
{
    self.receivedData = nil;
}

// #####################################################

- (void)setBlockOnAuthentificationRequest:(void (^)(NSURLAuthenticationChallenge *))blockOnAuthentificationRequest
{
    sharedAuthentificationBlock = blockOnAuthentificationRequest;
}

#pragma mark -
#pragma mark NSOperation Stuff


- (void)start
{
    NSParameterAssert(request);
 
    if (![NSThread isMainThread])
    {
        [self performSelectorOnMainThread:@selector(start) withObject:nil waitUntilDone:NO];
        return;
    }

    //NSLog(@"operation for <%@> started.", [request URL]);
    
    [self willChangeValueForKey:@"isExecuting"];
    _isExecuting = YES;
    [self didChangeValueForKey:@"isExecuting"];

    self.receivedData = [[NSMutableData alloc] init];
    connection = [[NSURLConnection alloc] initWithRequest:request
                                                  delegate:self];
    if (connection == nil)
        [self finish];
}

- (void)finish
{
//    NSLog(@"operation for <%@> finished.\n"
//          @"status code: %d, error: %@, data size: %lu",
//          [request URL], self.statusCode, self.error, (unsigned long)[self.receivedData length]);
    
    connection = nil;
    
    [self willChangeValueForKey:@"isExecuting"];
    [self willChangeValueForKey:@"isFinished"];
    
    _isExecuting = NO;
    _isFinished = YES;
    
    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];
    
    if(![self isCancelled])
    {
        if (self.statusCode != 200)
        {
            if(self.blockOnDownloadFail)
                self.blockOnDownloadFail(nil, self.statusCode);
            
            return;
        }

        if (self.error)
        {
            if(self.blockOnDownloadFail)
                self.blockOnDownloadFail(self.error, self.statusCode);
        }
        
        if(self.blockOnDownloadFinish)
            self.blockOnDownloadFinish(self.receivedData, self.statusCode);
        
        return;
    }

}

- (BOOL)isConcurrent
{
    return YES;
}



#pragma mark -
#pragma mark NSURLConnection Callbacks



- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    self.statusCode = (int)[httpResponse statusCode];
    self.expectedContentSize = [response expectedContentLength];
    
	if(self.blockOnResponse)
		self.blockOnResponse(httpResponse);
//    DLog(@"Expct. content size: %lld", self.expectedContentSize);
//    DLog(@"%@", [httpResponse allHeaderFields]);
}

- (void) connection: (NSURLConnection*) cn didReceiveData: (NSData*) data
{

    // Not cancelled, receive data.
    if (![self isCancelled]) 
    {
        [self.receivedData appendData:data];
        
        self.currentProgress = (float)[self.receivedData length]  / (float)[self expectedContentSize];

        if(self.blockOnDownloadStep)
            self.blockOnDownloadStep(self.currentProgress);
        
        return;
    }
    
    NSLog(@"Operation canceled, ignoring new files and returning...");
    
    // Cancelled, tear down connection.
    [self setIsExecuting:NO];
    [self setIsFinished:YES];
    [cn cancel];
    [connection cancel];
}


- (void) connectionDidFinishLoading: (NSURLConnection*) cn
{
    [self finish];
}

- (void) connection: (NSURLConnection*) cn didFailWithError: (NSError*) error
{
    self.error = error;
    [self finish];
}

- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace
{
//    DLog(@"ProtectionSpace: %@ | %@ | %d", protectionSpace.authenticationMethod, protectionSpace.host, protectionSpace.port);
	return ([protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust] || [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodDefault]);
}

//#warning implement the ssl pinning
// Diese Methode wird für die Anwendung des SSL Pinnings verwendet
// und checked damit das übermittelte Zertifikat gegen das vertrauenswürdige
// innerhalb des main bundles. Eine Übereinstimmtung gibt ein OK, sonst Abbruch! (ManInTheMiddle?!)
//- (void) connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
//{
//    SecTrustRef serverTrust = challenge.protectionSpace.serverTrust;
//    SecCertificateRef certificate = SecTrustGetCertificateAtIndex(serverTrust, 0);
//    
//    NSData *remoteCertificateData = CFBridgingRelease(SecCertificateCopyData(certificate));
//
//    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"certificate" ofType:@"crt"]; // Should be cer instead of crt?! Maybe the problem
//    NSData *localCertData = [NSData dataWithContentsOfFile:cerPath];
//    
//    if ([remoteCertificateData isEqualToData:localCertData])
//    {
//        DLog(@"SSL pinning successfully finished! Granting authorized access...");
//
//        NSURLCredential *credential = [NSURLCredential credentialForTrust:serverTrust];
//        [[challenge sender] useCredential:credential forAuthenticationChallenge:challenge];
//    }
//    else
//    {
//        DLog(@"SSL pinning failed! Denying access...");
//        [[challenge sender] cancelAuthenticationChallenge:challenge];
//    }
//}


//}

#define kAllowedLoginFailures 5

//- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
//{
//	
//	
//	
//    if(sharedAuthentificationBlock)
//    {
//		NSLog(@"Calling custom auth request block...");
//		sharedAuthentificationBlock(challenge);
//		return;
//    }
//    else
//    {
//		NSLog(@"Handling default way of auth request");
//        if (([challenge previousFailureCount] <= kAllowedLoginFailures))
//        {
//            
//            [[challenge sender]  useCredential:[NSURLCredential
//                                                credentialWithUser:@""
//                                                password:@""
//                                                persistence:NSURLCredentialPersistenceNone]
//                    forAuthenticationChallenge:challenge];
//        } else {
//            NSLog(@"Canceling auth: Too many tries!");
//            [[challenge sender] cancelAuthenticationChallenge:challenge];
//    }
//    }
//}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
	NSLog(@"Did receive auth challenge: %@", challenge);
	
	if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
		NSLog(@"Handling server trust");
		[challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
	}
	
	[challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
}

@end
