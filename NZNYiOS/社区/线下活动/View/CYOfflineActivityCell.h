//
//  CYOfflineActivityCell.h
//  nzny
//
//  Created by 张春咏 on 2017/1/14.
//  Copyright © 2017年 nznychina. All rights reserved.
//

#import <UIKit/UIKit.h>

// 模型
#import "CYOfflineActivityCellModel.h"


@interface CYOfflineActivityCell : UITableViewCell


// 模型
@property (nonatomic, strong) CYOfflineActivityCellModel *offlineActiveCellModel;


// 发布时间
@property (weak, nonatomic) IBOutlet UILabel *releaseTimeLab;


// 活动是否结束
@property (weak, nonatomic) IBOutlet UILabel *activeIfEndLab;

// 线下活动或往期回顾
@property (weak, nonatomic) IBOutlet UILabel *offlineActiveOrPastReviewLab;


// 活动标题
@property (weak, nonatomic) IBOutlet UILabel *activeTitleLab;

// 活动时间
@property (weak, nonatomic) IBOutlet UILabel *activeTimeLab;


// 活动图片
@property (weak, nonatomic) IBOutlet UIImageView *activePictureImgView;


// 活动详情介绍
@property (weak, nonatomic) IBOutlet UILabel *activeDeclarationLab;


// 查看详情：view
@property (weak, nonatomic) IBOutlet UIView *checkDeclarationView;


// 查看详情：label
@property (weak, nonatomic) IBOutlet UILabel *checkDeclarationLab;




@end
