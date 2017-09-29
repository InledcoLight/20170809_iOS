// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to APChannel.m instead.

#import "_APChannel.h"

const struct APChannelAttributes APChannelAttributes = {
	.index = @"index",
	.name = @"name",
};

const struct APChannelRelationships APChannelRelationships = {
	.light = @"light",
	.phases = @"phases",
};

const struct APChannelFetchedProperties APChannelFetchedProperties = {
};

@implementation APChannelID
@end

@implementation _APChannel

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"APChannel" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"APChannel";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"APChannel" inManagedObjectContext:moc_];
}

- (APChannelID*)objectID {
	return (APChannelID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"indexValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"index"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic index;



- (int16_t)indexValue {
	NSNumber *result = [self index];
	return [result shortValue];
}

- (void)setIndexValue:(int16_t)value_ {
	[self setIndex:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveIndexValue {
	NSNumber *result = [self primitiveIndex];
	return [result shortValue];
}

- (void)setPrimitiveIndexValue:(int16_t)value_ {
	[self setPrimitiveIndex:[NSNumber numberWithShort:value_]];
}





@dynamic name;






@dynamic light;

	

@dynamic phases;

	
- (NSMutableSet*)phasesSet {
	[self willAccessValueForKey:@"phases"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"phases"];
  
	[self didAccessValueForKey:@"phases"];
	return result;
}
	






@end
