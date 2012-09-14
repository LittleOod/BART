//
//  BAStep2.m
//  BARTApplication
//
//  Created by Torsten Schlumm on 6/22/12.
//  Copyright (c) 2012 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import "BAStep2.h"


@implementation BAStep2 {
    NSArray *emptyChildArray;
}

#pragma mark -
#pragma mark Global Properties


#pragma mark -
#pragma mark Local Properties

@synthesize experiment = _experiment;



#pragma mark -
#pragma mark Initialization

- (id) initWithName:(NSString*)name description:(NSString*)description;
{
    if(self = [super initWithType:BA_NODE_TYPE_STEP name:name description:description children:nil]) {
        
    }
    
    emptyChildArray = [[NSMutableArray arrayWithCapacity:0] retain];
    
    return self;
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
