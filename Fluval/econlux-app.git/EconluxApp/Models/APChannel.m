#import "APChannel.h"
#import "APGateway.h"

@interface APChannel ()

@end


@implementation APChannel

@synthesize lightColor;
@synthesize lightValue;
@synthesize lightType = _lightType;
@synthesize configuration;

- (BOOL) isRGBChannel {
	
	if(self.phases.count > 3) {
		return YES;
	}
	
	return NO;
}

// ################################################

+ (NSString *)titleForType:(LIGHT_TYPE)type {
	
	switch (type) {
	  case LIGHT_TYPE_1_CHANNEL: return APLocString(@"LIGHT_1_CHANNEL");
	  case LIGHT_TYPE_2_CHANNEL: return APLocString(@"LIGHT_2_CHANNEL");
	}
	
	return @"";
}

// ################################################

- (void)setLightType:(LIGHT_TYPE)lightType {
	
	_lightType = lightType;
	
	APGateway *gateway = [APGateway currentGateway];
	
	// GET LIGHT CONFIGURATION
	NSMutableDictionary *dict = [[[NSUserDefaults standardUserDefaults] valueForKey:@"LIGHT_TYPE_CONFIG"] mutableCopy];
	if(!dict)
		dict = [NSMutableDictionary new];
	
	// GET GATEWAY DICT
	NSMutableDictionary *gatewayDict = [[dict valueForKey:gateway.host] mutableCopy];
	if(!gatewayDict)
		gatewayDict = [NSMutableDictionary new];
	
	[gatewayDict setValue:[NSNumber numberWithInteger:_lightType] forKey:[NSString stringWithFormat:@"%d", (int)self.index]];
	
	// WRITE CHANNEL IN GATEWAY
	[dict setValue:gatewayDict forKey:gateway.host];
	
	[[NSUserDefaults standardUserDefaults] setValue:dict forKey:@"LIGHT_TYPE_CONFIG"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

// ################################################

- (LIGHT_TYPE)lightType {
	
	APGateway *gateway = [APGateway currentGateway];
	NSDictionary *gatewayDict = [[[NSUserDefaults standardUserDefaults] valueForKey:@"LIGHT_TYPE_CONFIG"] valueForKey:gateway.host];
	
	return [[gatewayDict valueForKey:[NSString stringWithFormat:@"%d", (int)self.index]] intValue];
}

// ################################################

- (int) indexOffset {

	// GET THE GLOBAL INDEX OFFSET
	int channelOffset = self.light.gateway.typeValue == GATEWAY_2CH? 2 : 5;
	channelOffset *= self.light.slotValue;
	
	return channelOffset;
}

// #####################################################


@end
