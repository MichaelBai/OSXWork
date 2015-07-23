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

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        _line = [[MBGoDesignLine alloc] initWithFrame:frame];
    }
    return self;
}

- (void)setFrame:(NSRect)frameRect
{
    [super setFrame:frameRect];
    _line.viewFrame = frameRect;
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    [[NSColor yellowColor] setFill];
    NSRectFill(dirtyRect);
    
    // Drawing code here.
//    _line.viewFrame = self.frame;
    [_line draw];
}

@end
