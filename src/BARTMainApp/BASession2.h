//
//  BASession2.h
//  BARTApplication
//
//  Created by Torsten Schlumm on 6/22/12.
//  Copyright (c) 2012 MPI Human Cognitive and Brain Sciences Leipzig. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BAConstants.h"
#import "BASessionTreeNode.h"


@interface BASession2 : BASessionTreeNode <NSCopying>


@property (readonly,retain) NSArray   *experiments;


- (id) initWithName:(NSString*)name description:(NSString*)description;
- (id) initWithName:(NSString*)name description:(NSString*)description experiments:(NSArray*)experiments;

- (void)addExperiment:(BASessionTreeNode*)experiment atIndex:(NSUInteger)index;
- (void)appendExperiment:(BASessionTreeNode*)experiment;
- (void)removeExperimentAtIndex:(NSUInteger)index;
- (void)removeExperiment:(BASessionTreeNode*)experiment;

+ (NSString*)displayTypeName;
+ (NSString*)displayDescription;

@end
