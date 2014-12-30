//
//  ViewController.h
//  PUZZRA
//
//  Created by totta on 2014/12/19.
//  Copyright (c) 2014年 totta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayViewController.h"
#import <LobiCore/LobiAPI.h>
#import <LobiRanking/LobiRanking.h>
#import "LobiNetwork.h"
#import "MyPageViewController.h"
#import "AppDelegate.h"

@protocol modalViewDelegate <NSObject>
-(void) modalViewWillClose;
@end


@interface ViewController : UIViewController {
    UIButton *playButton,*rankingButton;
    LobiNetwork *api;
    AppDelegate *shareDate;
    UIActivityIndicatorView *indicator;
}
@end

