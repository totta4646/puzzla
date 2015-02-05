//
//  ViewController.h
//  PUZZRA
//
//  Created by totta on 2014/12/19.
//  Copyright (c) 2014年 totta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayViewController.h"
#import "AnotherPlayViewController.h"
#import <LobiCore/LobiCore.h>
#import <LobiRanking/LobiRanking.h>
#import "LobiNetwork.h"
#import "MyPageViewController.h"
#import "AppDelegate.h"
#import "SoundPlay.h"

@protocol modalViewDelegate <NSObject>
-(void) modalViewWillClose;
@end


@interface ViewController : UIViewController {
    UIButton *playButton,*anotherplayButton,*rankingButton,*helpButton,*helpButton2;
    LobiNetwork *api;
    AppDelegate *ShareData;
    UIActivityIndicatorView *indicator;
    SoundPlay *sound;
    UIImage *help,*helpViewimage,*helpViewimage2;
    BOOL helpStatus;
}
@end

