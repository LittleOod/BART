//
//  BAExperiment2.m
//  BARTApplication
//
//  Created by Torsten Schlumm on 6/22/12.
//  Copyright (c) 2012 MPI Human Cognitive and Brain Sciences Leipzig. All rights reserved.
//

#import "BAExperiment2.h"
#import "BAStep2.h"
#import "BARTNotifications.h"

#import <objc/runtime.h>



@implementation BAExperiment2 {
    
    NSMutableArray *_steps;
    NSMutableSet   *_rtLoop;
    
}

#pragma mark -
#pragma mark Global Properties

@synthesize edl         = _edl;

#pragma mark -
#pragma mark Local Properties

@synthesize steps   = _steps;
@synthesize session = _session;
@synthesize rtLoop  = _rtLoop;


#pragma mark -
#pragma mark Initialization and Destruction

+ (id) experimentWithEDL:(COSystemConfig*)edl name:(NSString*)name description:(NSString*)description
{
    return [[[self alloc] initWithEDL:edl name:name description:description] autorelease];
}

- (id) initWithEDL:(COSystemConfig*)edl name:(NSString *)name
{
    return [self initWithEDL:edl name:name description:name steps:nil];
}

- (id) initWithEDL:(COSystemConfig*)edl name:(NSString *)name description:(NSString *)description
{
    return [self initWithEDL:edl name:name description:description steps:nil];
}

- (id) initWithEDL:(COSystemConfig*)edl name:(NSString *)name description:(NSString *)description steps:(NSArray *)steps
{
    if(self = [super initWithType:BA_NODE_TYPE_EXPERIMENT name:name description:description children:steps]) {
        _edl = [edl retain];
    }
    
    if(steps == nil) {
        _steps = [[NSMutableArray arrayWithCapacity:0] retain];
    } else {
        _steps = [[NSMutableArray arrayWithArray:steps] retain];
    }
    
    return self;
}


#pragma mark -
#pragma mark Property Methods 'steps'

- (NSArray*)children
{
    return [self steps];
}

- (void) setSteps:(NSArray*)steps
{
    [self willChangeValueForKey:@"steps"];

    _steps = [NSMutableArray arrayWithArray:steps];
    [_steps enumerateObjectsUsingBlock:^(id step, NSUInteger index, BOOL *stop) {
        [(BAStep2*)step setExperiment:self];
    }];
    
    [self didChangeValueForKey:@"steps"];
}

- (NSUInteger)countOfSteps
{
    return [_steps count];
}

- (id)objectInStepsAtIndex:(NSUInteger)index
{
    return [_steps objectAtIndex:index];
}

- (void)getSteps:(BAExperiment2 **)buffer range:(NSRange)inRange
{
    [_steps getObjects:buffer range:inRange];
}

- (void)insertObject:(BAStep2*)step inStepsAtIndex:(NSUInteger)index
{
    [self willChangeValueForKey:@"steps"];
    NSLog(@"insertObject:%@ inStepsAtIndex:%lu", step, index);
    [step setExperiment:self];
    [_steps insertObject:step atIndex:index];
    [self didChangeValueForKey:@"steps"];
}

- (void)removeObjectFromStepsAtIndex:(NSUInteger)index
{
    [self willChangeValueForKey:@"steps"];
    [_steps removeObjectAtIndex:index];
    [self didChangeValueForKey:@"steps"];
}

- (void)replaceObjectInStepsAtIndex:(NSUInteger)index withObject:(id)step
{
    [self willChangeValueForKey:@"steps"];
    [step setExperiment:self];
    [_steps replaceObjectAtIndex:index withObject:step];
    [self didChangeValueForKey:@"steps"];
}


#pragma mark -
#pragma mark Property Methods 'rtLoop'

- (NSSet*)rtLoop
{
    return [NSSet setWithSet:_rtLoop];
}

- (void)setRtLoop:(NSSet *)rtLoop
{
    [_rtLoop setSet:rtLoop];
}

- (NSUInteger)countOfRtLoop
{
    return [_rtLoop count];
}

- (BAStep2*)memberOfRtLoop:(BAStep2*)step
{
    return [_rtLoop member:step];
}

- (NSEnumerator*)enumeratorOfRtLoop
{
    return [_rtLoop objectEnumerator];
}

- (NSMutableSet*)mutableRtLoop
{
    return [self mutableSetValueForKey:@"rtLoop"];
}

- (void)addRtLoopObject:(BAStep2*)step
{
    [_rtLoop addObject:step];
}

- (void)addRtLoop:(NSSet*)steps
{
    [_rtLoop unionSet:steps];
}

- (void)removeRtLoopObject:(BAStep2*)step
{
    [_rtLoop removeObject:step];
}

- (void)removeRtLoop:(NSSet*)steps
{
    [_rtLoop minusSet:steps];
}



#pragma mark -
#pragma mark Instance Methods (Structure)

- (void)addStep:(id)step atIndex:(NSUInteger)index
{

    
    [self insertObject:step inStepsAtIndex:MIN(index, [self countOfSteps])];
    
    BARTSessionTreeNodeChangeNotificationChangeType changeType = childAdded;
    NSDictionary *notificationUserInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                          [NSNumber numberWithUnsignedInteger:changeType], BARTSessionTreeNodeChangeNotificationChangeTypeKey,
                                          [NSNumber numberWithUnsignedInteger:index], BARTSessionTreeNodeChangeNotificationChildIndexKey,
                                          nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:BARTSessionTreeNodeChangeNotification object:self userInfo:notificationUserInfo];
}

- (void)appendStep:(id)step
{
    NSUInteger index = [self countOfSteps];
    [self addStep:step atIndex:index];
}


- (void)removeStepAtIndex:(NSUInteger)index
{
    [self removeObjectFromStepsAtIndex:index];
    BARTSessionTreeNodeChangeNotificationChangeType changeType = childRemoved;
    NSDictionary *notificationUserInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                          [NSNumber numberWithUnsignedInteger:changeType], BARTSessionTreeNodeChangeNotificationChangeTypeKey,
                                          [NSNumber numberWithUnsignedInteger:index], BARTSessionTreeNodeChangeNotificationChildIndexKey,
                                          nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:BARTSessionTreeNodeChangeNotification object:self userInfo:notificationUserInfo];
}


- (void)removeStep:(BASessionTreeNode*)step
{
    [self removeStepAtIndex:[_steps indexOfObject:step]];
}


#pragma mark -
#pragma mark Notification / Observer Methods


#pragma mark -
#pragma mark Class Methods

+ (NSString*)typeDisplayName
{
    return @"Abstract Experiment";
}

+ (NSString*)typeDescription
{
    return @"Abstract Experiment Description";
}

+ (NSArray*)subclasses
{
    NSMutableArray *subClasses = [NSMutableArray array];
    Class *classes = nil;
    int count = objc_getClassList(NULL, 0);
    if(count) {
        classes = malloc(sizeof(Class)* count); 
        NSAssert(classes != NULL, @"Memory Allocation Failed in [Content +subclasses].");
        (void) objc_getClassList(classes, count); 
    }
    if (classes) {
        for(int i=0; i<count; i++) {
            Class myClass = classes[i]; 
            Class superClass = class_getSuperclass(myClass);
            char *name = class_getName(myClass);
            // take all our subclasses except the generated classes beginning with 'NSKVONotifying...'
            if(superClass == [self class] && [[NSString stringWithUTF8String:name] rangeOfString:@"NSKVONotifying"].location == NSNotFound) {
                NSLog(@"Found Class: %@", [NSString stringWithUTF8String:name]);
                [subClasses addObject:myClass];
            }
        }
        free(classes);
    }
    return subClasses;
}


@end
