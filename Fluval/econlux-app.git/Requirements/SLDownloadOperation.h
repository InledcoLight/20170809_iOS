//
//  CVDownloadOperation.h
//  CVSTorageTools
//
//  Created by Marco Rademacher on 24.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "APMacros.h"

@interface SLDownloadOperation : NSOperation <NSURLConnectionDelegate, NSURLConnectionDataDelegate>
{
    NSURLRequest *request;
    NSURLConnection *connection;
    NSMutableData *receivedData;
}

@property (copy, nonatomic) void (^blockOnDownloadFinish)(NSData *someData, NSInteger statusCode);
@property (copy, nonatomic) void (^blockOnDownloadFail)(NSError *anError, NSInteger statusCode);
@property (copy, nonatomic) void (^blockOnDownloadStep)(float progress);
@property (copy, nonatomic) void (^blockOnResponse)(NSURLResponse *response);
@property (copy, nonatomic) void (^blockOnAuthentificationRequest)(NSURLAuthenticationChallenge *); // Will be used in a static manner

@property(readonly) BOOL isExecuting;
@property(readonly) BOOL isFinished;

- (id) initWithRequest:(NSURLRequest*)rq;

@end
