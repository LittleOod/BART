//
//  COEDLValidator.m
//  CLETUS
//
//  Created by Oliver Zscheyge on 3/8/10.
//  Copyright 2010 MPI Human Cognitive and Brain Sciences Leipzig. All rights reserved.
//

#import "COEDLValidator.h"
#import "COXMLUtility.h"
#import "COEDLValidatorRule.h"
#import "COEDLValidatorLiteral.h"
#import "COErrorCode.h"


@interface COEDLValidator (PrivateStuff)
    
/**
 * Internally fills the array mRules with COEDLValidatorRule
 * objects. Data for these objects is gathered from the 
 * XML tree mRules;
 */
-(void)buildRules;

@end


@implementation COEDLValidator

-(id)initWithContentsOfEDLFile:(NSString*)edlPath
                   andEDLRules:(NSString*)rulePath
{
    if (self = [super init]) {
        mRules    = nil;
        mError    = nil;
        
        mEDLdoc   = nil;
        mEDLdoc   = [COXMLUtility newParsedXMLDocument:edlPath :&mError];
        if (mError) {
            return nil;
        }
        
        mEDLRules = nil;
        mEDLRules = [COXMLUtility newParsedXMLDocument:rulePath :&mError];
        if (mError) {
            return nil;
        }
    }
        
    return self;
}

-(BOOL)isEDLConfigCorrectAccordingToRules
{
    // Construct rules first.
    if (mRules == nil) {
        mRules = [NSMutableArray arrayWithCapacity:0];
        [self buildRules];
    }
    
    // Check whether all rules are satisfied.
    BOOL allRulesSatisfied = YES;
    NSMutableString* errorBuffer = [[NSMutableString alloc] initWithCapacity:1];
    for (COEDLValidatorRule* rule in mRules) {
        NSString* ruleID = [rule mRuleID];
        if (![rule isSatisfied]) {
            allRulesSatisfied = NO;
            if ([rule mError]) {
                if ([[rule mError] code] == INCORRECT_SYNTAX) {
                    [errorBuffer appendFormat:@"\n Rule %@ contains at least one literal with incorrect syntax!", ruleID];
                }
            } else {
                [errorBuffer appendFormat:@"\n Rule %@ violated! Message: %@", ruleID, [rule mMessage]];
            }
        }
    }
    
    if ([errorBuffer length] > 0) {
        NSString* errorHeadline = @"Violations/Errors: ";
        NSString* errorDomain = [errorHeadline stringByAppendingString:errorBuffer];
        mError = [NSError errorWithDomain:errorDomain
                                     code:EDL_LOGICAL_VALIDATION
                                 userInfo:nil];
//        // TODO: remove output
//        FILE* f = fopen("/tmp/validationErrors.txt", "w");
//        fputs([[mError domain] cStringUsingEncoding:NSUTF8StringEncoding], f);
//        fputc('\n', f);
//        fclose(f);
//        // END output
    }
    
    [errorBuffer release];
    
    return allRulesSatisfied;
}

-(void)buildRules
{
    for (NSXMLNode* edlRule in [mEDLRules nodesForXPath:@"/edlRules/rule" error:&mError]) {
        
        if ([edlRule kind] == NSXMLElementKind) {
            // ruleID
            NSString* ruleID = [COXMLUtility valueOfAttribute:@"ruleID" inElement:(NSXMLElement*) edlRule];
            NSMutableDictionary* parameters = [NSMutableDictionary dictionaryWithCapacity:0]; 
            NSMutableArray* premises = [NSMutableArray arrayWithCapacity:0];
            NSMutableArray* conclusions = [NSMutableArray arrayWithCapacity:0];
            NSString* message = @"";
            
            for (NSXMLNode* ruleChild in [edlRule children]) {
                
                if ([ruleChild kind] == NSXMLElementKind) {
                    NSString* ruleChildName = [ruleChild name];
                    
                    // parameters
                    if ([ruleChildName compare:@"param"] == 0) {
                        NSString* paramID  = [[COXMLUtility valueOfAttribute:@"pID" inElement:(NSXMLElement*) ruleChild] 
                                              stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                        NSString* paramRef = [[COXMLUtility valueOfFirstChild:@"paramRef" withKind:NSXMLElementKind ofElement:ruleChild] 
                                              stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                        
                        NSString* paramValue = [COEDLValidator substituteEDLValueForRef:paramRef basedOnNode:[[mEDLdoc rootElement] parent]]; 
                        
                        if (paramValue) {
                            [parameters setValue:paramValue forKey:paramID];
                        }

                    // premises
                    } else if ([ruleChildName compare:@"premise"] == 0) {
                        for (NSXMLNode* literalElem in [ruleChild children]) {
                            if ([literalElem kind] == NSXMLElementKind) {
                                NSString* literalString = [[literalElem stringValue] 
                                                           stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                                COEDLValidatorLiteral* literal = [[COEDLValidatorLiteral alloc] initWithLiteralString:literalString
                                                                                                        andParameters:parameters];
                            
                                [premises addObject:literal];
                                [literal release];
                            }
                        }
                        
                    // conclusions
                    } else if ([ruleChildName compare:@"conclusion"] == 0) {
                        NSString* literalString = [[COXMLUtility valueOfFirstChild:@"literal" withKind:NSXMLElementKind ofElement:ruleChild] 
                                                   stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                        
                        COEDLValidatorLiteral* literal = [[COEDLValidatorLiteral alloc] initWithLiteralString:literalString
                                                                                                andParameters:parameters];
                        
                        [conclusions addObject:literal];
                        [literal release];  
                        
                    // errorMessage
                    } else if ([ruleChildName compare:@"message"] == 0) {
                        message = [[ruleChild stringValue] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                    }
                }
            }
        
            COEDLValidatorRule* newRule = [[COEDLValidatorRule alloc] initWithRuleID:ruleID 
                                                                          Parameters:parameters 
                                                                            Premises:premises 
                                                                         Conclusions:conclusions 
                                                                          AndMessage:message];
            [mRules addObject:newRule];
            [newRule release];
        }
    }
}



+(NSString*)substituteEDLValueForRef:(NSString*)ref
                         basedOnNode:(NSXMLNode*)node
{
    if ([ref hasPrefix:@"ATTRIBUTE."]) {
        // Find and return an attribute value.
        
        NSString* attributeName  = [ref stringByReplacingOccurrencesOfString:@"ATTRIBUTE." 
                                                                  withString:@""];
        
        NSString* attributeValue = nil;
        
        for (NSXMLNode* child in [((NSXMLElement*) node) attributes]) {
            
            // Child is the requested attribute...
            if ([child kind] == NSXMLAttributeKind 
                && [[child name] compare:attributeName] == 0) {
                attributeValue = [[[NSString alloc] initWithString:[child stringValue]] autorelease];
            }
        }
        
        return attributeValue;
        
    } else if ([ref hasPrefix:@"CONTENT"]) {
        // Element value.
        
        return [[[NSString alloc] initWithString:[node stringValue]] autorelease];
        
    } else {
        // Determine whether node represents a final node, still has children or is just not existing.
        
        NSUInteger splitIndex = [ref rangeOfString:@"."].location;
        
        if (splitIndex == NSNotFound) {
            if ([node kind] == NSXMLElementKind) {
                if ([[(NSXMLElement*)node  elementsForName:ref] count] > 0) {
                    // Final node: return empty string stating existence of the node.
                    return @"";
                }
            }
            
            // Referenced node is not existing.
            return nil;
        }
        
        // Otherwise go to child and repeat recursive.
        NSString* newBaseNodeName = [ref substringToIndex:splitIndex];
        int occurenceNr = 1;
        
        // Node has multiple child elements of the same name. Locate the one wanted child.
        if ([newBaseNodeName hasSuffix:@"}"]) {
            NSUInteger curlyOpenIndex = [ref rangeOfString:@"{"].location;
            
            NSRange ofOccurenceNrString;
            ofOccurenceNrString.location = curlyOpenIndex + 1;
            ofOccurenceNrString.length   = [newBaseNodeName length] - 1 - curlyOpenIndex;
            
            occurenceNr = [[newBaseNodeName substringWithRange:ofOccurenceNrString] intValue];
            
            newBaseNodeName = [ref substringToIndex:curlyOpenIndex];
        }
        
        NSXMLNode* newBaseNode = nil;
        
        int currentOccurence = 0;
        for (NSXMLNode* child in [node children]) {
            
            if ([child kind] == NSXMLElementKind 
                || [child kind] == NSXMLAttributeKind) {
                
                if ([[child name] compare:newBaseNodeName] == 0) {
                    
                    currentOccurence++;
                    
                    // Child is the requested element...
                    if (currentOccurence == occurenceNr) {
                        newBaseNode = child;
                    }
                }
            }
        }
        
        if (newBaseNode) {
            return [self substituteEDLValueForRef:[ref substringFromIndex:splitIndex + 1] 
                                      basedOnNode:newBaseNode];
        } else {
            return nil;
        }
    }
}

-(NSError*)getError
{
    return mError;
}

-(void)dealloc {
    
    [mEDLdoc release];
    [mEDLRules release];
    
    [super dealloc];
}

@end
