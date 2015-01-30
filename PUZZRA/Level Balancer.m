//
//  Level Balancer.m
//  PUZZRA
//
//  Created by totta on 2014/12/23.
//  Copyright (c) 2014年 totta. All rights reserved.
//
#define LEVELUP 5
#define DEFFICULT 0.05


#import "Level Balancer.h"

@implementation Level_Balancer

/**
 レベル関係の初期化
 */
-(void)levelNew {
    level = 1;
    border = LEVELUP;
}

/**
 *  得点と比べてスピードを変えるか判断させる
 *
 *  @param score 現在の得点
 *
 *  @return 変更するかどうか
 */
-(BOOL)levelcheck {
    if(level >= border) {
        NSLog(@"レベルアップ");
        level = 1;
        border += LEVELUP;
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
//    NSLog(@"レベルアップ");
    speed = speed - DEFFICULT;
    if(speed < 0.2) {
        speed = 0.2;
    }
    return speed;
}

-(void)countUp {
    NSLog(@"%d",level);
    level++;
}
@end
