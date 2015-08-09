//
//  MBGoDesignScrollView.m
//  GoDesign
//
//  Created by Michael on 8/3/15.
//  Copyright (c) 2015 MichaelBai. All rights reserved.
//

#import "MBGoDesignScrollView.h"
#import "MBGoDesignImageView.h"

@interface MBGoDesignScrollView () <NSDraggingDestination>
{
    BOOL highlight;
}

@property (strong, nonatomic) NSView* containerView;
@property (strong, nonatomic) MBGoDesignImageView *imgView;

@property NSTrackingArea* trackingArea;

@end

@implementation MBGoDesignScrollView

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
    [self registerForDraggedTypes:[NSArray arrayWithObjects:NSFilenamesPboardType, nil]];
    [self setDocumentView:self.containerView];
    [self.containerView addSubview:self.imgView];
    
    _trackingArea = [[NSTrackingArea alloc] initWithRect:self.bounds
                                                 options: (NSTrackingMouseEnteredAndExited | NSTrackingMouseMoved | NSTrackingActiveInKeyWindow )
                                                   owner:self userInfo:nil];
    [self addTrackingArea:_trackingArea];
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    
    // Drawing code here.
    if ( highlight ) {
        //highlight by overlaying a gray border
        [[NSColor grayColor] set];
        [NSBezierPath setDefaultLineWidth:5];
        [NSBezierPath strokeRect:dirtyRect];
    }
}

- (NSView *)containerView
{
    if (!_containerView) {
        _containerView = [[NSView alloc] initWithFrame:self.bounds];
    }
    return _containerView;
}

- (MBGoDesignImageView *)imgView
{
    if (!_imgView) {
        _imgView = [[MBGoDesignImageView alloc] initWithFrame:CGRectZero];
        [_imgView unregisterDraggedTypes];
    }
    return _imgView;
}

#pragma mark - Destination Operations

- (NSDragOperation)draggingEntered:(id <NSDraggingInfo>)sender
{
    /*------------------------------------------------------
     method called whenever a drag enters our drop zone
     --------------------------------------------------------*/
    
    // Check if the pasteboard contains image data and source/user wants it copied
    if ([NSImage canInitWithPasteboard:[sender draggingPasteboard]] &&
        ([sender draggingSourceOperationMask] & NSDragOperationCopy) ) {
        
        //highlight our drop zone
        highlight=YES;
        
        [self setNeedsDisplay: YES];
        
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
    highlight = NO;
    
    [self setNeedsDisplay:YES];
    
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
            NSImage *newImage = [[NSImage alloc] initWithPasteboard:[sender draggingPasteboard]];
            [self.imgView setImage:newImage];
            
            // TODO: get scrren width, make width less than 2/3 screen width
            // resize window to contain the image
            NSRect imageViewFrame = NSMakeRect(0, 0, newImage.size.width, newImage.size.height);
            CGFloat screenWidth = 1000;
            CGFloat windowWidth = self.window.frame.size.width;
            while (imageViewFrame.size.width > screenWidth) {
                imageViewFrame.size.width /= 2;
                imageViewFrame.size.height /= 2;
            }
            imageViewFrame.origin.x = (windowWidth - imageViewFrame.size.width)/2;
            [self.imgView setImageFrameStyle:NSImageFrameNone];
            [self.imgView setFrame:imageViewFrame];
            
            // TODO: need to set frame width to minus scroll bar width and height to minus scroll bar height
            NSRect containerFrame = NSMakeRect(0, 0, MAX(imageViewFrame.size.width, self.bounds.size.width), MAX(imageViewFrame.size.height, self.bounds.size.height));
            [self.containerView setFrame:containerFrame];
        }
        
        //if the drag comes from a file, set the window title to the filename
        fileURL=[NSURL URLFromPasteboard: [sender draggingPasteboard]];
        [[self window] setTitle: fileURL!=NULL ? [fileURL absoluteString] : @"(no name)"];
    }
    
    return YES;
}

@end
