
//
//  APJSONModel.m
//  JSONModelGenerator
//
//  Created by Michael Müller on 05.04.14.
//  Copyright (c) 2014 AppPilots GbR. All rights reserved.
//

#import "APJSONModel.h"
#import "SLDownloadManager.h"
#import "SLDownloadOperation.h"
//pod 'Base64', '~> 1.0'
#import <Base64/MF_Base64Additions.h>

@implementation APJSONModel

// #####################################################

- (id)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
     
        Class myClass = self.class;
        NSDictionary *config = [myClass loadConfiguration:self.class];
        
        for(NSString *key in [config allKeys])
        {
            [self setValue:[coder valueForKey:config[key]] forKeyPath:config[key]];
        }
        
    }
    
    return self;
}

// ################################################

- (id) initWithDictionary:(NSDictionary *)dict {
	
	self = [super init];
	[self setDictionary:dict];
	return self;
}

// ################################################

- (NSString *) description {

	NSMutableString *str = [NSMutableString new];
	
	[str appendString:[[self class] description]];
	[str appendString:@"\n"];
	
	NSDictionary *config = [self loadConfiguration:[self class]];
	for(NSString *key in config) {
		
		NSString *modelKey = config[key];
		if ([modelKey rangeOfString:@"@"].location == NSNotFound) {
			[str appendFormat:@"%@ # %@\n", modelKey, [self valueForKey:modelKey]];
		} else {
			NSArray *comps = [modelKey componentsSeparatedByString:@"@"];
			modelKey = comps[0];
			[str appendFormat:@"%@ # %@\n", modelKey, [self valueForKey:modelKey]];
		}
	}

	return str;
}

// ################################################

- (void) setDictionary:(NSDictionary *)dict {

	NSDictionary *config = [self loadConfiguration:[self class]];
	
	for(NSString *key in config) {
		
		NSString *modelKey = config[key];
		id value = [dict valueForKeyPath:key];
		
		// SKIP NSNULL VALUES
		if([value isKindOfClass:[NSNull class]]) {
			continue;
		}
		
		// HANDLE ANOTHER APJSON OBJECT
		if ([modelKey rangeOfString:@"@"].location != NSNotFound) {

			NSArray *comps = [modelKey componentsSeparatedByString:@"@"];
			modelKey = comps[0];
			NSString *className = comps[1];

			// HANDLE ARRAY
			if([value isKindOfClass:[NSArray class]]) {
				
				NSMutableArray *subModelArray = [NSMutableArray new];
				for(NSDictionary *subModelDict in value) {
					[subModelArray addObject:[(APJSONModel *)[NSClassFromString(className) alloc] initWithDictionary:subModelDict]];
				}

				[self setValue:subModelArray forKey:modelKey];
				
			} else {

				// HANDLE DICT
				APJSONModel *obj = [(APJSONModel *)[NSClassFromString(className) alloc] initWithDictionary:value];
				[self setValue:obj forKey:modelKey];
				
			}

		} else {
			
			[self setValue:value forKey:modelKey];
		}
	
	}
	
	[self handleRawDataDict:dict];

}

// ################################################

- (NSDictionary *) loadConfiguration:(Class)class
{
    NSString *str = [[NSBundle mainBundle] pathForResource:[class description] ofType:@"model"];
    str = [[NSString alloc] initWithContentsOfFile:str encoding:NSUTF8StringEncoding error:nil];
    
    NSAssert(str, @"ERROR: Please distribute a valid model file for %@ model class!", [[self class] description]);
    
    NSArray *rows = [str componentsSeparatedByString:@"\n"];
    NSMutableDictionary *dict = [NSMutableDictionary new];
    
    for(NSString *row in rows)
    {
        NSArray *cols = [row componentsSeparatedByString:@"\t"];
        NSAssert(cols.count == 2, @"Invalid file format for model %@!", self.class);
        [dict setValue:cols[1] forKey:cols[0]];
    }
    
    return dict;
}

// #####################################################

- (NSString *)descriptionFromConfig:(NSDictionary *)config
{
    NSMutableString *str = [NSMutableString new];
    [str appendString:@"##### ##### #####\n"];
	for(NSString *key in config.allKeys) {
		
		NSString *cleanKey = config[key];
		if([self respondsToSelector:NSSelectorFromString(cleanKey)]) {
			[str appendString:[NSString stringWithFormat:@"%@ ## %@\n", config[key], [self valueForKeyPath:cleanKey]]];
		}
		
	}
	
    return str;
}






#pragma mark -
#pragma mark Network Acessors

// #####################################################

- (void) fetchDataFrom:(NSString *)url
               keyPath:(NSString *)keyPath
            completion:(void (^)(NSArray *))onCompletion
                 error:(void (^)(NSError *))onError
{
	[self fetchDataFrom:url keyPath:keyPath username:nil password:nil completion:onCompletion error:onError];
}

// #####################################################

- (void) fetchDataFrom:(NSString *)url
               keyPath:(NSString *)keyPath
			  username:(NSString *)username
			  password:(NSString *)password
            completion:(void (^)(NSArray *))onCompletion
                 error:(void (^)(NSError *))onError
{
    NSLog(@"Requesting ## %@", url);
    
	// FETCH THE DATA
    NSDictionary *requestHeaders = @{};
	
	// CREATING THE BASIC AUTH HEADER
	if(username && password)
	{
		NSString *base64String = [NSString stringWithFormat:@"%@:%@", username, password];
		base64String = [base64String base64String];
		requestHeaders = [requestHeaders mutableCopy];
		[requestHeaders setValue:[NSString stringWithFormat:@"Basic %@",base64String] forKey:@"Authorization"];
	}
    
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
	for(NSString *key in requestHeaders.allKeys)
		[request setValue:requestHeaders[key] forHTTPHeaderField:key];
	
	// FILL THE BODY
	if(self.httpBody)
		[request setHTTPBody:self.httpBody];

	SLDownloadOperation *op = [[SLDownloadOperation alloc] initWithRequest:request];
	[op setBlockOnDownloadFinish:^(NSData *data, NSInteger status) {
		
		// HANDLE ERROR
        if(status != 200)
        {
            NSError *err = [NSError errorWithDomain:@"APJSONModel" code:status userInfo:@{@"error":@"Status code != 200", @"statusCode":[NSNumber numberWithInteger:status]}];
            if(onError)
                onError(err);
            return;
        }
        
        // HANDLE SUCCESS
        id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        // HANDLE JSON PARSING ERROR
        if(!jsonObject)
        {
            NSError *err = [NSError errorWithDomain:@"APJSONModel"
                                               code:-100
                                           userInfo:@{@"error":@"JSON Parsing error! Invalid data?!"}];
            if(onError)
                onError(err);
            return;
        }
        
        // GET THE KEYPATH DATA
        id rawDataObject = jsonObject;
        if(keyPath)
            rawDataObject = [rawDataObject valueForKey:keyPath];
        
        if(!rawDataObject)
        {
            NSError *err = [NSError errorWithDomain:@"APJSONModel"
                                               code:-200
                                           userInfo:@{@"error":@"JSON result is nil! Invalid keypath?!?!",
                                                      @"keyPath":keyPath}];
            if(onError)
                onError(err);
            return;
        }
		      
		[self handleResponseData:rawDataObject completion:onCompletion];

	}];
	
	[op setBlockOnResponse:^(NSURLResponse *response) {
		
//		NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
//		NSDictionary *header = [httpResponse allHeaderFields];
//		
//		NSString *cacheControl = [header valueForKey:@"Cache-Control"];
		
		//NSLog(@"CacheControl: %@", cacheControl);
	}];
	
	[op setBlockOnDownloadFail:^(NSError *err, NSInteger code) {
		NSLog(@"JSONModel connection did fail (%ld) \n %@", (long)code, err);
	}];
	
	[[SLDownloadManager sharedSLDownloadManager] addOperation:op];
}

// #####################################################

- (void) handleResponseData:(id)rawDataObject completion:(void (^)(NSArray *))onCompletion
{
	// HANDLE THE VALID DATA
	NSMutableArray *arr = [NSMutableArray new];
	if([rawDataObject isKindOfClass:[NSArray class]])
	{
		for(NSDictionary *value in rawDataObject)
		{
			APJSONModel *newObject = [[[self class] alloc] initWithDictionary:value];
			[arr addObject:newObject];
		}
	}
	else
	{
		APJSONModel *newObject = [[[self class] alloc] initWithDictionary:rawDataObject];
		if(newObject)
			[arr addObject:newObject];
	}
	
	if(onCompletion)
		onCompletion(arr);
    
}

// #####################################################

- (void) handleRawDataDict:(NSDictionary *)dict {
	// TO OVERWRITE BY SUBCLASS
}

// #####################################################

- (BOOL)isEqual:(id)object
{
	if(![self respondsToSelector:@selector(identifier)])
		return NO;
    return [[object identifier] isEqualToString:[self valueForKey:@"identifier"]];
}

// #####################################################


#pragma mark -
#pragma mark NSCoding

- (void)encodeWithCoder:(NSCoder *)coder {
    
    Class myClass = self.class;
    NSDictionary *config = [myClass loadConfiguration:self.class];
                            
    for(NSString *key in [config allKeys])
    {
        [coder encodeObject:[self valueForKeyPath:config[key]] forKey:config[key]];
    }

}

// #####################################################


@end
