//
//  SoundPlay.h
//  puzzle
//
//  Created by totta on 2014/12/17.
//  Copyright (c) 2014年 totta. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface SoundPlay : NSObject
@property NSString *bgmpath;
@property NSURL *bgmurl;
@property AVAudioPlayer *sound,*sound2;
-(void)bomb;
-(void)timer;
-(void)fixed;
-(void)pause;
-(void)clearBlock;
@end
