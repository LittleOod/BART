//
//  COExperimentContext.m
//  BARTApplication
//
//  Created by Lydia Hellrung on 8/7/11.
//  Copyright 2011 MPI Human Cognitive and Brain Sciences Leipzig. All rights reserved.
//

// This class holds all the information about an experiment - the static configuration stuff as well as runtime information about currently loaded plugins and stuff like that.
// It's a Singleton so everybody in the application can use it.
// TODO: Add the COSystemConfig here and let's everybody ask this one about it - a lot of small changes to do :-)!

#import "COExperimentContext.h"
#import "COSystemConfig.h"
#import "BARTSerialIOFramework/BARTSerialPortIONotifications.h"
#import "BARTSerialIOFramework/SerialPort.h"
#import "NED/NEDesignElement.h"
#import "EDNA/EDDataElement.h"
#import "BARTNotifications.h"

NSString * const BARTDidResetExperimentContextNotification = @"de.mpg.cbs.BARTDidResetExperimentContextNotification";
NSString * const BARTTriggerArrivedNotification = @"de.mpg.cbs.BARTTriggerArrivedNotification";
//NSString * const BARTNextDataIncomeNotification = @"de.mpg.cbs.BARTNextDataIncomeNotification";


@interface COExperimentContext (PrivateMethods)

-(SerialPort*)setupSerialPortEyeTrac;
-(SerialPort*)setupSerialPortTriggerAndButtonBox;
-(BOOL) pluginClassIsValid:(Class)pluginClass;
-(NSArray*) loadPluginWithID:(NSString*)bundleIDStr;

-(void)triggerArrived:(NSNotification*)aNotification;
-(void)buttonWasPressed:(NSNotification*)aNotification;
-(NSError*)fillSystemConfigWithContentsOfEDLFile:(NSString*)edlPath;
-(NSError*)reset;
-(NSError*)configureExternalDevices;


@end

@implementation COExperimentContext

static COExperimentContext *sharedExperimentContext = nil;

@synthesize systemConfig;
@synthesize dictSerialIOPlugins;
@synthesize designElemRef;
@synthesize anatomyElemRef;
@synthesize functionalOrigDataRef;
@synthesize mLogFilePath;

//COSystemConfig *config;
BOOL useSerialPortEyeTrac;
BOOL useSerialPortTriggerAndButtonBox;
//NSError *err;
NSThread *eyeTracThread;
NSThread *triggerThread;
//SerialPort *serialPortEyeTrac;
//SerialPort *serialPortTriggerAndButtonBox;


dispatch_queue_t serialDesignElementAccessQueue;

+ (COExperimentContext*)getInstance {
	static dispatch_once_t predicate;
	static COExperimentContext *instance = nil;
	dispatch_once(&predicate, ^{instance = [[self alloc] init];});
	return instance;
}

//+ (COExperimentContext*)getInstance
//{
//    @synchronized(self) {
//        if (sharedExperimentContext == nil) {
//            sharedExperimentContext = [[self alloc] init]; 
//        }
//    }
//    NSLog(@"CONTEXT DESCR: %@", [[NSThread currentThread] description]);
//    NSLog(@"CONTEXT ADDR: %@", sharedExperimentContext);
//    return sharedExperimentContext;
//}

+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized(self) {
        if (sharedExperimentContext == nil) {
            sharedExperimentContext = [super allocWithZone:zone];
            return sharedExperimentContext;  // assignment and return on first allocation
        }
    }
    return nil; //on subsequent allocation attempts return nil
}

-(id)init
{
    if ((self = [super init])){
        systemConfig = [[COSystemConfig alloc] init];
        serialDesignElementAccessQueue = dispatch_queue_create("de.mpg.cbs.DesignElementAccesQueue", NULL);
        eyeTracThread = nil;
        triggerThread = nil;
    }
    
    return self;
}

-(void)dealloc
{
    if ((nil != eyeTracThread) && [eyeTracThread isExecuting] ){
        [eyeTracThread cancel];
        [eyeTracThread release];
        eyeTracThread = nil;
    }
    if ( (nil != triggerThread) && [triggerThread isExecuting]){
        [triggerThread cancel];
        [triggerThread release];
        triggerThread = nil;
    }
    if (nil != dictSerialIOPlugins){
        [dictSerialIOPlugins release];
        dictSerialIOPlugins = nil;
    }
    if (nil != designElemRef) {
        [designElemRef release];
        designElemRef = nil;
    }
    if (nil != anatomyElemRef){
        [anatomyElemRef release];
        anatomyElemRef = nil;
    }
    if (nil != functionalOrigDataRef){
        [functionalOrigDataRef release];
        functionalOrigDataRef = nil;
    }
    [super dealloc];
}

-(NSError*)reset 
{
    if ([eyeTracThread isExecuting] ){
        [eyeTracThread cancel];
        [eyeTracThread release];
        eyeTracThread = nil;
    }
    if ([triggerThread isExecuting]){
        [triggerThread cancel];
        [triggerThread release];
        triggerThread = nil;
    }
    if (nil != dictSerialIOPlugins){
        [dictSerialIOPlugins release];
        dictSerialIOPlugins = nil;
    }
    if (nil != designElemRef) {
        [designElemRef release];
        designElemRef = nil;
    }
    if (nil != anatomyElemRef){
        [anatomyElemRef release];
        anatomyElemRef = nil;
    }
    if (nil != functionalOrigDataRef){
        [functionalOrigDataRef release];
        functionalOrigDataRef = nil;
    }
    return nil;
}

-(NSError*)resetWithEDLFile:(NSString*)edlPath
{
    NSError *err = nil;
    
    if ( (err = [self reset]) != nil )
        return err;
    
    if ( (err = [self fillSystemConfigWithContentsOfEDLFile:edlPath]) != nil )
        return err;
    
    mLogFilePath = [systemConfig getProp:@"$logFolder"];
    
    err = [self configureExternalDevices];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:BARTDidResetExperimentContextNotification object:nil];
    
    return err;
    
}

-(NSError*)fillSystemConfigWithContentsOfEDLFile:(NSString*)edlPath
{
    return [systemConfig fillWithContentsOfEDLFile:edlPath];
}


-(NSError*)configureExternalDevices
{
    NSError *err = nil;
    NSMutableDictionary *mutableDictPlugins = [[NSMutableDictionary alloc] initWithCapacity:0];
    
    // setup the serial port for the eye tracker device
    //TODO get from config
    useSerialPortTriggerAndButtonBox = NO;
    if (YES == useSerialPortTriggerAndButtonBox){
        SerialPort *serialPortTriggerAndButtonBox = [[self setupSerialPortTriggerAndButtonBox] retain];
        if (nil != serialPortTriggerAndButtonBox){
            [mutableDictPlugins setObject:serialPortTriggerAndButtonBox forKey:[serialPortTriggerAndButtonBox deviceDescription]];
        }
        [serialPortTriggerAndButtonBox release];
    }
    // setup the serial port for the eye tracker device
    //TODO get from config:
    useSerialPortEyeTrac = NO;
    if (YES == useSerialPortEyeTrac){
        SerialPort* serialPortEyeTrac = [[self setupSerialPortEyeTrac] retain] ;
        if (nil != serialPortEyeTrac){
            [mutableDictPlugins setObject:serialPortEyeTrac forKey:[serialPortEyeTrac deviceDescription]];
        }
        [serialPortEyeTrac release];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(triggerArrived:)
                                                 name:BARTSerialIOScannerTriggerArrived object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(buttonWasPressed:)
                                                 name:BARTSerialIOButtonBoxPressedKey object:nil];
    
    dictSerialIOPlugins = [[NSDictionary alloc] initWithDictionary:mutableDictPlugins];
    [mutableDictPlugins removeAllObjects];
    [mutableDictPlugins release];
    return err;
    
}

-(BOOL)addOberserver:(id)object forProtocol:(NSString*)protocolName
{
    
    [object retain];
    
    
    if ( YES == [object conformsToProtocol:@protocol(BARTScannerTriggerProtocol)]  
        && (NSOrderedSame == [protocolName compare :@"BARTScannerTriggerProtocol"]) ) 
    {
        
        [[NSNotificationCenter defaultCenter]   addObserver:object  selector:@selector(triggerArrived:) name:BARTSerialIOScannerTriggerArrived object:nil];
        
        [[NSNotificationCenter defaultCenter]   addObserver:object  selector:@selector(triggerArrived:) name:BARTTriggerArrivedNotification object:nil];
        
        [[NSNotificationCenter defaultCenter]   addObserver:object  selector:@selector(terminusFromScannerArrived:) name:BARTScannerSentTerminusNotification object:nil];
        
        return YES;
        
    }
    
    
    if ( YES == [object conformsToProtocol:@protocol(BARTDataIncomeProtocol)]  
        && (NSOrderedSame == [protocolName compare:@"BARTDataIncomeProtocol"]) )
    {
        
        [[NSNotificationCenter defaultCenter]   addObserver:object  selector:@selector(dataArrived:) name:BARTDidLoadNextDataNotification object:nil];
        
        return YES;
        
    }

    if ( YES == [object conformsToProtocol:@protocol(BARTButtonPressProtocol)]  
        && (NSOrderedSame == [protocolName compare:@"BARTButtonPressProtocol"]) )
    {
        
        [[NSNotificationCenter defaultCenter]   addObserver:object  selector:@selector(buttonWasPressed:) name:BARTSerialIOButtonBoxPressedKey object:nil];
        
        return YES;
        
    }
    
    
    [object release];
    return NO;
    
    
}



- (id)copyWithZone:(NSZone *)zone
{
#pragma unused(zone)
    return self;
}

- (id)retain
{
    return self;
}

- (NSUInteger)retainCount
{
    return UINT_MAX;  //denotes an object that cannot be released
}

- (oneway void)release
{
    //do nothing
}

- (id)autorelease
{
    return self;
}

- (NSError*)startExperiment
{
    if (nil != eyeTracThread){
        [eyeTracThread start];}
    if (nil != triggerThread){
        [triggerThread start];}
    return nil;
}

-(NSError*)stopExperiment
{
    // cancel all threads that had been started
    if ((nil != eyeTracThread) && [eyeTracThread isExecuting] ){
        [eyeTracThread cancel];}
    if ((nil != triggerThread) && [triggerThread isExecuting]){
        [triggerThread cancel];}
    
    // close all serial ports correctly to be able to ope them again when necessary
    if ((nil != dictSerialIOPlugins) )
    {
        for (SerialPort *s in [dictSerialIOPlugins allValues])
        {
            NSLog(@"closing serial port: %@", [s devicePath]);
            [s closeSerialPort:nil];
        }
        
    }
    
    
    return nil;
}

-(SerialPort*)setupSerialPortEyeTrac
{
    SerialPort *serialPortEyeTrac = nil;
	
	//TODO: get from config
	NSString* const bundleIDStr = @"de.mpg.cbs.BARTSerialIO.BARTSerialIOPluginEyeTrac";
	NSArray *bundleArray = [[self loadPluginWithID:bundleIDStr] retain];
	
	//NSEnumerator *instanceEnum = [bundleArray objectEnumerator];
	NSUInteger i = 0;
	//while ([instanceEnum nextObject]) {
    
    id interpretSerialIO = [bundleArray objectAtIndex:i];
    NSLog(@"%@", interpretSerialIO);
    if (YES == [self pluginClassIsValid:interpretSerialIO])
    {
        NSDictionary* port  = [interpretSerialIO portParameters];
        if (nil == port){
            if (nil != serialPortEyeTrac){
                [serialPortEyeTrac release];}
            [bundleArray release];
            NSLog(@"No dict with port parameters got from external Plugin");
            return nil;}
        
        NSString *devPath   = [port objectForKey:@"pathToDevice"];
        NSString *descr     = [port objectForKey:@"deviceDescription"];
        int baudRate        = [[port objectForKey:@"baudRate"] integerValue];
        int bits            = [[port objectForKey:@"useBits"] integerValue];
        BOOL enableParity   = [[port objectForKey:@"enableParity"] boolValue];
        BOOL oddParity      = [[port objectForKey:@"useOddParity"] boolValue];//
        BOOL isSerial       = [[port objectForKey:@"isSerialPort"] boolValue];
        
        if (NO == isSerial){
            if (nil != serialPortEyeTrac){
                [serialPortEyeTrac release];}
            [bundleArray release];
            NSLog(@"No serial port wanted");
            return nil;}
        
        serialPortEyeTrac = [[SerialPort alloc] initSerialPortWithDevicePath:devPath
                                                              deviceDescript:descr
                                                                  symbolrate:baudRate 
                                                                enableParity:enableParity 
                                                                   oddParity:oddParity 
                                                                     andBits:bits];
        //set logfile stuff to plugin
        [interpretSerialIO setLogfilePath:mLogFilePath];
        //TODO
        [interpretSerialIO setLogfileNameAppend:[systemConfig getEDLFilePath]];
        
        [serialPortEyeTrac addObserver: interpretSerialIO];
    }
    //i++;
	//}
	
	NSError *err = [[NSError alloc] init];
    if (nil != eyeTracThread){
        [eyeTracThread release];}
    eyeTracThread = [[NSThread alloc] initWithTarget:serialPortEyeTrac selector:@selector(startSerialPortThread:) object:err]; 
    
    
    [err release];
    [bundleArray release];
    return [serialPortEyeTrac autorelease];
}

-(SerialPort*)setupSerialPortTriggerAndButtonBox
{
	SerialPort *serialPortTriggerAndButtonBox = nil;
	
	//TODO: get from config
	NSString* const bundleIDStr = @"de.mpg.cbs.BARTSerialIO.BARTSerialIOPluginFTDITriggerButton";
	NSArray *bundleArray = [[self loadPluginWithID:bundleIDStr] retain];
	NSLog(@"bundleArray size: %lu", [bundleArray count]);
	
	//NSEnumerator *instanceEnum = [bundleArray objectEnumerator];
	NSUInteger i = 0;
	//while ([instanceEnum nextObject]) {
    
    id interpretSerialIO = [bundleArray objectAtIndex:i];
    NSLog(@"%@", interpretSerialIO);
    if (YES == [self pluginClassIsValid:interpretSerialIO])
    {
        NSDictionary* port  = [interpretSerialIO portParameters];
        if (nil == port){
            if (nil != serialPortTriggerAndButtonBox){
                [serialPortTriggerAndButtonBox release];}
            [bundleArray release];
            NSLog(@"No dict with port parameters got from external Plugin");
            return nil;}
        
        NSString *devPath   = [port objectForKey:@"pathToDevice"];
        NSString *descr     = [port objectForKey:@"deviceDescription"];
        int baudRate        = [[port objectForKey:@"baudRate"] integerValue];
        int bits            = [[port objectForKey:@"useBits"] integerValue];
        BOOL enableParity   = [[port objectForKey:@"enableParity"] boolValue];
        BOOL oddParity      = [[port objectForKey:@"useOddParity"] boolValue];//
        BOOL isSerial       = [[port objectForKey:@"isSerialPort"] boolValue];
        
        if (NO == isSerial){
            if (nil != serialPortTriggerAndButtonBox){
                [serialPortTriggerAndButtonBox release];}
            [bundleArray release];
            NSLog(@"No serial port wanted");
            return nil;}
        
        serialPortTriggerAndButtonBox = [[SerialPort alloc] initSerialPortWithDevicePath:devPath
                                                                          deviceDescript:descr
                                                                              symbolrate:baudRate 
                                                                            enableParity:enableParity 
                                                                               oddParity:oddParity 
                                                                                 andBits:bits];
        //set logfile stuff to plugin
        [interpretSerialIO setLogfilePath:mLogFilePath];
        
        [serialPortTriggerAndButtonBox addObserver: interpretSerialIO];
    }
    //i++;
	//}
	
	NSError *err = [[NSError alloc] init];
    if (nil != triggerThread){
        [triggerThread release];
    }
	triggerThread = [[NSThread alloc] initWithTarget:serialPortTriggerAndButtonBox selector:@selector(startSerialPortThread:) object:err];    
    
    
    [err release];
    [bundleArray release];
    return [serialPortTriggerAndButtonBox autorelease];
}


// -------------------------------------------------------------------------------
//	loadPlugins:
// -------------------------------------------------------------------------------
-(NSArray*) loadPluginWithID:(NSString*)bundleIDString
//NSArray* loadPluginsSerialIO()
{
	NSMutableArray* bundleInstanceList = [[NSMutableArray alloc] init];
	
	NSMutableArray* bundlePaths = [NSMutableArray array];
	
	// our built bundles are found inside the app's "PlugIns" folder -
	NSMutableArray*	bundleSearchPaths = [NSMutableArray array];
	NSString* folderPath = [[NSBundle mainBundle] builtInPlugInsPath];
	[bundleSearchPaths addObject: folderPath];
	
	// to search other locations for bundles
	// (i.e. $(HOME)/Library/Application Support/BundleLoader
	
	NSString* currPath;
	NSArray* librarySearchPaths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
    NSEnumerator* searchPathEnum = [librarySearchPaths objectEnumerator];
    while ((currPath = [searchPathEnum nextObject]))
    {
		[bundleSearchPaths addObject: currPath];
    }
	
	
    searchPathEnum = [bundleSearchPaths objectEnumerator];
	while ((currPath = [searchPathEnum nextObject]))
    {
        NSDirectoryEnumerator *bundleEnum;
        NSString *currBundlePath;
        bundleEnum = [[NSFileManager defaultManager] enumeratorAtPath:currPath];
        if (bundleEnum)
        {
            while ((currBundlePath = [bundleEnum nextObject]))
            {
                if ([[currBundlePath pathExtension] isEqualToString:@"bundle"])
                {
					// we found a bundle, add it to the list
					[bundlePaths addObject:[currPath stringByAppendingPathComponent:currBundlePath]];
                }
            }
        }
    }
	
	// now that we have all bundle paths, start finding the ones we really want to load -
	//NSRange searchRange = NSMakeRange(0, [kPrefixBundleIDStr length]);
	NSRange searchRange = NSMakeRange(0, [bundleIDString length]);
	
	NSEnumerator* pathEnum = [bundlePaths objectEnumerator];
    while ((currPath = [pathEnum nextObject]))
    {
        NSBundle* currBundle = [NSBundle bundleWithPath:currPath];
        if (currBundle)
        {
			NSString* tbundleID = [currBundle objectForInfoDictionaryKey:@"CFBundleIdentifier"];
			
			// check the bundle ID to see if it starts with our known ID string (bundleIDString)
			// we want to only load the bundles we care about:
			//
			//if ([bundleIDStr compare:kPrefixBundleIDStr options:NSLiteralSearch range:searchRange] == NSOrderedSame)
			if ([tbundleID compare:bundleIDString options:NSLiteralSearch range:searchRange] == NSOrderedSame)
                
			{
				//TODO: VALIDATE THE PROTOCOL HERE
				// load and startup our bundle
				//
				// note: principleClass method actually loads the bundle for us,
				// or we can call [currBundle load] directly.
				//
				
				Class currPrincipalClass = [currBundle principalClass];
				if (currPrincipalClass)
				{
					id currInstance = [[currPrincipalClass alloc] init];
					if (currInstance)
					{
						[bundleInstanceList addObject:[currInstance autorelease]];
					}
				}
			}
        }
    }
	
	NSArray *finalBundleArray = [[NSArray alloc] initWithArray: bundleInstanceList] ;
	[bundleInstanceList release];
	
	return [finalBundleArray autorelease];
	
}

//BOOL pluginClassIsValid(Class pluginClass)
-(BOOL) pluginClassIsValid:(Class)pluginClass
{
	
	if ([pluginClass conformsToProtocol:@protocol(BARTSerialIOProtocol)])
	{//
		//		if ([pluginClass instancesRespondToSelector:@selector(valueArrived:)] &&
		//			[pluginClass instancesRespondToSelector:@selector(pluginTitle)] &&
		//			[pluginClass instancesRespondToSelector:@selector(pluginDescription)] &&
		//			[pluginClass instancesRespondToSelector:@selector(pluginIcon)] )
		{
			NSLog(@"Descr: %@", [pluginClass pluginDescription]);
			return YES;
		}
	}
	
	//if ([pluginClass conformsToProtocol:@protocol(...)])
	//	{
	//		if ([pluginClass instancesRespondToSelector:@selector(...)] &&
	//			[pluginClass instancesRespondToSelector:@selector(...)] &&
	//			[pluginClass instancesRespondToSelector:@selector(...)] &&
	//			[pluginClass instancesRespondToSelector:@selector(...)] )
	//		{
	//			return YES;
	//		}
	//	}
	
	return NO;
	
	
	
	
}

-(void)triggerArrived:(NSNotification*)aNotification
{
	NSLog(@"The arrived trigger is: %@", [aNotification object]);
}

-(void)buttonWasPressed:(NSNotification*)aNotification
{
	NSLog(@"The button pressed was: %@", [aNotification object]);
}

-(void)setDesign:(NEDesignElement*)newDesign
{
    dispatch_sync(serialDesignElementAccessQueue, ^{
        designElemRef = newDesign;
    });
    
}

-(NEDesignElement*)getDesign
{
    __block NEDesignElement *resDesign;
    dispatch_sync(serialDesignElementAccessQueue, ^{
        resDesign = [designElemRef copy];
    });
    
    return resDesign;
    
}



@end
