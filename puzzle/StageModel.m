//
//  StageModel.m
//  puzzle
//
//  Created by totta on 2014/12/13.
//  Copyright (c) 2014年 totta. All rights reserved.
//

#import "StageModel.h"

@implementation StageModel
//初期設定
-(void) ModelNew {    
    //stageBlock: 11 * 10 = 110マス
    _model = [@[] mutableCopy];
    for (int i = 0; i < STAGE_COL * STAGE_ROW; i++) {
        _model[i] = NONE_BLOCK;
    }
    shareData = (AppDelegate*)[[UIApplication sharedApplication] delegate];
}

//turnModelからstageModelへの以降
-(void) fixingBlock:(NSMutableArray*)blockModel {
    for (int i = 3; i >= 0; i--) {
        if(blockModel[i] != NONE_BLOCK){
            int temp = [shareData currentBlock:blockModel :i];
            _model[temp] = blockModel[i];
            [self dropFixedBlock:(int)temp];
        }
    }
}
//下に空きがあればつめるメソッド -> もしかしたらallmoveが軽かったらそっちで全てやるかも
-(void)dropFixedBlock:(int)current {
    int temp = current%STAGE_COL+STAGE_COL*STAGE_ROW-STAGE_COL,sum,sum2;
    for (int i = 0 ;i < STAGE_ROW;i++) {
        sum = temp - i*STAGE_COL;
        if(_model[sum] == NONE_BLOCK) {
            for (int j = i + 1; j < STAGE_ROW; j++) {
                sum2 = temp - j*STAGE_COL;
                if(_model[sum2] != NONE_BLOCK) {
                    _model[sum] = _model[sum2];
                    _model[sum2] = NONE_BLOCK;
                    return;
                }
            }
        }
    }
}
//ブロックを消す確認のメソッド
-(BOOL) clearBlock:(int)first :(int)second {
    int firstCol = first%STAGE_COL,firstRow = first/STAGE_COL,
        secondCol = second%STAGE_COL,secondRow = second/STAGE_COL,
        tempCol = firstCol - secondCol,tempRow = firstRow - secondRow,
        ii,jj,count = 0;
    NSNumber *tempNumber;
    NSMutableArray *tempArray = [@[] mutableCopy];
    if (_model[first] != _model[second]) {
        return false;
    } else {
        tempNumber = _model[first];
    }
    for (int i = 0; i <= abs(tempRow); i++) {
        if (tempRow > 0) {
            ii = i *(-1);
        } else {
            ii = i;
        }
        for (int j = 0; j <= abs(tempCol); j++) {
            if (tempCol > 0) {
                jj = j *(-1);
            } else {
                jj = j;
            }
            if(_model[first + ii * STAGE_COL + jj] == tempNumber) {
                tempArray[count] = [NSNumber numberWithInt:first+ ii * STAGE_COL + jj];
                count++;
            } else {
                return false;
            }
        }
    }
    [self deleteBlock:tempArray];
    return true;
}
//全部のブロックを移動させる
-(void) allmove {
    for(int i = STAGE_COL * STAGE_ROW -1 ; i > STAGE_COL; i--) {
        if(_model[i] == NONE_BLOCK) {
            _model[i] = _model[i - STAGE_COL];
            _model[i - STAGE_COL] = NONE_BLOCK;
        }
    }
}
//範囲を選択他ものに対してstageModel上のデータを消す
-(void) deleteBlock:(NSMutableArray*)deleteArray {
    int count = [deleteArray count];
    for (int i = 0; i < count; i++) {
        _model[[deleteArray[i] intValue]] = NONE_BLOCK;
    }
    for (int i = 0; i < 9; i++) {
     [self allmove];   
    }
}


//移動操作系
//それぞれの方向に対しての制御
-(BOOL)overBottom:(NSMutableArray*)blockModel {
    for (int i = 0 ; i < 4; i++) {
        if(blockModel[i] != NONE_BLOCK){
            int temp =[shareData currentBlock:blockModel :i];
            if(temp >= STAGE_COL * STAGE_ROW -STAGE_COL || _model[temp + STAGE_COL] != NONE_BLOCK){
                [self fixingBlock:blockModel];
                return true;
            }
        }
    }
    return false;
}
-(BOOL)overLeft:(NSMutableArray*)blockModel {
    for (int i = 0 ; i < 4; i++) {
        if(blockModel[i] != NONE_BLOCK){
            int temp =[shareData currentBlock:blockModel :i];
            if(temp%STAGE_COL == 0 || _model[temp - 1] != NONE_BLOCK){
                return true;
            }
        }
    }
    return false;
}
-(BOOL)overRight:(NSMutableArray*)blockModel {
    for (int i = 0 ; i < 4; i++) {
        if(blockModel[i] != NONE_BLOCK){
            int temp =[shareData currentBlock:blockModel :i];
            if(temp%STAGE_COL == 9 || _model[temp + 1] != NONE_BLOCK){
                return true;
            }
        }
    }
    return false;
}
@end
