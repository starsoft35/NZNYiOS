//
//  CYLivePushDetailsView.m
//  nzny
//
//  Created by 男左女右 on 2016/12/18.
//  Copyright © 2016年 nznychina. All rights reserved.
//

#import "CYLivePushDetailsView.h"

@implementation CYLivePushDetailsView

// 模型赋值
- (void)setLivePushDetailsViewModel:(CYLivePushDetailsViewModel *)livePushDetailsViewModel{
    
    _livePushDetailsViewModel = livePushDetailsViewModel;
    
    // 头像
    _headerImgView.image = [CYUtilities setUrlImgWithHostUrl:cHostUrl andUrl:livePushDetailsViewModel.LiveUserPortrait];
    
    // 姓名
    _nameLab.text = livePushDetailsViewModel.LiveUserName;
    
    // FID
    _idLab.text = [NSString stringWithFormat:@"ID：%ld",(long)livePushDetailsViewModel.LiveUserFId];
    
    // 人气
    //    _popularityLab.text = [NSString stringWithFormat:@"人气：%@",livePlayDetailsModel];
    
    // 关注
    
    // 观看列表
    
    // 开始时间
    _startTimeLab.text = [CYUtilities setYearMouthDayHourMinuteWithYearMouthDayHourMinuteSecond:livePushDetailsViewModel.PlanStartTime];
    
    
    // 背景
    _bgImgView.image = [CYUtilities setUrlImgWithHostUrl:cHostUrl andUrl:livePushDetailsViewModel.Pictrue];
    
}

@end
