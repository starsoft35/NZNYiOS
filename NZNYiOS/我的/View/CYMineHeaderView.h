//
//  CYMineHeaderView.h
//  NZNYiOS
//
//  Created by 男左女右 on 16/9/29.
//  Copyright © 2016年 NZNY. All rights reserved.
//

#import <UIKit/UIKit.h>

// 模型
#import "CYMineHeaderViewModel.h"



@interface CYMineHeaderView : UIView


// 模型
@property (nonatomic,strong)CYMineHeaderViewModel *mineMainHeaderViewModel;

// 头像
@property (weak, nonatomic) IBOutlet UIImageView *mineHeadImgView;


// 姓名：label
@property (weak, nonatomic) IBOutlet UILabel *userNameLab;


// ID：label
@property (weak, nonatomic) IBOutlet UILabel *userIDLab;

// 地址：label
@property (weak, nonatomic) IBOutlet UILabel *userAddressLab;


// 性别：imgView
@property (weak, nonatomic) IBOutlet UIImageView *userGenderImgView;



// 编辑信息button
@property (weak, nonatomic) IBOutlet UIButton *editInfoBtn;

// 视频：View
@property (weak, nonatomic) IBOutlet UIView *videoView;

// 视频数量：label
@property (weak, nonatomic) IBOutlet UILabel *videoCountLab;



// 直播：view
@property (weak, nonatomic) IBOutlet UIView *liveView;

// 直播数量：label
@property (weak, nonatomic) IBOutlet UILabel *liveCountLab;



// 粉丝：View
@property (weak, nonatomic) IBOutlet UIView *fansView;

// 粉丝数量：label
@property (weak, nonatomic) IBOutlet UILabel *fansCountLab;



// 关注：View
@property (weak, nonatomic) IBOutlet UIView *followView;

// 关注数量：label
@property (weak, nonatomic) IBOutlet UILabel *followCountLab;





@end
