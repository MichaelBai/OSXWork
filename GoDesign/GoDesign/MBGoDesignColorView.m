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
        _colorField.font = [NSFont fontWithName:@"Monaco" size:10];
        _colorField.textColor = [NSColor redColor];
        [self addSubview:_colorField];
        
        NSImageView* arrow = [[NSImageView alloc] initWithFrame:NSMakeRect(self.bounds.size.width/2-4/2, 0, 4, 5.5)];
        arrow.image = [NSImage imageNamed:@"color-arrow"];
        [self addSubview:arrow];
    }
    return self;
}

- (void)setColorStr:(NSString *)colorStr
{
    _colorStr = colorStr;
    _colorField.stringValue = _colorStr;
}

@end
