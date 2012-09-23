//
//  BARTNotifications.h
//  BARTApplication
//
//  Created by Lydia Hellrung on 3/24/11.
//  Copyright 2011 MPI Human Cognitive and Brain Sciences Leipzig. All rights reserved.
//

#ifndef BARTNOTIFICATIONS_H
#define BARTNOTIFICATIONS_H

#import "Cocoa/Cocoa.h"

extern NSString * const BARTDidLoadNextDataNotification;
extern NSString * const BARTDidCalcNextResultNotification ;
extern NSString * const BARTDidLoadBackgroundImageNotification;
extern NSString * const BARTDidReceiveNextTriggerNotification;
extern NSString * const BARTTestBackroundNotification;
extern NSString * const BARTScannerSentTerminusNotification;
extern NSString * const BARTStopExperimentNotification;

extern NSString * const BARTSessionTreeNodeChangeNotification;
extern NSString * const BARTSessionTreeNodeChangeNotificationChangeTypeKey;
extern NSString * const BARTSessionTreeNodeChangeNotificationChildIndexKey;

typedef enum {
    childAdded   = 0x01,
    childRemoved = 0x02
} BARTSessionTreeNodeChangeNotificationChangeType;

#endif // BARTNOTIFICATIONS_H
