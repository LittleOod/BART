//
//  DynamicDesignExperiment.m
//  BARTApplication
//
//  Created by Torsten Schlumm on 9/20/12.
//  Copyright (c) 2012 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#pragma mark -
#pragma mark Local Headers

#import "DynamicDesignExperiment.h"
#import "BAStep2.h"
#import "ProvideWorkingSpaceStep.h"


#pragma mark -
#pragma mark Global Headers


#pragma mark -
#pragma mark Implementation

@implementation DynamicDesignExperiment {
    
}


#pragma mark -
#pragma mark Main Entry Method

+ (id) experimentWithEDL:(COSystemConfig*)edl name:(NSString*)name description:(NSString*)description
{
    self = [super experimentWithEDL:edl name:name description:description];
    
    if(self) {
        NSLog(@"[DynamicDesignExperiment] initialization started ...");
        NSLog(@"[DynamicDesignExperiment] EDL: %@", edl);
        NSLog(@"[DynamicDesignExperiment] EDL node count: %lu", [[(BAExperiment2*)self edl] countNodes:@"*/*/*"]);
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self createSteps];
    });
    
    return self;
}


#pragma mark -
#pragma mark Initialization

- (void)createSteps
{
    NSLog(@"[DynamicDesignExperiment createSteps] called");
    
    [NSThread sleepForTimeInterval:5];

    BAStep2 *provideWorkingSpaceStep = [[ProvideWorkingSpaceStep alloc] init];
    [self appendStep:provideWorkingSpaceStep];
    
}



#pragma mark -
#pragma mark Class Methods

+ (NSString*)typeDisplayName
{
    return @"Dynamic Design";
}

+ (NSString*)typeDescription
{
    return @"Dynamic Design Experiment Description";
}



@end
