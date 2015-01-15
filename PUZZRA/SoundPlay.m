//
//  SoundPlay.m
//  puzzle
//
//  Created by totta on 2014/12/17.
//  Copyright (c) 2014年 totta. All rights reserved.
//

#import "SoundPlay.h"

@implementation SoundPlay

-(void) soundNew {
    ShareData = (AppDelegate*)[[UIApplication sharedApplication] delegate];
}

-(void)bomb {
    _bgmpath = [[NSBundle mainBundle] pathForResource:@"bomb1" ofType:@"mp3"];
    [self soundPlay];
}
-(void)timer {
    _bgmpath = [[NSBundle mainBundle] pathForResource:@"status03" ofType:@"mp3"];
    [self soundPlay];
}
-(void)fixed {
    _bgmpath = [[NSBundle mainBundle] pathForResource:@"puyon1" ofType:@"mp3"];
    [self soundPlay];
}
-(void)pause {
    _bgmpath = [[NSBundle mainBundle] pathForResource:@"decision4" ofType:@"mp3"];
    [self soundPlay];
}
-(void)clearBlock {
    _bgmpath = [[NSBundle mainBundle] pathForResource:@"button75" ofType:@"mp3"];
    [self soundPlay];
}

-(void)bgm {
    _bgmpath = [[NSBundle mainBundle] pathForResource:@"コーヒータイム" ofType:@"mp3"];
    [self soundPlay2];
}
-(void)bgm2 {
    _bgmpath = [[NSBundle mainBundle] pathForResource:@"modern_room_#214" ofType:@"mp3"];
    [self soundPlay2];
}
-(void)bgm3 {
    _bgmpath = [[NSBundle mainBundle] pathForResource:@"TALK_and_WALK" ofType:@"mp3"];
    [self soundPlay2];
}
-(void)timerbgm {
    _bgmpath = [[NSBundle mainBundle] pathForResource:@"おふざけサウンド" ofType:@"mp3"];
    [self soundPlay2];
}



-(void)soundPlay {
    _bgmurl = [NSURL fileURLWithPath:_bgmpath];
    _sound = [[AVAudioPlayer alloc]initWithContentsOfURL:_bgmurl error:nil];
    _sound.currentTime = 0;
    [_sound play];
}
-(void)soundPlay2 {
    _bgmurl = [NSURL fileURLWithPath:_bgmpath];
    _sound2 = [[AVAudioPlayer alloc]initWithContentsOfURL:_bgmurl error:nil];
    _sound2.numberOfLoops = -1;
    [_sound2 play];
}
-(void)stopbgm {
    [_sound2 stop];
}

@end
