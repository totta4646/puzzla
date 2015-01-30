//
//  MyPageViewController.m
//  PUZZRA
//
//  Created by totta on 2014/12/23.
//  Copyright (c) 2014年 totta. All rights reserved.
//

#import "MyPageViewController.h"

@interface MyPageViewController ()

@end

@implementation MyPageViewController
@synthesize delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    api = [[LobiNetwork alloc]init];
    error = false;
    alert = [UIAlertView new];
    nameAlert = [UIAlertView new];
    myPage = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    myPage.backgroundColor = [UIColor colorWithHex:@"fff"];
    [myPage addSubview:profile];
    [myPage addSubview:userImage];
    [myPage addSubview:userName];
    [self.view addSubview:myPage];
    UISwipeGestureRecognizer *backSwipe =
    [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                              action:@selector(back:)];
    backSwipe.direction = UISwipeGestureRecognizerDirectionRight;
    [myPage addGestureRecognizer:backSwipe ];

    profile = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT/5)];
    profile.backgroundColor = SCORE_COLOR;
    hiscore = [[UIButton alloc]initWithFrame:CGRectMake(0, HEIGHT*2/5-STAGE_CELL, WIDTH/3, STAGE_CELL)];
    [myPage addSubview:profile];
    [hiscore addTarget:self action:@selector(hiScore:)
      forControlEvents:UIControlEventTouchDown];
    hiscore.backgroundColor = BLOCK_COLOR5;
    [hiscore setTitle:@"ハイスコア" forState:UIControlStateNormal];
    [hiscore setTitleColor:[UIColor colorWithHex:@"fff"] forState:UIControlStateNormal];
    hiscore.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:12];
    [myPage addSubview:hiscore];
    
    maxchain = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH/3, HEIGHT*2/5-STAGE_CELL, WIDTH/3, STAGE_CELL)];
    [maxchain addTarget:self action:@selector(maxchain:)
       forControlEvents:UIControlEventTouchDown];
    maxchain.backgroundColor = BLOCK_COLOR2;
    [maxchain setTitle:@"最大連鎖数" forState:UIControlStateNormal];
    [maxchain setTitleColor:[UIColor colorWithHex:@"fff"] forState:UIControlStateNormal];
    maxchain.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:12];
    
    [myPage addSubview:maxchain];
    maxscore = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH/3*2, HEIGHT*2/5-STAGE_CELL, WIDTH/3, STAGE_CELL)];
    [maxscore addTarget:self action:@selector(maxscore:)
       forControlEvents:UIControlEventTouchDown];
    maxscore.backgroundColor = BLOCK_COLOR3;
    [maxscore setTitle:@"Another" forState:UIControlStateNormal];
    maxscore.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:12];
    [maxscore setTitleColor:[UIColor colorWithHex:@"fff"] forState:UIControlStateNormal];
    
    [myPage addSubview:maxscore];

    UIImage *img = [api getuserImage];
    if (!img) {
        error = true;
        [self errorAlert];
        return;
    }
    userImage = [[UIButton alloc]init];
    [userImage setBackgroundImage:img forState:UIControlStateNormal];
    userImage.frame = CGRectMake(STAGE_CELL, HEIGHT/5-STAGE_CELL*1.75, STAGE_CELL*2.5, STAGE_CELL*2.5);
    [userImage addTarget:self action:@selector(changeUserImage:)
  forControlEvents:UIControlEventTouchDown];
    [[userImage layer] setBorderColor:[BLOCK_COLOR4 CGColor]];
    [[userImage layer] setBorderWidth:5.0];
    [[userImage layer] setCornerRadius:10.0];
    [userImage setClipsToBounds:YES];
    [myPage addSubview:userImage];
    
    
    userName = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH/2 - STAGE_CELL,HEIGHT/5 -STAGE_CELL * 1.5, WIDTH/2 + STAGE_CELL, STAGE_CELL*2)];
    [userName setTitle:[api getuserName] forState:UIControlStateNormal];
    
    userName.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:30];
    [userName addTarget:self action:@selector(changeUserName:)
        forControlEvents:UIControlEventTouchDown];
    [userName setTitleColor:[UIColor colorWithHex:@"fff"] forState:UIControlStateNormal];
    [myPage addSubview:userName];
    
    [self drowMaxChainRanking];
    if (error) {
        return;
    }
    [self drowMaxScoreRanking];
    if (error) {
        return;
    }
    [self drowhiscoreRanking];
}
-(void) hiScore :(UIButton*) button {
    hiscoreranking.alpha = 1;
    maxscoreranking.alpha = 0;
    maxchainranking.alpha = 0;
}
-(void) maxchain :(UIButton*) button {
    hiscoreranking.alpha = 0;
    maxscoreranking.alpha = 0;
    maxchainranking.alpha = 1;
}
-(void) maxscore :(UIButton*) button {
    hiscoreranking.alpha = 0;
    maxscoreranking.alpha = 1;
    maxchainranking.alpha = 0;
}
- (void) drowMaxChainRanking {
    LobiNetworkResponse *resdata = [api maxchaindata];
    if(!resdata) {
        error = true;
        [self errorAlert];
    }
    UILabel *scoreLabel = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH/3, STAGE_CELL * 4.5, WIDTH/3, STAGE_CELL*2)];
    scoreLabel.text = [[[resdata.body objectForKey:@"self_order"] objectForKey:@"rank"] stringByAppendingString:@"位"];
    scoreLabel.textColor = SCORE_COLOR;
    scoreLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:25];
    scoreLabel.textAlignment = NSTextAlignmentCenter;
    [myPage addSubview:scoreLabel];
    int count = (int)[[resdata.body objectForKey:@"orders"] count];
    maxchainranking = [[UIScrollView alloc]initWithFrame:CGRectMake(0, HEIGHT*2/5, WIDTH,HEIGHT*3/5)];
    maxchainranking.contentSize = CGSizeMake(WIDTH, count * STAGE_CELL * 2.5);
    maxchainranking.bounces = NO;
    [myPage addSubview:maxchainranking];
    for(int i = 0;i < count; i++) {
        NSDictionary *hiscoredata = [resdata.body objectForKey:@"orders"][i];
        UIView *rankingView = [[UIView alloc]initWithFrame:CGRectMake(0, STAGE_CELL * 2.5 * i , WIDTH, STAGE_CELL * 2.5)];
        rankingView.backgroundColor = BLOCK_COLOR4;
        if(i%2 == 0) {
            rankingView.backgroundColor = BLOCK_COLOR2;
        }
        UILabel *rank = [[UILabel alloc]initWithFrame:CGRectMake(0 ,0,STAGE_CELL*2/3,STAGE_CELL*2/3)];
        rank.text = [NSString stringWithFormat:@"%d",i + 1];
        rank.textAlignment = NSTextAlignmentCenter;
        rank.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14];
        rank.textColor = [UIColor whiteColor];
        [rankingView addSubview:rank];
        NSURL *url = [NSURL URLWithString:[hiscoredata objectForKey:@"icon"]];
        NSData *dt = [NSData dataWithContentsOfURL:url];
        UIImage *image = [[UIImage alloc] initWithData:dt];
        
        UIImageView *userimg = [[UIImageView alloc]initWithImage:image];
        userimg.frame = CGRectMake(STAGE_CELL, STAGE_CELL*2.5/2-STAGE_CELL*0.75, STAGE_CELL*1.5, STAGE_CELL*1.5);
        userimg.layer.cornerRadius = 10.0f;
        userimg.layer.masksToBounds = YES;
        [rankingView addSubview:userimg];
        
        UILabel *username = [[UILabel alloc]initWithFrame:CGRectMake(STAGE_CELL * 3,STAGE_CELL*2.5/2-STAGE_CELL, STAGE_CELL * 4, STAGE_CELL)];
        username.text = [hiscoredata objectForKey:@"name"];
        username.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14];
        username.textColor = [UIColor whiteColor];
        [rankingView addSubview:username];
        
        UILabel *score = [[UILabel alloc]initWithFrame:CGRectMake(STAGE_CELL * 4.2,STAGE_CELL*2.2/2,STAGE_CELL * 5,STAGE_CELL)];
        score.text = [[hiscoredata objectForKey:@"score"] stringByAppendingString:@"回"];
        score.textAlignment = NSTextAlignmentCenter;
        score.font = [UIFont fontWithName:@"AppleGothic" size:30];
        score.textColor = [UIColor whiteColor];
        [rankingView addSubview:score];
        [maxchainranking addSubview:rankingView];
    }
}
- (void) drowhiscoreRanking {
    LobiNetworkResponse *resdata = [api hiScoredata];
    if(!resdata) {
        error = true;
        [self errorAlert];
    }
    UILabel *scoreLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, STAGE_CELL * 4.5, WIDTH/3, STAGE_CELL*2)];
    scoreLabel.text = [[[resdata.body objectForKey:@"self_order"] objectForKey:@"rank"] stringByAppendingString:@"位"];
    scoreLabel.textColor = SCORE_COLOR;
    scoreLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:25];
    scoreLabel.textAlignment = NSTextAlignmentCenter;
    [myPage addSubview:scoreLabel];
    
    int count = (int)[[resdata.body objectForKey:@"orders"] count];
    hiscoreranking = [[UIScrollView alloc]initWithFrame:CGRectMake(0, HEIGHT*2/5, WIDTH,HEIGHT*3/5)];
    hiscoreranking.tag = 0;
    hiscoreranking.contentSize = CGSizeMake(WIDTH, count * STAGE_CELL * 2.5);
    hiscoreranking.bounces = NO;
    [myPage addSubview:hiscoreranking];
    for(int i = 0;i < count; i++) {
        NSDictionary *hiscoredata = [resdata.body objectForKey:@"orders"][i];
        UIView *rankingView = [[UIView alloc]initWithFrame:CGRectMake(0, STAGE_CELL * 2.5 * i , WIDTH, STAGE_CELL * 2.5)];
        rankingView.backgroundColor = BLOCK_COLOR4;
        if(i%2 == 0) {
            rankingView.backgroundColor = BLOCK_COLOR5;
        }
        UILabel *rank = [[UILabel alloc]initWithFrame:CGRectMake(0 ,0,STAGE_CELL*2/3,STAGE_CELL*2/3)];
        rank.text = [NSString stringWithFormat:@"%d",i + 1];
        rank.textAlignment = NSTextAlignmentCenter;
        rank.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14];
        rank.textColor = [UIColor whiteColor];
        [rankingView addSubview:rank];
        NSURL *url = [NSURL URLWithString:[hiscoredata objectForKey:@"icon"]];
        NSData *dt = [NSData dataWithContentsOfURL:url];
        UIImage *image = [[UIImage alloc] initWithData:dt];
        
        UIImageView *userimg = [[UIImageView alloc]initWithImage:image];
        userimg.frame = CGRectMake(STAGE_CELL, STAGE_CELL*2.5/2-STAGE_CELL*0.75, STAGE_CELL*1.5, STAGE_CELL*1.5);
        userimg.layer.cornerRadius = 10.0f;
        userimg.layer.masksToBounds = YES;
        [rankingView addSubview:userimg];
        
        UILabel *username = [[UILabel alloc]initWithFrame:CGRectMake(STAGE_CELL * 3,STAGE_CELL*2.5/2-STAGE_CELL, STAGE_CELL * 4, STAGE_CELL)];
        username.text = [hiscoredata objectForKey:@"name"];
        username.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14];
        username.textColor = [UIColor whiteColor];
        [rankingView addSubview:username];
        
        UILabel *score = [[UILabel alloc]initWithFrame:CGRectMake(STAGE_CELL * 4.2,STAGE_CELL*2.2/2,STAGE_CELL * 5,STAGE_CELL)];
        score.text = [hiscoredata objectForKey:@"score"];
        score.textAlignment = NSTextAlignmentCenter;
        score.font = [UIFont fontWithName:@"AppleGothic" size:30];
        score.textColor = [UIColor whiteColor];
        [rankingView addSubview:score];
        [hiscoreranking addSubview:rankingView];
    }
}
- (void) drowMaxScoreRanking {
    LobiNetworkResponse *resdata = [api maxscoredata];
    if(!resdata) {
        error = true;
        [self errorAlert];
    }
    UILabel *scoreLabel = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH/3*2, STAGE_CELL * 4.5, WIDTH/3, STAGE_CELL*2)];
    scoreLabel.text = [[[resdata.body objectForKey:@"self_order"] objectForKey:@"rank"] stringByAppendingString:@"位"];
    scoreLabel.textColor = SCORE_COLOR;
    scoreLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:25];
    scoreLabel.textAlignment = NSTextAlignmentCenter;
    [myPage addSubview:scoreLabel];
    int count = (int)[[resdata.body objectForKey:@"orders"] count];
    maxscoreranking = [[UIScrollView alloc]initWithFrame:CGRectMake(0, HEIGHT*2/5, WIDTH,HEIGHT*3/5)];
    maxscoreranking.tag = 3;
    maxscoreranking.contentSize = CGSizeMake(WIDTH, count * STAGE_CELL * 2.5);
    maxscoreranking.bounces = NO;
    [myPage addSubview:maxscoreranking];
    for(int i = 0;i < count; i++) {
        NSDictionary *hiscoredata = [resdata.body objectForKey:@"orders"][i];
        UIView *rankingView = [[UIView alloc]initWithFrame:CGRectMake(0, STAGE_CELL * 2.5 * i , WIDTH, STAGE_CELL * 2.5)];
        rankingView.backgroundColor = BLOCK_COLOR4;
        if(i%2 == 0) {
            rankingView.backgroundColor = BLOCK_COLOR3;
        }
        UILabel *rank = [[UILabel alloc]initWithFrame:CGRectMake(0 ,0,STAGE_CELL*2/3,STAGE_CELL*2/3)];
        rank.text = [NSString stringWithFormat:@"%d",i + 1];
        rank.textAlignment = NSTextAlignmentCenter;
        rank.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14];
        rank.textColor = [UIColor whiteColor];
        [rankingView addSubview:rank];
        NSURL *url = [NSURL URLWithString:[hiscoredata objectForKey:@"icon"]];
        NSData *dt = [NSData dataWithContentsOfURL:url];
        UIImage *image = [[UIImage alloc] initWithData:dt];
        
        UIImageView *userimg = [[UIImageView alloc]initWithImage:image];
        userimg.frame = CGRectMake(STAGE_CELL, STAGE_CELL*2.5/2-STAGE_CELL*0.75, STAGE_CELL*1.5, STAGE_CELL*1.5);
        userimg.layer.cornerRadius = 10.0f;
        userimg.layer.masksToBounds = YES;
        [rankingView addSubview:userimg];
        
        UILabel *username = [[UILabel alloc]initWithFrame:CGRectMake(STAGE_CELL * 3,STAGE_CELL*2.5/2-STAGE_CELL, STAGE_CELL * 4, STAGE_CELL)];
        username.text = [hiscoredata objectForKey:@"name"];
        username.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14];
        username.textColor = [UIColor whiteColor];
        [rankingView addSubview:username];
        
        UILabel *score = [[UILabel alloc]initWithFrame:CGRectMake(STAGE_CELL * 4.2,STAGE_CELL*2.2/2,STAGE_CELL * 5,STAGE_CELL)];
        NSString *stemptime = [hiscoredata objectForKey:@"score"];
        int itemptime = [stemptime intValue],
        itempminutes = itemptime/100,
        itempseconds = itemptime%100;
        
        NSString *stempminutes = [NSString stringWithFormat:@"%02d",itempminutes],
        *stempseconds = [NSString stringWithFormat:@"%02d",itempseconds],
        *temptime = [stempminutes stringByAppendingString:@":"];
        score.text = [temptime stringByAppendingString:stempseconds];
        score.textAlignment = NSTextAlignmentCenter;
        score.font = [UIFont fontWithName:@"AppleGothic" size:30];
        score.textColor = [UIColor whiteColor];
        [rankingView addSubview:score];
        [maxscoreranking addSubview:rankingView];
    }
}
- (void)back:(UISwipeGestureRecognizer *)sender{
    [delegate modalViewWillClose];
}
- (void) changeUserName:(UIButton*)button {
    [self nameView];
}

- (void) changeUserImage:(UIButton*)button {
    UIImagePickerController *imgPic = [[UIImagePickerController alloc]init];
    imgPic.delegate = self;
    [imgPic setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    imgPic.allowsEditing = YES;
    [self presentViewController: imgPic animated:YES completion:nil];
}

- (void)imagePickerController :(UIImagePickerController *)picker
        didFinishPickingImage :(UIImage *)image editingInfo :(NSDictionary *)editingInfo {
    
    [api updateImage:image];
    [userImage setBackgroundImage:image forState:UIControlStateNormal];
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void) errorAlert {
    // ダイアログを表示中かチェックする
    for (UIWindow* window in [UIApplication sharedApplication].windows){
        for (UIView *subView in [window subviews]){
            if ([subView isKindOfClass:[UIAlertView class]]) {
                return;
            }
        }
    }
    
    alertStatus = 1;
    alert.title = @"通信エラー";
    alert.message = @"サーバーとの接続に失敗しました";
    alert.delegate = self;
    [alert addButtonWithTitle:@"OK"];
    [alert show];
}
-(void) errorAlert2 {
    alertStatus = 2;
    alert.title = @"通信エラー";
    alert.message = @"サーバーとの接続に失敗しました";
    alert.delegate = self;
    [alert addButtonWithTitle:@"OK"];
    [alert show];
}
-(void) errorAlert3 {
    alertStatus = 2;
    alert.title = @"ユーザー名が被っています";
    alert.message = @"異なるユーザー名にしてください";
    alert.delegate = self;
    [alert addButtonWithTitle:@"OK"];
    [alert show];
}
-(void) errorAlert4 {
    alertStatus = 2;
    alert.title = @"ユーザー名が長過ぎます";
    alert.message = @"ユーザー名を6文字以下にしてください";
    alert.delegate = self;
    [alert addButtonWithTitle:@"OK"];
    [alert show];
}
-(void) nameView{
    alertStatus = 0;
    nameAlert.title = @"Your New Name";
    nameAlert.delegate = self;
    [nameAlert addButtonWithTitle:@"cancel"];
    [nameAlert addButtonWithTitle:@"OK"];
    [nameAlert setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [nameAlert show];
}
-(void)alertView:(UIAlertView*)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1 && alertStatus == 0) {
        if([api rename:[[alertView textFieldAtIndex:0] text]] == 2) {
            [self errorAlert3];
        } else if ([api rename:[[alertView textFieldAtIndex:0] text]] == 1) {
            [self errorAlert2];
        } else if ([api rename:[[alertView textFieldAtIndex:0] text]] == 4) {
            [self errorAlert4];
        } else {
            [userName setTitle:[[alertView textFieldAtIndex:0] text] forState:UIControlStateNormal];
        }
    }
    if (buttonIndex == 0 && alertStatus == 1) {
        [delegate modalViewWillClose];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
