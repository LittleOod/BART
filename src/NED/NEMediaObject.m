//
//  NEMediaObject.m
//  BARTPresentation
//
//  Created by Oliver Zscheyge on 4/6/10.
//  Copyright 2010 MPI Cognitive and Human Brain Scienes Leipzig. All rights reserved.
//

#import "NEMediaObject.h"
#import "COExperimentContext.h"
#import "NEMediaText.h"
#import "NEMediaImage.h"
#import "NEMediaAudio.h"
#import "NERegressorAssignment.h"


@implementation NEMediaObject

@synthesize mPosition;
@synthesize hasConstraint;
@synthesize mEventTypeDescription;
@synthesize hasRegAssignment;

-(id)init
{
    if ((self = [super init])) {
        mPosition = (NSPoint) {0, 0};
        mID = @"";
        mConstraintID = @"";
        hasConstraint = NO;
        mEventTypeDescription = @"";
        hasRegAssignment = NO;
        mRegAssignment = nil;
    }
    
    return self;
}

-(id)initWithConfigEntry:(NSString*)key
{
    
    [self release];
    self = nil;
    
    
    COSystemConfig* config = [[COExperimentContext getInstance] systemConfig];
    
    NSString* objID   = [config getProp:[NSString stringWithFormat:@"%@/@moID", key]];
    NSString* objType = [config getProp:[NSString stringWithFormat:@"%@/@type", key]];
    NSString* constraintID = [config getProp:[NSString stringWithFormat:@"%@/@useConstraint", key]];
    
    NSUInteger countAssigns = [config countNodes:[NSString stringWithFormat:@"%@/regressorAssignment", key]];
    NSString* assignedRegID = @"";
    NSString* transferFunc = @"";
    // create and alloc here, but give it to instances to be held
    NERegressorAssignment* regAssign = nil;
    if (0 != countAssigns)
    {
        assignedRegID = [config getProp:[NSString stringWithFormat:@"%@/regressorAssignment/@assignToRegressor", key]];
        transferFunc =  [config getProp:[NSString stringWithFormat:@"%@/regressorAssignment/@useTransferFunction", key]];
        regAssign = [[NERegressorAssignment alloc] initWithFunctionID:transferFunc andRegID:assignedRegID];
    }
    
    
    
    if ([objType compare:@"TEXT"] == 0) {
        NSString* text = [config getProp:[NSString stringWithFormat:@"%@/contentText/text", key]];
        NSUInteger size = [[config getProp:[NSString stringWithFormat:@"%@/contentText/tSize", key]] intValue];
        float red = [[config getProp:[NSString stringWithFormat:@"%@/contentText/tColor/tcRed", key]] floatValue];
        float green = [[config getProp:[NSString stringWithFormat:@"%@/contentText/tColor/tcGreen", key]] floatValue];
        float blue = [[config getProp:[NSString stringWithFormat:@"%@/contentText/tColor/tcBlue", key]] floatValue];
        NSColor* color = [NSColor colorWithCalibratedRed:red
                                                   green:green
                                                    blue:blue
                                                   alpha:1.0];
        NSPoint position;
        position.x = [[config getProp:[NSString stringWithFormat:@"%@/contentText/posX", key]] floatValue];
        position.y = [[config getProp:[NSString stringWithFormat:@"%@/contentText/posY", key]] floatValue];
        
        self = [[NEMediaText alloc] initWithID:objID
                                          Text:text
                                        inSize:size
                                      andColor:color
                                     atPostion:position
                                 constrainedBy:constraintID
                              andRegAssignment:regAssign];
        
    } else if ([objType compare:@"SOUND"] == 0) {
        NSString* soundFilePath = [config getProp:[NSString stringWithFormat:@"%@/contentSound/soundFile", key]];
        self = [[NEMediaAudio alloc] initWithID:objID
                                        andFile:soundFilePath
                                  constrainedBy:constraintID
                               andRegAssignment:regAssign];
        
    } else if ([objType compare:@"IMAGE"] == 0) {
        NSString* imageFilePath = [config getProp:[NSString stringWithFormat:@"%@/contentImage/imageFile", key]];
        NSPoint position;
        position.x = [[config getProp:[NSString stringWithFormat:@"%@/contentImage/posX", key]] floatValue];
        position.y = [[config getProp:[NSString stringWithFormat:@"%@/contentImage/posY", key]] floatValue];
        
        self = [[NEMediaImage alloc] initWithID:objID
                                           file:imageFilePath
                                      displayAt:position
                                  constrainedBy:constraintID
                               andRegAssignment:regAssign];
    }
    
    if (nil != regAssign){
        [regAssign release]; // will be hold in objects themselves
    }
    return self;
}

-(void)presentInContext:(CGContextRef)context andRect:(NSRect)rect
{
#pragma unused(context)
#pragma unused(rect)
    return;
}
-(void)pausePresentation
{
    return;
}
-(void)continuePresentation
{
    return;
}
-(void)stopPresentation
{
    return;
}

-(NSString*)getID
{
    return mID;
}

-(NSString*)getConstraintID
{
    return mConstraintID;
}


-(NERegressorAssignment*)getRegressorAssignment
{
    return mRegAssignment;
}

@end
