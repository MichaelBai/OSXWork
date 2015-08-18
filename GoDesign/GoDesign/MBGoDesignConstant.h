//
//  MBGoDesignConstant.h
//  GoDesign
//
//  Created by Michael on 8/18/15.
//  Copyright (c) 2015 MichaelBai. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    LineHorizontal,
    LineVertical
} LineAxis;

typedef enum : NSUInteger {
    ModeManual,
    ModeAuto
} LineMode;

@interface MBGoDesignConstant : NSObject

@end
