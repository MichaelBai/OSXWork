//
//  MBGoDesignImageView.m
//  Trial
//
//  Created by Michael on 7/12/15.
//  Copyright (c) 2015 MichaelBai. All rights reserved.
//

#import "MBGoDesignImageView.h"
#import "MBGoDesignLineView.h"

@interface MBGoDesignImageView () 

@property NSMutableArray* measuringlines;

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
    
    
    
    [_measuringlines enumerateObjectsUsingBlock:^(MBGoDesignLineView* lineView, NSUInteger idx, BOOL *stop) {
        [lineView setNeedsDisplay:YES];
    }];
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
        CGRect lineViewFrame = CGRectMake(_startPoint.x, _startPoint.y, 0, 10);
        MBGoDesignLineView* lineView = [[MBGoDesignLineView alloc] initWithFrame:lineViewFrame];
        lineView.lineAxis = LineHorizontal;
        
        [_measuringlines addObject:lineView];
        [self addSubview:lineView];
    } else {
        _startPoint = CGPointZero;
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
        
        // TODO: duplicate code here, need to refact
        if (curLineView.lineAxis == LineHorizontal) {
            NSLog(@"%@ %@", NSStringFromPoint(_startPoint), NSStringFromPoint(locationInView));
            CGFloat width = ABS(locationInView.x - _startPoint.x);
            if (locationInView.x > _startPoint.x) {
                curLineView.lineDirection = LineRight;
                
                CGRect lineViewFrame = curLineView.frame;
                lineViewFrame.origin.x = _startPoint.x;
                lineViewFrame.size.width = width;
                curLineView.frame = lineViewFrame;
            } else {
                curLineView.lineDirection = LineLeft;
                
                CGRect lineViewFrame = curLineView.frame;
                lineViewFrame.size.width = width;
                lineViewFrame.origin.x = locationInView.x;
                curLineView.frame = lineViewFrame;
            }
        }
        
        [self setNeedsDisplay:YES];
    }
}

@end
