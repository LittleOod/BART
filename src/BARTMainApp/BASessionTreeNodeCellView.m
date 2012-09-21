//
//  BASessionTreeNodeCellView.m
//  BARTApplication
//
//  Created by Torsten Schlumm on 7/23/12.
//  Copyright (c) 2012 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import "BASessionTreeNodeCellView.h"
#import "BASessionTreeNode.h"


@implementation BASessionTreeNodeCellView

#pragma mark -
#pragma mark Local Properties

@synthesize nodeDescriptionTextField;
@synthesize nodeStateImageView;



#pragma mark -
#pragma mark Drawing

- (void)drawRect:(NSRect)dirtyRect
{
    if([[[self objectValue] name] isEqualToString:@"ExpName"]) {

    } else {

    }
    [super drawRect:dirtyRect];
    // NSLog(@"[BASessionTreeNodeCellView drawRect]: %@", NSStringFromRect(dirtyRect));
}


@end
