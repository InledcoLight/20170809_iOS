#import "_APLight.h"

@class APChannel;

@interface APLight : _APLight {}

@property (nonatomic, strong) NSArray *socketTitles;

- (NSString *) socketString;
- (NSString *) typeString;

- (APChannel *)channelForIndex:(int)channelIndex;

- (NSArray *)typeTitles;

@end
