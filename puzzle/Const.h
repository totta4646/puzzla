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
#define NONE_BLOCK [NSNumber numberWithInteger:0]
#define BLOCK_STARUS [NSNumber numberWithInteger:1]
#define BLOCK_STARUS2 [NSNumber numberWithInteger:2]
#define BLOCK_STARUS3 [NSNumber numberWithInteger:3]
#define BLOCK_STARUS4 [NSNumber numberWithInteger:4]
#define BLOCK_STARUS5 [NSNumber numberWithInteger:5]

#define BLOCK_COLOR [UIColor redColor]
#define BLOCK_COLOR2 [UIColor blueColor]
#define BLOCK_COLOR3 [UIColor blackColor]
#define BLOCK_COLOR4 [UIColor greenColor]
#define BLOCK_COLOR5 [UIColor yellowColor]

@end
