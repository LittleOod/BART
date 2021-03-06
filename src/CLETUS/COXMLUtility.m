//
//  COXMLUtility.m
//  CLETUS
//
//  Created by Oliver Zscheyge on 3/8/10.
//  Copyright 2010 MPI Human Cognitive and Brain Sciences Leipzig. All rights reserved.
//

#import "COXMLUtility.h"
#import "COErrorCode.h"


@implementation COXMLUtility

+(NSXMLDocument*)newParsedXMLDocument:(NSString*)filePath
                                     :(NSError**)error
{	
    NSURL* fileURL = [NSURL fileURLWithPath:filePath];
    if (!fileURL) {
        NSString* errorString = [NSString stringWithFormat:@"Could not create URL from given path %s!", filePath];
        if (nil != error){
            *error = [NSError errorWithDomain:errorString code:URL_CREATION userInfo:nil];
        }
        return nil;
    }

	NSXMLDocument* doc = nil;
    doc = [[NSXMLDocument alloc] initWithContentsOfURL:fileURL
                                               options:(NSXMLNodePreserveWhitespace|NSXMLNodePreserveCDATA)
                                                 error:error];
	
	return doc;
}

+(NSString*)valueOfFirstChild:(NSString*)childName 
                     withKind:(NSXMLNodeKind)childKind 
                    ofElement:(NSXMLNode*)node
{
    for (NSXMLNode* child in [node children]) {
        if ([child kind] == childKind) {
            if ([[child name] compare:childName] == 0) {
                return [child stringValue];
            }
        }
    }
    
    return nil;
}

+(NSString*)valueOfAttribute:(NSString*)name 
                   inElement:(NSXMLElement*)elem
{
    for (NSXMLNode* child in [elem attributes]) {
        if ([[child name] compare:name] == 0) {
            return [child stringValue];
        }
    }
    
    return nil;
}

@end
