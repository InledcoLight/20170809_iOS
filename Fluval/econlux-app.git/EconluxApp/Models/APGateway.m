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
	APLight *light = [APLight insertInManagedObjectContext:self.managedObjectContext];
	light.slotValue = slotIndex;
	light.gateway = self;
	[self.managedObjectContext save:nil];
	
	return light;
}

//// ################################################
//
//- (NSNumber *)type {
//    
//#ifdef ECONLUX
//    return [NSNumber numberWithInt:GATEWAY_5CH];
//#else
//    return [NSNumber numberWithInt:GATEWAY_2CH];
//#endif
//    
//}
//
//// #####################################################
//
//- (int16_t)typeValue {
//#ifdef ECONLUX
//    return GATEWAY_5CH;
//#else
//    return GATEWAY_2CH;
//#endif
//}
//
//// #####################################################

@end
