//
//  MBGoDesignWindowController.m
//  GoDesign
//
//  Created by Michael on 7/12/15.
//  Copyright (c) 2015 MichaelBai. All rights reserved.
//

#import "MBGoDesignWindowController.h"

@interface MBGoDesignWindowController ()



@end

@implementation MBGoDesignWindowController

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
        [_mode selectCellAtRow:0 column:0];
        [_axis selectCellAtRow:0 column:0];
    }
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

- (IBAction)modeChanged:(NSMatrix*)sender {
    if (sender.selectedRow == 0) {
        _scrollView.imgView.lineMode = ModeManual;
    } else {
        _scrollView.imgView.lineMode = ModeAuto;
    }
}

- (IBAction)axisChanged:(NSMatrix*)sender {
//    NSLog(@"%zd", sender.selectedRow);
    if (sender.selectedRow == 0) {
        _scrollView.imgView.lineAxis = LineHorizontal;
    } else {
        _scrollView.imgView.lineAxis = LineVertical;
    }
}


@end
