//
//  BASessionTreeView.m
//  BARTApplication
//
//  Created by Torsten Schlumm on 9/20/12.
//  Copyright (c) 2012 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import "BASessionTreeView.h"

@implementation BASessionTreeView


#pragma mark -
#pragma mark Responder Stuff

//- (BOOL)validateProposedFirstResponder:(NSResponder *)responder forEvent:(NSEvent *)event
//{
//    BOOL _superclassSuggestion = [super validateProposedFirstResponder:responder forEvent:event];
//    NSLog(@"[BARTSessionTreeView validateProposedFirstResponder: forEvent:] called: %@ | %@ Result from superclass = %i", responder, event, _superclassSuggestion);
//    
//    if([event type] == NSLeftMouseDown &&
//       [responder isKindOfClass:[NSTextField class]] &&
//       [[responder identifier] isEqualToString:@"SessionTreeNodeDescriptionTextField"]) {
//        NSLog(@"[BARTSessionTreeView validateProposedFirstResponder: forEvent:] confirmed SessionTreeNodeDescriptionTextField ... returning YES");
//        [responder becomeFirstResponder];
//        return YES;
//    } else {
//        return _superclassSuggestion;
//    }
//}


#pragma mark -
#pragma mark Drawing

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
}


@end
