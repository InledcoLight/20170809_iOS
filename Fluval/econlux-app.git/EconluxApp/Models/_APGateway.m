// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to APGateway.m instead.

#import "_APGateway.h"

const struct APGatewayAttributes APGatewayAttributes = {
	.host = @"host",
	.lastConnect = @"lastConnect",
	.name = @"name",
	.port = @"port",
	.runningMode = @"runningMode",
	.type = @"type",
};

const struct APGatewayRelationships APGatewayRelationships = {
	.lights = @"lights",
};

const struct APGatewayFetchedProperties APGatewayFetchedProperties = {
};

@implementation APGatewayID
@end

@implementation _APGateway

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"APGateway" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"APGateway";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"APGateway" inManagedObjectContext:moc_];
}

- (APGatewayID*)objectID {
	return (APGatewayID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"runningModeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"runningMode"];
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




@dynamic host;






@dynamic lastConnect;






@dynamic name;






@dynamic port;






@dynamic runningMode;



- (int16_t)runningModeValue {
	NSNumber *result = [self runningMode];
	return [result shortValue];
}

- (void)setRunningModeValue:(int16_t)value_ {
	[self setRunningMode:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveRunningModeValue {
	NSNumber *result = [self primitiveRunningMode];
	return [result shortValue];
}

- (void)setPrimitiveRunningModeValue:(int16_t)value_ {
	[self setPrimitiveRunningMode:[NSNumber numberWithShort:value_]];
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





@dynamic lights;

	
- (NSMutableSet*)lightsSet {
	[self willAccessValueForKey:@"lights"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"lights"];
  
	[self didAccessValueForKey:@"lights"];
	return result;
}
	






@end
