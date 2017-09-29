// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to APGateway.h instead.

#import <CoreData/CoreData.h>


extern const struct APGatewayAttributes {
	__unsafe_unretained NSString *host;
	__unsafe_unretained NSString *lastConnect;
	__unsafe_unretained NSString *name;
	__unsafe_unretained NSString *port;
	__unsafe_unretained NSString *runningMode;
	__unsafe_unretained NSString *type;
} APGatewayAttributes;

extern const struct APGatewayRelationships {
	__unsafe_unretained NSString *lights;
} APGatewayRelationships;

extern const struct APGatewayFetchedProperties {
} APGatewayFetchedProperties;

@class APLight;








@interface APGatewayID : NSManagedObjectID {}
@end

@interface _APGateway : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (APGatewayID*)objectID;





@property (nonatomic, strong) NSString* host;



//- (BOOL)validateHost:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* lastConnect;



//- (BOOL)validateLastConnect:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* name;



//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* port;



//- (BOOL)validatePort:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* runningMode;



@property int16_t runningModeValue;
- (int16_t)runningModeValue;
- (void)setRunningModeValue:(int16_t)value_;

//- (BOOL)validateRunningMode:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* type;



@property int16_t typeValue;
- (int16_t)typeValue;
- (void)setTypeValue:(int16_t)value_;

//- (BOOL)validateType:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet *lights;

- (NSMutableSet*)lightsSet;





@end

@interface _APGateway (CoreDataGeneratedAccessors)

- (void)addLights:(NSSet*)value_;
- (void)removeLights:(NSSet*)value_;
- (void)addLightsObject:(APLight*)value_;
- (void)removeLightsObject:(APLight*)value_;

@end

@interface _APGateway (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveHost;
- (void)setPrimitiveHost:(NSString*)value;




- (NSDate*)primitiveLastConnect;
- (void)setPrimitiveLastConnect:(NSDate*)value;




- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;




- (NSString*)primitivePort;
- (void)setPrimitivePort:(NSString*)value;




- (NSNumber*)primitiveRunningMode;
- (void)setPrimitiveRunningMode:(NSNumber*)value;

- (int16_t)primitiveRunningModeValue;
- (void)setPrimitiveRunningModeValue:(int16_t)value_;




- (NSNumber*)primitiveType;
- (void)setPrimitiveType:(NSNumber*)value;

- (int16_t)primitiveTypeValue;
- (void)setPrimitiveTypeValue:(int16_t)value_;





- (NSMutableSet*)primitiveLights;
- (void)setPrimitiveLights:(NSMutableSet*)value;


@end
