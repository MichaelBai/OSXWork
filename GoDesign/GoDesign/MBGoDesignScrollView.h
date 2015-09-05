//
//  MBGoDesignScrollView.h
//  GoDesign
//
//  Created by Michael on 8/3/15.
//  Copyright (c) 2015 MichaelBai. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MBGoDesignImageView.h"

@interface MBGoDesignScrollView : NSScrollView

@property (strong, nonatomic) MBGoDesignImageView *imgView;

- (void)selectImage:(NSImage*)image;

@end
