//
//  AlivcLiveViewController.h
//  DevAlivcLiveVideo
//
//  Created by lyz on 16/3/21.
//  Copyright © 2016年 Alivc. All rights reserved.
//

//#import <UIKit/UIKit.h>
#import "CYBaseViewController.h"

// 直播推流详情页
#import "CYLivePushDetailsView.h"


@interface AlivcLiveViewController : CYBaseViewController


// 直播推流详情页
@property (nonatomic, strong) CYLivePushDetailsView *livePushDetailsView;

// 所查看的用户Id
@property (nonatomic, copy) NSString *oppUserId;

// 直播ID
@property (nonatomic, copy) NSString *liveID;


// 前后摄像头：点击事件
- (void)changeCameraBtnClickWithBtn:(UIButton *)changeCameraBtn;
// 关闭：button：点击事件：为了让聊天界面去调用。
- (void)closeBtnForPushView;


@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (nonatomic, assign) BOOL isScreenHorizontal;
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil url:(NSString *)url;


// 背景：imageView
@property (weak, nonatomic) IBOutlet UIImageView *bgImgView;

// 头像、姓名、FID、关注：View
@property (weak, nonatomic) IBOutlet UIView *topHeadNameFIDFollowView;

// 头像：ImageView
@property (weak, nonatomic) IBOutlet UIImageView *headerImgView;


// 姓名：label
@property (weak, nonatomic) IBOutlet UILabel *nameLab;


// FID：label
@property (weak, nonatomic) IBOutlet UILabel *idLab;


// 人气：label
@property (weak, nonatomic) IBOutlet UILabel *popularityLab;


// 开始时间：label
@property (weak, nonatomic) IBOutlet UILabel *startTimeLab;






@end
