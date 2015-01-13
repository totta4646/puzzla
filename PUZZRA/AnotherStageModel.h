//
//  StageModel.h
//  puzzle
//
//  Created by totta on 2014/12/13.
//  Copyright (c) 2014年 totta. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Const.h"
#import "TurnBlockModel.h"
#import "AppDelegate.h"

@interface AnotherStageModel : NSObject {
    TurnBlockModel *turnModel;
    AppDelegate *shareData;
}
@property NSMutableArray *model;
-(void) ModelNew;
-(void) randomModelAdd;
-(void) allLeftSlideBlock;
-(NSMutableArray*) clearBlock:(int)first:(int)second;
-(BOOL) clearBlockCheck:(int)first :(int)second;
-(int) clearBlockSum:(int)first :(int)second;
-(void) deleteBlock:(NSMutableArray*)deleteArray;
-(NSMutableArray*)dropFixedBlock:(int)current;
-(NSMutableArray*)allmove;
-(NSMutableArray*)bombCurrent:(int)current;
-(BOOL)stageEmpty;
-(BOOL)gameover;
@end
