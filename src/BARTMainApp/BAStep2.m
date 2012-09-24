//
//  BAStep2.m
//  BARTApplication
//
//  Created by Torsten Schlumm on 6/22/12.
//  Copyright (c) 2012 MPI Human Cognitive and Brain Sciences Leipzig. All rights reserved.
//

#import "BAStep2.h"
#import "BARTNotifications.h"


@interface BAStep2()

- (void)doConfiguration:(BOOL)discardCurrentConfig;

@end



@implementation BAStep2 {
    NSArray *emptyChildArray;
    
}

#pragma mark -
#pragma mark Global Properties


#pragma mark -
#pragma mark Local Properties

@synthesize experiment = _experiment;

- (BAExperiment2*)experiment
{
    return _experiment;
}

- (void)setExperiment:(BAExperiment2*)experiment
{
    if(_experiment) {
        [_experiment autorelease];
    }
    [self willChangeValueForKey:@"experiment"];
    _experiment = [experiment retain];
    [self didChangeValueForKey:@"experiment"];
    
    // trigger configuration
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self doConfiguration:TRUE];
    });
}


#pragma mark -
#pragma mark Initialization

- (id)init{
    return [self initWithName:[[self class] typeDisplayName] description:[[self class] typeDescription]];
}

- (id) initWithName:(NSString*)name description:(NSString*)description;
{
    if(self = [super initWithType:BA_NODE_TYPE_STEP name:name description:description children:nil]) {
        
    }
    
    emptyChildArray = [[NSMutableArray arrayWithCapacity:0] retain];
    
    return self;
}


#pragma mark -
#pragma mark Configuration

- (void)configure:(BOOL)discardCurrentConfig
{
    // empty
}

- (void)doConfiguration:(BOOL)discardCurrentConfig
{
    BARTStepConfigurationNotificationEventType eventType;
    NSDictionary *notificationUserInfo;
    
    // configuration starts
    eventType = configurationStarted;
    notificationUserInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                            [NSNumber numberWithUnsignedInteger:eventType], BARTStepConfigurationNotificationEventTypeKey,
                            nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:BARTStepConfigurationNotification object:self userInfo:notificationUserInfo];

    // call custom step configuration
    [self configure:discardCurrentConfig];
    
    // configuration is finished
    eventType = configurationFinished;
    notificationUserInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                            [NSNumber numberWithUnsignedInteger:eventType], BARTStepConfigurationNotificationEventTypeKey,
                            nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:BARTStepConfigurationNotification object:self userInfo:notificationUserInfo];
    
}


- (NSArray*)children
{
    return emptyChildArray;
}

+ (NSString*)typeDisplayName
{
    return @"Abstract Step";
}

+ (NSString*)typeDescription
{
    return @"Abstract Step Description";
}

@end
