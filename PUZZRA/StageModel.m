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

-(BOOL)GameOver {
    if(_model[14] != NONE_BLOCK || _model[15] != NONE_BLOCK) {
        return true;
    }
    return false;
}

//turnModelからstageModelへの以降
-(NSMutableArray*)fixingBlock:(NSMutableArray*)blockModel {
    NSMutableArray *temparray;
    temparray = [@[] mutableCopy];
    temparray[0] = [NSNumber numberWithInt:-1];
    int count = 0;
    for (int i = 3; i >= 0; i--) {
        if(blockModel[i] != NONE_BLOCK){
            int temp = [shareData currentBlock:blockModel :i];
            _model[temp] = blockModel[i];
            temparray[count] = [NSNumber numberWithInt:temp];
            count++;
            //[self dropFixedBlock:(int)temp];
        }
    }
    return temparray;
}
//下に空きがあればつめるメソッド -> もしかしたらallmoveが軽かったらそっちで全てやるかも
-(NSMutableArray*)dropFixedBlock:(int)current {
    NSMutableArray *temparray;
    temparray = [@[] mutableCopy];
    temparray[0] = [NSNumber numberWithInt:-1];
    int temp = current%STAGE_COL+STAGE_COL*STAGE_ROW-STAGE_COL,sum,sum2;
    for (int i = 0 ;i < STAGE_ROW;i++) {
        sum = temp - i*STAGE_COL;
        if(_model[sum] == NONE_BLOCK) {
            for (int j = i + 1; j < STAGE_ROW; j++) {
                sum2 = temp - j*STAGE_COL;
                if(_model[sum2] != NONE_BLOCK) {
                    _model[sum] = _model[sum2];
                    _model[sum2] = NONE_BLOCK;
                    temparray[0] = [NSNumber numberWithInt:sum];
                    temparray[1] = [NSNumber numberWithInt:sum2];
                    return temparray;
                }
            }
        }
    }
    return temparray;
}
//ブロックを消す確認のメソッド
-(NSMutableArray*) clearBlock:(int)first :(int)second {
    int firstCol = first%STAGE_COL,firstRow = first/STAGE_COL,
    secondCol = second%STAGE_COL,secondRow = second/STAGE_COL,
    tempCol = firstCol - secondCol,tempRow = firstRow - secondRow,
    ii,jj,count = 0;
    NSNumber *tempNumber;
    NSMutableArray *tempArray = [@[] mutableCopy];
    tempNumber = _model[first];
    if(tempNumber == NONE_BLOCK) {
        return false;
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
    return tempArray;
}
-(BOOL) clearBlockCheck:(int)first :(int)second {
    int firstCol = first%STAGE_COL,firstRow = first/STAGE_COL,
    secondCol = second%STAGE_COL,secondRow = second/STAGE_COL,
    tempCol = firstCol - secondCol,tempRow = firstRow - secondRow;
    if((tempCol == 0 && abs(tempRow) < 2) ||
       (tempRow == 0 && abs(tempCol) < 2)) {
        return false;
    }
    return true;
}
-(int) clearBlockSum:(int)first :(int)second {
    int firstCol = first%STAGE_COL,firstRow = first/STAGE_COL,
    secondCol = second%STAGE_COL,secondRow = second/STAGE_COL,
    tempCol = firstCol - secondCol,tempRow = firstRow - secondRow,
    ii,jj,count = 0;
    NSNumber *tempNumber;
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
                count++;
            } else {
                return 0;
            }
        }
    }
    return count;
}
-(BOOL)stageEmpty {
    for (int i = 0; i < STAGE_COL * STAGE_ROW; i++) {
        if(_model[i] != NONE_BLOCK) {
            return false;
        }
    }
    return true;
}
-(NSMutableArray*) bombCurrent: (int) current {
    NSMutableArray * tempNumber = [@[] mutableCopy];
    if(current%STAGE_COL == STAGE_COL - 1 &&
       current/STAGE_COL == STAGE_ROW - 1) {
        tempNumber[0] = [NSNumber numberWithInt:current - STAGE_COL - 1];
        tempNumber[1] = [NSNumber numberWithInt:current - STAGE_COL];
        tempNumber[2] = [NSNumber numberWithInt:current - 1];
        tempNumber[3] = [NSNumber numberWithInt:current];
    } else if(current%STAGE_COL == 0 &&
              current/STAGE_COL == STAGE_ROW - 1) {
        tempNumber[0] = [NSNumber numberWithInt:current - STAGE_COL];
        tempNumber[1] = [NSNumber numberWithInt:current - STAGE_COL + 1];
        tempNumber[2] = [NSNumber numberWithInt:current];
        tempNumber[3] = [NSNumber numberWithInt:current + 1];
    } else if(current%STAGE_COL == 0) {
        tempNumber[0] = [NSNumber numberWithInt:current - STAGE_COL];
        tempNumber[1] = [NSNumber numberWithInt:current - STAGE_COL + 1];
        tempNumber[2] = [NSNumber numberWithInt:current];
        tempNumber[3] = [NSNumber numberWithInt:current + 1];
        tempNumber[4] = [NSNumber numberWithInt:current + STAGE_COL];
        tempNumber[5] = [NSNumber numberWithInt:current + STAGE_COL + 1];
        
    } else if(current%STAGE_COL == STAGE_COL - 1) {
        tempNumber[0] = [NSNumber numberWithInt:current - STAGE_COL - 1];
        tempNumber[1] = [NSNumber numberWithInt:current - STAGE_COL];
        tempNumber[2] = [NSNumber numberWithInt:current - 1];
        tempNumber[3] = [NSNumber numberWithInt:current];
        tempNumber[4] = [NSNumber numberWithInt:current + STAGE_COL - 1];
        tempNumber[5] = [NSNumber numberWithInt:current + STAGE_COL];
    } else if(current/STAGE_COL == STAGE_ROW - 1) {
        tempNumber[0] = [NSNumber numberWithInt:current - STAGE_COL - 1];
        tempNumber[1] = [NSNumber numberWithInt:current - STAGE_COL];
        tempNumber[2] = [NSNumber numberWithInt:current - STAGE_COL + 1];
        tempNumber[3] = [NSNumber numberWithInt:current - 1];
        tempNumber[4] = [NSNumber numberWithInt:current];
        tempNumber[5] = [NSNumber numberWithInt:current + 1];
    } else {
        tempNumber[0] = [NSNumber numberWithInt:current - STAGE_COL - 1];
        tempNumber[1] = [NSNumber numberWithInt:current - STAGE_COL];
        tempNumber[2] = [NSNumber numberWithInt:current - STAGE_COL + 1];
        tempNumber[3] = [NSNumber numberWithInt:current - 1];
        tempNumber[4] = [NSNumber numberWithInt:current];
        tempNumber[5] = [NSNumber numberWithInt:current + 1];
        tempNumber[6] = [NSNumber numberWithInt:current + STAGE_COL - 1];
        tempNumber[7] = [NSNumber numberWithInt:current + STAGE_COL];
        tempNumber[8] = [NSNumber numberWithInt:current + STAGE_COL + 1];
    }
    return tempNumber;
}

//アニメーション用のメソッド
-(NSMutableArray*) allmove {
    int count = 0;
    NSMutableArray *tempArray;
    tempArray = [@[] mutableCopy];
    for(int i = STAGE_COL * STAGE_ROW -1 ; i >  STAGE_COL * STAGE_ROW - (STAGE_COL + 1); i--) {
        if(_model[i] == NONE_BLOCK) {
            for (int j = 0; 0 < i - STAGE_COL * j; j++) {
                if(_model[i-STAGE_COL*j] != NONE_BLOCK) {
                    tempArray[count] = [NSNumber numberWithInteger:i - STAGE_COL * j];
                    count++;
                    tempArray[count] = [NSNumber numberWithInteger:i];
                    count++;
                    break;
                }
            }
        }
    }
    [self alldown];
    return tempArray;
}

//全部のブロックを移動させる
-(void) alldown {
    for (int j = 0; j < 9; j++) {
        for(int i = STAGE_COL * STAGE_ROW -1 ; i > STAGE_COL; i--) {
            if(_model[i] == NONE_BLOCK) {
                _model[i] = _model[i - STAGE_COL];
                _model[i - STAGE_COL] = NONE_BLOCK;
            }
        }
    }
}
//範囲を選択他ものに対してstageModel上のデータを消す
-(void) deleteBlock:(NSMutableArray*)deleteArray {
    int count = (int)[deleteArray count];
    for (int i = 0; i < count; i++) {
        _model[[deleteArray[i] intValue]] = NONE_BLOCK;
    }
    [self allmove];
}

-(void) replaceBlock:(int)current:(int)after {
    NSNumber *temp = _model[current];
    _model[current] = _model[after];
    _model[after] = temp;
}

-(NSNumber*) checkCurrentBlockStatus:(int)current {
    return _model[current];
}
//移動操作系
//それぞれの方向に対しての制御
-(BOOL)overBottom:(NSMutableArray*)blockModel {
    for (int i = 0 ; i < 4; i++) {
        if(blockModel[i] != NONE_BLOCK){
            int temp =[shareData currentBlock:blockModel :i];
            if(temp >= STAGE_COL * STAGE_ROW -STAGE_COL || _model[temp + STAGE_COL] != NONE_BLOCK){
                //                [self fixingBlock:blockModel];
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
