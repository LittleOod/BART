//
//  BASessionTreeNodeCellView.m
//  BARTApplication
//
//  Created by Torsten Schlumm on 7/23/12.
//  Copyright (c) 2012 MPI Human Cognitive and Brain Sciences Leipzig. All rights reserved.
//

#import "BASessionTreeNodeCellView.h"
#import "BASessionTreeNode.h"


@interface BASessionTreeNodeCellView()

- (void)enableSubViews;
- (void)disableSubViews;

@end


@implementation BASessionTreeNodeCellView

#pragma mark -
#pragma mark Local Properties

@synthesize nodeDescriptionTextField;
@synthesize nodeStateImageView;
@synthesize nodeProgressIndicator;


#pragma mark -
#pragma mark Initialization

- (id)initWithFrame:(NSRect)frameRect
{
    if(self = [super initWithFrame:frameRect]) {
        [self setWantsLayer:TRUE];
    }
    return self;
}

- (id)initWithCoder:(NSCoder*)aDecoder
{
    if(self = [super initWithCoder:aDecoder]) {
        [self setWantsLayer:TRUE];
    }
    return self;
}


#pragma mark -
#pragma mark Progress Indicator

- (void)startProgressIndicator
{
    [self disableSubViews];
    [[self nodeProgressIndicator] startAnimation:self];
}

- (void)stopProgressIndicator
{
    [self enableSubViews];
    [[self nodeProgressIndicator] stopAnimation:self];
}


#pragma mark -
#pragma mark Disable/Enable Subviews

- (void)disableSubViews
{
    if([self wantsLayer] == FALSE) {
        [self setWantsLayer:TRUE];
    }
    [[self animator] setAlpha:0.1];
//    [[self textField] setAlphaValue:0.5];
//    [[self imageView] setAlphaValue:0.5];
//    [nodeStateImageView setAlphaValue:0.5];
//    [nodeDescriptionTextField setAlphaValue:0.5];
}

- (void)enableSubViews
{
    if([self wantsLayer] == FALSE) {
        [self setWantsLayer:TRUE];
    }
    [[self animator] setAlpha:1.0];
//    [[self textField] setAlphaValue:1.0];
//    [[self imageView] setAlphaValue:1.0];
//    [nodeStateImageView setAlphaValue:1.0];
//    [nodeDescriptionTextField setAlphaValue:1.0];
}


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
