//
//  StageModel.h
//  puzzle
//
//  Created by totta on 2014/12/13.
//  Copyright (c) 2014年 totta. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Const.h"
#import "AppDelegate.h"
#import "TurnBlockModel.h"

@interface StageModel : NSObject {
    AppDelegate *shareData;
}
@property NSMutableArray *model;
-(void) ModelNew;
-(BOOL) overBottom:(NSMutableArray*)blockModel;
-(BOOL) overRight:(NSMutableArray*)blockModel;
-(BOOL) overLeft:(NSMutableArray*)blockModel;
-(NSMutableArray*) clearBlock:(int)first:(int)second;
-(BOOL) clearBlockCheck:(int)first :(int)second;
-(int) clearBlockSum:(int)first :(int)second;
-(BOOL) GameOver;
-(void) deleteBlock:(NSMutableArray*)deleteArray;
-(NSMutableArray*) fixingBlock:(NSMutableArray*)blockModel;
-(NSMutableArray*)dropFixedBlock:(int)current;
-(NSMutableArray*) allmove;
@end
