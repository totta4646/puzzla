//
//  MyScore.m
//  PUZZRA
//
//  Created by totta on 2014/12/26.
//  Copyright (c) 2014年 totta. All rights reserved.
//

#import "MyScore.h"

@implementation MyScore

/**
 *  スコアの初期化
 */
-(void) scoreNew {
    maxChain = 0;
    tempChian = 0;
    score = 0;
    tempscore = 0;
    maxscore = 0;
}
/**
 *  アイテムを使用した際の追加得点
 */
-(void) useItem {
    score += 2000;
}
/**
 *  ブロックを消した時の加点
 *
 *  @param add 消した個数
 */
-(void) addScore:(int)add {
    tempscore = add * (tempChian + 1) * 100;
    score = score + tempscore;
}
/**
 *  スコアのエフェクトを表示するためのメソッド
 *
 *  @return 現行のスコア
 */
-(int) getcurrentaddscore {
    return tempscore;
}
/**
 *  得点を表示する
 *
 *  @return 総得点を返す
 */
-(int)getScore {
    return score;
}
/**
 *  瞬間最大スコアを保存
 *
 *  @param sendmaxtempscore 得点
 */
-(void)checkMaxScore:(int)sendmaxtempscore {
    if(maxscore < sendmaxtempscore * (tempChian + 1) * 100) {
        maxscore = sendmaxtempscore * (tempChian + 1) * 100;
    }
}
/**
 *  瞬間最大スコアを返す
 *
 *  @return 瞬間最大スコア
 */
-(int)getMaxScore {
    return maxscore;
}

/**
 *  落下までにいくつ消したかの加点
 */
-(void) countMaxChain {
    tempChian++;
}
/**
 *  ブロックが変わった時の処理
 */
-(void) changeNextBlock {
    if(maxChain < tempChian) {
        maxChain = tempChian;
    }
    tempChian = 0;
}
/**
 *  最大カウント数を返す
 *
 *  @return 最大カウント数
 */
-(int) getMaxChainScore {
    return maxChain;
}
@end
