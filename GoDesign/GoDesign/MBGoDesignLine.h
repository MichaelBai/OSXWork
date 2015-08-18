//
//  MBGoDesignLine.h
//  GoDesign
//
//  Created by Michael on 7/12/15.
//  Copyright (c) 2015 MichaelBai. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface MBGoDesignLine : NSObject

@property NSBezierPath* path;
@property NSColor *color;
@property CGFloat thickness;

@property NSRect viewFrame;

@property LineAxis lineAxis;

- (instancetype)initWithFrame:(NSRect)frame lineAxis:(LineAxis)lineAxis;

- (void)draw;

@end
