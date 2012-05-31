//
//  BAHierarchyTreeController.m
//  BARTApplication
//
//  Created by Torsten Schlumm on 5/15/12.
//  Copyright (c) 2012 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import "BAHierarchyTreeController.h"

#import "BASession.h"
#import "BAExperiment.h"
#import "BAStep.h"



@implementation BAHierarchyTreeController

- (NSView*)outlineView:(NSOutlineView *)outlineView
    viewForTableColumn:(NSTableColumn *)tableColumn
                  item:(id)item
{
    NSLog(@"outlineView:%@ viewForTableColumn:%@ item:%@", outlineView, tableColumn, item);
    
    
    NSTableCellView *result = nil;
    
    result = [outlineView makeViewWithIdentifier:[tableColumn identifier] owner:self];
    result.textField.stringValue = [(BAHierarchyElement*)[item representedObject] name];

    NSString *elementType = NSStringFromClass([(BAHierarchyElement*)[item representedObject] class]);
    NSLog(@"Class for element [%@]: %@", [[item representedObject] description], elementType);
    if([[elementIconNames allKeys] containsObject:elementType]) {
        NSLog(@"element icon name: %@", [elementIconNames valueForKey:elementType]);
        result.imageView.image = [NSImage imageNamed:[elementIconNames valueForKey:elementType]];
    } else {
        NSLog(@"element icon name: %@", [elementIconNames valueForKey:@"Unknown"]);
        result.imageView.image = [NSImage imageNamed:[elementIconNames valueForKey:@"Unknown"]];
    }
    
    
    result.backgroundStyle = NSBackgroundStyleLight;
    
    return result;
}


- (NSImage*)imageForBAHierarchyElement:(BAHierarchyElement*)element
{
    [element class];
    return nil;
}

- (IBAction)showElementPopover:(id)sender
{
    NSLog(@"Element Popover Trigger for: %@", [[self selectedObjects] objectAtIndex:0]);
}




+ (void)initialize
{
    NSLog(@"+ (void)initialize");
    elementIconNames = [[NSDictionary alloc] initWithObjectsAndKeys:
                        @"Hierarchy Element Icon Session.png",    NSStringFromClass([BASession class]),
                        @"Hierarchy Element Icon Experiment.png", NSStringFromClass([BAExperiment class]),
                        @"Hierarchy Element Icon Step.png",       NSStringFromClass([BAStep class]),
                        @"Hierarchy Element Icon Unknown.png",    @"Unknown",
                        nil];
}

@end
