//
//  CYVideoDetailsView.h
//  nzny
//
//  Created by 男左女右 on 2016/11/27.
//  Copyright © 2016年 nznychina. All rights reserved.
//

#import <UIKit/UIKit.h>

// 模型：视频视图详情
#import "CYVideoDetailsViewModel.h"

// 模型：他人详情页
#import "CYOthersInfoViewModel.h"


// 模型：视频详情页
#import "CYVideoDetailsViewModel.h"

@interface CYVideoDetailsView : UIView

// 模型：视频视图详情
//@property (nonatomic, strong) CYVideoDetailsViewModel *videoDetailsViewModel;


// 模型：他人详情页
@property (nonatomic, strong) CYOthersInfoViewModel *othersInfoVM;

// 模型：视频详情页
//@property (nonatomic, strong) CYVideoDetailsViewModel *videoDetailsViewModel;

// 背景
@property (weak, nonatomic) IBOutlet UIImageView *bgImgView;


// 上部头像、姓名、ID、关注：View
@property (weak, nonatomic) IBOutlet UIView *topHeadNameIDFollowView;

// 上部头像、姓名、ID、关注背景：imageView
@property (weak, nonatomic) IBOutlet UIImageView *topHeadNameIDFollowBgImgView;

// 上部头像、姓名、ID、关注背景：imageView：已关注，关注按钮隐藏时的背景
@property (weak, nonatomic) IBOutlet UIImageView *topAllreadyFollowBgImgView;


// 头像：imageView
@property (weak, nonatomic) IBOutlet UIImageView *headImgView;

// 姓名：label
@property (weak, nonatomic) IBOutlet UILabel *nameLab;

// id：label
@property (weak, nonatomic) IBOutlet UILabel *idLab;


// 关注：button
@property (weak, nonatomic) IBOutlet UIButton *followBtn;

// 关闭：button
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;

// 标签：label
@property (weak, nonatomic) IBOutlet UILabel *tagLab;

// 宣言：label
@property (weak, nonatomic) IBOutlet UILabel *declarationLab;


// 联系他：button
@property (weak, nonatomic) IBOutlet UIButton *connectBtn;

// 送礼：button
@property (weak, nonatomic) IBOutlet UIButton *giveGiftBtn;

// 点赞：button
@property (weak, nonatomic) IBOutlet UIButton *likeBtn;


// 分享：button
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;


// 播放：button
@property (weak, nonatomic) IBOutlet UIButton *playBtn;


// 下部标签、宣言、联系View
@property (weak, nonatomic) IBOutlet UIView *bottomTipDecConView;


@end
