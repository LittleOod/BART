//
//  ProvideAnatomyStep.m
//  BARTApplication
//
//  Created by Torsten Schlumm on 9/25/12.
//  Copyright (c) 2012 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#pragma mark -
#pragma mark Local Headers

#import "ProvideAnatomyStep.h"


#pragma mark -
#pragma mark Global Headers



#pragma mark -
#pragma mark Implementation

@implementation ProvideAnatomyStep {
    
}

#pragma mark -
#pragma mark Configuration

- (void)configure:(BOOL)discardCurrentConfig
{
    NSLog(@"[ProvideAnatomyStep configure:%@] called.", (discardCurrentConfig ? @"TRUE" : @"FALSE"));
    
    [NSThread sleepForTimeInterval:(5 + (random() % 11))];
    
    [self setState:BA_NODE_STATE_READY];
    
    NSLog(@"[ProvideAnatomyStep configure:%@] finished.", (discardCurrentConfig ? @"TRUE" : @"FALSE"));
}


#pragma mark -
#pragma mark Class Methods

+ (NSString*)typeDisplayName
{
    return @"Provide Anatomy";
}

+ (NSString*)typeDescription
{
    return @"Step to provide a referencing anatomy either from a file or by performing an anatomical scan.";
}



@end
