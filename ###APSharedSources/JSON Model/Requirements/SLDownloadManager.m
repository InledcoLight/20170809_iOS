
//
//  Created by Michael Müller on 24.04.12.
//  Copyright (c) 2012 App-Pilot.biz. All rights reserved.
//

#import "SLDownloadManager.h"
#import "SLDownloadOperation.h"

@interface SLDownloadManager()

@property (strong, nonatomic)NSOperationQueue* operationQueue;
@property (nonatomic, strong) NSMutableArray *temporaryQueue;
@property (nonatomic, assign) NSInteger numberOfMaxDownloads, numberOfCompletedDownloads;

@end


@implementation SLDownloadManager

+ (SLDownloadManager*)sharedSLDownloadManager
{
    static SLDownloadManager* sharedCVDownloadManager;
    static dispatch_once_t done;
    dispatch_once(&done,^{sharedCVDownloadManager = [SLDownloadManager new]; });
    return sharedCVDownloadManager;
}

- (id)init
{
    self = [super init];
    if (self) 
    {
        self.operationQueue = [[NSOperationQueue alloc] init];
    }
    return self;
}

- (void) addOperation:(NSOperation *)operation
{
    [[self operationQueue] addOperation:operation];
    //NSLog(@"Now active operations: %d", (int)[self.operationQueue operationCount]);
}

- (void) loadBunchOfRequests:(NSArray *)arrayOfNSURLRequest andCompletionBlocks:(NSArray *)arrayOfCompletionBlocks
{
    
    NSLog(@"ERROR NEEDS TO BE IMPLEMENTED!!");
    
//    // EARLY RETURN ON EMPTY DATA
//    if(arrayOfNSURLRequest.count == 0)
//    {
//        if(self.blockOnLoadingProgressChange)
//            self.blockOnLoadingProgressChange(1.0f);
//        return;
//    }
// 
//    self.numberOfMaxDownloads = arrayOfNSURLRequest.count;
//    self.numberOfCompletedDownloads = 0;
//    
//    // ADD EACH REQUEST
//    __weak SLDownloadManager *me = self;
//    for (int i=0;i<arrayOfNSURLRequest.count;i++)
//    {
//        NSURLRequest *aRequest = [arrayOfNSURLRequest objectAtIndex:i];
//        void (^block)(NSData *) = [arrayOfCompletionBlocks objectAtIndex:i];
//        
//        // CREATE THE OPERATION
//        SLDownloadOperation *op = [[SLDownloadOperation alloc] init
//                                   
//                                   initWithRequest:aRequest onFinish:^(NSData *data) {
//            me.numberOfCompletedDownloads++;
//            double loadingProgress = (float)me.numberOfCompletedDownloads / (float)me.numberOfMaxDownloads;
//        
//            if(block)
//                block(data);
//            
//            // CALLING THE STEP BLOCK
//            if(me.blockOnLoadingProgressChange)
//                me.blockOnLoadingProgressChange(loadingProgress);
//        }];
//        
//        // DETACH THE OPERATION
//        [[self operationQueue] addOperation:op];
//        
//    }
}

@end
