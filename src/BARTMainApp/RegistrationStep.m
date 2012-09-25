//
//  RegistrationStep.m
//  BARTApplication
//
//  Created by Torsten Schlumm on 9/25/12.
//  Copyright (c) 2012 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#pragma mark -
#pragma mark Local Headers

#import "RegistrationStep.h"


#pragma mark -
#pragma mark Global Headers



#pragma mark -
#pragma mark Implementation

@implementation RegistrationStep {
    
}

#pragma mark -
#pragma mark Configuration

- (void)configure:(BOOL)discardCurrentConfig
{
    NSLog(@"[RegistrationStep configure:%@] called.", (discardCurrentConfig ? @"TRUE" : @"FALSE"));
    
    [NSThread sleepForTimeInterval:(5 + (random() % 11))];
    
    [self setState:BA_NODE_STATE_READY];
    
    NSLog(@"[RegistrationStep configure:%@] finished.", (discardCurrentConfig ? @"TRUE" : @"FALSE"));
}


#pragma mark -
#pragma mark Class Methods

+ (NSString*)typeDisplayName
{
    return @"Registration";
}

+ (NSString*)typeDescription
{
    return @"Coregistration of Functional Data to Anatomical Data and optionally into MNI-Space.";
}

@end
