//
//  BASessionTreeNode.h
//  BARTApplication
//
//  Created by Torsten Schlumm on 6/21/12.
//  Copyright (c) 2012 MPI Human Cognitive and Brain Sciences Leipzig. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

#import "BAConstants.h"


@interface BASessionTreeNode : NSTreeNode <NSCopying>
    

@property (readonly)  id                     object;
@property (readonly)  NSString              *name;
@property (readonly)  NSString              *description;
@property (readonly)  uint                   type;
@property (readonly)  NSImage               *typeIcon;
@property (readwrite) NSInteger              state;
@property (readonly)  NSImage               *stateIcon;
@property (readonly)  NSArray               *children;

@property (readwrite) BOOL                   configurationRunning;


- (id)initWithType:(uint)type name:(NSString*)name description:(NSString*)description children:(NSArray*)children;

- (void)addObjectToGlobalTable:(id)object name:(NSString*)name;
- (id)objectFromGlobalTable:(NSString*)name;

- (BOOL)isRoot;
- (NSUInteger)childCount;

- (void)dump;

@end
