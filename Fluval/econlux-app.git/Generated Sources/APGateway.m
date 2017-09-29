#import "APGateway.h"


@interface APGateway ()

// Private interface goes here.

@end


@implementation APGateway

+ (instancetype) currentGateway {
	
	// GET THE LAST CONNECTED GATEWAY
	NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:[APGateway entityName]];
	[req setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"lastConnect" ascending:NO]]];
	[req setFetchLimit:1];
	
	return [[MOC executeFetchRequest:req error:nil] firstObject];
}

// ################################################

- (APLight *)lightForSlot:(int)slotIndex {
	
	// TRY TO GET AN EXISTING LIGHT WITH GIVEN SLOT ID
	for(APLight *l in self.lights) {
		if(l.slotValue == slotIndex) {
			return l;
		}
	}
	
	// CREATE NEW LIGHT OBJECT
	DLog(@"Creating new light object for index: %d", slotIndex);
	APLight *light = [APLight insertInManagedObjectContext:self.managedObjectContext];
	light.slotValue = slotIndex;
	light.gateway = self;
	[self.managedObjectContext save:nil];
	
	return light;
}

// ################################################

@end
