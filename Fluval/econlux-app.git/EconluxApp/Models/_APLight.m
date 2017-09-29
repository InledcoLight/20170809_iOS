// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to APLight.m instead.

#import "_APLight.h"

const struct APLightAttributes APLightAttributes = {
	.name = @"name",
	.slot = @"Slot",
	.type = @"type",
};

const struct APLightRelationships APLightRelationships = {
	.channels = @"channels",
	.gateway = @"gateway",
};

const struct APLightFetchedProperties APLightFetchedProperties = {
};

@implementation APLightID
@end

@implementation _APLight

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"APLight" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"APLight";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"APLight" inManagedObjectContext:moc_];
}

- (APLightID*)objectID {
	return (APLightID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"slotValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"slot"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"typeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"type"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic name;






@dynamic slot;



- (int16_t)slotValue {
	NSNumber *result = [self slot];
	return [result shortValue];
}

- (void)setSlotValue:(int16_t)value_ {
	[self setSlot:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveSlotValue {
	NSNumber *result = [self primitiveSlot];
	return [result shortValue];
}

- (void)setPrimitiveSlotValue:(int16_t)value_ {
	[self setPrimitiveSlot:[NSNumber numberWithShort:value_]];
}





@dynamic type;



- (int16_t)typeValue {
	NSNumber *result = [self type];
	return [result shortValue];
}

- (void)setTypeValue:(int16_t)value_ {
	[self setType:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveTypeValue {
	NSNumber *result = [self primitiveType];
	return [result shortValue];
}

- (void)setPrimitiveTypeValue:(int16_t)value_ {
	[self setPrimitiveType:[NSNumber numberWithShort:value_]];
}





@dynamic channels;

	
- (NSMutableSet*)channelsSet {
	[self willAccessValueForKey:@"channels"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"channels"];
  
	[self didAccessValueForKey:@"channels"];
	return result;
}
	

@dynamic gateway;

	






@end
