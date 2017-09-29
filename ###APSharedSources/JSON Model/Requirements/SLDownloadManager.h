
//
//  Created by Michael Müller on 24.04.12.
//  Copyright (c) 2012 App-Pilot.biz. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SLDownloadManager : NSObject

@property (copy, nonatomic) void (^blockOnLoadingProgressChange) (float loadingProgressInPercent);

- (void) addOperation:(NSOperation *)operation;

// USE THIS METHOD TO LOAD MULTIPLE REQUESTS
// AND USE THE onLoadingProgressChange BLOCK TO GET NOTE ON EVENTS
- (void) loadBunchOfRequests:(NSArray *)arrayOfNSURLRequest andCompletionBlocks:(NSArray *)arrayOfCompletionBlocks;

+ (SLDownloadManager*)sharedSLDownloadManager;

@end
