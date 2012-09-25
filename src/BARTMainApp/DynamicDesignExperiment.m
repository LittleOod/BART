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

    // this way of creating a step needs the 'step-header' to be included
    BAStep2 *provideWorkingSpaceStep = [[ProvideWorkingSpaceStep alloc] init];
    [provideWorkingSpaceStep setState:BA_NODE_STATE_NEEDS_CONFIGURATION];
    [self appendStep:provideWorkingSpaceStep];

    // no need to include the 'step-header' for this way of creating the step
    BAStep2 *provideAnatomyStep = [[NSClassFromString(@"ProvideAnatomyStep") alloc] init];
    [provideAnatomyStep setState:BA_NODE_STATE_NEEDS_CONFIGURATION];
    [self appendStep:provideAnatomyStep];

    BAStep2 *registrationStep = [[NSClassFromString(@"RegistrationStep") alloc] init];
    [registrationStep setState:BA_NODE_STATE_NEEDS_CONFIGURATION];
    [self appendStep:registrationStep];
    
    BAStep2 *roiSelectionStep = [[NSClassFromString(@"ROISelectionStep") alloc] init];
    [roiSelectionStep setState:BA_NODE_STATE_NEEDS_CONFIGURATION];
    [self appendStep:roiSelectionStep];
    
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
