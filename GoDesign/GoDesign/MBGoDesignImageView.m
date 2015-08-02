//
//  MBGoDesignImageView.m
//  Trial
//
//  Created by Michael on 7/12/15.
//  Copyright (c) 2015 MichaelBai. All rights reserved.
//

#import "MBGoDesignImageView.h"
#import "MBGoDesignLineView.h"

@interface MBGoDesignImageView () <NSDraggingDestination>
{
    BOOL highlight;
}

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
    }
    return self;
}

- (void)awakeFromNib
{
    _measuringlines = [NSMutableArray array];
    _startPoint = CGPointZero;
    
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
    
    if ( highlight ) {
        //highlight by overlaying a gray border
        [[NSColor grayColor] set];
        [NSBezierPath setDefaultLineWidth:5];
        [NSBezierPath strokeRect:dirtyRect];
    }
    
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

#pragma mark - Destination Operations

- (NSDragOperation)draggingEntered:(id <NSDraggingInfo>)sender
{
    /*------------------------------------------------------
     method called whenever a drag enters our drop zone
     --------------------------------------------------------*/
    
    // Check if the pasteboard contains image data and source/user wants it copied
    if ( [NSImage canInitWithPasteboard:[sender draggingPasteboard]] &&
        [sender draggingSourceOperationMask] &
        NSDragOperationCopy ) {
        
        //highlight our drop zone
        highlight=YES;
        
        [self setNeedsDisplay: YES];
        
        /* When an image from one window is dragged over another, we want to resize the dragging item to
         * preview the size of the image as it would appear if the user dropped it in. */
        [sender enumerateDraggingItemsWithOptions:NSDraggingItemEnumerationConcurrent
                                          forView:self
                                          classes:[NSArray arrayWithObject:[NSPasteboardItem class]]
                                    searchOptions:nil
                                       usingBlock:^(NSDraggingItem *draggingItem, NSInteger idx, BOOL *stop) {
                                           
                                           //                                           /* Only resize a fragging item if it originated from one of our windows.  To do this,
                                           //                                            * we declare a custom UTI that will only be assigned to dragging items we created.  Here
                                           //                                            * we check if the dragging item can represent our custom UTI.  If it can't we stop. */
                                           //                                           if ( ![[[draggingItem item] types] containsObject:kPrivateDragUTI] ) {
                                           //
                                           //                                               *stop = YES;
                                           //
                                           //                                           } else {
                                           /* In order for the dragging item to actually resize, we have to reset its contents.
                                            * The frame is going to be the destination view's bounds.  (Coordinates are local
                                            * to the destination view here).
                                            * For the contents, we'll grab the old contents and use those again.  If you wanted
                                            * to perform other modifications in addition to the resize you could do that here. */
                                           [draggingItem setDraggingFrame:self.bounds contents:[[[draggingItem imageComponents] objectAtIndex:0] contents]];
                                           //                                           }
                                       }];
        
        //accept data as a copy operation
        return NSDragOperationCopy;
    }
    
    return NSDragOperationNone;
}

- (void)draggingExited:(id <NSDraggingInfo>)sender
{
    /*------------------------------------------------------
     method called whenever a drag exits our drop zone
     --------------------------------------------------------*/
    //remove highlight of the drop zone
    highlight=NO;
    
    [self setNeedsDisplay: YES];
}

- (BOOL)prepareForDragOperation:(id <NSDraggingInfo>)sender
{
    /*------------------------------------------------------
     method to determine if we can accept the drop
     --------------------------------------------------------*/
    //finished with the drag so remove any highlighting
    highlight=NO;
    
    [self setNeedsDisplay: YES];
    
    //check to see if we can accept the data
    return [NSImage canInitWithPasteboard: [sender draggingPasteboard]];
}

- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender
{
    /*------------------------------------------------------
     method that should handle the drop data
     --------------------------------------------------------*/
    if ( [sender draggingSource] != self ) {
        NSURL* fileURL;
        
        //set the image using the best representation we can get from the pasteboard
        if([NSImage canInitWithPasteboard: [sender draggingPasteboard]]) {
            NSImage *newImage = [[NSImage alloc] initWithPasteboard: [sender draggingPasteboard]];
            [self setImage:newImage];
            
            // TODO: get scrren width, make width less than 2/3 screen width
            // resize window to contain the image
            // window scroll horizontal and vertical when image is big
            NSRect imageViewFrame = NSMakeRect(0, 0, newImage.size.width, newImage.size.height);
            CGFloat screenWidth = 1000;
            CGFloat windowWidth = self.window.frame.size.width;
            while (imageViewFrame.size.width > screenWidth) {
                imageViewFrame.size.width /= 2;
                imageViewFrame.size.height /= 2;
            }
            imageViewFrame.origin.x = (windowWidth - imageViewFrame.size.width)/2;
            [self setFrame:imageViewFrame];
        }
        
        //if the drag comes from a file, set the window title to the filename
        fileURL=[NSURL URLFromPasteboard: [sender draggingPasteboard]];
        [[self window] setTitle: fileURL!=NULL ? [fileURL absoluteString] : @"(no name)"];
    }
    
    return YES;
}

@end
