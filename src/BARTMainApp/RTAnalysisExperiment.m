//
//  RTAnalysisExperiment.m
//  BARTApplication
//
//  Created by Torsten Schlumm on 8/6/12.
//  Copyright (c) 2012 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import "RTAnalysisExperiment.h"
#import "BAStep2.h"



@implementation RTAnalysisExperiment


- (void)createSteps
{
    NSLog(@"[RTAnalysisExperiment createSteps] called");

    [NSThread sleepForTimeInterval:5];

    for(unsigned long stepIndex = 0; stepIndex < 12; stepIndex++) {
        BAStep2 *step = [[BAStep2 alloc] initWithName:[NSString stringWithFormat:@"RTAnalysis Step %03lu", stepIndex] description:[NSString stringWithFormat:@"Description of RTAnalysis Step %03lu", stepIndex]];
        [self appendStep:step];
        [NSThread sleepForTimeInterval:0.2];
    }
    
    
}




+ (id) experimentWithEDL:(COSystemConfig*)edl name:(NSString*)name description:(NSString*)description
{
    self = [super experimentWithEDL:edl name:name description:description];
    
    if(self) {
        NSLog(@"[RTAnalysisExperiment] initialization started ...");
        NSLog(@"[RTAnalysisExperiment] EDL: %@", edl);
        NSLog(@"[RTAnalysisExperiment] EDL node count: %lu", [[(BAExperiment2*)self edl] countNodes:@"*/*/*"]);
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self createSteps];
    });
    
    return self;
}

+ (NSString*)typeDisplayName
{
    return @"RT Analysis";
}

+ (NSString*)typeDescription
{
    return @"RT Analysis Experiment Description";
}



@end
