//
//  NEPresentationExternalConditionController.m
//  BARTApplication
//
//  Created by Lydia Hellrung on 8/7/11.
//  Copyright 2011 MPI Human Cognitive and Brain Sciences Leipzig. All rights reserved.
//

#import "NEPresentationExternalConditionController.h"
#import "CLETUS/COExperimentContext.h"
#import "BARTSerialIOFramework/SerialPort.h"
#import "NEConstraint.h"

@interface NEPresentationExternalConditionController (PrivateMethods)

-(NSError*)buildConstraintDictionary;

@end


@implementation NEPresentationExternalConditionController

COExperimentContext *expContext;
NSArray *constraintsArray;
NSDictionary *dictExternalConditions;
NSUInteger screenResolutionX;
NSUInteger screenResolutionY;


-(id)initWithConstraints:(NSArray*)newConstraintsArray
{
    if ((self = [super init])){
        expContext = [COExperimentContext getInstance];
        if (nil == constraintsArray){
            constraintsArray = [newConstraintsArray retain];
        }
        else{
            [constraintsArray release];
            constraintsArray = [newConstraintsArray retain];
        }
        if ( (nil != [self buildConstraintDictionary])){
            NSLog(@"Can't init %@", self);
            return nil;
        }
        // temp formatter to convert from string to number
        NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        
        screenResolutionX = [[f numberFromString:[[expContext systemConfig] getProp:@"$screenResolutionX"]] unsignedIntegerValue];
        screenResolutionY = [[f numberFromString:[[expContext systemConfig] getProp:@"$screenResolutionY"]] unsignedIntegerValue];
        [f release];
        
    }
    return self;
}


-(NSError*)buildConstraintDictionary
{
    NSError *err = nil;
    NSDictionary *dictSerialIOPlugins = [expContext dictSerialIOPlugins];
    NSMutableDictionary *mutableDictExternalCond = [[NSMutableDictionary alloc] initWithCapacity:[constraintsArray count]];
    
     
    //TODO: 
    //mehrere Sourcen verwalten!! MOMENTAN WIRD UEBERSCHRIEBEN
    for (NEConstraint* constraint in constraintsArray)
    {
        NSString *constraintID = [constraint constraintID];
        
        // get all sources for external variables and make unique names
        NSSet *uniqueVariableSources = [NSSet setWithArray:[[constraint variables] allKeys] ];
        NSLog(@"Number of Sources: %lu", [uniqueVariableSources count]);
        
        for (NSString *externalDevice in [[constraint variables] allKeys]) {
            if (nil != [dictSerialIOPlugins objectForKey:externalDevice])
            {
                [mutableDictExternalCond 
                 setObject:[NSDictionary dictionaryWithObjectsAndKeys:
                            [dictSerialIOPlugins objectForKey:externalDevice], @"plugin", 
                            [[constraint variables] objectForKey:externalDevice], @"paramsArray",
                            [constraint conditions], @"conditionsArray",
                            [constraint actionsThen], @"actionsThenArray",
                            [constraint actionsElse], @"actionsElseArray",
                            nil ] 
                 forKey:constraintID ];
            }
        }
    }
    
    dictExternalConditions = [[NSDictionary alloc] initWithDictionary:mutableDictExternalCond];
    [mutableDictExternalCond release];
    
    return err;
}

-(NSDictionary*)checkConstraintForID:(NSString*)constraintID;
{

    //call the external device and ask all your questions
    //TODO: mehrere Sourcen behandeln und diese im Block alle aufrufen
    SerialPort* s = [[dictExternalConditions objectForKey:constraintID] objectForKey:@"plugin"];
  
    if (nil != s){
        
        NSDictionary *dictForPlugin = [NSDictionary dictionaryWithObjectsAndKeys:[[dictExternalConditions objectForKey:constraintID] objectForKey:@"paramsArray"], @"paramsArray", [NSNumber numberWithUnsignedInteger:screenResolutionX], @"screenResolutionX", [NSNumber numberWithUnsignedInteger:screenResolutionY], @"screenResolutionY",  nil];
        
        NSDictionary *dictFromPlugin = [[s evaluateConstraintForParams:dictForPlugin] retain];
        //NSLog(@"DICT FROM PLUGIN %@", dictFromPlugin);
        
        //result 
        NSDictionary *dictReturn;
        NSMutableArray  *arrayConditions = [[NSMutableArray alloc] initWithCapacity:1];
        NSArray *constraintConditions = [[dictExternalConditions objectForKey:constraintID] objectForKey:@"conditionsArray"]; 
        //NSLog(@"CONDITIONSARRAY: %@", constraintConditions);
        
        
        
        NSArray *actionsThen = [[dictExternalConditions objectForKey:constraintID] objectForKey:@"actionsThenArray"];
        NSArray *actionsElse = [[dictExternalConditions objectForKey:constraintID] objectForKey:@"actionsElseArray"];
        NSMutableDictionary *dictSysVariablesResults = [[NSMutableDictionary alloc] initWithCapacity:1];
        
        //collect conditions
        for (NSString *para in [dictFromPlugin allKeys]){
            //NSLog(@"PARA: %@", para);
            //NSLog(@"ALL KEYS: %@", [dictFromPlugin allKeys]);
            if (NSNotFound != [constraintConditions indexOfObject:para])
            {
                [arrayConditions addObject:[dictFromPlugin objectForKey:para]];
            }
            else
            {//collect values for actions
                [dictSysVariablesResults setValue:[dictFromPlugin objectForKey:para] forKey:para];
//                for (NSDictionary *action in actionsThen)
//                {
//                    for (NSDictionary *att in [action objectForKey:@"attributesArray"])
//                    {
//                        if ( NSOrderedSame == [[att objectForKey:@"attributeName"] compare:para options:NSCaseInsensitiveSearch])
//                        {
//                            [att setValue:[dictFromPlugin objectForKey:para] forKey:@"attributeValue"];
//                        }
//                        
//                    }
//                }
                
            }
        }
        
        
        
        
        
        dictReturn = [[NSDictionary alloc] initWithObjectsAndKeys:
                      arrayConditions, @"conditionsArray", 
                      dictSysVariablesResults, @"resultVariables",
                      actionsThen, @"actionsThen",
                      actionsElse, @"actionsElse",
                      nil];
        
        // TODO sort conditions and params from different sources to feed in a return dictionary
       // return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:p.x], @"eyePosX",[NSNumber numberWithFloat:p.y], @"eyePosY", nil];
        
        [dictFromPlugin release];
        //[arrayConditions removeAllObjects];
        [arrayConditions release];
        //[dictSysVariablesResults removeAllObjects];
        [dictSysVariablesResults release];
        
        return [dictReturn autorelease];
        
    }

    return nil;
    
    
}



-(void)dealloc
{
    [constraintsArray release];
    [dictExternalConditions release];
    [super dealloc];
}


@end