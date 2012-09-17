//
//  BASession2.m
//  BARTApplication
//
//  Created by Torsten Schlumm on 6/22/12.
//  Copyright (c) 2012 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import "BASession2.h"
#import "BAExperiment2.h"
#import "BARTNotifications.h"


@implementation BASession2 {
    
    NSMutableArray *_experiments;
    
}

#pragma mark -
#pragma mark Global Properties

#pragma mark -
#pragma mark Local Properties

@synthesize experiments = _experiments;

#pragma mark -
#pragma mark Initialization

- (id) initWithName:(NSString *)name description:(NSString *)description
{
    return [self initWithName:name description:description experiments:nil];
}

- (id) initWithName:(NSString *)name description:(NSString *)description experiments:(NSArray *)experiments
{
    if(self = [super initWithType:BA_NODE_TYPE_SESSION name:name description:description children:experiments]) {
        
    }

    if(experiments == nil) {
        _experiments = [[NSMutableArray arrayWithCapacity:0] retain];
    } else {
        _experiments = [[NSMutableArray arrayWithArray:experiments] retain];
    }
    
    return self;
}


#pragma mark -
#pragma mark Property Methods 'experiments'

- (NSArray*) children
{
    return [self experiments];
}

- (void) setExperiments:(NSArray *)experiments
{
    [self willChangeValueForKey:@"experiments"];
    
    _experiments = [NSMutableArray arrayWithArray:experiments];
    [_experiments enumerateObjectsUsingBlock:^(id experiment, NSUInteger index, BOOL *stop) {
        [(BAExperiment2*)experiment setSession:self];
    }];
    
    [self didChangeValueForKey:@"experiments"];
}

- (NSUInteger) countOfExperiments
{
    return [_experiments count];
}

- (id) objectInExperimentsAtIndex:(NSUInteger)index
{
    return [_experiments objectAtIndex:index];
}

- (void) getExperiments:(BAExperiment2 **)buffer range:(NSRange)inRange
{
    [_experiments getObjects:buffer range:inRange];
}

- (void)insertObject:(BAExperiment2*)experiment inExperimentsAtIndex:(NSUInteger)index
{
    [self willChangeValueForKey:@"experiments"];
    NSLog(@"insertObject:%@ inExperimentsAtIndex:%lu", experiment, index);
    [experiment setSession:self];
    [_experiments insertObject:experiment atIndex:index];
    [self didChangeValueForKey:@"experiments"];
}

- (void)removeObjectFromExperimentsAtIndex:(NSUInteger)index
{
    [self willChangeValueForKey:@"experiments"];
    [_experiments removeObjectAtIndex:index];
    [self didChangeValueForKey:@"experiments"];
}

- (void)replaceObjectInExperimentsAtIndex:(NSUInteger)index withObject:(id)experiment
{
    [self willChangeValueForKey:@"experiments"];
    [experiment setSession:self];
    [_experiments replaceObjectAtIndex:index withObject:experiment];
    [self didChangeValueForKey:@"experiments"];
}

#pragma mark -
#pragma mark Instance Methods (Structure)

- (void)addExperiment:(id)experiment atIndex:(NSUInteger)index
{
    NSLog(@"[BASession2 addExperiment atIndex]: %@ | %@", experiment, index);
    
    [self insertObject:experiment inExperimentsAtIndex:MIN(index, [self countOfExperiments])];
    
    BARTSessionTreeNodeChangeNotificationChangeType changeType = childAdded;
    NSDictionary *notificationUserInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                          [NSNumber numberWithUnsignedInteger:changeType], BARTSessionTreeNodeChangeNotificationChangeTypeKey,
                                          [NSNumber numberWithUnsignedInteger:index], BARTSessionTreeNodeChangeNotificationChildIndexKey,
                                          nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:BARTSessionTreeNodeChangeNotification object:self userInfo:notificationUserInfo];
}

- (void)appendExperiment:(id)experiment
{
    NSUInteger index = [self countOfExperiments];
    [self addExperiment:experiment atIndex:index];
}


- (void)removeExperimentAtIndex:(NSUInteger)index
{
    [self removeObjectFromExperimentsAtIndex:index];
    BARTSessionTreeNodeChangeNotificationChangeType changeType = childRemoved;
    NSDictionary *notificationUserInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                          [NSNumber numberWithUnsignedInteger:changeType], BARTSessionTreeNodeChangeNotificationChangeTypeKey,
                                          [NSNumber numberWithUnsignedInteger:index], BARTSessionTreeNodeChangeNotificationChildIndexKey,
                                          nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:BARTSessionTreeNodeChangeNotification object:self userInfo:notificationUserInfo];
}


- (void)removeExperiment:(BASessionTreeNode*)experiment
{
    [self removeExperimentAtIndex:[_experiments indexOfObject:experiment]];
}



#pragma mark -
#pragma mark Class Methods

+ (NSString*)typeDisplayName
{
    return @"Abstract Session";
}

+ (NSString*)typeDescription
{
    return @"Abstract Session Description";
}


@end
