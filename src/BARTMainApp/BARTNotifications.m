//
//  BARTNotifications.m
//  BARTApplication
//
//  Created by Lydia Hellrung on 3/25/11.
//  Copyright 2011 MPI Human Cognitive and Brain Sciences Leipzig. All rights reserved.
//
#import "BARTNotifications.h"

NSString * const BARTDidLoadNextDataNotification = @"BARTNextDataNotification";
NSString * const BARTDidCalcNextResultNotification = @"BARTNextResultNotification";
NSString * const BARTDidLoadBackgroundImageNotification = @"BARTLoadedBackgroundImageFinished";
NSString * const BARTDidReceiveNextTriggerNotification = @"BARTNextTriggerNotification";
NSString * const BARTTestBackroundNotification = @"BARTTestBackroundNotification";
NSString * const BARTScannerSentTerminusNotification = @"BARTScannerSentTerminusNotification";
NSString * const BARTStopExperimentNotification = @"BARTStopExperimentNotification";

NSString * const BARTSessionTreeNodeChangeNotification = @"BARTSessionTreeNodeChangeNotification";
NSString * const BARTSessionTreeNodeChangeNotificationChangeTypeKey = @"BARTSessionTreeNodeChangeNotificationChangeTypeKey";
NSString * const BARTSessionTreeNodeChangeNotificationChildIndexKey = @"BARTSessionTreeNodeChangeNotificationChildIndexKey";
