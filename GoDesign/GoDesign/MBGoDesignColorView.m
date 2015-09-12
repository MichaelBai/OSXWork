//
//  MBGoDesignColorView.m
//  GoDesign
//
//  Created by bailu on 9/10/15.
//  Copyright (c) 2015 MichaelBai. All rights reserved.
//

#import "MBGoDesignColorView.h"

@interface MBGoDesignColorView ()

@property NSTextField* colorField;

@end

@implementation MBGoDesignColorView

- (instancetype)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _colorField = [[NSTextField alloc] initWithFrame:self.bounds];
        _colorField.alignment = NSCenterTextAlignment;
        _colorField.editable = NO;
        _colorField.bordered = NO;
        _colorField.selectable = NO;
        _colorField.backgroundColor = [NSColor clearColor];
        [self addSubview:_colorField];
    }
    return self;
}

- (void)setColorStr:(NSString *)colorStr
{
    _colorStr = colorStr;
    _colorField.stringValue = _colorStr;
}

@end
