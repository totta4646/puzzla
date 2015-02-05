//
//  PlayViewController.h
//  puzzle
//
//  Created by totta on 2014/12/12.
//  Copyright (c) 2014年 totta. All rights reserved.
//

#import "Const.h"
#import "StageModel.h"
#import "TurnBlockModel.h"
#import "AppDelegate.h"
#import "UIColor+Hex.h"
#import "SoundPlay.h"
#import "ViewController.h"
#import "AppDelegate.h"
#import "LobiNetwork.h"
#import "Level Balancer.h"
#import "MyScore.h"
#import <sys/sysctl.h>

@interface PlayViewController : UIViewController {
    StageModel *stageModel;
    TurnBlockModel *blockModel;
    SoundPlay *sound;
    AppDelegate *shareData;
    LobiNetwork *api;
    Level_Balancer *level;
    MyScore *score;

    float hoge;
    UIAlertView *alert;
    UIActivityIndicatorView *indicator;
    UIView *gameView,*ButtonView,*scoreView,*pauseView;
    UIColor *tempColor;
    UIButton *leftButton,*rightButton,*downButton,*turnButton,*turnButtonReverce,*pauseButton,*resetButton,*resumeButton,*homeButton,*stageCell;
    NSTimer *autoDown,*timeout,*longtap,*dragPointer;
    UILabel *scoreTitle,*stageLabel;
    float speed,currentPointX,currentPointY;
    int touchCount,firstNum,secondNum,labelCount,clearCount,speedTempScore,tempDragPoint;
    BOOL pause,bomb,timerOn,DragOn,turnMode,gameOver,levelup;
    id delegate;
}
@property (nonatomic,retain) id delegate;
-(void) drowview;
-(void) removeStageBlock;
@end

