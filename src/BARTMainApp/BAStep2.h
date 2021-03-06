//
//  BAStep2.h
//  BARTApplication
//
//  Created by Torsten Schlumm on 6/22/12.
//  Copyright (c) 2012 MPI Human Cognitive and Brain Sciences Leipzig. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BAConstants.h"
#import "BAExperiment2.h"


@interface BAStep2 : BASessionTreeNode <NSCopying>


@property (readwrite,assign) BAExperiment2 *experiment;

- (id)init;
- (id)initWithName:(NSString*)name description:(NSString*)description;


// step implementations will have to overwrite this method to do
// their specific configuration
- (void)configure:(BOOL)discardCurrentConfig;

// this is just a wrapper method to handle notifications for
// the views etc. and finally call the above 'configure' method
// of the actual implementation
// step implementations shouldn't touch this method unless you
// really know what you're doing
- (void)doConfiguration:(BOOL)discardCurrentConfig;

+ (NSString*)typeDisplayName;
+ (NSString*)typeDescription;

@end
