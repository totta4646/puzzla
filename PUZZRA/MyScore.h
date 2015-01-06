//
//  MyScore.h
//  PUZZRA
//
//  Created by totta on 2014/12/26.
//  Copyright (c) 2014年 totta. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyScore : NSObject {
    int maxChain,tempChian,score,tempscore,maxscore;
    
}
-(void)scoreNew;

-(int)getScore;
-(void)useItem;
-(void)addScore:(int)add;
-(void)checkMaxScore:(int)sendmaxtempscore;
-(int)countMaxChain;
-(void)changeNextBlock;
-(int)getMaxChainScore;
-(int)getMaxScore;
-(int)getcurrentaddscore;

    
@end
