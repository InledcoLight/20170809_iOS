// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to APPhase.h instead.

#import <CoreData/CoreData.h>


extern const struct APPhaseAttributes {
	__unsafe_unretained NSString *color;
	__unsafe_unretained NSString *isBreak;
	__unsafe_unretained NSString *isNeeded;
	__unsafe_unretained NSString *name;
	__unsafe_unretained NSString *sort;
	__unsafe_unretained NSString *startsLinear;
	__unsafe_unretained NSString *stopsLinear;
	__unsafe_unretained NSString *timeFrom;
	__unsafe_unretained NSString *timeTo;
	__unsafe_unretained NSString *value;
} APPhaseAttributes;

extern const struct APPhaseRelationships {
	__unsafe_unretained NSString *channel;
} APPhaseRelationships;

extern const struct APPhaseFetchedProperties {
} APPhaseFetchedProperties;

@class APChannel;












@interface APPhaseID : NSManagedObjectID {}
@end

@interface _APPhase : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (APPhaseID*)objectID;





@property (nonatomic, strong) NSString* color;



//- (BOOL)validateColor:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* isBreak;



@property BOOL isBreakValue;
- (BOOL)isBreakValue;
- (void)setIsBreakValue:(BOOL)value_;

//- (BOOL)validateIsBreak:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* isNeeded;



@property BOOL isNeededValue;
- (BOOL)isNeededValue;
- (void)setIsNeededValue:(BOOL)value_;

//- (BOOL)validateIsNeeded:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* name;



//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* sort;



@property int16_t sortValue;
- (int16_t)sortValue;
- (void)setSortValue:(int16_t)value_;

//- (BOOL)validateSort:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* startsLinear;



@property BOOL startsLinearValue;
- (BOOL)startsLinearValue;
- (void)setStartsLinearValue:(BOOL)value_;

//- (BOOL)validateStartsLinear:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* stopsLinear;



@property BOOL stopsLinearValue;
- (BOOL)stopsLinearValue;
- (void)setStopsLinearValue:(BOOL)value_;

//- (BOOL)validateStopsLinear:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* timeFrom;



//- (BOOL)validateTimeFrom:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* timeTo;



//- (BOOL)validateTimeTo:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* value;



@property int16_t valueValue;
- (int16_t)valueValue;
- (void)setValueValue:(int16_t)value_;

//- (BOOL)validateValue:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) APChannel *channel;

//- (BOOL)validateChannel:(id*)value_ error:(NSError**)error_;





@end

@interface _APPhase (CoreDataGeneratedAccessors)

@end

@interface _APPhase (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveColor;
- (void)setPrimitiveColor:(NSString*)value;




- (NSNumber*)primitiveIsBreak;
- (void)setPrimitiveIsBreak:(NSNumber*)value;

- (BOOL)primitiveIsBreakValue;
- (void)setPrimitiveIsBreakValue:(BOOL)value_;




- (NSNumber*)primitiveIsNeeded;
- (void)setPrimitiveIsNeeded:(NSNumber*)value;

- (BOOL)primitiveIsNeededValue;
- (void)setPrimitiveIsNeededValue:(BOOL)value_;




- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;




- (NSNumber*)primitiveSort;
- (void)setPrimitiveSort:(NSNumber*)value;

- (int16_t)primitiveSortValue;
- (void)setPrimitiveSortValue:(int16_t)value_;




- (NSNumber*)primitiveStartsLinear;
- (void)setPrimitiveStartsLinear:(NSNumber*)value;

- (BOOL)primitiveStartsLinearValue;
- (void)setPrimitiveStartsLinearValue:(BOOL)value_;




- (NSNumber*)primitiveStopsLinear;
- (void)setPrimitiveStopsLinear:(NSNumber*)value;

- (BOOL)primitiveStopsLinearValue;
- (void)setPrimitiveStopsLinearValue:(BOOL)value_;




- (NSDate*)primitiveTimeFrom;
- (void)setPrimitiveTimeFrom:(NSDate*)value;




- (NSDate*)primitiveTimeTo;
- (void)setPrimitiveTimeTo:(NSDate*)value;




- (NSNumber*)primitiveValue;
- (void)setPrimitiveValue:(NSNumber*)value;

- (int16_t)primitiveValueValue;
- (void)setPrimitiveValueValue:(int16_t)value_;





- (APChannel*)primitiveChannel;
- (void)setPrimitiveChannel:(APChannel*)value;


@end
