//
//  BAMainSplitViewDelegate.m
//  BARTApplication
//
//  Created by Torsten Schlumm on 9/14/12.
//  Copyright (c) 2012 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import "BAMainSplitViewDelegate.h"

@implementation BAMainSplitViewDelegate


@synthesize mainSplitView = _mainSplitView;


- (BOOL)splitView:(NSSplitView *)splitView shouldAdjustSizeOfSubview:(NSView *)view
{
//    NSLog(@"[BAMainSplitViewDelegate splitView shouldAdjustSizeOfSubview] called: %@ | %@", splitView, view);
    
    if(view == [[[self mainSplitView] subviews] objectAtIndex:0]) {
        return FALSE;
    }
    
    return TRUE;
}

@end
