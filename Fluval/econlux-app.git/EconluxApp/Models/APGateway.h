#import "_APGateway.h"
#import "APLight.h"


typedef enum {
    APGatewayModeAutomatic,
    APGatewayModeManual
} APGatewayMode;

@interface APGateway : _APGateway {}

+ (instancetype) currentGateway;

- (APLight *)lightForSlot:(int)slotIndex;

@end
