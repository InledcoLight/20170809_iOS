#import "APLight.h"

@interface APLight ()

@end


@implementation APLight

@synthesize socketTitles;
@synthesize typeTitles;

// ################################################

- (instancetype)initWithEntity:(NSEntityDescription *)entity insertIntoManagedObjectContext:(NSManagedObjectContext *)context {
	
	self = [super initWithEntity:entity insertIntoManagedObjectContext:context];
	
	self.socketTitles = @[@"Slot A", @"Slot B"];
	self.typeTitles = @[@"1 channel", @"2 channel"];

	return self;
}

// ################################################

- (NSString *) typeString {
	return self.typeTitles[self.typeValue];
}

// ################################################

- (NSString *) socketString {
	return self.socketTitles[self.slotValue];
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
