//
//  MBGoDesignLineLengthView.m
//  GoDesign
//
//  Created by bailu on 8/15/15.
//  Copyright (c) 2015 MichaelBai. All rights reserved.
//

#import "MBGoDesignLineLengthView.h"

@implementation MBGoDesignLineLengthView

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    [_lineLength drawAtPoint:NSZeroPoint withAttributes:nil];
}

@end
