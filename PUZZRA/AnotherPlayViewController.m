//
//  PlayViewController.m
//  puzzle
//
//  Created by totta on 2014/12/12.
//  Copyright (c) 2014年 totta. All rights reserved.
//

#import "AnotherPlayViewController.h"


@interface AnotherPlayViewController ()

@end

@implementation AnotherPlayViewController
@synthesize delegate;
- (void)viewDidLoad {
    [super viewDidLoad];
    //model初期化
    DragOn = false;
    NSNotificationCenter*   nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(applicationDidEnterBackground) name:@"applicationDidEnterBackground" object:nil];
    api = [[LobiNetwork alloc]init];
    self.view.backgroundColor = [UIColor whiteColor];
    shareData = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    pause = false;
    sound = [[SoundPlay alloc]init];
    [sound bgm2];
    pauseButton = [[UIButton alloc]init];
    pauseButton.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:20];
    pauseView = [[UIView alloc]init];
    resetButton = [[UIButton alloc]init];
    resumeButton = [[UIButton alloc]init];
    resumeButton.tag = 1001;
    homeButton = [[UIButton alloc]init];
    pauseView.tag = 1000;
    turnCount = 0;
    labelCount = 0;
    clearCount = 0;
    stageModel = [[AnotherStageModel alloc]init];
    [stageModel ModelNew];
    level = [[Level_Balancer alloc]init];
    [level levelNew];
    indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    float w = indicator.frame.size.width;
    float h = indicator.frame.size.height;
    float x = self.view.frame.size.width/2 - w/2;
    float y = self.view.frame.size.height/2 - h/2;
    indicator.frame = CGRectMake(x, y, w, h);
    indicator.color = [UIColor blackColor];
    // 現在のサブビューとして登録する
    [self.view addSubview:indicator];
    
    //パズルをするViewの描写
    gameView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, STAGE_HEIGHT)];
    
    [self.view addSubview:gameView];
    [self drowView];
    scoreView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, STAGE_CELL * 2)];
    scoreView.backgroundColor = SCORE_COLOR;
    [self.view addSubview:scoreView];
    
    [self drowButton:scoreView :pauseButton :WIDTH*3/4 :STAGE_CELL :WIDTH/4 : STAGE_CELL :SCORE_COLOR :BLOCK_COLOR :@"PAUSE" :SCORE_COLOR :BUTTON_BORDER_WIDHT :@selector(wait:)];
    
    
    //ボタンのViewの描写
    ButtonView = [[UIView alloc]initWithFrame:CGRectMake(0, STAGE_HEIGHT, WIDTH, HEIGHT-STAGE_HEIGHT)];
    ButtonView.backgroundColor = SCORE_COLOR;
    scoreTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-STAGE_HEIGHT)];
    scoreTitle.text = @"00:00";
    scoreTitle.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:45];
    scoreTitle.textAlignment = NSTextAlignmentCenter;
    scoreTitle.textColor = [UIColor whiteColor];
    [self timerSetUp];
    
    [self.view addSubview:ButtonView];
    [ButtonView addSubview:scoreTitle];
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(handlePanGesture:)];
    panGesture.maximumNumberOfTouches = 1;
    [gameView addGestureRecognizer:panGesture];
}

- (void)timerSetUp {
    startTime = [NSDate timeIntervalSinceReferenceDate];
    mTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                              target:self
                                            selector:@selector(timeCounter)
                                            userInfo:nil
                                             repeats:YES];
    
}
- (void)timeCounter{
    double cTime = [NSDate timeIntervalSinceReferenceDate] - startTime;
    int minute = fmod((cTime/60), 60);
    int second = fmod(cTime, 60);
    tempscore = minute * 100 + second;
    scoreTitle.text = [NSString stringWithFormat:@"%02d:%02d", minute, second];
    scoreTitle.textColor = [UIColor whiteColor];
    if(minute >= 5) {
        [mTimer invalidate];
        [self gameover];
    }
}

/**
 *  x軸とy軸からモデルのどのブロックかを返すメソッド
 *
 *  @param pointX col
 *  @param pointY row
 *
 *  @return current model number
 */

-(int) currentPositon:(float)pointX:(float)pointY {
    int tempStageCell = (int)STAGE_CELL, currentY = (int)pointY - (tempStageCell * 2),sum,
    currentRow = currentY / tempStageCell,
    currentCol = (int)pointX / ((int)self.view.frame.size.width /((int)STAGE_COL));
    sum = currentCol + currentRow * 10;
    if (currentCol == 10) {
        return sum - 1;
    }
    return sum;
}
-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self.view];
    
    [super touchesBegan:touches withEvent:event];
    if(location.y < (float)STAGE_CELL * 2){
        DragOn = false;
        return;
    }
    currentPointX = location.x,currentPointY = location.y;
    DragOn = true;
    tempDragPoint = [self currentPositon:currentPointX :currentPointY];
    [self drowDragPoint:tempDragPoint];
    dragPointer = [NSTimer scheduledTimerWithTimeInterval:1
                                                   target:self
                                                 selector:@selector(resetDrag)
                                                 userInfo:nil
                                                  repeats:NO];
}
- (void)handlePanGesture:(UIPanGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateChanged){
        if ([dragPointer isValid]) {
            [dragPointer invalidate];
            dragPointer = [NSTimer scheduledTimerWithTimeInterval:2
                                                           target:self
                                                         selector:@selector(resetDrag)
                                                         userInfo:nil
                                                          repeats:NO];
        }
    }
    if (sender.state == UIGestureRecognizerStateEnded){
        CGPoint tapPoint = [sender translationInView:self.view];
        int movedPositionX = (int)currentPointX + (int)tapPoint.x,
        movedPositionY = (int)currentPointY + (int)tapPoint.y,
        DragPoint = [self currentPositon:movedPositionX:movedPositionY];
        if(DragPoint < 0 || DragPoint > STAGE_COL * (STAGE_ROW - 1) - 1 ||
           tempDragPoint > STAGE_COL * (STAGE_ROW - 1) - 1 || !DragOn) {
            return;
        }
        [self drowDragPoint:DragPoint];
        firstNum = tempDragPoint,secondNum = DragPoint;
        if([stageModel clearBlockCheck:firstNum :secondNum] &&
           [[stageModel clearBlock:firstNum :secondNum] count] > 2) {
            [self moveControll:firstNum:secondNum];
            [self removeEffectSelectBlock:[stageModel clearBlock:firstNum :secondNum]];
            //モデルを消すメソッド
            [stageModel deleteBlock:[stageModel clearBlock:firstNum :secondNum]];
            if([stageModel gameover]){
                [self gameover];
            }
            
            [sound clearBlock];
            [score countMaxChain];
            
            return;
        }
        if ([dragPointer isValid]) {
            [dragPointer invalidate];
            dragPointer = [NSTimer scheduledTimerWithTimeInterval:1
                                                           target:self
                                                         selector:@selector(resetDrag)
                                                         userInfo:nil
                                                          repeats:NO];
        }
    }
}
-(void) resetDrag {
    [self returndrowDragPoint:tempDragPoint];
}
-(void)allBind {
    pause = true;
}
-(void)allBind2 {
    [pauseButton setEnabled:NO];
}
-(void)allUnBind {
    [pauseButton setEnabled:YES];
    pause = false;
}
//ボタン操作
-(void)wait:(UIButton*)button{
    [sound pause];
    [self allBind];
    [self drowPauseView];
}
-(void)resume:(UIButton*)button{
    [sound pause];
    [self allUnBind];
    for(UIView* item in self.view.subviews) {
        if(item.tag == 1000 ) {
            [item removeFromSuperview];
        }
    }
}
-(void)reset:(UIButton*)button{
    [self allUnBind];
    for(UIView* item in self.view.subviews) {
        if(item.tag == 1000) {
            [item removeFromSuperview];
        }
    }
    for(UILabel* item in pauseView.subviews) {
        if(item.tag == 1000) {
            [item removeFromSuperview];
        }
    }
    [mTimer invalidate];
    [self timerSetUp];
    scoreTitle.text = @"00:00";
    startTime = [NSDate timeIntervalSinceReferenceDate];
    [stageModel ModelNew];
    [self drowView];
}
-(void)home:(UIButton*)button {
    [sound stopbgm];
    [delegate modalViewWillClose];
}

//描写されているものを消すメソッド
-(void) removeStageBlock {
    for(UIButton* item in gameView.subviews) {
        if(item.tag == 2000) {
            continue;
        }
        [item removeFromSuperview];
    }
}


//ボタンを描写するメソッド
- (void) drowButton :(UIView*)addView:(UIButton*)drowButton:(float)widthPoint:(float)heightPoint:(float)width:(float)height:(UIColor*)backGroundColor:(UIColor*)textColor:(NSString*)title:(UIColor*)borderColor:(float)borderWidth:(SEL)selector {

    [drowButton setTitle:title forState:UIControlStateNormal];
    drowButton.frame = CGRectMake(widthPoint, heightPoint, width, height);
    [drowButton addTarget:self action:selector
         forControlEvents:UIControlEventTouchDown];
    drowButton.backgroundColor = [backGroundColor colorWithAlphaComponent:0.7];
    [drowButton.layer setBorderWidth:borderWidth];
    [drowButton.layer setBorderColor:borderColor.CGColor];
    [addView addSubview:drowButton];
}

//stageのブロックの描写
-(void) drowView {
    [self removeStageBlock];
    for(int i = STAGE_COL * (STAGE_ROW - 1) - 1; i >= 0; i-- ){
        if(stageModel.model[i] == NONE_BLOCK) {
            continue;
        }
        stageLabel = [[UILabel alloc]initWithFrame:CGRectMake(i % STAGE_COL * STAGE_CELL,STAGE_CELL + i / STAGE_COL * STAGE_CELL + STAGE_CELL , STAGE_CELL, WIDTH/10)];
        stageLabel.backgroundColor = [self checkBlockColor:stageModel.model[i]];
        stageLabel.tag = i;
        [[stageLabel layer] setCornerRadius:10];
        [stageLabel setClipsToBounds:YES];
        [stageLabel.layer setBorderColor:BLOCK_BORDER_COLOR.CGColor];
        [gameView addSubview:stageLabel];
    }
}

-(void) drowPauseView {
    pauseView.frame = CGRectMake(0, 0, WIDTH, HEIGHT);
    pauseView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    [self.view addSubview:pauseView];
    
    [self drowButton:pauseView :resumeButton :STAGE_CELL * 2 :STAGE_CELL * 6 :STAGE_CELL*6 :STAGE_CELL  * 1.5:BUTTON_COLOR :BLOCK_COLOR4 :@"RESUME" :BUTTON_BORDER_COLOR :BUTTON_BORDER_WIDHT :@selector(resume:)];
    [self drowButton:pauseView :resetButton :STAGE_CELL * 2 :STAGE_CELL * 8 :STAGE_CELL*6 :STAGE_CELL  * 1.5:BUTTON_COLOR :BLOCK_COLOR4 :@"RESET" :BUTTON_BORDER_COLOR :BUTTON_BORDER_WIDHT :@selector(reset:)];
    [self drowButton:pauseView :homeButton :STAGE_CELL * 2 :STAGE_CELL * 10 :STAGE_CELL*6 :STAGE_CELL  * 1.5:BUTTON_COLOR :BLOCK_COLOR4 :@"HOME" :BUTTON_BORDER_COLOR :BUTTON_BORDER_WIDHT :@selector(home:)];
}
-(void) drowGameOverView {
    pauseView.frame = CGRectMake(0, 0, WIDTH, HEIGHT);
    pauseView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    [self.view addSubview:pauseView];
    UILabel *currentScore = [[UILabel alloc]initWithFrame:CGRectMake(0, STAGE_CELL*3, WIDTH, STAGE_CELL*6)];
    currentScore.text = scoreTitle.text;
    currentScore.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:65];
    currentScore.textColor = [UIColor whiteColor];
    currentScore.textAlignment = NSTextAlignmentCenter;
    currentScore.tag = 1000;
    [pauseView addSubview:currentScore];
    [self drowButton:pauseView :resetButton :STAGE_CELL * 2 :STAGE_CELL * 8 :STAGE_CELL*6 :STAGE_CELL  * 1.5:BUTTON_COLOR :BLOCK_COLOR4 :@"RESET" :BUTTON_BORDER_COLOR :BUTTON_BORDER_WIDHT :@selector(reset:)];
    [self drowButton:pauseView :homeButton :STAGE_CELL * 2 :STAGE_CELL * 10 :STAGE_CELL*6 :STAGE_CELL  * 1.5:BUTTON_COLOR :BLOCK_COLOR4 :@"HOME" :BUTTON_BORDER_COLOR :BUTTON_BORDER_WIDHT :@selector(home:)];
}



//色の判定
-(UIColor*)checkBlockColor:(NSNumber*)blockStatus {
    if(blockStatus == NONE_BLOCK) {
        return BLOCK_COLOR_NONE;
    }else if(blockStatus == BLOCK_STARUS) {
        return BLOCK_COLOR;
    }else if(blockStatus == BLOCK_STARUS2) {
        return BLOCK_COLOR2;
    }else if(blockStatus == BLOCK_STARUS3) {
        return BLOCK_COLOR3;
    }else if(blockStatus == BLOCK_STARUS4) {
        return BLOCK_COLOR4;
    }else {
        return BLOCK_COLOR5;
    }
}



-(void)gameover{
    [self allBind];
    for(UIButton* item in pauseView.subviews) {
        if(item.tag == 1001) {
            [item removeFromSuperview];
        }
    }
    [mTimer invalidate];
    [self drowGameOverView];
//    [self.view bringSubviewToFront:indicator];
//    [indicator startAnimating];
    if(![api sendMaxScore:tempscore]) {
//        [self alertOffline];
    }
    [indicator stopAnimating];
}

//スライドさせるとこ
-(void) moveControll:(int)first:(int)second {
    int tempFirstCol = first % STAGE_COL, tempSecondCol = second % STAGE_COL,
    tempFirstRow = first / STAGE_COL, tempSecondRow = second / STAGE_COL,
    diffCol = tempFirstCol - tempSecondCol,diffRow = tempFirstRow - tempSecondRow,
    ii;
    BOOL change = false;
    if (first < second) {
        first = second;
        change = true;
    }
    for(int i = 0; i < abs(diffCol) + 1; i++) {
        ii = i;
        if ((diffCol < 0 && change) ||
            (diffCol > 0 && !change)) {
            ii = i * -1;
        }
        for (int j = 0; 0 < ((first + i) - STAGE_ROW * (abs(diffRow) -1 + j)); j++) {
            [self movingEffect:first + ii - STAGE_COL * j:first + ii - STAGE_COL * (abs(diffRow) + 1 + j)];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void) drowDragPoint:(int)currentPosition {
    for(UIButton* item in gameView.subviews) {
        if(item.tag == currentPosition) {
            [gameView bringSubviewToFront:item];
            [UIView animateWithDuration:0.2
                             animations:^{
                                 item.backgroundColor = [UIColor colorWithHex:@"ff7f66"];
                                 item.transform = CGAffineTransformMakeScale(1.25, 1.25);
                             }
                             completion:^(BOOL finished){
                             }];
        }
    }
}
-(void) returndrowDragPoint:(int)currentPosition {
    for(UIButton* item in gameView.subviews) {
        if(item.tag >= 0 && item.tag < 200) {
            [gameView bringSubviewToFront:item];
            [UIView animateWithDuration:0.2
                             animations:^{
                                 item.backgroundColor = [self checkBlockColor:stageModel.model[item.tag]];
                                 item.transform = CGAffineTransformMakeScale(1, 1);
                             }
                             completion:^(BOOL finished){
                             }];
        }
    }
}
//落下のエフェクト
-(void) movingEffect:(int)movedPosition:(int)currentPosition {
    if(currentPosition < 0) {
        return;
    }
//    NSLog(@"\n移動後:%d\n移動前:%d",movedPosition,currentPosition);
    int currentCol = currentPosition%STAGE_COL,
    currentPositionRow = currentPosition/STAGE_COL,movedPositionRow = movedPosition/STAGE_COL,
    diffRow = movedPositionRow - currentPositionRow;
    for(UIButton* item in gameView.subviews) {
        if(item.tag == currentPosition) {
            [UIView animateWithDuration:0.2
                             animations:^{item.frame = CGRectMake(currentCol * STAGE_CELL,(currentPositionRow + 2) * STAGE_CELL + diffRow * STAGE_CELL,STAGE_CELL,STAGE_CELL);}
                             completion:^(BOOL finished){
                             }];
        }
    }
}
//描写されているものを消すメソッド
-(void) removeEffectSelectBlock:(NSMutableArray*)array {
    int count = (int)[array count];
    for(int i = 0; i < count; i++) {
        for(UIButton* item in gameView.subviews) {
            if(item.tag == [array[i] intValue]) {
                //付随するアニメーション
                [UIView animateWithDuration:0.2
                                 animations:^{
                                     item.transform = CGAffineTransformMakeRotation(M_PI);
                                     item.transform = CGAffineTransformMakeScale(2, 2);
                                     item.alpha = 0;
                                 }
                                 completion:^(BOOL finished){
                                     [item removeFromSuperview];
                                     if(count - 1 == i) {
                                         [stageModel allLeftSlideBlock];
                                         [self drowView];
                                     }
                                 }];
            }
        }
    }
}
-(void)alertView:(UIAlertView*)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        if(![api sendScore:[score getScore]]) {
            [self alertOffline];
        } else if(![api sendMaxChainScore:[score getMaxChainScore]]) {
            [self alertOffline];
        }
    }
}

-(void) alertOffline {
    UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"通信エラー"
                                                  message:@"スコアの送信に失敗しました。"
                                                 delegate:self
                                        cancelButtonTitle:@"Cancel"
                                        otherButtonTitles:@"ReTry", nil];
    [alert show];
}

- (void)applicationDidEnterBackground {
    [sound pause];
    [self allBind];
    [self drowPauseView];
}
@end
