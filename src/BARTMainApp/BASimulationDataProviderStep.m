//
//  BASimulationDataProviderStep.m
//  BARTApplication
//
//  Created by Torsten Schlumm on 6/8/12.
//  Copyright (c) 2012 MPI Human Cognitive and Brain Sciences Leipzig. All rights reserved.
//

#import "BASimulationDataProviderStep.h"

@implementation BASimulationDataProviderStep

- (id)initWithNameAndComment:(NSString *)name comment:(NSString *)comment
{
    if(self = [super initWithNameAndComment:name comment:comment])
    {
        [[self properties] setObject:@"BASimulationDataProviderConfigView"    forKey: BA_ELEMENT_PROPERTY_CONFIGURATION_UI_NAME];
        [[self properties] setObject:@"BASimulationDataProviderExecutionView" forKey: BA_ELEMENT_PROPERTY_EXECUTION_UI_NAME];
    }
    
    return self;
}

@end
