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


@interface ViewController : UIViewController {
    StageModel *stageModel;
    TurnBlockModel *blockModel;
    UIView *gameView,*ButtonView;
    UIColor *tempColor;
    UIButton *leftButton,*rightButton,*downButton,*turnButton,*turnButtonReverce;
    AppDelegate *shareData;
    NSTimer *autoDown,*timeout;
    float speed;
    int touchCount,firstNum,secondNum;
}
-(void) drowview;
-(void) removeStageBlock;
@end

