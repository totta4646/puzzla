//
//  Level Balancer.m
//  PUZZRA
//
//  Created by totta on 2014/12/23.
//  Copyright (c) 2014年 totta. All rights reserved.
//
#define LEVELUP 1000
#define DEFFICULT 0.01


#import "Level Balancer.h"

@implementation Level_Balancer

/**
 レベル関係の初期化
 */
-(void)levelNew {
    level = 0;
}

/**
 *  得点と比べてスピードを変えるか判断させる
 *
 *  @param score 現在の得点
 *
 *  @return 変更するかどうか
 */
-(BOOL)levelcheck:(int)score {

    if(score/LEVELUP >= level) {
        level++;
        return true;
    }
    return false;
}
/**
 *  スピードを変える
 *
 *  @param speed 現在のスピード
 *
 *  @return 変更後のスピード
 */

-(float)levelup:(float)speed {
    NSLog(@"%f",speed);
    speed = speed - DEFFICULT;
    return speed;
}
@end
