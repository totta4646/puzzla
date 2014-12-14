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
-(BOOL) clearBlock:(int)first:(int)second;
-(BOOL) GameOver;
@end
