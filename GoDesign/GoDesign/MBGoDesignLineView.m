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

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    // Drawing code here.
    _line = [[MBGoDesignLine alloc] initWithFrame:self.frame lineAxis:self.lineAxis];
    [_line draw];
}

@end
