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

- (instancetype)initWithFrame:(NSRect)frame lineAxis:(LineAxis)lineAxis
{
    self = [super init];
    if (self) {
        _lineAxis = lineAxis;
        
        _path = [NSBezierPath bezierPath];
        _viewFrame = frame;
        _color = [NSColor redColor];
        _thickness = 1.0f;
    }
    return self;
}

#pragma mark - Public Methods

- (void)draw {
    // Set the color and line width for the drawing context then draw NSBezierPath instance.
    [self.color set];
    if (_lineAxis == LineHorizontal) {
        [_path moveToPoint:NSMakePoint(_thickness/2, 0)];
        [_path lineToPoint:NSMakePoint(_thickness/2, _viewFrame.size.height)];
        [_path moveToPoint:NSMakePoint(_thickness/2, _viewFrame.size.height/2)];
        [_path lineToPoint:NSMakePoint(_viewFrame.size.width-_thickness/2, _viewFrame.size.height/2)];
        [_path moveToPoint:NSMakePoint(_viewFrame.size.width-_thickness/2, 0)];
        [_path lineToPoint:NSMakePoint(_viewFrame.size.width-_thickness/2, _viewFrame.size.height)];
    } else {
        [_path moveToPoint:NSMakePoint(0, _thickness/2)];
        [_path lineToPoint:NSMakePoint(_viewFrame.size.width, _thickness/2)];
        [_path moveToPoint:NSMakePoint(_viewFrame.size.width/2, _thickness/2)];
        [_path lineToPoint:NSMakePoint(_viewFrame.size.width/2, _viewFrame.size.height-_thickness/2)];
        [_path moveToPoint:NSMakePoint(0, _viewFrame.size.height-_thickness/2)];
        [_path lineToPoint:NSMakePoint(_viewFrame.size.width, _viewFrame.size.height-_thickness/2)];
    }
    [self.path setLineWidth:self.thickness];
    [self.path stroke];
}

@end
