#import "_APPhase.h"

@interface APPhase : _APPhase {}

- (NSString *) timeToAsString;
- (NSString *) timeFromAsString;

@property (nonatomic, assign) BOOL isValid;

+ (int) timeAsInt:(NSDate *)date;

+ (NSDateFormatter *)dateFormatter;

@end
