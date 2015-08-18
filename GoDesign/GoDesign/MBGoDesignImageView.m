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

@interface MBGoDesignImageView () 

@property NSMutableArray* measuringlines;
@property NSMutableArray* lineLengths;

@property NSBezierPath *path;
@property NSPoint startPoint;
@property NSPoint endPoint;

@property NSTrackingArea* trackingArea;

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
    }
    return self;
}

- (void)awakeFromNib
{
    
}

- (void)setFrame:(NSRect)frameRect
{
    [super setFrame:frameRect];
    _trackingArea = [[NSTrackingArea alloc] initWithRect:self.bounds
                                                 options: (NSTrackingMouseEnteredAndExited | NSTrackingMouseMoved | NSTrackingActiveInKeyWindow )
                                                   owner:self userInfo:nil];
    [self addTrackingArea:_trackingArea];
}

- (void)drawRect:(NSRect)dirtyRect
{
    /*------------------------------------------------------
     draw method is overridden to do drop highlighing
     --------------------------------------------------------*/
    //do the usual draw operation to display the image
    [super drawRect:dirtyRect];
    
    MBGoDesignLineView* lastLineView = _measuringlines.lastObject;
    [lastLineView setNeedsDisplay:YES];
//    [_measuringlines enumerateObjectsUsingBlock:^(MBGoDesignLineView* lineView, NSUInteger idx, BOOL *stop) {
//        [lineView setNeedsDisplay:YES];
//    }];
    MBGoDesignLineLengthView* lastLineLengthView = _lineLengths.lastObject;
    [lastLineLengthView setNeedsDisplay:YES];
}

#pragma mark - Mouse Event Methods

/*
 Override NSResponder's mouse handling methods to respond to the events we want.
 */

// Start drawing a new squiggle on mouse down.
- (void)mouseDown:(NSEvent *)event {
    
	// Convert from the window's coordinate system to this view's coordinates.
    NSPoint locationInView = [self convertPoint:event.locationInWindow fromView:nil];
    if (CGPointEqualToPoint(_startPoint, CGPointZero)) {
        _startPoint = locationInView;
        NSRect lineViewFrame = NSMakeRect(_startPoint.x, _startPoint.y, 0, 0);
        MBGoDesignLineView* lineView = [[MBGoDesignLineView alloc] initWithFrame:lineViewFrame lineAxis:_lineAxis];
        
        [_measuringlines addObject:lineView];
        [self addSubview:lineView];
        
        // add line length view
        NSRect lineLengthFrame = NSMakeRect(locationInView.x, locationInView.y, 30, 20);
        MBGoDesignLineLengthView* lineLengthView = [[MBGoDesignLineLengthView alloc] initWithFrame:lineLengthFrame];
        [_lineLengths addObject:lineLengthView];
        [self addSubview:lineLengthView];
    } else {
        _startPoint = CGPointZero;
        
        MBGoDesignLineLengthView* curLineLengthView = _lineLengths.lastObject;
        NSRect lineLengthFrame = curLineLengthView.frame;
        MBGoDesignLineView* curLineView = _measuringlines.lastObject;
        // TODO: need adjust by line direction, here is lineright
        lineLengthFrame.origin = NSMakePoint(curLineView.frame.origin.x + curLineView.frame.size.width + 3, curLineView.frame.origin.y);
        curLineLengthView.frame = lineLengthFrame;
    }
    
    [self setNeedsDisplay:YES];
}

// Draw to end point on existing squiggle on mouse drag.
- (void)mouseDragged:(NSEvent *)event {
    
	// Convert from the window's coordinate system to this view's coordinates.
//    NSPoint locationInView = [self convertPoint:event.locationInWindow fromView:nil];
//    MBGoDesignLineView* curLineView = _measuringlines.lastObject;
//    CGRect lineViewFrame = curLineView.frame;
//    lineViewFrame.size.width = ABS(locationInView.x - lineViewFrame.origin.x);
//    curLineView.frame = lineViewFrame;
//    
//    [self setNeedsDisplay:YES];
}

- (void)mouseMoved:(NSEvent *)theEvent
{
    if (!CGPointEqualToPoint(_startPoint, CGPointZero)) {
        NSPoint locationInView = [self convertPoint:theEvent.locationInWindow fromView:nil];
        MBGoDesignLineView* curLineView = _measuringlines.lastObject;
        MBGoDesignLineLengthView* curLineLengthView = _lineLengths.lastObject;
        
        // TODO: duplicate code here, need to refact
        if (curLineView.lineAxis == LineHorizontal) {
//            NSLog(@"%@ %@", NSStringFromPoint(_startPoint), NSStringFromPoint(locationInView));
            CGFloat width = ABS(locationInView.x - _startPoint.x);
            CGRect lineViewFrame = curLineView.frame;
            lineViewFrame.size.height = 10;
            lineViewFrame.size.width = width;
            if (locationInView.x > _startPoint.x) {
                lineViewFrame.origin.x = _startPoint.x;
            } else {
                lineViewFrame.origin.x = locationInView.x;
            }
            curLineView.frame = lineViewFrame;
            
            curLineLengthView.frame = NSMakeRect(locationInView.x + 3, locationInView.y, 30, 20);
            curLineLengthView.lineLength = [NSString stringWithFormat:@"%.0f", width];
        } else { // Vertical
            CGFloat height = ABS(locationInView.y - _startPoint.y);
            CGRect lineViewFrame = curLineView.frame;
            lineViewFrame.size.width = 10;
            lineViewFrame.size.height = height;
            if (locationInView.y > _startPoint.y) {
                lineViewFrame.origin.y = _startPoint.y;
            } else {
                lineViewFrame.origin.y = locationInView.y;
            }
            curLineView.frame = lineViewFrame;
            
            curLineLengthView.frame = NSMakeRect(locationInView.x + 3, locationInView.y, 30, 20);
            curLineLengthView.lineLength = [NSString stringWithFormat:@"%.0f", height];
        }
        
        [self setNeedsDisplay:YES];
    }
}

@end
