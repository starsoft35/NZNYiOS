//
//  CYTitleTimeCountStatusCell.m
//  nzny
//
//  Created by 男左女右 on 2016/12/13.
//  Copyright © 2016年 nznychina. All rights reserved.
//

#import "CYTitleTimeCountStatusCell.h"

@implementation CYTitleTimeCountStatusCell


// 模型赋值
- (void)setLiveCellModel:(CYOtherLiveCellModel *)liveCellModel{
    
    _liveCellModel = liveCellModel;
    
    // 标题
    _titleLab.text = liveCellModel.Title;
    
    // 开始时间
    _liveStartTimeLab.text = liveCellModel.PlanStartTime;
    
    // 观看人数
    _liveWatchCountLab.text = [NSString stringWithFormat:@"%ld 人观看",liveCellModel.LookerCount];
    
    
    // 直播状态
    if (liveCellModel.Status == 1) {
        
        _liveStatusLab.text = @"预告";
        _liveStatusLab.textColor = [UIColor colorWithRed:0.18 green:0.67 blue:0.17 alpha:1.00];
    }
    else if (liveCellModel.Status == 2) {
        
        _liveStatusLab.text = @"正在直播";
        _liveStatusLab.textColor = [UIColor colorWithRed:0.91 green:0.51 blue:0.23 alpha:1.00];
    }
    else if (liveCellModel.Status == 3) {
        
        _liveStatusLab.text = @"直播结束";
        _liveStatusLab.textColor = [UIColor colorWithRed:0.50 green:0.50 blue:0.50 alpha:1.00];
    }
}


@end
