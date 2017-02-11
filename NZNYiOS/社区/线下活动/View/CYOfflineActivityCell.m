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
    _releaseTimeLab.text = [CYUtilities setYearMouthDayHourMinuteWithChineseYearMouthDayHourMinuteSecond:offlineActiveCellModel.CreateDate];
    
    // 活动是否结束
    _activeIfEndLab.text = offlineActiveCellModel.Status;
    if ([offlineActiveCellModel.Status isEqualToString:@"活动预告"]) {
        
        _activeIfEndLab.backgroundColor = [UIColor colorWithRed:0.91 green:0.51 blue:0.23 alpha:1.00];
    }
    else if ([offlineActiveCellModel.Status isEqualToString:@"已结束"]) {
        
        _activeIfEndLab.backgroundColor = [UIColor colorWithRed:0.50 green:0.50 blue:0.50 alpha:1.00];
    }
    else {
        
        _activeIfEndLab.hidden = YES;
    }
    
    // 线下活动or往期回顾
    _offlineActiveOrPastReviewLab.text = [NSString stringWithFormat:@"【线下活动】"];
    
    // 标题
    _activeTitleLab.text = [NSString stringWithFormat:@"%@",offlineActiveCellModel.Title];
    
    // 活动时间
    _activeTimeLab.text = [CYUtilities setYearMouthDayHourMinuteWithChineseMouthDay:offlineActiveCellModel.HoldingTime];
    
    // 活动图片
    UIImage *activePictureImg = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:offlineActiveCellModel.PictureUrl]]];
    NSLog(@"activePictureImg.size.width:%f",activePictureImg.size.width);
    NSLog(@"activePictureImg.size.height:%f",activePictureImg.size.height);
//    _activePictureImgView.image = activePictureImg;
    
    [_activePictureImgView setImage:activePictureImg];
    
    [_activePictureImgView setContentScaleFactor:[[UIScreen mainScreen] scale]];
    
    _activePictureImgView.contentMode =  UIViewContentModeScaleAspectFit;
    
//    _activePictureImgView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    
    _activePictureImgView.clipsToBounds = YES;
    
    // 活动详情介绍
    _activeDeclarationLab.text = offlineActiveCellModel.Summary;
    
    
}

@end
