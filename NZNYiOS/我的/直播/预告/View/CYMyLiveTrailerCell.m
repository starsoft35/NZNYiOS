//
//  CYMyLiveTrailerCell.m
//  nzny
//
//  Created by 男左女右 on 2016/12/14.
//  Copyright © 2016年 nznychina. All rights reserved.
//

#import "CYMyLiveTrailerCell.h"

@implementation CYMyLiveTrailerCell

// 模型赋值
- (void)setMyLiveTrailerCellModel:(CYMyLiveTrailerCellModel *)myLiveTrailerCellModel{
    
    
    _myLiveTrailerCellModel = myLiveTrailerCellModel;
    
    
    
    // 直播背景
//    _liveTrailerBgImgView.image = [CYUtilities setUrlImgWithHostUrl:cHostUrl andUrl:myLiveTrailerCellModel.Pictrue];
    if ([myLiveTrailerCellModel.Pictrue isEqualToString:@""]) {
        
        _liveTrailerBgImgView.image = [UIImage imageNamed:@"默认头像"];
    }
    else {
        
        
        [_liveTrailerBgImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",cHostUrl,myLiveTrailerCellModel.Pictrue]] placeholderImage:[UIImage imageNamed:@"默认头像"]];
    }
    
    // 直播状态
    if (myLiveTrailerCellModel.IsEnter) {
        
        // 可以进入直播间
        _liveStatusImgView.image = [UIImage imageNamed:@"进入直播间激活"];
        
        _liveStatusLab.text = @"进入直播间";
        
    }
    else {
        
        // 不可以进入直播间
        _liveStatusImgView.image = [UIImage imageNamed:@"进入直播间未激活"];
        
        _liveStatusLab.text = @"进入直播间";
    }
    
    
    // 直播开始时间
    NSString *year = [myLiveTrailerCellModel.PlanStartTime substringToIndex:4];
    NSString *month = [myLiveTrailerCellModel.PlanStartTime substringWithRange:NSMakeRange(5, 2)];
    NSString *day = [myLiveTrailerCellModel.PlanStartTime substringWithRange:NSMakeRange(8, 2)];
    NSString *hour = [myLiveTrailerCellModel.PlanStartTime substringWithRange:NSMakeRange(11, 2)];
    NSString *minute = [myLiveTrailerCellModel.PlanStartTime substringWithRange:NSMakeRange(14, 2)];
    _liveStartTimeLab.text = [CYUtilities setYearMouthDayHourMinuteWithYearMouthDayHourMinuteSecond:myLiveTrailerCellModel.PlanStartTime];
    
    // 直播标题
    _titleLab.text = myLiveTrailerCellModel.Title;
    
}


@end
