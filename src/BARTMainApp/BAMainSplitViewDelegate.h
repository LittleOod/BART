//
//  BAMainSplitViewDelegate.h
//  BARTApplication
//
//  Created by Torsten Schlumm on 9/14/12.
//  Copyright (c) 2012 MPI Human Cognitive and Brain Sciences Leipzig. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>


@interface BAMainSplitViewDelegate : NSObject <NSSplitViewDelegate>


@property (assign) IBOutlet NSSplitView *mainSplitView;

@end
