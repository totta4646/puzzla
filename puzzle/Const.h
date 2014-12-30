//
//  Const.h
//  puzzle
//
//  Created by totta on 2014/12/12.
//  Copyright (c) 2014年 totta. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Const : NSObject
#define STAGE_ROW 12
#define STAGE_COL 10
#define WIDTH self.view.frame.size.width
#define HEIGHT self.view.frame.size.height
#define BUTTON_BORDER_WIDHT 1

#define SCORE_COLOR [UIColor colorWithHex:@"79aef2"]

#define NONE_BLOCK [NSNumber numberWithInteger:0]
#define BLOCK_STARUS [NSNumber numberWithInteger:1]
#define BLOCK_STARUS2 [NSNumber numberWithInteger:2]
#define BLOCK_STARUS3 [NSNumber numberWithInteger:3]
#define BLOCK_STARUS4 [NSNumber numberWithInteger:4]
#define BLOCK_STARUS5 [NSNumber numberWithInteger:5]
#define BLOCK_STARUS6 [NSNumber numberWithInteger:6]

#define BLOCK_BORDER_COLOR [UIColor colorWithHex:@"bbe8ff"]
#define BLOCK_COLOR_NONE [UIColor colorWithHex:@"ffffff"]
#define BLOCK_COLOR [UIColor colorWithHex:@"416bbf"]
#define BLOCK_COLOR2 [UIColor colorWithHex:@"95d5d7"]
#define BLOCK_COLOR3 [UIColor colorWithHex:@"51b8bd"]
#define BLOCK_COLOR4 [UIColor colorWithHex:@"aad7ff"]
#define BLOCK_COLOR5 [UIColor colorWithHex:@"3baad8"]

#define BUTTON_COLOR [UIColor colorWithHex:@"416bbf"]
#define BUTTON_COLOR2 [UIColor colorWithHex:@"497cbe"]
#define BUTTON_COLOR3 [UIColor colorWithHex:@"385ca6"]

#define BUTTON_BORDER_COLOR [UIColor colorWithHex:@"8cb9f2"]

@end
