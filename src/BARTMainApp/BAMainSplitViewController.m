//
//  BAMainSplitViewController.m
//  BARTApplication
//
//  Created by Torsten Schlumm on 5/15/12.
//  Copyright (c) 2012 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import "BAMainSplitViewController.h"

@interface BAMainSplitViewController ()

@end

@implementation BAMainSplitViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

//- (void)setView:(NSView *)view
//{
//    NSLog(@"setView: %@", view);
//}

//- (void)splitViewDidResizeSubviews:(NSNotification *)notification
//{
//    NSLog(@"%@", notification);
//}

- (CGFloat)splitView:(NSSplitView *)splitView constrainMinCoordinate:(CGFloat)proposedMinimumPosition ofSubviewAt:(NSInteger)dividerIndex
{
    if(dividerIndex == 0) {
        return proposedMinimumPosition + 150;
    } else {
        return proposedMinimumPosition;
    }
}

@end
