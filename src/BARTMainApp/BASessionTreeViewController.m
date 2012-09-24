//
//  BASessionTreeViewController.m
//  BARTApplication
//
//  Created by Torsten Schlumm on 6/21/12.
//  Copyright (c) 2012 MPI Human Cognitive and Brain Sciences Leipzig. All rights reserved.
//

#pragma mark -
#pragma mark Headers

#import "BASessionTreeViewController.h"
#import "BASessionTreeNodeCellView.h"
#import "BASessionContext.h"
#import "BARTNotifications.h"

#import <QuartzCore/QuartzCore.h>


#pragma mark -
#pragma mark Implementation

@implementation BASessionTreeViewController {
    
    NSOperationQueue *sessionTreeViewQueue;
}


#pragma mark -
#pragma mark Initialization

- (id)initWithCoder:(NSCoder*)aDecoder
{
    if(self = [super initWithCoder:aDecoder]) {
        NSLog(@"[BASessionTreeViewController initWithCoder] called: %@", aDecoder);

        sessionTreeViewQueue = [[NSOperationQueue alloc] init];
        
        [[BASessionContext sharedBASessionContext] addObserver:self
                                                    forKeyPath:@"currentSession"
                                                       options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew
                                                       context:nil];

        [[NSNotificationCenter defaultCenter] addObserverForName:BARTSessionTreeNodeChangeNotification
                                                          object:nil
                                                           queue:[NSOperationQueue mainQueue]
                                                      usingBlock:^(NSNotification *notification) {
                                                          [self handleSessionTreeNodeChangeNotification:notification];
                                                      }];
        [[NSNotificationCenter defaultCenter] addObserverForName:BARTStepConfigurationNotification
                                                          object:nil
                                                           queue:[NSOperationQueue mainQueue]
                                                      usingBlock:^(NSNotification *notification) {
                                                          [self handleStepConfigurationNotification:notification];
                                                      }];
    }
    
    return self;
}


#pragma mark -
#pragma mark Observers and Notifications

- (void)handleSessionTreeNodeChangeNotification:(NSNotification*)notification
{
    NSLog(@"[BARTSessionTreeNodeChangeNotification] %@", notification);
    [NSAnimationContext beginGrouping];
    [[NSAnimationContext currentContext] setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
//    [NSAnimationContext setCompletionHandler: ^{
//        NSLog(@"[NSAnimationContext] Animations Completed.");
//    }];
    [_sessionTreeOutlineView beginUpdates];
    BARTSessionTreeNodeChangeNotificationChangeType changeType = (BARTSessionTreeNodeChangeNotificationChangeType)[[[notification userInfo] objectForKey:BARTSessionTreeNodeChangeNotificationChangeTypeKey] unsignedIntegerValue];
    if(changeType == childAdded) {
        NSIndexSet *insertIndexSet = [NSIndexSet indexSetWithIndex:[[[notification userInfo] objectForKey:BARTSessionTreeNodeChangeNotificationChildIndexKey] unsignedIntegerValue]];
        [_sessionTreeOutlineView insertItemsAtIndexes:insertIndexSet inParent:[notification object] withAnimation:NSTableViewAnimationSlideDown];
    }
    if(changeType == childRemoved) {
        NSIndexSet *removeIndexSet = [NSIndexSet indexSetWithIndex:[[[notification userInfo] objectForKey:BARTSessionTreeNodeChangeNotificationChildIndexKey] unsignedIntegerValue]];
        [_sessionTreeOutlineView removeItemsAtIndexes:removeIndexSet inParent:[notification object] withAnimation:NSTableViewAnimationSlideUp];
    }
    [_sessionTreeOutlineView endUpdates];
    [NSAnimationContext endGrouping];
}

- (void)handleStepConfigurationNotification:(NSNotification*)notification
{
    NSLog(@"[BARTStepConfigurationNotification] %@", notification);

    BARTStepConfigurationNotificationEventType eventType = (BARTStepConfigurationNotificationEventType)[[[notification userInfo] objectForKey:BARTStepConfigurationNotificationEventTypeKey] unsignedIntegerValue];
    if(eventType == configurationStarted) {
        [[[_sessionTreeOutlineView viewAtColumn:0 row:[_sessionTreeOutlineView rowForItem:[notification object]] makeIfNecessary:TRUE] nodeProgressIndicator] startAnimation:self];
    }
    if(eventType == configurationFinished) {
        [[[_sessionTreeOutlineView viewAtColumn:0 row:[_sessionTreeOutlineView rowForItem:[notification object]] makeIfNecessary:TRUE] nodeProgressIndicator] stopAnimation:self];
    }
}




- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    NSLog(@"[BASessionTreeViewController observeValueForKeyPath ofObject change context] called: %@ | %@ | %@ | %@", keyPath, object, change, context);
    if([keyPath isEqualToString:@"currentSession"]) {
//        [_sessionTreeOutlineView reloadItem:[change objectForKey:NSKeyValueChangeNewKey] reloadChildren:TRUE];
    }
}


#pragma mark -
#pragma mark Actions & Mouse Events

- (IBAction)handleSessionTreeNodeDescriptionClick:(id)sender
{
    NSLog(@"[BARTSessionTreeNodeChangeNotification handleSessionTreeNodeDescriptionClick] called: %@", sender);
}


#pragma mark -
#pragma mark Local Properties

@synthesize sessions = _sessions;

- (NSArray*)sessions {
    return [NSArray arrayWithObject:[[BASessionContext sharedBASessionContext] currentSession]];
}


- (void)outlineViewSelectionDidChange:(NSNotification*)notification
{
    NSLog(@"[BASessionTreeViewController outlineViewSelectionDidChange] called: %@", notification);

    if([notification object] == _sessionTreeOutlineView) {
        
        BASessionTreeNode *selectedNode = [_sessionTreeOutlineView itemAtRow:[_sessionTreeOutlineView selectedRow]];
        
        NSLog(@"[BASessionTreeViewController outlineViewSelectionDidChange] selectedNode: %@", selectedNode);
        
        [selectedNode setState:random() % 6];
    }
}

#pragma mark -
#pragma mark NSOutlineViewDelegate Methods


- (NSView*)outlineView:(NSOutlineView *)outlineView
    viewForTableColumn:(NSTableColumn *)tableColumn
                  item:(id)item
{
    NSLog(@"[BASessionTreeViewController outlineView: viewForTableColumn: item:] %@ | %@ | %@", outlineView, tableColumn, item);

    if([item isKindOfClass:[BASession2 class]]) {
        return [outlineView makeViewWithIdentifier:[[[outlineView tableColumns] objectAtIndex:0] identifier] owner:self];
    } else {
        return [outlineView makeViewWithIdentifier:[tableColumn identifier] owner:self];
    }
}

- (NSTableRowView*)outlineView:(NSOutlineView *)outlineView
                rowViewForItem:(id)item {

    NSLog(@"[BASessionTreeViewController outlineView: rowViewForItem:] %@ | %@", outlineView, item);

    NSTableRowView *returnView = [_sessionTreeOutlineView rowViewAtRow:[_sessionTreeOutlineView rowForItem:item] makeIfNecessary:YES];
    NSLog(@"[BASessionTreeViewController] OutlineView returned view: %@", returnView);
    
    if([item isKindOfClass:[BAExperiment2 class]]) {
        [returnView setEmphasized:TRUE];
    } else {
        [returnView setEmphasized:FALSE];
    }
    
    return returnView;
}


#pragma mark -
#pragma mark NSOutlineViewDataSource Methods

- (NSInteger)outlineView:(NSOutlineView *)outlineView
  numberOfChildrenOfItem:(id)item
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

- (id)outlineView:(NSOutlineView *)outlineView
            child:(NSInteger)index
           ofItem:(id)item
{
    NSLog(@"[BASessionTreeViewController childOfItem]: %@ | %@ | %lu", outlineView, item, index);

    if(item == nil) {
        return [[self sessions] objectAtIndex:index];
    } else {
        return [[(BASessionTreeNode*)item children] objectAtIndex:index];
    }
}

- (BOOL)outlineView:(NSOutlineView *)outlineView
   isItemExpandable:(id)item
{
    return !([item isKindOfClass:[BAStep2 class]]);
}

- (BOOL)outlineView:(NSOutlineView *)outlineView
   shouldSelectItem:(id)item
{
    return ![item isKindOfClass:[BASession2 class]];
}

- (BOOL)outlineView:(NSOutlineView *)outlineView
        isGroupItem:(id)item
{
//    return [item isKindOfClass:[BASession2 class]];
    return NO;
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
