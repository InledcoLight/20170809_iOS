// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to APChannel.h instead.

#import <CoreData/CoreData.h>


extern const struct APChannelAttributes {
	__unsafe_unretained NSString *index;
	__unsafe_unretained NSString *name;
} APChannelAttributes;

extern const struct APChannelRelationships {
	__unsafe_unretained NSString *light;
	__unsafe_unretained NSString *phases;
} APChannelRelationships;

extern const struct APChannelFetchedProperties {
} APChannelFetchedProperties;

@class APLight;
@class APPhase;




@interface APChannelID : NSManagedObjectID {}
@end

@interface _APChannel : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (APChannelID*)objectID;





@property (nonatomic, strong) NSNumber* index;



@property int16_t indexValue;
- (int16_t)indexValue;
- (void)setIndexValue:(int16_t)value_;

//- (BOOL)validateIndex:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* name;



//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) APLight *light;

//- (BOOL)validateLight:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSSet *phases;

- (NSMutableSet*)phasesSet;





@end

@interface _APChannel (CoreDataGeneratedAccessors)

- (void)addPhases:(NSSet*)value_;
- (void)removePhases:(NSSet*)value_;
- (void)addPhasesObject:(APPhase*)value_;
- (void)removePhasesObject:(APPhase*)value_;

@end

@interface _APChannel (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitiveIndex;
- (void)setPrimitiveIndex:(NSNumber*)value;

- (int16_t)primitiveIndexValue;
- (void)setPrimitiveIndexValue:(int16_t)value_;




- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;





- (APLight*)primitiveLight;
- (void)setPrimitiveLight:(APLight*)value;



- (NSMutableSet*)primitivePhases;
- (void)setPrimitivePhases:(NSMutableSet*)value;


@end
