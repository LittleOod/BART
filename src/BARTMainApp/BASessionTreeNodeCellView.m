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


@implementation BASessionTreeNodeCellView {
    
}

static CGFloat disabledAlphaValue = 0.3;
static CGFloat  enabledAlphaValue = 1.0;

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
    [NSAnimationContext beginGrouping];
    [[self textField] setAlphaValue:disabledAlphaValue];
    [[self imageView] setAlphaValue:disabledAlphaValue];
    [nodeStateImageView setAlphaValue:disabledAlphaValue];
    [nodeDescriptionTextField setAlphaValue:disabledAlphaValue];
    [NSAnimationContext endGrouping];
}

- (void)enableSubViews
{
    [NSAnimationContext beginGrouping];
    [[self textField] setAlphaValue:enabledAlphaValue];
    [[self imageView] setAlphaValue:enabledAlphaValue];
    [nodeStateImageView setAlphaValue:enabledAlphaValue];
    [nodeDescriptionTextField setAlphaValue:enabledAlphaValue];
    [NSAnimationContext endGrouping];
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
