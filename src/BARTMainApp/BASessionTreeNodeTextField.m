//
//  BASessionTreeNodeTextField.m
//  BARTApplication
//
//  Created by Torsten Schlumm on 10/1/12.
//  Copyright (c) 2012 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import "BASessionTreeNodeTextField.h"

@implementation BASessionTreeNodeTextField


- (void)setEnabled:(BOOL)enabled
{
    [super setEnabled:enabled];
    
    if (enabled == NO) {
        [self setTextColor:[NSColor secondarySelectedControlColor]];
    } else {
        if([[self identifier] isEqualToString:@"SessionTreeNodeDescriptionTextField"]) {
            [self setTextColor:[NSColor disabledControlTextColor]];
        } else if([[self identifier] isEqualToString:@"SessionTreeNodeNameTextField"]) {
            [self setTextColor:[NSColor controlTextColor]];
        } else {
            [self setTextColor:[NSColor controlTextColor]];
        }
    }
}






- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
}




@end
