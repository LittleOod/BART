//
//  glmtest.m
//  BARTApplication
//
//  Created by Lydia Hellrung on 9/1/10.
//  Copyright 2010 MPI Cognitive and Human Brain Sciences Leipzig. All rights reserved.
//

#import "glmtest.h"

#import "../../src/CLETUS/COSystemConfig.h"
#import "../../src/ARTIE/GLM/BAAnalyzerGLM.h"
#import "BAAnalyzerGLMReference.h"



@implementation glmtest

@end

int main(void)
{
	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	COSystemConfig *config = [COSystemConfig getInstance];
	NSError *err = [config fillWithContentsOfEDLFile:@"../../tests/BARTMainAppTests/ConfigTestDataset02.edl"];
	if (nil != err)
		NSLog(@"%@", err);
	
	uint nrTimesteps = 39;
	uint tr = 1560;
	uint length = tr*nrTimesteps;
	NSString *strLength = [NSString stringWithFormat:@"%d", length];
	[config setProp:@"$TR" :[NSString stringWithFormat:@"%d", tr] ];
	[config setProp:@"$nrTimesteps" :[NSString stringWithFormat:@"%d", nrTimesteps] ];
	
	NSString* elemToReplaceKey = @"$gwDesign";
	NSXMLElement* elemDesign = [NSXMLElement elementWithName:@"gwDesignStruct"];
	
	
	NSUInteger nrTrialsInRegr1 = 7;
	NSXMLElement* elemRegressor1 = [NSXMLElement elementWithName:@"timeBasedRegressor"];
	NSXMLElement* tbrDesign = [NSXMLElement elementWithName:@"tbrDesign"];
	[tbrDesign addAttribute:[NSXMLNode attributeWithName:@"length"  stringValue:strLength]];
	[tbrDesign addAttribute:[NSXMLNode attributeWithName:@"repetitions"  stringValue:@"1"]];
	
	
	[elemRegressor1 addAttribute:[NSXMLNode attributeWithName:@"regressorID"  stringValue:@"reg1"]];
	[elemRegressor1 addAttribute:[NSXMLNode attributeWithName:@"name"		stringValue:@"visual"]];
	[elemRegressor1 addAttribute:[NSXMLNode attributeWithName:@"length"  stringValue:strLength]];
	[elemRegressor1 addAttribute:[NSXMLNode attributeWithName:@"useRefFct"  stringValue:@"gloverGamma1"]];
	[elemRegressor1 addAttribute:[NSXMLNode attributeWithName:@"scaleHeightToZeroMean"  stringValue:@"false"]];
	[elemRegressor1 addAttribute:[NSXMLNode attributeWithName:@"useRefFctFirstDerivative"  stringValue:@"false"]];
	[elemRegressor1 addAttribute:[NSXMLNode attributeWithName:@"useRefFctSecondDerivative"  stringValue:@"false"]];
	
	
	for (unsigned int k = 0; k < nrTrialsInRegr1; k++)
	{
		NSXMLElement* elemEvent = [NSXMLElement elementWithName:@"statEvent"];
		NSString *stringTrialTime = @"time";
		NSString *stringTrialDuration = @"duration";
		NSString *stringTrialHeight = @"height";
		
		NSString *strTime = [NSString stringWithFormat:@"%d", (k+4)*1000];
		NSXMLNode* attrTrialTime = [NSXMLNode attributeWithName:stringTrialTime stringValue:strTime];
		NSXMLNode* attrTrialDuration = [NSXMLNode attributeWithName:stringTrialDuration stringValue:@"0"];
		NSXMLNode* attrTrialHeight = [NSXMLNode attributeWithName:stringTrialHeight stringValue:@"1"];
		
		[elemEvent addAttribute:attrTrialTime];
		[elemEvent addAttribute:attrTrialDuration];
		[elemEvent addAttribute:attrTrialHeight];
		[tbrDesign addChild:elemEvent];
	}
	[elemRegressor1 addChild:tbrDesign];
	[elemDesign addChild:elemRegressor1];
	
	
	/***reg 2**/
	NSUInteger nrTrialsInRegr2 = 17;
	NSXMLElement* elemRegressor2 = [NSXMLElement elementWithName:@"timeBasedRegressor"];
	
	NSXMLElement* tbrDesign2 = [NSXMLElement elementWithName:@"tbrDesign"];
	[tbrDesign2 addAttribute:[NSXMLNode attributeWithName:@"length"  stringValue:strLength]];
	[tbrDesign2 addAttribute:[NSXMLNode attributeWithName:@"repetitions"  stringValue:@"1"]];
	
	
	[elemRegressor2 addAttribute:[NSXMLNode attributeWithName:@"regressorID"  stringValue:@"reg2"]];
	[elemRegressor2 addAttribute:[NSXMLNode attributeWithName:@"name"		stringValue:@"aud"]];
	[elemRegressor2 addAttribute:[NSXMLNode attributeWithName:@"length"  stringValue:strLength]];
	[elemRegressor2 addAttribute:[NSXMLNode attributeWithName:@"useRefFct"  stringValue:@"gloverGamma1"]];
	[elemRegressor2 addAttribute:[NSXMLNode attributeWithName:@"scaleHeightToZeroMean"  stringValue:@"false"]];
	[elemRegressor2 addAttribute:[NSXMLNode attributeWithName:@"useRefFctFirstDerivative"  stringValue:@"false"]];
	[elemRegressor2 addAttribute:[NSXMLNode attributeWithName:@"useRefFctSecondDerivative"  stringValue:@"false"]];
	
	
	for (unsigned int k = 0; k < nrTrialsInRegr2; k++)
	{
		NSXMLElement* elemEvent = [NSXMLElement elementWithName:@"statEvent"];
		NSString *stringTrialTime = @"time";
		NSString *stringTrialDuration = @"duration";
		NSString *stringTrialHeight = @"height";
		
		NSString *strTime = [NSString stringWithFormat:@"%d", (k)*3000];
		NSXMLNode* attrTrialTime = [NSXMLNode attributeWithName:stringTrialTime stringValue:strTime];
		NSXMLNode* attrTrialDuration = [NSXMLNode attributeWithName:stringTrialDuration stringValue:@"0"];
		NSXMLNode* attrTrialHeight = [NSXMLNode attributeWithName:stringTrialHeight stringValue:@"1"];
		
		[elemEvent addAttribute:attrTrialTime];
		[elemEvent addAttribute:attrTrialDuration];
		[elemEvent addAttribute:attrTrialHeight];
		[tbrDesign2 addChild:elemEvent];
	}
	[elemRegressor2 addChild:tbrDesign2];
	[elemDesign addChild:elemRegressor2];
	[config replaceProp:elemToReplaceKey withNode: elemDesign];	
	
	[config writeToFile:@"/tmp/myDesign.edl"];
	[config fillWithContentsOfEDLFile:@"/tmp/myDesign.edl"];
	//TODO has to be added to edl
	// swa sws minval, fwhm
	uint fwhm = 4;
	uint minval = 2000;
	BOOL swa = NO;
	uint sws = 40;
	
	
	
	
	//BADataElement *inputData = [[BADataElement alloc] initWithDatasetFile:@"../tests/BARTMainAppTests/testfiles/TestDataset02-functional.nii" ofImageDataType:IMAGE_DATA_FLOAT];
	
	//randomized input data
	uint rows = 32;
	uint cols = 17;
	uint slices = 10;
	uint tsteps = 21;
	BADataElement *inputData = [[BADataElement alloc] initWithDataType:IMAGE_DATA_FLOAT 
															   andRows:rows andCols:cols 
															 andSlices:slices andTimesteps:tsteps];
	
	for (uint t = 0; t < tsteps; t++){
		for (uint s = 0; s < slices; s++){
			for (uint c = 0; c < cols; c++){
				for (uint r = 0; r < rows; r++){
					float val = rand()%32000;
					[inputData setVoxelValue:[NSNumber numberWithFloat:val] atRow:r col:c slice:s timestep:t];
				}
			}
		}
	}
	
	BADesignElement *inputDesign = [[BADesignElement alloc] initWithDynamicDataOfImageDataType:IMAGE_DATA_FLOAT];
	
	
	BAAnalyzerGLMReference *glmReference = [[BAAnalyzerGLMReference alloc] initWithFwhm:fwhm 
																			  andMinval:minval 
																	 forSlidingAnalysis:swa 
																			   withSize:sws];
	
	BAAnalyzerGLM *glmAlg = [[BAAnalyzerGLM alloc] init];
	
	
	
	
	
	
	BADataElement* outputAlg = [glmAlg anaylzeTheData:inputData withDesign:inputDesign andCurrentTimestep:nrTimesteps];
	BADataElement* outputRef = [glmReference anaylzeTheData:inputData withDesign:inputDesign andCurrentTimestep:nrTimesteps];
	
	for (uint t = 0; t < [outputAlg numberTimesteps]; t++){
		for (uint s = 0; s < [outputAlg numberSlices]; s++){
			
			float* sliceAlg = [outputAlg getSliceData:s atTimestep:t];
			float* sliceRef = [outputRef getSliceData:s atTimestep:t];
			float *pRef = sliceRef;
			float *pAlg = sliceAlg;
			float compAccuracy = 0.00001;
			
			for (uint c = 0; c < [outputAlg numberCols]; c++){
				for (uint r = 0; r < [outputAlg numberRows]; r++){
					NSLog(@"%.2f   %.2f\n",*pRef++, *pAlg++);
				}
			}
			free(sliceAlg);
			free(sliceRef);
			
			
		}}
	
	
	
	[pool drain];

	
	
}