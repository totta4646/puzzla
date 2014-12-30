//
//  MyPageViewController.h
//  PUZZRA
//
//  Created by totta on 2014/12/23.
//  Copyright (c) 2014年 totta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Const.h"
#import "UIColor+Hex.h"
#import "LobiNetwork.h"
#import "ViewController.h"

@interface MyPageViewController : UIViewController
    <UINavigationControllerDelegate,
    UIImagePickerControllerDelegate,
    UIAlertViewDelegate>{
    id delegate;
    int alertStatus;
        BOOL error;
        UIView *myPage,*profile;
    UIButton *userImage,*userName,*hiscore,*maxchain,*maxscore;
        UIAlertView *alert,*nameAlert;
    LobiNetwork *api;
    LobiNetworkResponse *data;
        UIScrollView *hiscoreranking,*maxchainranking,*maxscoreranking;;
}
@property (nonatomic,retain) id delegate;

@end
