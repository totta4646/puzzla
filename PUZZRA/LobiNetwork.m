//
//  LobiNetwork.m
//  PUZZRA
//
//  Created by totta on 2014/12/20.
//  Copyright (c) 2014年 totta. All rights reserved.
//

#import "LobiNetwork.h"

@implementation LobiNetwork

/**
 *  Lobiのアカウントに自動的にsignup
 *  trueで成功
 */
-(BOOL) signUp {
    __block BOOL success = true;
    __block BOOL api = false;
    timeout = false;
    [LobiAPI signupWithBaseName:@"player"
                     completion:^(LobiNetworkResponse *res){
                         if (res.error) {
                             success = false;
                         }
                         api = true;
                     }];
    [self setTimeOut];
    while (!api) {
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.5f]];
        if(timeout) {
            return false;
        }
    }
    return success;
}
/**
 *  プレイ後にスコアを送信する
 *
 *  @param score 送信するスコア
 *
 *  @return 成功したか
 */
-(BOOL) sendScore:(int)score {
    __block BOOL success = true;
    __block BOOL api = false;
    timeout = false;
    [LobiAPI sendRanking:@"puzzra_hiscore_141219"
                   score:score
                 handler:^(LobiNetworkResponse *res) {
                     if (res.error) {
                         success = false;
                     }
                     api = true;
                 }];
    [self setTimeOut];
    while (!api) {
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.5f]];
        if(timeout) {
            return false;
        }
    }
//    NSLog(@"%d",success);
    return success;
}
/**
 *  プレイ後に最大連鎖数を送信する
 *
 *  @param score 送信する最大連鎖数
 *
 *  @return 成功したかどうか
 */
-(BOOL) sendMaxChainScore:(int)score {
    __block BOOL success = true;
    __block BOOL api = false;
    timeout = false;
    [LobiAPI sendRanking:@"puzzra_maxchain_141219"
                   score:score
                 handler:^(LobiNetworkResponse *res) {
                     if (res.error) {
                         success = false;
                     }
                     api = true;
                 }];
    while (!api) {
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.5f]];
        if(timeout) {
            return false;
        }
    }
    return success;
}
-(BOOL) sendMaxScore:(int)score {
    __block BOOL success = true;
    __block BOOL api = false;
    timeout = false;
    [LobiAPI sendRanking:@"puzzra_anotherscore_141219"
                   score:score
                 handler:^(LobiNetworkResponse *res) {
                     if (res.error) {
                         success = false;
                     }
                     api = true;
                 }];
    [self setTimeOut];
    while (!api) {
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.5f]];
        if(timeout) {
            return false;
        }
    }
    return success;
}

/**
 *  名前の変更
 *
 *  @param newname 変更する名前
 */
-(int) rename:(NSString*)newname {
    if([newname length] > 6) {
        return 4;
    }
    __block int success = 0;
    __block BOOL api = false;
    timeout = false;
    [LobiAPI updateUserName:newname
                 completion:^(LobiNetworkResponse *res){
                     if (res.error) {
                         success = 1;
                         if(400 == res.error.code) {
                             success = 2;
                         }
                     }
                     api = true;
                 }];
    [self setTimeOut];
    while (!api) {
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.5f]];
        if(timeout) {
            return false;
        }
    }
    return success;
}
/**
 *  ユーザーの登録されている画像の更新
 *
 *  @param sendData 変わる画像
 */
-(void) updateImage:(UIImage*)sendData {
    UIImage *data = sendData;
    [LobiAPI updateUserIcon:data
                 completion:^(LobiNetworkResponse *res){
                 }];
}
/**
 *  ユーザーの画像の取得
 *
 *  @return 写真の取得
 */
-(UIImage*)getuserImage {
    __block BOOL api = false;
    timeout = false;
    tempData = nil;
    timeout = false;
    [LobiAPI signupWithBaseName:@"player"
                     completion:^(LobiNetworkResponse *res){
                         if (res.error) {
                             return ;
                         }
                         tempData = res;
                         api = true;
                     }];
    [self setTimeOut2];
    while (!api) {
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.5f]];
        if(timeout) {
            return false;
        }
    }
    NSURL *url = [NSURL URLWithString:[tempData.dictionary objectForKey:@"icon"]];
    NSData *dt = [NSData dataWithContentsOfURL:url];
    UIImage *image = [[UIImage alloc] initWithData:dt];
    return image;
}

-(void) setTimeOut {
    apiTimeOut = [NSTimer scheduledTimerWithTimeInterval:5
                                                  target:self
                                                selector:@selector(stopApiLoading)
                                                userInfo:nil
                                                 repeats:NO];
}
-(void) setTimeOut2 {
    apiTimeOut = [NSTimer scheduledTimerWithTimeInterval:20
                                                  target:self
                                                selector:@selector(stopApiLoading)
                                                userInfo:nil
                                                 repeats:NO];
}
-(void) stopApiLoading {
    timeout = true;
}

/**
 *  ランキングデータの取得
 *
 *  @return ハイスコアのまとめたapi
 */
-(LobiNetworkResponse*)hiScoredata {
    __block BOOL api = false;
    timeout = false;
    [LobiAPI getRanking:@"puzzra_hiscore_141219"
                   type:KLRRankingRangeAll
                 origin:KLRRankingCursorOriginTop
                 cursor:1
                  limit:30
                handler:^(LobiNetworkResponse *res) {
                    if (res.error) {
                        return ;
                    }
                    tempData = res;
                    api = true;
                }];
    [self setTimeOut2];
    while (!api) {
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.5f]];
        if(timeout) {
            return false;
        }
    }
    return tempData;
}

/**
 *  ランキングデータの取得
 *
 *  @return 最大連鎖数のまとめたapi
 */
-(LobiNetworkResponse*)maxchaindata {
    __block BOOL api = false;
    timeout = false;
    [LobiAPI getRanking:@"puzzra_maxchain_141219"
                   type:KLRRankingRangeAll
                 origin:KLRRankingCursorOriginTop
                 cursor:1
                  limit:30
                handler:^(LobiNetworkResponse *res) {
                    if (res.error) {
                        return ;
                    }
                    tempData = res;
                    api = true;
                }];
    [self setTimeOut2];
    while (!api) {
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.5f]];
        if(timeout) {
            return false;
        }
    }
    return tempData;
}
/**
 *  ランキングデータの取得
 *
 *  @return 瞬間最大スコアのまとめたapi
 */
-(LobiNetworkResponse*)maxscoredata {
    __block BOOL api = false;
    timeout = false;
    [LobiAPI getRanking:@"puzzra_anotherscore_141219"
                   type:KLRRankingRangeAll
                 origin:KLRRankingCursorOriginTop
                 cursor:1
                  limit:30
                handler:^(LobiNetworkResponse *res) {
                    if (res.error) {
                        return ;
                    }
                    tempData = res;
                    api = true;
                }];
    [self setTimeOut2];
    while (!api) {
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.5f]];
        if(timeout) {
            return false;
        }
    }
    return tempData;
}
/**
 *  ユーザーの名前の取得
 *
 *  @return ユーザーの名前
 */
-(NSString*)getuserName {
    __block BOOL api = false;
    timeout = false;
    tempData = nil;
    [LobiAPI signupWithBaseName:@"player"
                     completion:^(LobiNetworkResponse *res){
                         if (res.error) {
                             return ;
                         }
                         tempData = res;
                         api = true;
                     }];
    [self setTimeOut];
    while (!api) {
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.5f]];
        if(timeout) {
            return false;
        }
    }
    NSString *name = [tempData.dictionary objectForKey:@"name"];
    return name;
}
@end
