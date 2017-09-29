#import "_APChannel.h"
#import "APChannelConfiguration.h"

typedef enum {
	LIGHT_TYPE_1_CHANNEL = 0,
	LIGHT_TYPE_2_CHANNEL = 1
} LIGHT_TYPE;

@interface APChannel : _APChannel {}

@property (nonatomic, strong) UIColor *lightColor;
@property (nonatomic, assign) int lightValue;
@property (nonatomic, assign) LIGHT_TYPE lightType;

@property (nonatomic, strong) APChannelConfiguration *configuration;

- (BOOL) isRGBChannel;
+ (NSString *)titleForType:(LIGHT_TYPE)type;
- (int) indexOffset;

@end
