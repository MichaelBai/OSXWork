//
//  MBGoDesignWindowController.h
//  GoDesign
//
//  Created by Michael on 7/12/15.
//  Copyright (c) 2015 MichaelBai. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MBGoDesignScrollView.h"

@interface MBGoDesignWindowController : NSWindowController

@property (weak) IBOutlet MBGoDesignScrollView *scrollView;

@end
