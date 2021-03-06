//
//  TriggerButtonInterpret.h
//  BARTSerialIOPluginFTDITriggerButton
//
//  Created by Lydia Hellrung on 5/7/11.
//  Copyright 2011 MPI Human Cognitive and Brain Sciences Leipzig. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#include "BARTSerialIOFramework/BARTSerialIOProtocol.h"



@interface TriggerButtonInterpret : NSObject  <BARTSerialIOProtocol> {

	NSNumber *triggerID;
	unsigned char triggerIDChar;
    @private
    size_t countTrigger;
    NSDictionary *dictPortParameters;
    NSString *mLogfilePath;
    NSString *mLogfileNameAppend;

}

@property (copy, nonatomic) NSNumber *triggerID;

@end
