//
//  MBGoDesignColorView.m
//  GoDesign
//
//  Created by bailu on 9/10/15.
//  Copyright (c) 2015 MichaelBai. All rights reserved.
//

#import "MBGoDesignColorView.h"

@implementation MBGoDesignColorView

- (instancetype)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    [_colorStr drawAtPoint:NSZeroPoint withAttributes:nil];
}

@end
