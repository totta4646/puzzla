//
//  TurnBlockModel.m
//  puzzle
//
//  Created by totta on 2014/12/13.
//  Copyright (c) 2014年 totta. All rights reserved.
//

#import "TurnBlockModel.h"

@implementation TurnBlockModel

-(void)ModelNew {
    //dropBlock: 2 * 2 = 4マス
    _model = [@[] mutableCopy];
    modelTemp = [@[] mutableCopy];
    for (int i = 0; i < 4; i++) {
        _model[i] = NONE_BLOCK;
    }
    shareData = (AppDelegate*)[[UIApplication sharedApplication] delegate];

}
//起点となるブロックのModelをいれる
-(void)randomBlock {
    [self resetBlock];
    _model[0] = [NSNumber numberWithInteger:(int)arc4random_uniform(4) + 1];
    _model[1] = [NSNumber numberWithInteger:(int)arc4random_uniform(4) + 1];
    shareData.row = 0;
    shareData.col = 4;
}
//Modelのリセット
-(void) resetBlock {
    _model = [@[] mutableCopy];
    for (int i = 0; i < 4; i++) {
        _model[i] = NONE_BLOCK;
    }
}

//モデルの回転
-(void)turnBlock:(BOOL)reverce:(NSMutableArray*)stageModel{
    if (reverce) {
        [self turn2];
    } else {
        [self turn];
    }
    _model = [modelTemp mutableCopy];
    if((_model[0] != NONE_BLOCK || _model[2] != NONE_BLOCK) && shareData.col == -1) {
        shareData.col++;
    }
    if((_model[1] != NONE_BLOCK || _model[3] != NONE_BLOCK) && shareData.col == STAGE_COL-1) {
        shareData.col--;
    }
    if((_model[2] != NONE_BLOCK || _model[3] != NONE_BLOCK) && shareData.row == STAGE_ROW-2) {
        shareData.row--;
    }
    [self touchBlock:reverce:stageModel];
}
//回転動作後のブロックの状態の判定およびブロックのずらし
-(void)touchBlock:(BOOL)reverce:(NSMutableArray*)stageModel {
    int temp,tempData = -1,tempData2 = -1;
    for (int i = 0 ; i < 4; i++) {
        if(_model[i] != NONE_BLOCK){
            if(tempData != -1) {
                tempData2 = i;
            } else {
                tempData = i;
            }
        }
    }
    if(reverce){
        if(tempData%2 == tempData2%2 && tempData%2 == 0) {
            temp = [shareData currentBlock:stageModel:2];
            //縦
            [self bottomCheck:temp:stageModel];
        } else if(tempData%2 != tempData2%2 && tempData/2 == 0) {
            temp = [shareData currentBlock:stageModel:0];
            //横上
            [self leftCheck:temp :stageModel:reverce];
        } else if(tempData%2 != tempData2%2 && tempData/2 == 1) {
            temp = [shareData currentBlock:stageModel:3];
            //横下
            [self rightCheck:temp :stageModel:reverce];
        }
    } else {
        if(tempData%2 == tempData2%2 && tempData%2 == 1) {
            temp = [shareData currentBlock:stageModel:3];
            //縦右
            [self bottomCheck:temp:stageModel];
            
        } else if(tempData%2 != tempData2%2 && tempData/2 == 0) {
            temp = [shareData currentBlock:stageModel:1];
            //横上
            [self rightCheck:temp :stageModel:reverce];
        } else if(tempData%2 != tempData2%2 && tempData/2 == 1) {
            temp = [shareData currentBlock:stageModel:2];
            //横下
            [self leftCheck:temp :stageModel:reverce];
        }

    }
}

//回転後にそれぞれの方向にぶつかったか
-(void)bottomCheck:(int)num:(NSMutableArray*)stageModel {
    if((stageModel[num] != NONE_BLOCK) ||
       (stageModel[num] != NONE_BLOCK && stageModel[num - STAGE_COL] == NONE_BLOCK)) {
        shareData.row--;
    }
}
-(void)leftCheck:(int)num:(NSMutableArray*)stageModel:(BOOL)reverce {
    NSNumber *tempNumber;
    if((stageModel[num] != NONE_BLOCK && shareData.col == STAGE_COL-2) ||
       (stageModel[num+1] != NONE_BLOCK && shareData.col == 0) ||
       (stageModel[num] != NONE_BLOCK && stageModel[num+2] != NONE_BLOCK)) {
        if(stageModel[num+1] != NONE_BLOCK && shareData.col == 0){
            shareData.col--;
        }
        if (!reverce) {
            [self turn];
            [self turn];
        }
        [self turn];
        tempNumber = _model[1];
        _model[1] = _model[3];
        _model[3] = tempNumber;
    } else if(stageModel[num] != NONE_BLOCK && stageModel[num + 2] == NONE_BLOCK ){
        shareData.col++;
    }
}
-(void)rightCheck:(int)num:(NSMutableArray*)stageModel:(BOOL)reverce {
    NSNumber *tempNumber;
    if((stageModel[num] != NONE_BLOCK && shareData.col == 0) ||
       (stageModel[num-1] != NONE_BLOCK && shareData.col == STAGE_COL-2) ||
       (stageModel[num] != NONE_BLOCK && stageModel[num-2] != NONE_BLOCK)) {
        if(stageModel[num-1] != NONE_BLOCK && shareData.col == STAGE_COL-2){
            shareData.col++;
        }
        [self turn];
        if (!reverce) {
            [self turn];
            [self turn];
        }
        tempNumber = _model[0];
        _model[0] = _model[2];
        _model[2] = tempNumber;
    } else if(stageModel[num] != NONE_BLOCK && stageModel[num - 2] == NONE_BLOCK ){
        shareData.col--;
    }
}

//回転
-(void)turn{
    modelTemp[0] = _model[2];
    modelTemp[1] = _model[0];
    modelTemp[2] = _model[3];
    modelTemp[3] = _model[1];
    _model = [modelTemp mutableCopy];
}
-(void)turn2 {
    modelTemp[0] = _model[1];
    modelTemp[1] = _model[3];
    modelTemp[2] = _model[0];
    modelTemp[3] = _model[2];
    _model = [modelTemp mutableCopy];
}
@end
