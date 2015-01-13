//
//  SoundPlay.h
//  puzzle
//
//  Created by totta on 2014/12/17.
//  Copyright (c) 2014年 totta. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "AppDelegate.h"

@interface SoundPlay : NSObject {
    AppDelegate *ShareData;
}
@property NSString *bgmpath;
@property NSURL *bgmurl;
@property AVAudioPlayer *sound,*sound2,*sound3,*sound4;
-(void)bomb;
-(void)timer;
-(void)fixed;
-(void)pause;
-(void)clearBlock;
-(void)bgm;
-(void)bgm2;
-(void)bgm3;
-(void)timerbgm;
-(void)stopbgm;
-(void)soundNew;
@end
