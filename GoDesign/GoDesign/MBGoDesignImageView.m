//
//  MBGoDesignImageView.m
//  Trial
//
//  Created by Michael on 7/12/15.
//  Copyright (c) 2015 MichaelBai. All rights reserved.
//

#import "MBGoDesignImageView.h"

@interface MBGoDesignImageView () <NSDraggingDestination>
{
    BOOL highlight;
}

@property NSBezierPath *path;
@property NSPoint startPoint;
@property NSPoint endPoint;

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
    
    [[NSColor redColor] set];
    [self.path setLineWidth:2];
    [self.path stroke];
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
        }
        
        //if the drag comes from a file, set the window title to the filename
        fileURL=[NSURL URLFromPasteboard: [sender draggingPasteboard]];
        [[self window] setTitle: fileURL!=NULL ? [fileURL absoluteString] : @"(no name)"];
    }
    
    return YES;
}

#pragma mark - Mouse Event Methods

/*
 Override two of NSResponder's mouse handling methods to respond to the events we want.
 */

// Start drawing a new squiggle on mouse down.
- (void)mouseDown:(NSEvent *)event {
    
	// Convert from the window's coordinate system to this view's coordinates.
    _startPoint = [self convertPoint:event.locationInWindow fromView:nil];
    
    // Create a default NSBezierPath.
    _path = [NSBezierPath bezierPath];
    
    // Set the initial point of the path to be "initialPoint".
    [_path moveToPoint:_startPoint];
    
//    ASCSquiggle *newSquiggle = [[ASCSquiggle alloc] initWithInitialPoint:locationInView];
//    
//    CGFloat red     = randomComponent(),
//    green   = randomComponent(),
//    blue    = randomComponent(),
//    alpha   = randomComponent() / 2.f + .5f;
//    
//    newSquiggle.color = [NSColor colorWithCalibratedRed:red green:green blue:blue alpha:alpha];
//    
//    newSquiggle.thickness = 1 + 3.f * randomComponent();
//    
//    [self.squiggles addObject:newSquiggle];
    
    [self setNeedsDisplay:YES];
}

// Draw points on existing squiggle on mouse drag.
- (void)mouseDragged:(NSEvent *)event {
    
	// Convert from the window's coordinate system to this view's coordinates.
    NSPoint locationInView = [self convertPoint:event.locationInWindow fromView:nil];
    _endPoint = NSMakePoint(locationInView.x, _startPoint.y);
    [self.path lineToPoint:_endPoint];
    
//    ASCSquiggle *currentSquiggle = [self.squiggles lastObject];
//    
//    [currentSquiggle addPoint:locationInView];
    
    [self setNeedsDisplay:YES];
}


@end
