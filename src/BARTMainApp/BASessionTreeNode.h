//
//  BASessionTreeNode.h
//  BARTApplication
//
//  Created by Torsten Schlumm on 6/21/12.
//  Copyright (c) 2012 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

#import "BAConstants.h"


@interface BASessionTreeNode : NSTreeNode <NSCopying>
    

@property (readonly) id                     object;
@property (readonly) NSString              *name;
@property (readonly) NSString              *description;
@property (readonly) uint                   type;
@property (readonly) NSImage               *typeIcon;
@property (readonly) NSInteger              state;
@property (readonly) NSImage               *stateIcon;
@property (readonly) NSArray               *children;


- (id)initWithType:(uint)type name:(NSString*)name description:(NSString*)description children:(NSArray*)children;


-(BOOL)isRoot;
-(NSUInteger)childCount;

-(void)dump;

@end
