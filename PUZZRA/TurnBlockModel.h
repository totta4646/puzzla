//
//  TurnBlockModel.h
//  puzzle
//
//  Created by totta on 2014/12/13.
//  Copyright (c) 2014年 totta. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Const.h"
#import "AppDelegate.h"


@interface TurnBlockModel : NSObject {
    NSMutableArray *modelTemp;
    AppDelegate *shareData;
}
@property NSMutableArray *model;
@property int row,col;
-(void)ModelNew;
-(void)randomBlock;
-(void)turnBlock:(BOOL)reverce:(NSMutableArray*)stageModel;
-(void)randomItem;
-(void)randomItem2;
-(int)currentBlock:(NSMutableArray*)blockModel:(int)i;
@end
