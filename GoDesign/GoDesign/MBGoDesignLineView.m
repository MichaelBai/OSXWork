//
//  MBGoDesignLineView.m
//  GoDesign
//
//  Created by Michael on 7/18/15.
//  Copyright (c) 2015 MichaelBai. All rights reserved.
//

#import "MBGoDesignLineView.h"

@interface MBGoDesignLineView ()

@property MBGoDesignLine* line;

@end

@implementation MBGoDesignLineView

- (instancetype)initWithFrame:(NSRect)frame lineAxis:(LineAxis)lineAxis
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        _lineAxis = lineAxis;
    }
    return self;
}

//- (void)setFrame:(NSRect)frameRect
//{
//    [super setFrame:frameRect];
//    _line.viewFrame = frameRect;
//}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    
//    [[NSColor whiteColor] setFill];
//    NSRectFill(dirtyRect);
//    NSLog(@"draw rect %@", NSStringFromRect(dirtyRect));
    // Drawing code here.
//    _line.viewFrame = self.frame;
    _line = [[MBGoDesignLine alloc] initWithFrame:self.frame lineAxis:self.lineAxis];
    [_line draw];
//    NSLog(@"draw rect END");
}

@end
