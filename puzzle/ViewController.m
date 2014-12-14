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

- (void)viewDidLoad {
    [super viewDidLoad];
    //model初期化
    touchCount = 0;
    shareData = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    stageModel = [[StageModel alloc]init];
    [stageModel ModelNew];
    blockModel = [[TurnBlockModel alloc]init];
    [blockModel ModelNew];
    
    //パズルをするViewの描写
    gameView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, STAGE_HEIGHT)];
    [self.view addSubview:gameView];
    [self drowview];
    //ボタンのViewの描写
    ButtonView = [[UIView alloc]initWithFrame:CGRectMake(0, STAGE_HEIGHT, WIDTH, HEIGHT-STAGE_HEIGHT)];
    [self.view addSubview:ButtonView];
  
    [self drowButton:ButtonView :turnButtonReverce :0 :0 :WIDTH/2 :(HEIGHT-STAGE_HEIGHT)/3 :BLOCK_COLOR :BLOCK_COLOR :@"hoge" :BLOCK_COLOR :0.2 :@selector(turnReverce:)];
    [self drowButton:ButtonView :turnButton :WIDTH/2 :0 :WIDTH/2 :(HEIGHT-STAGE_HEIGHT)/3 :BLOCK_COLOR5 :BLOCK_COLOR5 :@"hoge" :BLOCK_COLOR5 :0.2 :@selector(turn:)];
    [self drowButton:ButtonView :leftButton :0 :(HEIGHT-STAGE_HEIGHT)/3 :WIDTH/2 :(HEIGHT-STAGE_HEIGHT)/3 :BLOCK_COLOR2 :BLOCK_COLOR2 :@"hoge" :BLOCK_COLOR2 :0.2 :@selector(left:)];
    [self drowButton:ButtonView :rightButton :WIDTH/2 :(HEIGHT-STAGE_HEIGHT)/3 :WIDTH/2 :(HEIGHT-STAGE_HEIGHT)/3 :BLOCK_COLOR3 :BLOCK_COLOR3 :@"hoge" :BLOCK_COLOR3 :0.2 :@selector(right:)];
    [self drowButton:ButtonView :downButton :0 :(HEIGHT-STAGE_HEIGHT)*2/3 :WIDTH :(HEIGHT-STAGE_HEIGHT)/3 :BLOCK_COLOR4 :BLOCK_COLOR4 :@"hoge" :BLOCK_COLOR4 :0.2 :@selector(down:)];

    [blockModel randomBlock];
    [self drowTurnBlock];

    speed = 1.0;
    autoDown = [NSTimer scheduledTimerWithTimeInterval:speed
                                            target:self
                                          selector:@selector(down:)
                                          userInfo:nil
                                           repeats:YES];

}

//ボタン操作
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
        [self drowview];
        [blockModel randomBlock];
        [self drowTurnBlock];
        return;
    }
    shareData.row++;
    [self drowTurnBlock];
    
}


//描写されているものを消すメソッド
-(void) removeStageBlock {
    for(UIButton* item in gameView.subviews) {
        [item removeFromSuperview];
    }
}
-(void) removeTurnBlock {
    for(UILabel* item in gameView.subviews) {
        if(item.tag == 10) {
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
    drowButton = [[UIButton alloc]init];
    drowButton.frame = CGRectMake(widthPoint, heightPoint, width, height);
    [drowButton addTarget:self action:selector
         forControlEvents:UIControlEventTouchDown];
    drowButton.backgroundColor = backGroundColor;
    [addView addSubview:drowButton];
}

//操作するBlockの描写
-(void) drowTurnBlock {
    [self removeTurnBlock];
    for (int i = 0; i < 4; i++ ) {
        
        if(blockModel.model[i] == NONE_BLOCK) {
            continue;
        }
        UILabel *cell = [[UILabel alloc]initWithFrame:CGRectMake(STAGE_CELL * (shareData.col + i%2), STAGE_CELL * (shareData.row + i/2 + 2), STAGE_CELL, STAGE_CELL)];
        cell.tag = 10;
        cell.backgroundColor = [self checkBlockColor:blockModel.model[i]];
        [cell.layer setBorderWidth:1];
        [cell.layer setBorderColor:[UIColor blackColor].CGColor];
        [gameView addSubview:cell];
    }
}
//stageのブロックの描写
-(void) drowview {
    [self removeStageBlock];
    for(int i = 0; i < STAGE_COL * STAGE_ROW; i++ ){
        UIButton *cell = [[UIButton alloc]initWithFrame:CGRectMake(i % STAGE_COL * STAGE_CELL,STAGE_CELL + i / STAGE_COL * STAGE_CELL, STAGE_CELL, WIDTH/10)];
        cell.backgroundColor = [self checkBlockColor:stageModel.model[i]];
        cell.tag = i;
        if (stageModel.model[i] != NONE_BLOCK) {
            [cell addTarget:self action:@selector(cell:)
           forControlEvents:UIControlEventTouchDown];
        }
        [cell.layer setBorderWidth:1];
        [cell.layer setBorderColor:[UIColor blackColor].CGColor];
        [gameView addSubview:cell];
    }
}
//タップした時に現われるpointerの描写
-(void) drowPoint:(int)point {
    UILabel *pointcell = [[UILabel alloc]initWithFrame:CGRectMake(point % STAGE_COL * STAGE_CELL,STAGE_CELL + point / STAGE_COL * STAGE_CELL, STAGE_CELL, WIDTH/10)];
    pointcell.tag = 500;
    pointcell.backgroundColor = [UIColor grayColor];
    pointcell.layer.cornerRadius = WIDTH/10;
    [pointcell.layer setBorderWidth:1];
    [pointcell.layer setBorderColor:[UIColor blackColor].CGColor];
    [gameView addSubview:pointcell];
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
        return [UIColor whiteColor];
    }
}

//タップしたcellのアクション系統
- (void)cell:(id)sender {
    if(touchCount == 0) {
        firstNum = [sender tag];
        [self drowPoint:[sender tag]];
    }
    if(touchCount == 1 && (firstNum != [sender tag])) {
        secondNum = [sender tag];
        [self drowPoint:[sender tag]];
        if([stageModel clearBlock:firstNum :secondNum]) {
            [self drowview];
            [self drowTurnBlock];
            [self removePointer];
        }
        timeout = [NSTimer scheduledTimerWithTimeInterval:2.0
                                                    target:self
                                                    selector:@selector(pointTimeout:)
                                                    userInfo:nil
                                                    repeats:NO];
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
