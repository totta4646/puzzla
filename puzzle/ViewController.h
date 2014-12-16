//
//  ViewController.h
//  puzzle
//
//  Created by totta on 2014/12/12.
//  Copyright (c) 2014年 totta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Const.h"
#import "StageModel.h"
#import "TurnBlockModel.h"
#import "AppDelegate.h"
#import "UIColor+Hex.h"

@interface ViewController : UIViewController {
    StageModel *stageModel;
    TurnBlockModel *blockModel;
    UIView *gameView,*ButtonView,*scoreView,*pauseView;
    UIColor *tempColor;
    UIButton *leftButton,*rightButton,*downButton,*turnButton,*turnButtonReverce,*pauseButton,*resetButton,*resumeButton,*homeButton,*stageCell;
    AppDelegate *shareData;
    NSTimer *autoDown,*timeout,*longtap;
    float speed;
    int touchCount,firstNum,secondNum,*score;
    BOOL pause;
}
//@property (nonatomic, assign) UIButton *stageCell;
-(void) drowview;
-(void) removeStageBlock;
@end

