//
//  PlayViewController.h
//  puzzle
//
//  Created by totta on 2014/12/12.
//  Copyright (c) 2014年 totta. All rights reserved.
//

#import "Const.h"
#import "AnotherStageModel.h"
#import "AppDelegate.h"
#import "UIColor+Hex.h"
#import "SoundPlay.h"
#import "ViewController.h"
#import "AppDelegate.h"
#import "LobiNetwork.h"
#import "Level Balancer.h"
#import "MyScore.h"

@interface AnotherPlayViewController : UIViewController {
    AnotherStageModel *stageModel;
    SoundPlay *sound;
    AppDelegate *shareData;
    LobiNetwork *api;
    Level_Balancer *level;
    MyScore *score;
    UIView *gameView,*ButtonView,*scoreView,*pauseView;
    UIColor *tempColor;
    UIButton *leftButton,*rightButton,*downButton,*turnButton,*turnButtonReverce,*pauseButton,*resetButton,*resumeButton,*homeButton,*stageCell;
    NSTimer *mTimer,*longtap,*dragPointer;
    UILabel *scoreTitle,*stageLabel;
    float speed,currentPointX,currentPointY;
    int touchCount,firstNum,secondNum,turnCount,labelCount,clearCount,speedTempScore,tempDragPoint,tempscore;
    BOOL pause,bomb,timerOn,DragOn;
    id delegate;
    NSTimeInterval startTime;
}
@property (nonatomic,retain) id delegate;
-(void) drowview;
-(void) removeStageBlock;
@end

