//
//  BASessionTreeNode.m
//  BARTApplication
//
//  Created by Torsten Schlumm on 6/21/12.
//  Copyright (c) 2012 MPI Human Cognitive and Brain Sciences Leipzig. All rights reserved.
//

#import "BASessionTreeNode.h"

#import "BASession2.h"
#import "BAExperiment2.h"
#import "BAStep2.h"


@implementation BASessionTreeNode {
    
    NSDictionary *globalObjectTable;

}


@synthesize object      = _object;
@synthesize children    = _children;
@synthesize type        = _type;
@synthesize state       = _state;
@synthesize name        = _name;
@synthesize description = _description;

@synthesize typeIcon  = _typeIcon;
@synthesize stateIcon = _stateIcon;

@synthesize configurationRunning = _configurationRunning;


#pragma mark -
#pragma mark Property Related Methods

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString *)key
{
    NSLog(@"[BASessionTreeNode keyPathsForValuesAffectingValueForKey]: %@", key);

    if([key compare:@"stateIcon"] == NSOrderedSame) {
        return [NSSet setWithObjects:@"state", @"object.state", nil];
    }
    
    return nil;
}


- (NSImage*)typeIcon
{
    NSLog(@"[BASessionTreeNode typeIcon] called (%@)", self);
    
    if(_type == BA_NODE_TYPE_SESSION) {
        return [NSImage imageNamed:@"SessionTreeNodeIconSession.png"];
    } else if (_type == BA_NODE_TYPE_EXPERIMENT) {
        return [NSImage imageNamed:@"SessionTreeNodeIconExperiment.png"];
    } else if (_type == BA_NODE_TYPE_STEP) {
        return [NSImage imageNamed:@"SessionTreeNodeIconStep.png"];
    } else {
        return [NSImage imageNamed:@"SessionTreeNodeIconUnknown.png"];
    }
}



- (NSImage*)stateIcon
{
    NSLog(@"[BASessionTreeNode stateIcon] called (%@)", self);

    if(_state == BA_NODE_STATE_RUNNING) {
        return [[NSImage imageNamed:@"runner.png"] retain];
    } else if (_state == BA_NODE_STATE_READY) {
        return [[NSImage imageNamed:NSImageNameStatusAvailable] retain];
    } else if (_state == BA_NODE_STATE_NEEDS_CONFIGURATION) {
        return [[NSImage imageNamed:NSImageNameStatusPartiallyAvailable] retain];
    } else if (_state == BA_NODE_STATE_ERROR) {
        return [[NSImage imageNamed:NSImageNameStatusUnavailable] retain];
    } else if (_state == BA_NODE_STATE_FINISHED) {
        return [[NSImage imageNamed:NSImageNameMenuOnStateTemplate] retain];
    } else {
        return [[NSImage imageNamed:NSImageNameStatusNone] retain];
    }
}


#pragma mark -
#pragma mark Initialization/Deallocation

- (id)initWithType:(uint)type name:(NSString*)name description:(NSString*)description children:(NSArray*)children
{
    if(self = [super init]) {
        if(children == nil) {
            _children = [[NSArray arrayWithObjects:nil] retain];
        } else {
            _children = [[NSArray arrayWithArray:children] retain];
        }
        _type        = type;
        _name        = [name copy];
        _description = [description copy];
        _state       = BA_NODE_STATE_UNKNOWN;
        
        _configurationRunning = FALSE;

        // init global object table
        globalObjectTable = [[NSDictionary alloc] initWithObjectsAndKeys:nil];

        NSLog(@"Created BASessionTreeNode:");
        NSLog(@"           type: %lu",  _type);
        NSLog(@"           name: %@",   _name);
        NSLog(@"    description: %@",   _description);
        NSLog(@"          state: %lu",  _state);
        NSLog(@"   conf running: %hhu", _configurationRunning);
        NSLog(@"       children: %@",   _children);
    }
    
    return self;
}


- (void)dealloc
{
//    [_object removeObserver:self forKeyPath:@"state"];
    [globalObjectTable release];
    [super dealloc];
}


#pragma mark -
#pragma mark Instance Methods (Global Objects)

- (void)addObjectToGlobalTable:(id)object name:(NSString*)name
{
    [globalObjectTable setValue:object forKey:name];
}

- (id)objectFromGlobalTable:(NSString*)name
{
    return [globalObjectTable objectForKey:name];
}


#pragma mark -
#pragma mark Instance Methods (Structure)

-(BOOL)isRoot
{
    NSLog(@"[BASessionTreeNode isRoot] called");
    return _type == BA_NODE_TYPE_SESSION;
}


-(BOOL)isLeaf
{
    NSLog(@"[BASessionTreeNode isLeaf] called (%@)", _name);
    return ([self children] == nil || [[self children] count] == 0);
}


-(NSUInteger)childCount
{
    NSLog(@"[BASessionTreeNode childCount] called");
    return [[self children] count];
}

-(NSArray*)childNodes
{
    NSLog(@"[BASessionTreeNode childNodes] called");
    return [self children];
}

-(NSTreeNode*)descendantNodeAtIndexPath:(NSIndexPath *)indexPath
{
    int count = [indexPath length];
    NSTreeNode *node = self;
    
    for (int index = 0; index < count; index++) {
        node = [[node childNodes] objectAtIndex:[indexPath indexAtPosition:index]];
    }
    
    return node;
}


//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
//{
//    if(_object == object && [keyPath isEqualToString:@"state"]) {
//        _state = (NSInteger)[change objectForKey:NSKeyValueChangeNewKey];
//    }
//}

#pragma mark -
#pragma mark NSObject methods

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}


#pragma mark -
#pragma mark Debugging

- (void)dump
{
    NSLog(@"BASessionTreeNode Dump:");
    NSLog(@"           type: %u",   [self type]);
    NSLog(@"           name: %@",   [self name]);
    NSLog(@"    description: %@",   [self description]);
    NSLog(@"          state: %lu",  [self state]);
    NSLog(@"   conf running: %hhu", [self configurationRunning]);
    NSLog(@"       children: %@",   [self children]);
}

@end
