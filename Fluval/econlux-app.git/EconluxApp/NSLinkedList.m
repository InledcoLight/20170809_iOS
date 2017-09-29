#import "NSLinkedList.h"

@interface NSLinkedNode : NSObject

@property (nonatomic) id obj;
@property (nonatomic) NSLinkedNode *next;
@property (nonatomic) NSLinkedNode *previous;

- (id)initWithObj:(id)obj next:(NSLinkedNode *)next previous:(NSLinkedNode *)previous;

@end

@implementation NSLinkedNode

- (id)initWithObj:(id)obj next:(NSLinkedNode *)next previous:(NSLinkedNode *)previous
{
    if(!obj)
    {
        @throw NSInvalidArgumentException;
    }
    if((self = [super init]))
    {
        _obj = obj; _next = next; _previous = previous;
    }
    return self;
}

@end

/////////////////////////////////////////////////////////////////////////////////////

@interface NSLinkedList ()

@property (nonatomic, readonly) NSLinkedNode *first;
@property (nonatomic, readonly) NSLinkedNode *last;

@end

@implementation NSLinkedList

- (id)initWithObject:(id)obj
{
    if((self = [super init]))
    {
        _first = _last = [[NSLinkedNode alloc] initWithObj:obj next:nil previous:nil];
        _count = 1;
    }
    return self;
}

- (void)pushNodeBack:(NSLinkedNode *)node
{
    if(node)
    {
        if(_count)
        {
            _last.next = node;
            _last = node;
        }
        else 
        {
            _first = _last = node;
        }
        _count++;
    }
}


- (void)pushNodeFront:(NSLinkedNode *)node 
{
    if(node)
    {
        if(_count)
        {
            _first.previous = node;
            _first = node;
        } 
        else
        {
            _first = _last = node;
        }
        _count++;
    }
}

- (void)removeNode:(NSLinkedNode *)node 
{
    if(_count)
    {
        if(_count == 1)
        {
            // delete first and only 
            _first = _last = nil;
        }
        else if(node.previous == nil)
        {
            // delete first of many
            _first = _first.next;
            _first.previous = nil;
        }
        else if(node.next == nil) 
        {
            // delete last
            _last = _last.previous;
            _last.next = nil;
        }
        else
        {
            // delete in the middle
            NSLinkedNode *tmp = node.previous;
            tmp.next = node.next;
            tmp = node.next;
            tmp.previous = node.previous;
        }
        _count--;
    }
}

- (void)pushBack:(id)obj
{
    NSLinkedNode *node = [[NSLinkedNode alloc] initWithObj:obj next:nil previous:_last];
    [self pushNodeBack:node];
}

- (void)pushFront:(id)obj
{
    NSLinkedNode *node = [[NSLinkedNode alloc] initWithObj:obj next:_first previous:nil];
    [self pushNodeFront:node];
}

- (id)popBack
{
    if(_count)
    {
        NSLinkedNode *node = _last;
        if(_count == 1)
        { 
            _first = _last = NULL;
        }
        else 
        {
            _last = _last.previous;
            _last.next = NULL;
        }
        _count--;
        node.next = nil;
        node.previous = nil;
        return node.obj;
    }
    return nil;
}

- (id)popFront
{
    if(_count)
    {
        NSLinkedNode *node = _first;
        if(_count == 1)
        { 
            _first = _last = nil;
        }
        else
        {
            _first = _first.next;
            _first.previous = nil;
        }
        _count--;
        node.next = nil;
        node.previous = nil;
        return node.obj;
    }
    return nil;
}


- (void)removeAll
{
    while(_first)
    {
        [self removeNode:_first];
    }
}


- (void)remove:(id)obj
{
    NSLinkedNode *node = _first;
    while(node)
    {
        NSLinkedNode *next = node.next;
        if([node.obj isEqual:obj])
        {
            [self removeNode:node];
        }
        node = next;
    }
}

- (NSArray *)allObjects
{
    NSMutableArray *objects = [NSMutableArray array];
    NSLinkedNode *node = _first;
    while(node)
    {
        [objects addObject:node.obj];
        node = node.next;
    }
    return [NSArray arrayWithArray:objects];
}

- (void)dealloc 
{
    [self removeAll];
}

@end
