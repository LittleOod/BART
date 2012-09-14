//
//  BASessionTreeViewController.m
//  BARTApplication
//
//  Created by Torsten Schlumm on 6/21/12.
//  Copyright (c) 2012 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import "BASessionTreeViewController.h"

#import "BASessionContext.h"



@implementation BASessionTreeViewController


@synthesize sessions = _sessions;


- (NSArray*)sessions {
    return [NSArray arrayWithObject:[[BASessionContext sharedBASessionContext] currentSession]];
}


- (void)outlineViewSelectionDidChange:(NSNotification*)notification
{
    BASessionTreeNode *selectedNode = [[[notification object] itemAtRow:[[notification object] selectedRow]] representedObject];
    
    NSLog(@"[BASessionTreeViewController outlineViewSelectionDidChange]: %@", selectedNode);
    
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
#pragma mark NSOutlineViewDataSource Methods

- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item
{
    NSUInteger count = 0;
    
    if(item == nil) {
//        count = [[[[BASessionContext sharedBASessionContext] currentSession] children] count];
        count = [[self sessions] count];
    } else {
        count = [[(BASessionTreeNode*)item children] count];
    }

    NSLog(@"[BASessionTreeViewController numberOfChildrenOfItem]: %@ | %@ | %lu", outlineView, item, count);
    NSLog(@"[BASessionTreeViewController numberOfChildrenOfItem]: Node --> %@", (BASessionTreeNode*)item);
    
    return count;
}

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item
{
    NSLog(@"[BASessionTreeViewController childOfItem]: %@ | %@ | %lu", outlineView, item, index);

    if(item == nil) {
        return [[self sessions] objectAtIndex:index];
    } else {
        return [[(BASessionTreeNode*)item children] objectAtIndex:index];
    }
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item
{
    return !([item isKindOfClass:[BAStep2 class]]);
}

- (id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(id)item
{
    if([[tableColumn identifier] isEqualToString:@"SessionTreeNodeCell"]) {
        // here we could do any kind of necessary adjustments
        return item;
    }
    
    // default: just return the item
    return item;
}

#pragma mark -
#pragma mark Stuff for Debugging

- (id)arrangedObjects
{
    NSLog(@"[BASessionTreeViewController arrangedObjects] called: [arrangedObjects = %@]", [NSArray arrayWithObject:[[BASessionContext sharedBASessionContext] currentSession]]);
    return [NSArray arrayWithObject:[[BASessionContext sharedBASessionContext] currentSession]];
}



@end
