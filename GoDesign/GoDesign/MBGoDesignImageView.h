//
//  MBGoDesignImageView.h
//  Trial
//
//  Created by Michael on 7/12/15.
//  Copyright (c) 2015 MichaelBai. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface MBGoDesignImageView : NSImageView

@property OperationMode opMode;
@property LineAxis lineAxis;
@property LineMode lineMode;

- (void)undo;
- (void)redo;

@end
