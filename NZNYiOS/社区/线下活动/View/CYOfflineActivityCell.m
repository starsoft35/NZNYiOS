//
//  CYOfflineActivityCell.m
//  nzny
//
//  Created by 张春咏 on 2017/1/14.
//  Copyright © 2017年 nznychina. All rights reserved.
//

#import "CYOfflineActivityCell.h"

@implementation CYOfflineActivityCell


- (void)setOfflineActiveCellModel:(CYOfflineActivityCellModel *)offlineActiveCellModel{
    
    _offlineActiveCellModel = offlineActiveCellModel;
    
    
    // 发布时间
    _releaseTimeLab.text = [NSString stringWithFormat:@"%@",offlineActiveCellModel.CreateDate];
    
    // 线下活动or往期回顾
    _offlineActiveOrPastReviewLab.text = [NSString stringWithFormat:@"【%@】",offlineActiveCellModel.ActivityCategoryName];
    
    // 标题
    _activeTitleLab.text = [NSString stringWithFormat:@"Title"];
}

@end
