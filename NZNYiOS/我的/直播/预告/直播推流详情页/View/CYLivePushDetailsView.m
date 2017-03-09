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
//    _headerImgView.image = [CYUtilities setUrlImgWithHostUrl:cHostUrl andUrl:livePushDetailsViewModel.LiveUserPortrait];
    if ([livePushDetailsViewModel.LiveUserPortrait isEqualToString:@""]) {
        
        _headerImgView.image = [UIImage imageNamed:@"默认头像"];
    }
    else {
        
        
        [_headerImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",cHostUrl,livePushDetailsViewModel.LiveUserPortrait]] placeholderImage:[UIImage imageNamed:@"默认头像"]];
        
        
    }
    
    _headerImgView.layer.cornerRadius = (30.0 / 1334.0) * cScreen_Height;
    
    // 姓名
    _nameLab.text = livePushDetailsViewModel.LiveUserName;
    
    // FID
    _idLab.text = [NSString stringWithFormat:@"ID：%ld",(long)livePushDetailsViewModel.LiveUserFId];
    
    // 人气
    //    _popularityLab.text = [NSString stringWithFormat:@"人气：%@",livePlayDetailsModel];
    
    // 关注
    // 如果已经关注，则隐藏
//    _topHeadNameFIDBgImgView.hidden = YES;
    
    
    // 观看列表
    
    // 开始时间
    _startTimeLab.text = [CYUtilities setYearMouthDayHourMinuteWithYearMouthDayHourMinuteSecond:livePushDetailsViewModel.PlanStartTime];
    
    
    // 背景
//    _bgImgView.image = [CYUtilities setUrlImgWithHostUrl:cHostUrl andUrl:livePushDetailsViewModel.Pictrue];
    if ([livePushDetailsViewModel.Pictrue isEqualToString:@""]) {
        
        _bgImgView.image = [UIImage imageNamed:@"默认头像"];
    }
    else {
        
        [_bgImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",cHostUrl,livePushDetailsViewModel.Pictrue]] placeholderImage:[UIImage imageNamed:@"默认头像"]];
    }
    
}

@end
