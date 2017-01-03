//
//  CYLivePushDetailsView.h
//  nzny
//
//  Created by 男左女右 on 2016/12/18.
//  Copyright © 2016年 nznychina. All rights reserved.
//

#import <UIKit/UIKit.h>

// 模型
#import "CYLivePushDetailsViewModel.h"

@interface CYLivePushDetailsView : UIView


// 模型
@property (nonatomic, strong) CYLivePushDetailsViewModel *livePushDetailsViewModel;

// 背景
@property (weak, nonatomic) IBOutlet UIImageView *bgImgView;


// 头像、姓名、FID、关注：View
@property (weak, nonatomic) IBOutlet UIView *topHeadNameFIDFollowView;


// 头像
@property (weak, nonatomic) IBOutlet UIImageView *headerImgView;


// 姓名
@property (weak, nonatomic) IBOutlet UILabel *nameLab;


// FID
@property (weak, nonatomic) IBOutlet UILabel *idLab;


// 人气
@property (weak, nonatomic) IBOutlet UILabel *popularityLab;


// 开始时间
@property (weak, nonatomic) IBOutlet UILabel *startTimeLab;


// 关闭：button
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;


// 前后摄像头：button
@property (weak, nonatomic) IBOutlet UIButton *changeCameraBtn;


// 分享：button
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;



@end
