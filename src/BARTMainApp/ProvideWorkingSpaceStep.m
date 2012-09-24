//
//  ProvideWorkingSpaceStep.m
//  BARTApplication
//
//  Created by Torsten Schlumm on 9/20/12.
//  Copyright (c) 2012 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#pragma mark -
#pragma mark Local Headers

#import "ProvideWorkingSpaceStep.h"


#pragma mark -
#pragma mark Global Headers



#pragma mark -
#pragma mark Implementation

@implementation ProvideWorkingSpaceStep {
    
}

#pragma mark -
#pragma mark Configuration

- (void)configure:(BOOL)discardCurrentConfig
{
    NSLog(@"[ProvideWorkingSpaceStep configure:%@] called.", (discardCurrentConfig ? @"TRUE" : @"FALSE"));

    [NSThread sleepForTimeInterval:20];
    
    NSLog(@"[ProvideWorkingSpaceStep configure:%@] finished.", (discardCurrentConfig ? @"TRUE" : @"FALSE"));
}


#pragma mark -
#pragma mark Class Methods

+ (NSString*)typeDisplayName
{
    return @"Provide Working Space";
}

+ (NSString*)typeDescription
{
    return @"Step to provide the working space for the current experiment either from a previous experiment or through the aquisition of a 'localizer'.";
}



@end
