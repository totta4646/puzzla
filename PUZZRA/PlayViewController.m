//
//  PlayViewController.m
//  puzzle
//
//  Created by totta on 2014/12/12.
//  Copyright (c) 2014年 totta. All rights reserved.
//

#import "PlayViewController.h"


@interface PlayViewController ()

@end

@implementation PlayViewController
@synthesize delegate;
- (void)viewDidLoad {
    [super viewDidLoad];
    //model初期化
    DragOn = false;
    NSNotificationCenter*   nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(applicationDidEnterBackground) name:@"applicationDidEnterBackground" object:nil];
    speed = 0.8;
    api = [[LobiNetwork alloc]init];
    self.view.backgroundColor = [UIColor whiteColor];
    shareData = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    pause = false;
    sound = [[SoundPlay alloc]init];
    downButton = [[UIButton alloc]init];
    UILongPressGestureRecognizer *gestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressedHandler:)];
    [downButton addGestureRecognizer:gestureRecognizer];
    leftButton = [[UIButton alloc]init];
    rightButton = [[UIButton alloc]init];
    turnButton = [[UIButton alloc]init];
    pauseButton = [[UIButton alloc]init];
    pauseButton.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:20];
    pauseView = [[UIView alloc]init];
    resetButton = [[UIButton alloc]init];
    resumeButton = [[UIButton alloc]init];
    resumeButton.tag = 1001;
    homeButton = [[UIButton alloc]init];
    pauseView.tag = 1000;
    bomb = false;
    timerOn = false;
    turnCount = 0;
    labelCount = 0;
    clearCount = 0;
    stageModel = [[StageModel alloc]init];
    [stageModel ModelNew];
    blockModel = [[TurnBlockModel alloc]init];
    [blockModel ModelNew];
    level = [[Level_Balancer alloc]init];
    [level levelNew];
    score = [[MyScore alloc]init];
    [score scoreNew];
    
    //パズルをするViewの描写
    gameView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, STAGE_HEIGHT)];

    [self.view addSubview:gameView];
    [self drowView];
    scoreView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, STAGE_CELL * 2)];
    scoreView.backgroundColor = SCORE_COLOR;
    [self.view addSubview:scoreView];
    
    scoreTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, STAGE_CELL, WIDTH/2, STAGE_CELL)];
    scoreTitle.textAlignment = NSTextAlignmentCenter;
    scoreTitle.textColor = [UIColor whiteColor];
    [self reDrowScore:0];
    [self drowButton:scoreView :pauseButton :WIDTH*3/4 :STAGE_CELL :WIDTH/4 : STAGE_CELL :SCORE_COLOR :BLOCK_COLOR :@"PAUSE" :SCORE_COLOR :BUTTON_BORDER_WIDHT :@selector(wait:)];
    
    
    //ボタンのViewの描写
    ButtonView = [[UIView alloc]initWithFrame:CGRectMake(0, STAGE_HEIGHT, WIDTH, HEIGHT-STAGE_HEIGHT)];
    [self.view addSubview:ButtonView];
    
    [self drowButton:ButtonView :turnButton :0 :0 :WIDTH :(HEIGHT-STAGE_HEIGHT)/3 :BUTTON_COLOR3 :BLOCK_COLOR5 :@"⇄" :BUTTON_BORDER_COLOR :BUTTON_BORDER_WIDHT :@selector(turn:)];
    [self drowButton:ButtonView :leftButton :0 :(HEIGHT-STAGE_HEIGHT)/3 :WIDTH/2 :(HEIGHT-STAGE_HEIGHT)/3 :BUTTON_COLOR2 :BLOCK_COLOR2 :@"←" :BUTTON_BORDER_COLOR :BUTTON_BORDER_WIDHT :@selector(left:)];
    [self drowButton:ButtonView :rightButton :WIDTH/2 :(HEIGHT-STAGE_HEIGHT)/3 :WIDTH/2 :(HEIGHT-STAGE_HEIGHT)/3 :BUTTON_COLOR2 :BLOCK_COLOR3 :@"→" :BUTTON_BORDER_COLOR :1 :@selector(right:)];
    [self drowButton:ButtonView :downButton :0 :(HEIGHT-STAGE_HEIGHT)*2/3 :WIDTH :(HEIGHT-STAGE_HEIGHT)/3 :BUTTON_COLOR :BLOCK_COLOR4 :@"↓" :BUTTON_BORDER_COLOR :BUTTON_BORDER_WIDHT :@selector(down:)];
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(handlePanGesture:)];
    panGesture.maximumNumberOfTouches = 1;
    [gameView addGestureRecognizer:panGesture];
    [blockModel randomBlock];
    [self drowTurnBlock];
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
    int  tempStageCell = (int)STAGE_CELL, currentY = (int)pointY - (tempStageCell * 2),sum,
    
    currentRow = currentY / tempStageCell,
    currentCol = (int)pointX / ((int)self.view.frame.size.width /(int)STAGE_COL);
    
    sum = currentCol + currentRow * 10 + 10;
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
}
- (void)handlePanGesture:(UIPanGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded){
        CGPoint tapPoint = [sender translationInView:self.view];
        int movedPositionX = (int)currentPointX + (int)tapPoint.x,
            movedPositionY = (int)currentPointY + (int)tapPoint.y,
            DragPoint = [self currentPositon:movedPositionX:movedPositionY];
        if(DragPoint < 0 || DragPoint > STAGE_COL * STAGE_ROW - 1 || !DragOn) {
            [self drowView];
            [self drowTurnBlock];
            return;
        }
        [self drowDragPoint:DragPoint];
        firstNum = tempDragPoint,secondNum = DragPoint;
        int tempScore = [stageModel clearBlockSum:firstNum :secondNum];
        if([stageModel clearBlockCheck:firstNum :secondNum] &&
           [[stageModel clearBlock:firstNum :secondNum] count] > 3) {
            turnCount++;
            clearCount++;
            [score addScore:tempScore];
            [score checkMaxScore:tempScore];
            [self scoreEffect:firstNum:secondNum];
            [self reDrowScore:[score getScore]];
            //ブロックの移動メソッド
            [self moveControll:firstNum:secondNum];
            [self removeEffectSelectBlock:[stageModel clearBlock:firstNum :secondNum]];
            //モデルを消すメソッド
            [stageModel deleteBlock:[stageModel clearBlock:firstNum :secondNum]];
            [sound clearBlock];
            [score countMaxChain];
            return;
        } else {
            NSTimer *dragPointer = [NSTimer scheduledTimerWithTimeInterval:0.3
                                                        target:self
                                                      selector:@selector(resetDrag)
                                                      userInfo:nil
                                                       repeats:NO];
        }
    }
}
-(void) resetDrag {
    [self drowView];
    [self drowTurnBlock];
}
-(void) timerStart{
    autoDown = [NSTimer scheduledTimerWithTimeInterval:speed
                                                target:self
                                              selector:@selector(down:)
                                              userInfo:nil
                                               repeats:YES];
}
-(void) timerStartItem:(UIButton*)button{
    timerOn = false;
    if(![autoDown isValid]) {
        autoDown = [NSTimer scheduledTimerWithTimeInterval:speed
                                                    target:self
                                                  selector:@selector(down:)
                                                  userInfo:nil
                                                   repeats:YES];
    }
}
-(void)allBind {
    [downButton setEnabled:NO];
    [rightButton setEnabled:NO];
    [leftButton setEnabled:NO];
    [turnButton setEnabled:NO];
    pause = true;
}
-(void)allBind2 {
    [downButton setEnabled:NO];
    [rightButton setEnabled:NO];
    [leftButton setEnabled:NO];
    [turnButton setEnabled:NO];
    [pauseButton setEnabled:NO];
}
-(void)allUnBind {
    [pauseButton setEnabled:YES];
    [downButton setEnabled:YES];
    [rightButton setEnabled:YES];
    [leftButton setEnabled:YES];
    [turnButton setEnabled:YES];
    [turnButtonReverce setEnabled:YES];
    pause = false;
}
//ボタン操作
-(void)wait:(UIButton*)button{
    [sound pause];
    [autoDown invalidate];
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
    [self timerStart];
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
    speed = 0.8;
    [self reDrowScore:0];
    [stageModel ModelNew];
    [blockModel ModelNew];
    [self drowView];
    [blockModel randomBlock];
    [self drowTurnBlock];
    
    shareData.row = 0;
    shareData.col = 4;
    [self timerStart];
}
-(void)home:(UIButton*)button {
    [delegate modalViewWillClose];
}
-(void)turn:(UIButton*)button{
    [blockModel turnBlock:(BOOL)false:(NSMutableArray*)stageModel.model];
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
                    [self movingEffect:([check2[0] intValue]) :[check2[1] intValue]];
                }
            }
        }
        [blockModel randomBlock];
        if(clearCount > 3) {
            [blockModel randomItem];
            clearCount = 0;
        }
        [sound fixed];
        [self drowTurnBlock];
        [longtap invalidate];
        turnCount = 0;
        [score changeNextBlock];
        return;
    }
    shareData.row++;
    [self drowTurnBlock];
    
}
//長押しの判定
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
        if(blockModel.model[i] == BLOCK_STARUS5 || blockModel.model[i] == BLOCK_STARUS6) {
            UIImage *img;
            if(blockModel.model[i] == BLOCK_STARUS6){
                img = [UIImage imageNamed:@"Simple-Line-Icons-Set-Vol2-full_07.png"];
            } else {
                img = [UIImage imageNamed:@"Simple-Line-Icons-full_03.png"];
            }
            UIImageView *cell = [[UIImageView alloc] initWithImage:img];
            cell.frame = CGRectMake(STAGE_CELL * (shareData.col + i%2), STAGE_CELL * (shareData.row + i/2 + 2), STAGE_CELL, STAGE_CELL);
            cell.tag = 200;
            cell.backgroundColor = [self checkBlockColor:blockModel.model[i]];
            [[cell layer] setCornerRadius:10];
            [cell setClipsToBounds:YES];
            [cell.layer setBorderColor:BLOCK_BORDER_COLOR.CGColor];
            [gameView addSubview:cell];
        } else {
            UILabel *cell = [[UILabel alloc]initWithFrame:CGRectMake(STAGE_CELL * (shareData.col + i%2), STAGE_CELL * (shareData.row + i/2 + 2), STAGE_CELL, STAGE_CELL)];
            cell.tag = 200;
            cell.backgroundColor = [self checkBlockColor:blockModel.model[i]];
            [[cell layer] setCornerRadius:10];
            [cell setClipsToBounds:YES];
            [cell.layer setBorderColor:BLOCK_BORDER_COLOR.CGColor];
            [gameView addSubview:cell];
        }
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
        if(stageModel.model[i] == BLOCK_STARUS5) {
            UIImage *img = [UIImage imageNamed:@"Simple-Line-Icons-full_03.png"];
            [stageCell setBackgroundImage:img forState:UIControlStateNormal];
            stageCell.tag = i;
            [stageCell addTarget:self action:@selector(cell:)
                forControlEvents:UIControlEventTouchDown];
            [[stageCell layer] setCornerRadius:10];
            [stageCell setClipsToBounds:YES];
            [stageCell.layer setBorderColor:BLOCK_BORDER_COLOR.CGColor];
            [gameView addSubview:stageCell];
        } else if (stageModel.model[i] == BLOCK_STARUS6) {
            UIImage *img = [UIImage imageNamed:@"Simple-Line-Icons-Set-Vol2-full_07.png"];
            [stageCell setBackgroundImage:img forState:UIControlStateNormal];
            stageCell.tag = i;
            [stageCell addTarget:self action:@selector(cell:)
                forControlEvents:UIControlEventTouchDown];
            [[stageCell layer] setCornerRadius:10];
            [stageCell setClipsToBounds:YES];
            [stageCell.layer setBorderColor:BLOCK_BORDER_COLOR.CGColor];
            [gameView addSubview:stageCell];
        } else {
            stageLabel = [[UILabel alloc]initWithFrame:CGRectMake(i % STAGE_COL * STAGE_CELL,STAGE_CELL + i / STAGE_COL * STAGE_CELL, STAGE_CELL, WIDTH/10)];
            stageLabel.backgroundColor = [self checkBlockColor:stageModel.model[i]];
            stageLabel.tag = i;
            [[stageLabel layer] setCornerRadius:10];
            [stageLabel setClipsToBounds:YES];
            [stageLabel.layer setBorderColor:BLOCK_BORDER_COLOR.CGColor];
            [gameView addSubview:stageLabel];
            
        }
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
    [api sendScore:[score getScore]];
    [api sendMaxChainScore:[score getMaxChainScore]];
    [api sendMaxScore:[score getMaxScore]];
    UILabel *currentScore = [[UILabel alloc]initWithFrame:CGRectMake(0, STAGE_CELL*3, WIDTH, STAGE_CELL*6)];
    NSString *tempScore = [NSString stringWithFormat:@"%d",[score getScore]];
    currentScore.text = [@"SCORE:" stringByAppendingString:tempScore];
    currentScore.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:30];
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

//タップしたcellのアクション系統
- (void)cell:(id)sender {
    if(pause) {
        return;
    }
    firstNum = (int)[sender tag];
    if(stageModel.model[firstNum] == BLOCK_STARUS5 && !timerOn) {
        timerOn = true;
        [score useItem];
        [self reDrowScore:[score getScore]];
        NSMutableArray *tempNumber = [@[] mutableCopy];
        tempNumber[0] = [NSNumber numberWithInteger:firstNum];
        [stageModel deleteBlock:tempNumber];
        for(int i = 0; i * STAGE_COL < firstNum; i++) {
            [self movingEffect:firstNum - i * STAGE_COL:firstNum - (i + 1) * STAGE_COL];
        }
        [self removeEffectSelectBlock:tempNumber];
        [sound timer];
        [self stoptime];
        return;
    }
    if(stageModel.model[firstNum] == BLOCK_STARUS6 && !timerOn) {
        [score useItem];
        [self reDrowScore:[score getScore]];
        NSMutableArray * tempNumber = [[stageModel bombCurrent:firstNum] mutableCopy];
        [stageModel deleteBlock:tempNumber];
        [self moveControll:[tempNumber[0] intValue]:[tempNumber[(int)[tempNumber count]-1] intValue]];
        [self removeEffectSelectBlock:tempNumber];
        if(![autoDown isValid]){
            [self timerStart];
        }
        [sound bomb];
        [self allUnBind];
        return;
    }
}

-(void) reDrowScore:(int)addPoint {
    if([level levelcheck:addPoint]) {
        [autoDown invalidate];
        speed = [level levelup:speed];
        [self timerStart];
    }
    NSString *tempScore = [NSString stringWithFormat:@"%d",addPoint];
    scoreTitle.text = [@"SCORE:" stringByAppendingString:tempScore];
    scoreTitle.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:20];
    [scoreView addSubview:scoreTitle];
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

-(void)stoptime {
    [autoDown invalidate];
    timeout = [NSTimer scheduledTimerWithTimeInterval:10
                                               target:self
                                             selector:@selector(timerStartItem:)
                                             userInfo:nil
                                              repeats:NO];
}
//スコアを表示するメソッド
-(void) scoreEffect:(int)first:(int)second {
    labelCount++;
    int tempFirstCol = first % STAGE_COL, tempSecondCol = second % STAGE_COL,
    tempFirstRow = first / STAGE_COL, tempSecondRow = second / STAGE_COL,
    diffCol = tempFirstCol - tempSecondCol,diffRow = tempFirstRow - tempSecondRow,tagNumber = 100000 + labelCount;
    int pointWidth = tempFirstCol * STAGE_CELL ,pointHeight = (tempFirstRow + 1 + (abs(diffRow) + 1)/2) * STAGE_CELL,viewWidth = (abs(diffCol) + 1) * STAGE_CELL,viewHeight = STAGE_CELL;
    if (tempFirstCol > tempSecondCol) {
        pointWidth = tempSecondCol * STAGE_CELL;
    }
    if (tempFirstRow > tempSecondRow) {
        pointHeight = (tempSecondRow + 1 + (abs(diffRow) + 1)/2) * STAGE_CELL;
    }
    if(viewWidth < STAGE_CELL * 2) {
        viewWidth = STAGE_CELL * 2;
        pointWidth = pointWidth - STAGE_CELL/2;
    }
    
    UILabel *scoreAnimation = [[UILabel alloc]initWithFrame:CGRectMake(pointWidth, pointHeight, viewWidth, viewHeight)];
    
    scoreAnimation.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:28];
    
    NSString *Stringscore = [NSString stringWithFormat:@"%d",[score getcurrentaddscore]];
    scoreAnimation.text = Stringscore;
    scoreAnimation.textAlignment = NSTextAlignmentCenter;
    scoreAnimation.textColor = [UIColor colorWithHex:@"28638f"];
    scoreAnimation.tag = tagNumber;
    [self.view addSubview:scoreAnimation];
    [UIView animateWithDuration:1
                     animations:^{scoreAnimation.frame = CGRectMake(pointWidth ,pointHeight - STAGE_CELL*2/3, viewWidth, viewHeight);}
                     completion:^(BOOL finished){
                         for(UILabel* item in self.view.subviews) {
                             if(item.tag == tagNumber) {
                                 labelCount--;
                                 [item removeFromSuperview];
                             }
                         }
                     }];
}


-(void) drowDragPoint:(int)currentPosition {
    for(UIButton* item in gameView.subviews) {
        if(item.tag == currentPosition) {
            [UIView animateWithDuration:0.2
                             animations:^{
                                 item.backgroundColor = [UIColor colorWithHex:@"ff7f66"];
                                 item.transform = CGAffineTransformMakeScale(1.2, 1.2);
}
                             completion:^(BOOL finished){
                             }];
        }
    }
}
//落下のエフェクト消した時
-(void) movingEffect:(int)movedPosition:(int)currentPosition {
    int currentCol = currentPosition%STAGE_COL,
    currentPositionRow = currentPosition/STAGE_COL,movedPositionRow = movedPosition/STAGE_COL,
    diffRow = movedPositionRow - currentPositionRow;
    for(UIButton* item in gameView.subviews) {
        if(item.tag == currentPosition) {
            [UIView animateWithDuration:0.2
                             animations:^{item.frame = CGRectMake(currentCol * STAGE_CELL,(currentPositionRow + 1) * STAGE_CELL + diffRow * STAGE_CELL,STAGE_CELL,STAGE_CELL);}
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

- (void)applicationDidEnterBackground {
    [sound pause];
    [autoDown invalidate];
    [self allBind];
    [self drowPauseView];
}
@end
