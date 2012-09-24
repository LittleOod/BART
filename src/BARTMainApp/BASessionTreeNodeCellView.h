//
//  BASessionTreeNodeCellView.h
//  BARTApplication
//
//  Created by Torsten Schlumm on 7/23/12.
//  Copyright (c) 2012 MPI Human Cognitive and Brain Sciences Leipzig. All rights reserved.
//

#import <Cocoa/Cocoa.h>



@interface BASessionTreeNodeCellView : NSTableCellView {


@private
    IBOutlet NSTextField         *nodeDescriptionTextField;
    IBOutlet NSImageView         *nodeStateImageView;
    IBOutlet NSProgressIndicator *nodeProgressIndicator;

}

@property (assign) NSTextField         *nodeDescriptionTextField;
@property (assign) NSImageView         *nodeStateImageView;
@property (assign) NSProgressIndicator *nodeProgressIndicator;


- (void)startProgressIndicator;
- (void)stopProgressIndicator;



@end
