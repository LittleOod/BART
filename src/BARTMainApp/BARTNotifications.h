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


// Session Tree Changes
extern NSString * const BARTSessionTreeNodeChangeNotification;
// Notification Info Dictionary Keys
extern NSString * const BARTSessionTreeNodeChangeNotificationChangeTypeKey;
extern NSString * const BARTSessionTreeNodeChangeNotificationChildIndexKey;
// Change Types
typedef enum {
    childAdded   = 0x01,
    childRemoved = 0x02
} BARTSessionTreeNodeChangeNotificationChangeType;


// Step Configuration
extern NSString * const BARTStepConfigurationNotification;
// Notification Info Dictionary Keys
extern NSString * const BARTStepConfigurationNotificationEventTypeKey;
// Event Types
typedef enum {
    configurationStarted  = 0x01,
    configurationFinished = 0x02
} BARTStepConfigurationNotificationEventType;



#endif // BARTNOTIFICATIONS_H
