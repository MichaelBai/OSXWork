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

- (IBAction)openFile:(NSButton *)sender {
    // Create a File Open Dialog class.
    NSOpenPanel* openDlg = [NSOpenPanel openPanel];
    
    // Set array of file types
    NSArray *fileTypesArray;
    fileTypesArray = [NSArray arrayWithObjects:@"jpg", @"gif", @"png", nil];
    
    // Enable options in the dialog.
    [openDlg setCanChooseFiles:YES];
    [openDlg setAllowedFileTypes:fileTypesArray];
    [openDlg setAllowsMultipleSelection:NO];
    
    // Display the dialog box.  If the OK pressed,
    // process the files.
    if ( [openDlg runModal] == NSOKButton ) {
        
        // Gets list of all files selected
        NSArray *files = [openDlg URLs];
        
//        // Loop through the files and process them.
//        for(int i = 0; i < [files count]; i++ ) {
//            // Do something with the filename.
//            NSLog(@"File path: %@", [[files objectAtIndex:i] path]);
//        }
        
        if (files.count > 0) {
            // only one file here
            NSImage* image = [[NSImage alloc] initWithContentsOfURL:files[0]];
            [self.scrollView selectImage:image];
        }
    }
}

@end
