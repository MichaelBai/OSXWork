//
//  MBGoDesignLine.h
//  GoDesign
//
//  Created by Michael on 7/12/15.
//  Copyright (c) 2015 MichaelBai. All rights reserved.
//

#import <Cocoa/Cocoa.h>

typedef enum : NSUInteger {
    LineHorizontal,
    LineVertical
} LineAxis;

typedef enum : NSUInteger {
    LineLeft,
    LineRight,
    LineUp,
    LineDown
} LineDirection;

@interface MBGoDesignLine : NSObject

@property NSBezierPath* path;
@property NSColor *color;
@property CGFloat thickness;

@property NSRect viewFrame;

- (instancetype)initWithFrame:(NSRect)frame;

- (void)draw;

@end
