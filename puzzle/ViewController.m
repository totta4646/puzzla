//
//  ViewController.m
//  puzzle
//
//  Created by totta on 2014/12/12.
//  Copyright (c) 2014年 totta. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()
    #define STAGE_HEIGHT WIDTH/STAGE_COL * 13
    #define STAGE_CELL WIDTH/STAGE_COL

@end

@implementation ViewController
//@synthesize stageCell;

- (void)viewDidLoad {
    [super viewDidLoad];
    //model初期化
    pause = false;
    downButton = [[UIButton alloc]init];
    UILongPressGestureRecognizer *gestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressedHandler:)];
    [downButton addGestureRecognizer:gestureRecognizer];
    leftButton = [[UIButton alloc]init];
    rightButton = [[UIButton alloc]init];
    turnButton = [[UIButton alloc]init];
    turnButtonReverce = [[UIButton alloc]init];
    pauseButton = [[UIButton alloc]init];
    pauseView = [[UIView alloc]init];
    resetButton = [[UIButton alloc]init];
    resumeButton = [[UIButton alloc]init];
    resumeButton.tag = 1001;
    homeButton = [[UIButton alloc]init];
    pauseView.tag = 1000;
    touchCount = 0;
    score = 0;
    shareData = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    stageModel = [[StageModel alloc]init];
    [stageModel ModelNew];
    blockModel = [[TurnBlockModel alloc]init];
    [blockModel ModelNew];
    //パズルをするViewの描写
    gameView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, STAGE_HEIGHT)];
    [self.view addSubview:gameView];
    [self drowView];
    scoreView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, STAGE_CELL * 2)];
    scoreView.backgroundColor = SCORE_COLOR;
    [self.view addSubview:scoreView];

    UILabel *scoreTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, STAGE_CELL, WIDTH/3, STAGE_CELL)];
    scoreTitle.text = @"SCORE:100000";
    scoreTitle.textAlignment = NSTextAlignmentCenter;
    scoreTitle.textColor = [UIColor whiteColor];
    [scoreView addSubview:scoreTitle];

    [self drowButton:scoreView :pauseButton :WIDTH*3/4 :STAGE_CELL :WIDTH/4 : STAGE_CELL :SCORE_COLOR :BLOCK_COLOR :@"PAUSE" :SCORE_COLOR :BUTTON_BORDER_WIDHT :@selector(wait:)];

    
    //ボタンのViewの描写
    ButtonView = [[UIView alloc]initWithFrame:CGRectMake(0, STAGE_HEIGHT, WIDTH, HEIGHT-STAGE_HEIGHT)];
    [self.view addSubview:ButtonView];
  
    [self drowButton:ButtonView :turnButtonReverce :0 :0 :WIDTH/2 :(HEIGHT-STAGE_HEIGHT)/3 :BUTTON_COLOR3 :BLOCK_COLOR :@"⇆" :BUTTON_BORDER_COLOR :BUTTON_BORDER_WIDHT :@selector(turnReverce:)];
    [self drowButton:ButtonView :turnButton :WIDTH/2 :0 :WIDTH/2 :(HEIGHT-STAGE_HEIGHT)/3 :BUTTON_COLOR3 :BLOCK_COLOR5 :@"⇄" :BUTTON_BORDER_COLOR :BUTTON_BORDER_WIDHT :@selector(turn:)];
    [self drowButton:ButtonView :leftButton :0 :(HEIGHT-STAGE_HEIGHT)/3 :WIDTH/2 :(HEIGHT-STAGE_HEIGHT)/3 :BUTTON_COLOR2 :BLOCK_COLOR2 :@"←" :BUTTON_BORDER_COLOR :BUTTON_BORDER_WIDHT :@selector(left:)];
    [self drowButton:ButtonView :rightButton :WIDTH/2 :(HEIGHT-STAGE_HEIGHT)/3 :WIDTH/2 :(HEIGHT-STAGE_HEIGHT)/3 :BUTTON_COLOR2 :BLOCK_COLOR3 :@"→" :BUTTON_BORDER_COLOR :1 :@selector(right:)];
    [self drowButton:ButtonView :downButton :0 :(HEIGHT-STAGE_HEIGHT)*2/3 :WIDTH :(HEIGHT-STAGE_HEIGHT)/3 :BUTTON_COLOR :BLOCK_COLOR4 :@"↓" :BUTTON_BORDER_COLOR :BUTTON_BORDER_WIDHT :@selector(down:)];

    [blockModel randomBlock];
    [self drowBaseView];
    [self drowTurnBlock];
    
    speed = 1.0;
    [self timerStart];
}

-(void) timerStart {
    autoDown = [NSTimer scheduledTimerWithTimeInterval:speed
                                                target:self
                                              selector:@selector(down:)
                                              userInfo:nil
                                               repeats:YES];
}
-(void)allBind {
    [downButton setEnabled:NO];
    [rightButton setEnabled:NO];
    [leftButton setEnabled:NO];
    [turnButton setEnabled:NO];
    [turnButtonReverce setEnabled:NO];
    pause = true;
}
-(void)allUnBind {
    [downButton setEnabled:YES];
    [rightButton setEnabled:YES];
    [leftButton setEnabled:YES];
    [turnButton setEnabled:YES];
    [turnButtonReverce setEnabled:YES];
    pause = false;
}
//ボタン操作
-(void)wait:(UIButton*)button{
    [autoDown invalidate];
    [self allBind];
    [self drowPauseView];
}
-(void)resume:(UIButton*)button{
    [self allUnBind];
    for(UIView* item in self.view.subviews) {
        if(item.tag == 1000 ) {
            [item removeFromSuperview];
        }
    }
    [self timerStart];
}
-(void)reset:(UIButton*)button{
    [self allUnBind];
    for(UIView* item in self.view.subviews) {
        if(item.tag == 1000) {
            [item removeFromSuperview];
        }
    }
    [stageModel ModelNew];
    [blockModel ModelNew];
    [self drowView];
    [blockModel randomBlock];
    [self drowTurnBlock];

    shareData.row = 0;
    shareData.col = 4;
    [self timerStart];
}
-(void)turn:(UIButton*)button{
    [blockModel turnBlock:(BOOL)false:(NSMutableArray*)stageModel.model];
    [self drowTurnBlock];
}
-(void)turnReverce:(UIButton*)button{
    [blockModel turnBlock:(BOOL)true:(NSMutableArray*)stageModel.model];
    [self drowTurnBlock];
}
-(void)left:(UIButton*)button{
    if([stageModel overLeft:blockModel.model]) {
        return;
    }
    shareData.col--;
    [self drowTurnBlock];
}
-(void)right:(UIButton*)button{
    if([stageModel overRight:blockModel.model]) {
        return;
    }
    shareData.col++;
    [self drowTurnBlock];
    
}
-(void)down:(UIButton*)button{
    if([stageModel overBottom:blockModel.model]) {
        NSMutableArray *check = [stageModel fixingBlock:blockModel.model];
        [self drowView];
        if([check[0] intValue] != -1){
            for (int i = 0; i < 2; i++) {
                NSMutableArray *check2 = [stageModel dropFixedBlock:[check[i] intValue]];
                if([check2[0] intValue] != -1) {
                    [self movingEffect2:([check2[0] intValue]) :[check2[1] intValue]];
                }
            }
        }
        [blockModel randomBlock];
        [self drowTurnBlock];
        [longtap invalidate];
        return;
    }
    shareData.row++;
    [self drowTurnBlock];
    
}
-(void)longPressedHandler:(UILongPressGestureRecognizer *)gestureRecognizer {
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
            longtap = [NSTimer scheduledTimerWithTimeInterval:0.05
                                                       target:self
                                                     selector:@selector(down:)
                                                     userInfo:nil
                                                      repeats:YES];
            break;
        case UIGestureRecognizerStateEnded:
            [longtap invalidate];
            break;
        default:
            break;
    }
}


//描写されているものを消すメソッド
-(void) removeSelectStageBlock:(NSMutableArray*)array {
    int count = [array count];
    for(int i = 0; i < count; i++) {
        for(UIButton* item in gameView.subviews) {
            if(item.tag == [array[i] intValue]) {
                //付随するアニメーション
                [UIView animateWithDuration:0.3
                                 animations:^{
                                     item.transform = CGAffineTransformMakeRotation(M_PI);
                                     item.transform = CGAffineTransformMakeScale(2, 2);
                                     item.alpha = 0;
                                 }
                                 completion:^(BOOL finished){
                                     [item removeFromSuperview];
                                     [self drowView];
                                     [self drowTurnBlock];
                }];

            }
        }
    }
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
-(void) removeTurnBlock {
    for(UILabel* item in gameView.subviews) {
        if(item.tag == 200) {
            [item removeFromSuperview];
        }
    }
}
-(void) removePointer {
    touchCount = 0;
    firstNum = 0;
    secondNum = 0;
    for(UILabel* item in gameView.subviews) {
        if(item.tag == 500) {
            [item removeFromSuperview];
        }
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

//操作するBlockの描写
-(void) drowTurnBlock {
    [self removeTurnBlock];
    if([stageModel GameOver]) {
        [self gameover];
        return;
    }
    for (int i = 0; i < 4; i++ ) {
        if(blockModel.model[i] == NONE_BLOCK) {
            continue;
        }
        UILabel *cell = [[UILabel alloc]initWithFrame:CGRectMake(STAGE_CELL * (shareData.col + i%2), STAGE_CELL * (shareData.row + i/2 + 2), STAGE_CELL, STAGE_CELL)];
        cell.tag = 200;
        cell.backgroundColor = [self checkBlockColor:blockModel.model[i]];
//        [cell.layer setBorderWidth:1];
        [[cell layer] setCornerRadius:10];
        [cell setClipsToBounds:YES];
        [cell.layer setBorderColor:BLOCK_BORDER_COLOR.CGColor];
        [gameView addSubview:cell];
    }
}
//stageのブロックの描写
-(void) drowView {
    [self removeStageBlock];
    for(int i = STAGE_COL * STAGE_ROW-1; i >= 0; i-- ){
        if(stageModel.model[i] == NONE_BLOCK) {
            continue;
        }
        stageCell = [[UIButton alloc]initWithFrame:CGRectMake(i % STAGE_COL * STAGE_CELL,STAGE_CELL + i / STAGE_COL * STAGE_CELL, STAGE_CELL, WIDTH/10)];
        stageCell.backgroundColor = [self checkBlockColor:stageModel.model[i]];
        stageCell.tag = i;
        [stageCell addTarget:self action:@selector(cell:)
            forControlEvents:UIControlEventTouchDown];
//        [stageCell.layer setBorderWidth:1];
        [[stageCell layer] setCornerRadius:10];
        [stageCell setClipsToBounds:YES];
        [stageCell.layer setBorderColor:BLOCK_BORDER_COLOR.CGColor];
        [gameView addSubview:stageCell];
    }
}
//ステージの元となるセルの描写
-(void) drowBaseView {
    return;
    [self removeStageBlock];
    for(int i = STAGE_COL * STAGE_ROW-1; i >= 0; i-- ){
        if(i < STAGE_COL) {
            continue;
        }
        UILabel *baseCell = [[UIButton alloc]initWithFrame:CGRectMake(i % STAGE_COL * STAGE_CELL,STAGE_CELL + i / STAGE_COL * STAGE_CELL, STAGE_CELL, WIDTH/10)];
        baseCell.backgroundColor = BLOCK_COLOR_NONE;
        baseCell.tag = 2000;
//        [baseCell.layer setBorderWidth:0.5];
        [baseCell.layer setBorderColor:BLOCK_BORDER_COLOR.CGColor];
        [gameView addSubview:baseCell];
    }
}
//タップした時に現われるpointerの描写
-(void) drowPoint:(int)point {
    UIImage *img = [UIImage imageNamed:@"20081.png"];
    UIImageView *pointcell = [[UIImageView alloc] initWithImage:img];
    pointcell.frame = CGRectMake(point % STAGE_COL * STAGE_CELL,STAGE_CELL + point / STAGE_COL * STAGE_CELL, STAGE_CELL, WIDTH/10);
    pointcell.tag = 500;
    [gameView addSubview:pointcell];
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
    

    [self drowButton:pauseView :resetButton :STAGE_CELL * 2 :STAGE_CELL * 8 :STAGE_CELL*6 :STAGE_CELL  * 1.5:BUTTON_COLOR :BLOCK_COLOR4 :@"RESET" :BUTTON_BORDER_COLOR :BUTTON_BORDER_WIDHT :@selector(reset:)];
    [self drowButton:pauseView :homeButton :STAGE_CELL * 2 :STAGE_CELL * 10 :STAGE_CELL*6 :STAGE_CELL  * 1.5:BUTTON_COLOR :BLOCK_COLOR4 :@"HOME" :BUTTON_BORDER_COLOR :BUTTON_BORDER_WIDHT :@selector(home:)];
}



//色の判定
-(UIColor*)checkBlockColor:(NSNumber*)blockStatus {
    if(blockStatus == BLOCK_STARUS) {
        return BLOCK_COLOR;
    }else if(blockStatus == BLOCK_STARUS2) {
        return BLOCK_COLOR2;
    }else if(blockStatus == BLOCK_STARUS3) {
        return BLOCK_COLOR3;
    }else if(blockStatus == BLOCK_STARUS4) {
        return BLOCK_COLOR4;
    }else if(blockStatus == BLOCK_STARUS5) {
        return BLOCK_COLOR5;
    } else {
        return BLOCK_COLOR_NONE;
    }
}

//タップしたcellのアクション系統
- (void)cell:(id)sender {
    if(pause) {
        return;
    }
    if(touchCount == 0) {
        firstNum = [sender tag];
        [self drowPoint:[sender tag]];
        timeout = [NSTimer scheduledTimerWithTimeInterval:2.0
                                                   target:self
                                                 selector:@selector(pointTimeout:)
                                                 userInfo:nil
                                                  repeats:NO];
    }
    if(touchCount == 1 && (firstNum != [sender tag])) {
        [self drowPoint:[sender tag]];
        secondNum = [sender tag];
        int tempScore = [stageModel clearBlockSum:firstNum :secondNum];
        if([stageModel clearBlockCheck:firstNum :secondNum] &&
            [[stageModel clearBlock:firstNum :secondNum] count] > 3) {
            //ブロックの移動メソッド
            [self moveControll:firstNum:secondNum];
            [self removeSelectStageBlock:[stageModel clearBlock:firstNum :secondNum]];
            //モデルを消すメソッド
            [stageModel deleteBlock:[stageModel clearBlock:firstNum :secondNum]];
            [self removePointer];
            return;
        }
    }
    if (touchCount == 2) {
        return;
    }
    touchCount++;
}
//時間でpointerを消すメソッド
- (void)pointTimeout :(UIButton*)button {
    [self removePointer];
}

-(void)gameover{
    [autoDown invalidate];
    [self allBind];
    for(UIButton* item in pauseView.subviews) {
        if(item.tag == 1001) {
            [item removeFromSuperview];
        }
    }
    [self drowGameOverView];
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

//落下のエフェクト消した時
-(void) movingEffect:(int)movedPosition:(int)currentPosition {
    int currentCol = currentPosition%STAGE_COL,
    currentPositionRow = currentPosition/STAGE_COL,movedPositionRow = movedPosition/STAGE_COL,
    diffRow = movedPositionRow - currentPositionRow;
    UIButton *temp;
    for(UIButton* item in gameView.subviews) {
        if(item.tag == currentPosition) {
            [UIView animateWithDuration:0.5
                             animations:^{item.frame = CGRectMake(currentCol * STAGE_CELL,(currentPositionRow + 1) * STAGE_CELL + diffRow * STAGE_CELL,STAGE_CELL,STAGE_CELL);}
                             completion:^(BOOL finished){}];
        }
    }
}
//落下のエフェクト設置した時
-(void) movingEffect2:(int)movedPosition:(int)currentPosition {
    int currentCol = currentPosition%STAGE_COL,
    currentPositionRow = currentPosition/STAGE_COL,movedPositionRow = movedPosition/STAGE_COL,
    diffRow = movedPositionRow - currentPositionRow;
    UIButton *temp;
    for(UIButton* item in gameView.subviews) {
        if(item.tag == currentPosition) {
            [UIView animateWithDuration:0.3
                             animations:^{item.frame = CGRectMake(currentCol * STAGE_CELL,(currentPositionRow + 1) * STAGE_CELL + diffRow * STAGE_CELL,STAGE_CELL,STAGE_CELL);}
                             completion:^(BOOL finished){
                                 [self drowView];
                                 [self drowTurnBlock];
                             }];
        }
    }
}

@end
