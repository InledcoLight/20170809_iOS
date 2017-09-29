// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to APPhase.m instead.

#import "_APPhase.h"

const struct APPhaseAttributes APPhaseAttributes = {
	.color = @"color",
	.isBreak = @"isBreak",
	.isNeeded = @"isNeeded",
	.name = @"name",
	.sort = @"sort",
	.startsLinear = @"startsLinear",
	.stopsLinear = @"stopsLinear",
	.timeFrom = @"timeFrom",
	.timeTo = @"timeTo",
	.value = @"value",
};

const struct APPhaseRelationships APPhaseRelationships = {
	.channel = @"channel",
};

const struct APPhaseFetchedProperties APPhaseFetchedProperties = {
};

@implementation APPhaseID
@end

@implementation _APPhase

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"APPhase" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"APPhase";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"APPhase" inManagedObjectContext:moc_];
}

- (APPhaseID*)objectID {
	return (APPhaseID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"isBreakValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"isBreak"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"isNeededValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"isNeeded"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"sortValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"sort"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"startsLinearValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"startsLinear"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"stopsLinearValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"stopsLinear"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"valueValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"value"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic color;






@dynamic isBreak;



- (BOOL)isBreakValue {
	NSNumber *result = [self isBreak];
	return [result boolValue];
}

- (void)setIsBreakValue:(BOOL)value_ {
	[self setIsBreak:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveIsBreakValue {
	NSNumber *result = [self primitiveIsBreak];
	return [result boolValue];
}

- (void)setPrimitiveIsBreakValue:(BOOL)value_ {
	[self setPrimitiveIsBreak:[NSNumber numberWithBool:value_]];
}





@dynamic isNeeded;



- (BOOL)isNeededValue {
	NSNumber *result = [self isNeeded];
	return [result boolValue];
}

- (void)setIsNeededValue:(BOOL)value_ {
	[self setIsNeeded:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveIsNeededValue {
	NSNumber *result = [self primitiveIsNeeded];
	return [result boolValue];
}

- (void)setPrimitiveIsNeededValue:(BOOL)value_ {
	[self setPrimitiveIsNeeded:[NSNumber numberWithBool:value_]];
}





@dynamic name;






@dynamic sort;



- (int16_t)sortValue {
	NSNumber *result = [self sort];
	return [result shortValue];
}

- (void)setSortValue:(int16_t)value_ {
	[self setSort:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveSortValue {
	NSNumber *result = [self primitiveSort];
	return [result shortValue];
}

- (void)setPrimitiveSortValue:(int16_t)value_ {
	[self setPrimitiveSort:[NSNumber numberWithShort:value_]];
}





@dynamic startsLinear;



- (BOOL)startsLinearValue {
	NSNumber *result = [self startsLinear];
	return [result boolValue];
}

- (void)setStartsLinearValue:(BOOL)value_ {
	[self setStartsLinear:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveStartsLinearValue {
	NSNumber *result = [self primitiveStartsLinear];
	return [result boolValue];
}

- (void)setPrimitiveStartsLinearValue:(BOOL)value_ {
	[self setPrimitiveStartsLinear:[NSNumber numberWithBool:value_]];
}





@dynamic stopsLinear;



- (BOOL)stopsLinearValue {
	NSNumber *result = [self stopsLinear];
	return [result boolValue];
}

- (void)setStopsLinearValue:(BOOL)value_ {
	[self setStopsLinear:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveStopsLinearValue {
	NSNumber *result = [self primitiveStopsLinear];
	return [result boolValue];
}

- (void)setPrimitiveStopsLinearValue:(BOOL)value_ {
	[self setPrimitiveStopsLinear:[NSNumber numberWithBool:value_]];
}





@dynamic timeFrom;






@dynamic timeTo;






@dynamic value;



- (int16_t)valueValue {
	NSNumber *result = [self value];
	return [result shortValue];
}

- (void)setValueValue:(int16_t)value_ {
	[self setValue:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveValueValue {
	NSNumber *result = [self primitiveValue];
	return [result shortValue];
}

- (void)setPrimitiveValueValue:(int16_t)value_ {
	[self setPrimitiveValue:[NSNumber numberWithShort:value_]];
}





@dynamic channel;

	






@end
