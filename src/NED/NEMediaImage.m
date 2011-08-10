//
//  NEMediaImage.m
//  BARTPresentation
//
//  Created by Oliver Zscheyge on 4/7/10.
//  Copyright 2010 MPI Cognitive and Human Brain Scienes Leipzig. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "NEMediaImage.h"
#import "COExperimentContext.h"


@implementation NEMediaImage

-(id)initWithID:(NSString*)objID
           file:(NSString*)path
      displayAt:(NSPoint)position
{
    if ((self = [super init])) {
        mID       = [objID retain];
        
        NSString* resolvedPath  = [[[COExperimentContext getInstance] systemConfig] getEDLFilePath];
        resolvedPath = [resolvedPath stringByDeletingLastPathComponent];
        NSArray* pathComponents = [[resolvedPath pathComponents] arrayByAddingObjectsFromArray:[path pathComponents]];
        resolvedPath = [NSString pathWithComponents:pathComponents];
        //TODO: error handling if file not found!
        //mImage    = [[CIImage alloc] initWithContentsOfURL:[NSURL fileURLWithPath:resolvedPath]];
        
        /*********/
        //TODO : Scale Factor?!
            CIImage *im    = [[CIImage alloc] initWithContentsOfURL:[NSURL fileURLWithPath:resolvedPath]];
            // Resize the image
            CIFilter *scaleFilter = [CIFilter filterWithName:@"CILanczosScaleTransform"];
            [scaleFilter setValue:im forKey:@"inputImage"];
            [scaleFilter setValue:[NSNumber numberWithFloat:0.5] forKey:@"inputScale"];
            [scaleFilter setValue:[NSNumber numberWithFloat:1.0] forKey:@"inputAspectRatio"];
            mImage = [[scaleFilter valueForKey:@"outputImage"] retain];
         
        /******/
        mPosition = position;
    }
    
    return self;
}

-(void)dealloc
{
    [mID release];
    [mImage release];
    
    [super dealloc];
}

-(void)presentInContext:(CGContextRef)context andRect:(NSRect)rect
{
    CIContext* ciContext = [CIContext contextWithCGContext:context options:nil];
    [ciContext  drawImage:mImage
                  atPoint:mPosition
                 fromRect:rect];
}

@end
