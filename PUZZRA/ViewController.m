//
//  ViewController.m
//  PUZZRA
//
//  Created by totta on 2014/12/19.
//  Copyright (c) 2014年 totta. All rights reserved.
//
#import <LobiRanking/LobiRanking.h>
#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    ShareData.music = 0;
    sound = [SoundPlay new];
    [sound bgm];
    music = true;
    api = [[LobiNetwork alloc]init];
    if(![api signUp]) {
        [self alert];
        ShareData.madeUser = -1;
    }
    playButton = [UIButton new];
    anotherplayButton = [UIButton new];
    rankingButton = [UIButton new];
    musicButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [musicButton setBackgroundImage:onMusic forState:UIControlStateNormal];
    [musicButton addTarget:self action:@selector(music:)
        forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:musicButton];
    
    [self drowButton:self.view :playButton :STAGE_CELL * 2 :STAGE_CELL * 10 :STAGE_CELL*6 :STAGE_CELL  * 1.5:BUTTON_COLOR :BLOCK_COLOR4 :@"PLAY" :BUTTON_BORDER_COLOR :BUTTON_BORDER_WIDHT :@selector(startgame:)];
    [self drowButton:self.view :anotherplayButton :STAGE_CELL * 2 :STAGE_CELL * 12 :STAGE_CELL*6 :STAGE_CELL  * 1.5:BUTTON_COLOR :BLOCK_COLOR4 :@"ANOTHER" :BUTTON_BORDER_COLOR :BUTTON_BORDER_WIDHT :@selector(anotherstartgame:)];
    [self drowButton:self.view :rankingButton :STAGE_CELL * 2 :STAGE_CELL * 14 :STAGE_CELL*6 :STAGE_CELL  * 1.5:BUTTON_COLOR :BLOCK_COLOR4 :@"RAKING" :BUTTON_BORDER_COLOR :BUTTON_BORDER_WIDHT :@selector(ranking:)];
    indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    float w = indicator.frame.size.width;
    float h = indicator.frame.size.height;
    float x = self.view.frame.size.width/2 - w/2;
    float y = self.view.frame.size.height/2 - h/2;
    indicator.frame = CGRectMake(x, y, w, h);
    indicator.color = SCORE_COLOR;
    // 現在のサブビューとして登録する
    [self.view addSubview:indicator];

    UIImage *image = [UIImage imageNamed:@"logo.png"];
    UIImageView *logo = [[UIImageView alloc]initWithImage:image];
    logo.frame = CGRectMake(WIDTH*0.1, 150 , WIDTH*0.8, WIDTH*0.8*0.27217742);
    [self.view addSubview:logo];
}

/**
 *  音を鳴らすかどうかのボタン
 */
-(void) music :(UIButton*)button {
    if(music) {
        [musicButton setBackgroundImage:noneMusic forState:UIControlStateNormal];
        [sound stopbgm];
        ShareData.music = 0;
    } else {
        [musicButton setBackgroundImage:onMusic forState:UIControlStateNormal];
        [sound bgm];
        ShareData.music = 1;
    }
    music = !music;
}

-(void) ranking :(UIButton*)button {
    MyPageViewController *mypage = [[MyPageViewController alloc] init];
    mypage.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    mypage.delegate = self;
    [self allbind];
    [indicator startAnimating];
    [self presentModalViewController:mypage animated:YES];
}
-(void) allbind {
    [playButton setEnabled:NO];
    [rankingButton setEnabled:NO];
}
-(void) allunbind {
    [playButton setEnabled:YES];
    [rankingButton setEnabled:YES];
}

-(void) startgame :(UIButton*)button{
    [sound stopbgm];

    PlayViewController *view = [[PlayViewController alloc] init];
    view.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    view.delegate = self;
    [self presentModalViewController:view animated:YES];
}
-(void) anotherstartgame :(UIButton*)button{
    [sound stopbgm];
    AnotherPlayViewController *view = [[AnotherPlayViewController alloc] init];
    view.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    view.delegate = self;
    [self presentModalViewController:view animated:YES];
}


-(void) alert {
    UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"通信エラー"
                                                  message:@"ユーザーデータの作成に失敗しました。"
                                                 delegate:self
                                        cancelButtonTitle:nil
                                        otherButtonTitles:@"OK", nil];
    [alert show];
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

- (void)presentRanking {
    [LobiRanking presentRanking];
}
//画面が返ってきたときのメソッド
-(void) modalViewWillClose {
    [sound bgm];
    [indicator stopAnimating];
    [self allunbind];
    [self dismissModalViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
