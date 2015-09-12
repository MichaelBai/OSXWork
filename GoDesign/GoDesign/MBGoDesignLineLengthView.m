//
//  MBGoDesignLineLengthView.m
//  GoDesign
//
//  Created by bailu on 8/15/15.
//  Copyright (c) 2015 MichaelBai. All rights reserved.
//

#import "MBGoDesignLineLengthView.h"

@interface MBGoDesignLineLengthView ()

@property NSTextField* lineLengthField;

@end

@implementation MBGoDesignLineLengthView

- (instancetype)initWithFrame:(NSRect)frameRect
{
    self = [super initWithFrame:frameRect];
    if (self) {
        _lineLengthField = [[NSTextField alloc] initWithFrame:self.bounds];
        _lineLengthField.alignment = NSCenterTextAlignment;
        _lineLengthField.editable = NO;
        _lineLengthField.bordered = NO;
        _lineLengthField.selectable = NO;
        _lineLengthField.backgroundColor = [NSColor clearColor];
        [self addSubview:_lineLengthField];
    }
    return self;
}

- (void)setLineLength:(NSString *)lineLength
{
    _lineLength = lineLength;
    _lineLengthField.stringValue = _lineLength;
}

@end
