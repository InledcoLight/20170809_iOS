//
//  APJSONModel.h
//  JSONModelGenerator
//
//  Created by Michael Müller on 05.04.14.
//  Copyright (c) 2014 AppPilots GbR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APJSONModel : NSObject

- (NSString *)descriptionFromConfig:(NSDictionary *)config;

- (void) fetchDataFrom:(NSString *)url
               keyPath:(NSString *)keyPath
            completion:(void (^)(NSArray *))onCompletion
                 error:(void (^)(NSError *))onError;

- (void) fetchDataFrom:(NSString *)url
               keyPath:(NSString *)keyPath
			  username:(NSString *)username
			  password:(NSString *)password
            completion:(void (^)(NSArray *))onCompletion
                 error:(void (^)(NSError *))onError;


// TO OVERRIDE
- (void) handleRawDataDict:(NSDictionary *)dict;
- (id) initWithDictionary:(NSDictionary *)dict;
- (void) setDictionary:(NSDictionary *)dict;

// SET FROM THE OUTSIDE IF YOU WANT TO INCLUDE A REQUEST BODY
// SET THIS BEFORE CALL THE FETCH METHODS
@property (nonatomic, strong) NSData *httpBody;

@end
