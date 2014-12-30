//
//  LobiRanking.h
//  LobiSDK
//
//  Created by takahashi-kohei on 2014/03/16.
//  Copyright (c) 2014年 KAMEDAkyosuke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "LobiAPI+Ranking.h"

@interface LobiRanking : NSObject

+ (instancetype)sharedInstance;
+ (NSString*)SDKVersion;
+ (void)presentRanking;

@end
