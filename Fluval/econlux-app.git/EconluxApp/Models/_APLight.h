// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to APLight.h instead.

#import <CoreData/CoreData.h>


extern const struct APLightAttributes {
	__unsafe_unretained NSString *name;
	__unsafe_unretained NSString *slot;
	__unsafe_unretained NSString *type;
} APLightAttributes;

extern const struct APLightRelationships {
	__unsafe_unretained NSString *channels;
	__unsafe_unretained NSString *gateway;
} APLightRelationships;

extern const struct APLightFetchedProperties {
} APLightFetchedProperties;

@class APChannel;
@class APGateway;





@interface APLightID : NSManagedObjectID {}
@end

@interface _APLight : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (APLightID*)objectID;





@property (nonatomic, strong) NSString* name;



//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* slot;



@property int16_t slotValue;
- (int16_t)slotValue;
- (void)setSlotValue:(int16_t)value_;

//- (BOOL)validateSlot:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* type;



@property int16_t typeValue;
- (int16_t)typeValue;
- (void)setTypeValue:(int16_t)value_;

//- (BOOL)validateType:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet *channels;

- (NSMutableSet*)channelsSet;




@property (nonatomic, strong) APGateway *gateway;

//- (BOOL)validateGateway:(id*)value_ error:(NSError**)error_;





@end

@interface _APLight (CoreDataGeneratedAccessors)

- (void)addChannels:(NSSet*)value_;
- (void)removeChannels:(NSSet*)value_;
- (void)addChannelsObject:(APChannel*)value_;
- (void)removeChannelsObject:(APChannel*)value_;

@end

@interface _APLight (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;




- (NSNumber*)primitiveSlot;
- (void)setPrimitiveSlot:(NSNumber*)value;

- (int16_t)primitiveSlotValue;
- (void)setPrimitiveSlotValue:(int16_t)value_;




- (NSNumber*)primitiveType;
- (void)setPrimitiveType:(NSNumber*)value;

- (int16_t)primitiveTypeValue;
- (void)setPrimitiveTypeValue:(int16_t)value_;





- (NSMutableSet*)primitiveChannels;
- (void)setPrimitiveChannels:(NSMutableSet*)value;



- (APGateway*)primitiveGateway;
- (void)setPrimitiveGateway:(APGateway*)value;


@end
