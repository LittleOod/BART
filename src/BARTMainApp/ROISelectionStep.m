//
//  ROISelectionStep.m
//  BARTApplication
//
//  Created by Torsten Schlumm on 9/25/12.
//  Copyright (c) 2012 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#pragma mark -
#pragma mark Local Headers

#import "ROISelectionStep.h"


#pragma mark -
#pragma mark Global Headers



#pragma mark -
#pragma mark Implementation

@implementation ROISelectionStep {
    
}

#pragma mark -
#pragma mark Configuration

- (void)configure:(BOOL)discardCurrentConfig
{
    NSLog(@"[ROISelectionStep configure:%@] called.", (discardCurrentConfig ? @"TRUE" : @"FALSE"));
    
    [NSThread sleepForTimeInterval:(5 + (random() % 11))];
    
    [self setState:BA_NODE_STATE_READY];
    
    NSLog(@"[ROISelectionStep configure:%@] finished.", (discardCurrentConfig ? @"TRUE" : @"FALSE"));
}


#pragma mark -
#pragma mark Class Methods

+ (NSString*)typeDisplayName
{
    return @"ROI Selection";
}

+ (NSString*)typeDescription
{
    return @"Allows for the Selection of ROI's by importing a Mask or Selection by Hand.";
}

@end
