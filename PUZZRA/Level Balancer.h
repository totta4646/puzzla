//
//  Level Balancer.h
//  PUZZRA
//
//  Created by totta on 2014/12/23.
//  Copyright (c) 2014年 totta. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Level_Balancer : NSObject {
    int level;
}
-(void)levelNew;
-(float)levelup:(float)speed;
-(BOOL)levelcheck:(int)score;

@end
