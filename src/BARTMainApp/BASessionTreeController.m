//
//  BASessionTreeController.m
//  BARTApplication
//
//  Created by Torsten Schlumm on 6/21/12.
//  Copyright (c) 2012 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import "BASessionTreeController.h"

#import "BASessionContext.h"



@implementation BASessionTreeController


@synthesize treeRoots;


- (NSArray*)treeRoots
{
    return [NSArray arrayWithObject:[[BASessionContext sharedBASessionContext] currentSession]];
}

- (void)outlineViewSelectionDidChange:(NSNotification*)notification
{
    BASessionTreeNode *selectedNode = [[[notification object] itemAtRow:[[notification object] selectedRow]] representedObject];
    
    NSLog(@"[BASessionTreeController outlineViewSelectionDidChange]: %@", selectedNode);
    
    [[selectedNode object] setState:random() % 6];
    
}

- (NSView*)outlineView:(NSOutlineView *)outlineView
    viewForTableColumn:(NSTableColumn *)tableColumn
                  item:(id)item
{
    NSLog(@"outlineView:%@ viewForTableColumn:%@ item:%@", outlineView, tableColumn, item);

    return [outlineView makeViewWithIdentifier:[tableColumn identifier] owner:self];
}


#pragma mark -
#pragma mark Stuff for Debugging

- (id)arrangedObjects
{
    NSLog(@"[BASessionTreeController arrangedObjects] called: [arrangedObjects = %@]", [NSArray arrayWithObject:[[BASessionContext sharedBASessionContext] currentSession]]);
    return [NSArray arrayWithObject:[[BASessionContext sharedBASessionContext] currentSession]];
}

- (id)content
{
    NSLog(@"[BASessionTreeController content] called: [content = %@]", [super content]);
    return [super content];
}


- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item
{
    NSLog(@"[BASessionTreeController childOfItem]: %@ | %@ | %lu", outlineView, item, index);
    
}


@end
