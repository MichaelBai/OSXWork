//
//  MBGoDesignLineView.h
//  GoDesign
//
//  Created by Michael on 7/18/15.
//  Copyright (c) 2015 MichaelBai. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MBGoDesignLine.h"

@interface MBGoDesignLineView : NSView

@property LineAxis lineAxis;

- (instancetype)initWithFrame:(NSRect)frame lineAxis:(LineAxis)lineAxis;

@end
