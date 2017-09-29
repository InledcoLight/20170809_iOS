#import "_APGateway.h"
#import "APLight.h"

@interface APGateway : _APGateway {}

+ (instancetype) currentGateway;

- (APLight *)lightForSlot:(int)slotIndex;

@end
