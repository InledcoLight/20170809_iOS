#import "_APLight.h"

@class APChannel;

@interface APLight : _APLight {}

@property (nonatomic, strong) NSArray *typeTitles;
@property (nonatomic, strong) NSArray *socketTitles;

- (NSString *) typeString;
- (NSString *) socketString;

- (APChannel *)channelForIndex:(int)channelIndex;

@end
