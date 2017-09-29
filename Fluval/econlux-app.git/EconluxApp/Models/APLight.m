#import "APLight.h"
#import "APLightConfiguration.h"

@interface APLight ()

@end


@implementation APLight

@synthesize socketTitles;

// ################################################

- (instancetype)initWithEntity:(NSEntityDescription *)entity insertIntoManagedObjectContext:(NSManagedObjectContext *)context {
	
	self = [super initWithEntity:entity insertIntoManagedObjectContext:context];
	return self;
}

// ################################################

- (NSArray *)typeTitles {
	
	NSMutableArray *titles = [NSMutableArray new];
	for(APLightConfiguration *config in [APLightConfiguration getConfigurations]) {
		[titles addObject:config.label];
	}
	
	return titles;
}


// #####################################################

- (NSArray *)socketTitles {

	// CREATE SLOT TITLES
	NSMutableArray *slotTitles = [NSMutableArray new];
	for(int i=1; i<=(self.gateway.typeValue == GATEWAY_2CH? 2:3); i++) {
		[slotTitles addObject:[NSString stringWithFormat:@"%d", i]];
	}

	return slotTitles;
}

// ################################################

- (NSString *) socketString {
	return self.socketTitles[self.slotValue];
}

// ################################################

- (NSString *) typeString {

	APLightConfiguration *config = [APLightConfiguration configurationByIdentifier:self.typeValue];
	return config.label;
}

// ################################################

- (APChannel *)channelForIndex:(int)channelIndex {
	
	// TRY TO GET AN EXISTING LIGHT WITH GIVEN SLOT ID
	for(APChannel *c in self.channels) {
		if(c.indexValue == channelIndex) {
			return c;
		}
	}
	
	// CREATE NEW LIGHT OBJECT
	DLog(@"Creating new channel object for index: %d", channelIndex);
	APChannel *channel = [APChannel insertInManagedObjectContext:self.managedObjectContext];
	channel.indexValue = channelIndex;
	[self addChannelsObject:channel];
	[self.managedObjectContext save:nil];
	
	return channel;
}

// ################################################

@end
