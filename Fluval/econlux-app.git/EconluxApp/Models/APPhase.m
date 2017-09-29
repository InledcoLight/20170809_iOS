#import "APPhase.h"


@interface APPhase ()

// Private interface goes here.

@end


@implementation APPhase

@synthesize isValid;

static NSDateFormatter *formatter;


// #####################################################

+ (NSDateFormatter *)dateFormatter {

	NSDateFormatter *formatter = [NSDateFormatter new];
    if([APLocString(@"LANGUAGE") isEqualToString:@"English"]) {
        formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        [formatter setDateFormat:@"hh:mm a"];
    } else {
//        formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
//        [formatter setDateFormat:@"hh:mm a"];
        [formatter setDateFormat:@"HH:mm"];
    }
	
	return formatter;
}

// #####################################################

- (id)initWithEntity:(NSEntityDescription *)entity insertIntoManagedObjectContext:(NSManagedObjectContext *)context {
	
	self = [super initWithEntity:entity insertIntoManagedObjectContext:context];
	self.isValid = YES;
	return self;
}

// #####################################################

- (NSString *) timeFromAsString
{
	if(!formatter)
        formatter = [APPhase dateFormatter];
	
	NSString *str = [formatter stringFromDate:self.timeFrom];
	return str? str : @"undefined";
}

// #####################################################

- (NSString *) timeToAsString
{
    if(!formatter)
        formatter = [APPhase dateFormatter];

	NSString *str = [formatter stringFromDate:self.timeTo];
	return str? str : @"undefined";
}

// #####################################################

+ (int) timeAsInt:(NSDate *)date {

    if(!formatter)
        formatter = [APPhase dateFormatter];
	
	return [[formatter stringFromDate:date] intValue];
}

@end
