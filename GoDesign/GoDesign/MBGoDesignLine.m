//
//  MBGoDesignLine.m
//  GoDesign
//
//  Created by Michael on 7/12/15.
//  Copyright (c) 2015 MichaelBai. All rights reserved.
//

#import "MBGoDesignLine.h"

@implementation MBGoDesignLine

#pragma mark - Init Methods

- (instancetype)initWithFrame:(NSRect)frame
{
    self = [super init];
    if (self) {
        _path = [NSBezierPath bezierPath];
        _viewFrame = frame;
        _color = [NSColor redColor];
        _thickness = 2.0f;
    }
    return self;
}

#pragma mark - Public Methods

- (void)draw {
    // Set the color and line width for the drawing context then draw NSBezierPath instance.    
    [self.color set];
    [_path moveToPoint:NSMakePoint(0, 0)];
    [_path lineToPoint:NSMakePoint(_viewFrame.size.width, 0)];
    [self.path setLineWidth:self.thickness];
    [self.path stroke];
}

@end
