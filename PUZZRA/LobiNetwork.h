//
//  LobiNetwork.h
//  PUZZRA
//
//  Created by totta on 2014/12/20.
//  Copyright (c) 2014年 totta. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <LobiCore/LobiAPI.h>
#import <LobiRanking/LobiRanking.h>
#import "AppDelegate.h"

@interface LobiNetwork : NSObject {
    LobiNetworkResponse *tempData;
    NSTimer *apiTimeOut;
    BOOL timeout;
}
-(BOOL) signUp;
-(BOOL) rename:(NSString*)newname;
-(BOOL) sendScore:(int)score;
-(BOOL) sendMaxChainScore:(int)score;
-(BOOL) sendMaxScore:(int)score;
-(void) updateImage:(UIImage*)sendData;
-(NSString*)getuserName;
-(UIImage*)getuserImage;
-(LobiNetworkResponse*)hiScoredata;
-(LobiNetworkResponse*)maxchaindata;
-(LobiNetworkResponse*)maxscoredata;
@end
