#import <Foundation/Foundation.h>

@interface NSLinkedList : NSObject

- (id)initWithObject:(id)obj;			

- (void)pushBack:(id)obj;
- (void)pushFront:(id)obj;

- (id)popBack;
- (id)popFront;								

- (void)removeAll;
- (void)remove:(id)obj;

- (NSArray *)allObjects;

@property (nonatomic, readonly) NSUInteger count;

@end
