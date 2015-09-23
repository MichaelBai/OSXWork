//
//  MBGoDesignImageView.m
//  Trial
//
//  Created by Michael on 7/12/15.
//  Copyright (c) 2015 MichaelBai. All rights reserved.
//

#import "MBGoDesignImageView.h"
#import "MBGoDesignLineView.h"
#import "MBGoDesignLineLengthView.h"
#import "MBGoDesignColorView.h"

#define LINEVIEW_WIDTH 10
#define LENGTH_WIDTH 40
#define LENGTH_HEIGHT 20

@interface MBGoDesignImageView () 

@property NSMutableArray* measuringlines;
@property NSMutableArray* lineLengths;
@property NSMutableArray* colorViews;

@property NSPoint startPoint;
@property NSPoint endPoint;

@property NSTrackingArea* trackingArea;

@property MBGoDesignLineView* autoLine;
@property MBGoDesignColorView* colorView;

@property unsigned char* rawData;

@end

@implementation MBGoDesignImageView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        _measuringlines = [NSMutableArray array];
        _startPoint = CGPointZero;
        
        _lineLengths = [NSMutableArray array];
        
        _colorViews = [NSMutableArray array];
        
        _opMode = OP_Measure;
    }
    return self;
}

- (void)dealloc
{
    if (_rawData != NULL) {
        free(_rawData);
    }
}

- (void)setImage:(NSImage *)newImage
{
    [super setImage:newImage];
    if (_rawData != NULL) {
        free(_rawData);
        _rawData = NULL;
    }
    [self drawImageToRGBContext:self.image]; // alloc memory and set address to _rawData
}

- (void)setFrame:(NSRect)frameRect
{
    [super setFrame:frameRect];
    _trackingArea = [[NSTrackingArea alloc] initWithRect:self.bounds
                                                 options: (NSTrackingMouseEnteredAndExited | NSTrackingMouseMoved | NSTrackingActiveInKeyWindow )
                                                   owner:self userInfo:nil];
    [self addTrackingArea:_trackingArea];
}

- (void)resetLengthFrameToLineCenter
{
    // TODO: line length view should adjust size like sizeToFit in iOS, and now the length frame adjusting code is ugly, need to refact
    
    MBGoDesignLineView* lastLineView = _measuringlines.lastObject;
    MBGoDesignLineLengthView* lastLineLengthView = _lineLengths.lastObject;
    // set line length to the center of cur line
    NSRect lastLineFrame = lastLineView.frame;
//    NSRect oldLengthFrame = lastLineLengthView.frame;
    NSRect newLengthFrame;
    if (lastLineView.lineAxis == LineHorizontal) {
        newLengthFrame = NSMakeRect(lastLineFrame.origin.x + lastLineFrame.size.width/2 - LENGTH_WIDTH/2, lastLineFrame.origin.y, LENGTH_WIDTH, LENGTH_HEIGHT);
    } else {
        newLengthFrame = NSMakeRect(lastLineFrame.origin.x, lastLineFrame.origin.y + lastLineFrame.size.height/2 - LENGTH_HEIGHT/2, LENGTH_WIDTH, LENGTH_HEIGHT);
    }
    lastLineLengthView.frame = newLengthFrame;
}

#pragma mark - Draw

- (void)drawRect:(NSRect)dirtyRect
{
    //do the usual draw operation to display the image
    [super drawRect:dirtyRect];
    
    MBGoDesignLineView* lastLineView = _measuringlines.lastObject;
    [lastLineView setNeedsDisplay:YES];
    MBGoDesignLineLengthView* lastLineLengthView = _lineLengths.lastObject;
    [lastLineLengthView setNeedsDisplay:YES];
    MBGoDesignColorView* lastColorView = _colorViews.lastObject;
    [lastColorView setNeedsDisplay:YES];
}

#pragma mark - Cursor

- (void)resetCursorRects
{
    [self addCursorRect:self.bounds cursor:[NSCursor crosshairCursor]];
}

#pragma mark - Mouse Event Methods

/*
 Override NSResponder's mouse handling methods to respond to the events we want.
 */
- (void)mouseDown:(NSEvent *)event {
    if (_opMode == OP_Color) {
        _colorView = nil;
        [self setNeedsDisplay:YES];
        return;
    }
    
    if (_lineMode == ModeAuto) {
        [self resetLengthFrameToLineCenter];
        
        _autoLine = nil;
        [self setNeedsDisplay:YES];
        return;
    }
    
	// Convert from the window's coordinate system to this view's coordinates.
    NSPoint locationInView = [self convertPoint:event.locationInWindow fromView:nil];
    locationInView = NSMakePoint((int)locationInView.x, (int)locationInView.y);
    
    if (CGPointEqualToPoint(_startPoint, CGPointZero)) {
        _startPoint = locationInView;
        NSRect lineViewFrame = NSMakeRect(_startPoint.x, _startPoint.y-LINEVIEW_WIDTH/2, 0, 0);
        MBGoDesignLineView* lineView = [[MBGoDesignLineView alloc] initWithFrame:lineViewFrame lineAxis:_lineAxis];
        
//        [_measuringlines addObject:lineView];
//        [self addSubview:lineView];
        [self addLineView:lineView];
        
        // add line length view
        NSRect lineLengthFrame = NSMakeRect(locationInView.x, locationInView.y, LENGTH_WIDTH, LENGTH_HEIGHT);
        MBGoDesignLineLengthView* lineLengthView = [[MBGoDesignLineLengthView alloc] initWithFrame:lineLengthFrame];
        [_lineLengths addObject:lineLengthView];
        [self addSubview:lineLengthView];
    } else {
        _startPoint = CGPointZero;
        
        MBGoDesignLineLengthView* curLineLengthView = _lineLengths.lastObject;
        NSRect lineLengthFrame = curLineLengthView.frame;
        MBGoDesignLineView* curLineView = _measuringlines.lastObject;
        // TODO: need adjust to line middle
        lineLengthFrame.origin = NSMakePoint(curLineView.frame.origin.x + curLineView.frame.size.width - 3, curLineView.frame.origin.y + 5);
        curLineLengthView.frame = lineLengthFrame;
        
        [self resetLengthFrameToLineCenter];
    }
    
    
    [self setNeedsDisplay:YES];
}

- (void)rightMouseDown:(NSEvent *)theEvent
{
    // remove last manual line
    MBGoDesignLineView* curLineView = _measuringlines.lastObject;
    [curLineView removeFromSuperview];
    [_measuringlines removeLastObject];
    MBGoDesignLineLengthView* curLineLengthView = _lineLengths.lastObject;
    [curLineLengthView removeFromSuperview];
    [_lineLengths removeLastObject];
    
    _startPoint = CGPointZero;
}

- (void)mouseMoved:(NSEvent *)theEvent
{
    NSPoint locationInView = [self convertPoint:theEvent.locationInWindow fromView:nil];
    locationInView = NSMakePoint((int)locationInView.x, (int)locationInView.y);
    // When moves fast, location may out of image view, disgard it here
    if (!NSPointInRect(locationInView, self.bounds)) {
        return;
    }
    
    if (_opMode == OP_Color) {
        if (!_colorView) {
            _colorView = [[MBGoDesignColorView alloc] initWithFrame:NSMakeRect(locationInView.x - 30, locationInView.y, 60, 18)];
            [_colorViews addObject:_colorView];
            [self addSubview:_colorView];
        }
        _colorView.frame = NSMakeRect(locationInView.x - 30, locationInView.y, 60, 18);
        _colorView.colorStr = [self getColorStringInPoint:locationInView];
        
        [self setNeedsDisplay:YES];
        return;
    }
    
    if (_lineMode == ModeAuto) {
        if (!_autoLine) {
            _autoLine = [[MBGoDesignLineView alloc] initWithFrame:NSZeroRect lineAxis:_lineAxis];
            
//            [_measuringlines addObject:_autoLine];
//            [self addSubview:_autoLine];
            [self addLineView:_autoLine];
            
            // TODO: duplicate here with code in MouseDown:
            NSRect lineLengthFrame = NSMakeRect(locationInView.x, locationInView.y, LENGTH_WIDTH, LENGTH_HEIGHT);
            MBGoDesignLineLengthView* lineLengthView = [[MBGoDesignLineLengthView alloc] initWithFrame:lineLengthFrame];
            [_lineLengths addObject:lineLengthView];
            [self addSubview:lineLengthView];
        }
        
        MBGoDesignLineLengthView* curLineLengthView = _lineLengths.lastObject;
        
        if (_lineAxis == LineHorizontal) {
            NSPoint leftPoint, rightPoint;
            
            leftPoint = [self getPointSameColorWithPoint:locationInView isStart:YES isHorizontal:YES];
            rightPoint = [self getPointSameColorWithPoint:locationInView isStart:NO isHorizontal:YES];
            
            CGFloat width = ABS(leftPoint.x - rightPoint.x) + 1;
            NSRect lineFrame = NSMakeRect(leftPoint.x, locationInView.y-LINEVIEW_WIDTH/2, width, LINEVIEW_WIDTH);
            _autoLine.frame = lineFrame;
            
            curLineLengthView.frame = NSMakeRect(locationInView.x + 3, locationInView.y, LENGTH_WIDTH, LENGTH_HEIGHT);
            curLineLengthView.lineLength = [NSString stringWithFormat:@"%.0f", width];
        } else {
            NSPoint upPoint, downPoint;
            
            upPoint = [self getPointSameColorWithPoint:locationInView isStart:YES isHorizontal:NO];
            downPoint = [self getPointSameColorWithPoint:locationInView isStart:NO isHorizontal:NO];
            
            CGFloat height = ABS(upPoint.y - downPoint.y) + 1;
            NSRect lineFrame = NSMakeRect(downPoint.x-LINEVIEW_WIDTH/2, self.image.size.height - downPoint.y - 1, LINEVIEW_WIDTH, height);
            _autoLine.frame = lineFrame;
            
            curLineLengthView.frame = NSMakeRect(locationInView.x + 3, locationInView.y, LENGTH_WIDTH, LENGTH_HEIGHT);
            curLineLengthView.lineLength = [NSString stringWithFormat:@"%.0f", height];
        }
        
        [self setNeedsDisplay:YES];
        
        return;
    }
    
    // Manual
    if (!CGPointEqualToPoint(_startPoint, CGPointZero)) {
        MBGoDesignLineView* curLineView = _measuringlines.lastObject;
        MBGoDesignLineLengthView* curLineLengthView = _lineLengths.lastObject;
        
        // TODO: duplicate code here, need to refact
        if (curLineView.lineAxis == LineHorizontal) {
            CGFloat width = ABS(locationInView.x - _startPoint.x);
            CGRect lineViewFrame = curLineView.frame;
            lineViewFrame.size.height = LINEVIEW_WIDTH;
            lineViewFrame.size.width = width;
            if (locationInView.x > _startPoint.x) {
                lineViewFrame.origin.x = _startPoint.x;
            } else {
                lineViewFrame.origin.x = locationInView.x;
            }
            curLineView.frame = lineViewFrame;
            
            curLineLengthView.frame = NSMakeRect(locationInView.x + 3, locationInView.y, LENGTH_WIDTH, LENGTH_HEIGHT);
            curLineLengthView.lineLength = [NSString stringWithFormat:@"%.0f", width];
        } else { // Vertical
            CGFloat height = ABS(locationInView.y - _startPoint.y);
            CGRect lineViewFrame = curLineView.frame;
            lineViewFrame.size.width = LINEVIEW_WIDTH;
            lineViewFrame.size.height = height;
            if (locationInView.y > _startPoint.y) {
                lineViewFrame.origin.y = _startPoint.y;
            } else {
                lineViewFrame.origin.y = locationInView.y;
            }
            curLineView.frame = lineViewFrame;
            
            curLineLengthView.frame = NSMakeRect(locationInView.x + 3, locationInView.y, LENGTH_WIDTH, LENGTH_HEIGHT);
            curLineLengthView.lineLength = [NSString stringWithFormat:@"%.0f", height];
        }
        
        [self setNeedsDisplay:YES];
    }
}

- (void)mouseExited:(NSEvent *)theEvent
{
    if (_opMode == OP_Color) {
        [_colorViews removeLastObject];
        [_colorView removeFromSuperview];
        _colorView = nil;
        return;
    }
    if (_lineMode == ModeAuto) {
        if (_autoLine) {
            [_measuringlines removeLastObject];
            [_autoLine removeFromSuperview];
            _autoLine = nil;
            
            MBGoDesignLineLengthView* curLineLengthView = _lineLengths.lastObject;
            [curLineLengthView removeFromSuperview];
            [_lineLengths removeLastObject];
        }
    }
}

#pragma mark - Color

- (NSString*)getColorStringInPoint:(NSPoint)point
{
    if (_rawData == NULL) {
        return @"";
    }
    
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * self.image.size.width;
    
    NSUInteger byteIndex = (bytesPerRow * (self.image.size.height - point.y)) + (int)point.x * bytesPerPixel;
    
    NSInteger red = _rawData[byteIndex];
    NSInteger green = _rawData[byteIndex + 1];
    NSInteger blue = _rawData[byteIndex + 2];
    return [NSString stringWithFormat:@"#%02lx%02lx%02lx", red, green, blue];
}

#pragma mark - Image Pixel Exec

// http://stackoverflow.com/a/1262893/1391851

- (void)drawImageToRGBContext:(NSImage*)image
{
    CGImageRef imageRef = [image CGImageForProposedRect:nil context:NULL hints:nil];
    
    NSUInteger width = image.size.width;
    NSUInteger height = image.size.height;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    _rawData = (unsigned char*) calloc(height * width * 4, sizeof(unsigned char));
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    CGContextRef context = CGBitmapContextCreate(_rawData, width, height,
                                                 bitsPerComponent, bytesPerRow, colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    CGContextRelease(context);
}

- (NSPoint)getPointSameColorWithPoint:(NSPoint)point isStart:(BOOL)isStart isHorizontal:(BOOL)isHorizontal
{
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * self.image.size.width;
    
    NSUInteger byteIndex = (bytesPerRow * (self.image.size.height - point.y)) + (int)point.x * bytesPerPixel;
    
    NSInteger threshold = 5;
    
    NSInteger red = _rawData[byteIndex];
    NSInteger green = _rawData[byteIndex + 1];
    NSInteger blue = _rawData[byteIndex + 2];
    
    NSPoint retPoint;
    if (isHorizontal && isStart) {
        retPoint.y = point.y;
        NSUInteger left = 0;
        for (int i = point.x - 1; i >= 0; i--) {
            NSInteger curRed = _rawData[byteIndex];
            NSInteger curGreen = _rawData[byteIndex + 1];
            NSInteger curBlue = _rawData[byteIndex + 2];
            
            if (ABS(curRed - red) > threshold ||
                ABS(curGreen - green) > threshold ||
                ABS(curBlue - blue) > threshold) {
                left = i + 1;
                break;
            }
            
            byteIndex -= bytesPerPixel;
        }
        retPoint.x = left;
    } else if (isHorizontal && !isStart) {
        retPoint.y = point.y;
        NSUInteger right = self.image.size.width - 1;
        for (int i = point.x; i < self.image.size.width - 1; i++) {
            NSInteger curRed = _rawData[byteIndex];
            NSInteger curGreen = _rawData[byteIndex + 1];
            NSInteger curBlue = _rawData[byteIndex + 2];
            
            if (ABS(curRed - red) > threshold ||
                ABS(curGreen - green) > threshold ||
                ABS(curBlue - blue) > threshold) {
                right = i - 1;
                break;
            }
            
            byteIndex += bytesPerPixel;
        }
        retPoint.x = right;
    } else if (!isHorizontal && isStart) {
        retPoint.x = point.x;
        NSUInteger up = 0;
        for (int i = self.image.size.height - point.y; i >= 0; i--) {
            NSInteger curRed = _rawData[byteIndex];
            NSInteger curGreen = _rawData[byteIndex + 1];
            NSInteger curBlue = _rawData[byteIndex + 2];
            
            if (ABS(curRed - red) > threshold ||
                ABS(curGreen - green) > threshold ||
                ABS(curBlue - blue) > threshold) {
                up = i + 1;
                break;
            }
            
            byteIndex -= bytesPerRow;
        }
        retPoint.y = up;
    } else if (!isHorizontal && !isStart) {
        retPoint.x = point.x;
        NSUInteger down = self.image.size.height - 1;
        for (int i = self.image.size.height - point.y; i < self.image.size.height - 1; i++) {
            NSInteger curRed = _rawData[byteIndex];
            NSInteger curGreen = _rawData[byteIndex + 1];
            NSInteger curBlue = _rawData[byteIndex + 2];
            
            if (ABS(curRed - red) > threshold ||
                ABS(curGreen - green) > threshold ||
                ABS(curBlue - blue) > threshold) {
                down = i - 1;
                break;
            }
            
            byteIndex += bytesPerRow;
        }
        retPoint.y = down;
    }
    
    return retPoint;
}

- (void)undo
{
    if ([self.undoManager canUndo]) {
        [self.undoManager undo];
        [self setNeedsDisplay:YES];
    }
}

- (void)redo
{
    if ([self.undoManager canRedo]) {
        [self.undoManager redo];
        [self setNeedsDisplay:YES];
    }
}

- (void)removeLineView:(MBGoDesignLineView*)lineView
{
    [self.undoManager beginUndoGrouping];
    [[self.undoManager prepareWithInvocationTarget:self] addLineView:lineView];
    [_measuringlines removeObject:lineView];
    [lineView removeFromSuperview];
    [self setNeedsDisplay:YES];
    [self.undoManager endUndoGrouping];
}

- (void)addLineView:(MBGoDesignLineView*)lineView
{
    [[self.undoManager prepareWithInvocationTarget:self] removeLineView:lineView];
    [_measuringlines addObject:lineView];
    [self addSubview:lineView];
    [self setNeedsDisplay:YES];
}

@end
