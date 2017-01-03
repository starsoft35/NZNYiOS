//
//  CYMineVideoView.h
//  nzny
//
//  Created by 男左女右 on 2016/10/30.
//  Copyright © 2016年 nznychina. All rights reserved.
//

#import <UIKit/UIKit.h>

// 模型
#import "CYMineVideoViewModel.h"


@interface CYMineVideoView : UIView


// 模型
//@property (nonatomic,strong)CYMineVideoViewModel *mineVideoViewModel;


// 数组
@property (nonatomic, strong) NSMutableArray *listArr;



// 左侧视频背景：imageView
@property (weak, nonatomic) IBOutlet UIImageView *leftVideoBackImgView;

// 左侧视频播放：imageView
@property (weak, nonatomic) IBOutlet UIImageView *leftVideoPlayImgView;

// 左侧视频审核状态：label
@property (weak, nonatomic) IBOutlet UILabel *leftVideoAuditStatusLab;


// 左侧视频创建时间：label
@property (weak, nonatomic) IBOutlet UILabel *leftVideoTimeLab;

// 左侧视频大小：label
@property (weak, nonatomic) IBOutlet UILabel *leftVideoSizeLab;


// 左侧视频黑色背景
@property (weak, nonatomic) IBOutlet UIImageView *leftVideoBlackImgView;



// 左侧视频使用：button
@property (weak, nonatomic) IBOutlet UIButton *leftVideoUseBtn;

// 左侧视频分享：button
@property (weak, nonatomic) IBOutlet UIButton *leftVideoShareBtn;

// 左侧视频删除：button
@property (weak, nonatomic) IBOutlet UIButton *leftVideoDeleteBtn;



// 右侧视频背景：imageView
@property (weak, nonatomic) IBOutlet UIImageView *rightVideoBackImgView;

// 右侧视频播放：imageView
@property (weak, nonatomic) IBOutlet UIImageView *rightVideoPlayImgView;

// 右侧视频审核状态：label
@property (weak, nonatomic) IBOutlet UILabel *rightVideoAuditStatusLab;


// 右侧视频创建时间：label
@property (weak, nonatomic) IBOutlet UILabel *rightVideoTimeLab;

// 右侧视频大小：label
@property (weak, nonatomic) IBOutlet UILabel *rightVideoSizeLab;

// 右侧视频黑色背景
@property (weak, nonatomic) IBOutlet UIImageView *rightVideoBlackImgView;


// 右侧视频使用：button
@property (weak, nonatomic) IBOutlet UIButton *rightVideoUseBtn;

// 右侧视频分享：button
@property (weak, nonatomic) IBOutlet UIButton *rightVideoShareBtn;

// 右侧视频删除：button
@property (weak, nonatomic) IBOutlet UIButton *rightVideoDeleteBtn;


// 上传：手机视频：button
@property (weak, nonatomic) IBOutlet UIButton *uploadPhoneVideoBtn;

// 上传：拍视频：button
@property (weak, nonatomic) IBOutlet UIButton *uploadPlayVideoBtn;


@end
