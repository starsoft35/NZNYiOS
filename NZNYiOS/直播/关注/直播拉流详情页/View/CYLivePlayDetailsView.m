//
//  CYLivePlayDetailsView.m
//  nzny
//
//  Created by 男左女右 on 2016/12/10.
//  Copyright © 2016年 nznychina. All rights reserved.
//

#import "CYLivePlayDetailsView.h"

@implementation CYLivePlayDetailsView

// 模型赋值
- (void)setLivePlayDetailsModel:(CYLivePlayDetailsViewModel *)livePlayDetailsModel{
    
    
    _livePlayDetailsModel = livePlayDetailsModel;
    
    // 头像
    _headImgView.image = [CYUtilities setUrlImgWithHostUrl:cHostUrl andUrl:livePlayDetailsModel.LiveUserPortrait];
    
    // 姓名
    _nameLab.text = livePlayDetailsModel.LiveUserName;
    
    // FID
    _idLab.text = [NSString stringWithFormat:@"%ld",livePlayDetailsModel.LiveUserFId];
    
    // 人气
//    _popularityLab.text = [NSString stringWithFormat:@"人气：%@",livePlayDetailsModel];
    
    // 关注
    
    // 观看列表
    
    // 开始时间
    _startTimeLab.text = [CYUtilities setYearMouthDayHourMinuteWithYearMouthDayHourMinuteSecond:livePlayDetailsModel.PlanStartTime];
    
    // 开始时间提示窗
    if (livePlayDetailsModel.isTrailer) {
        
        // 开始时间提示窗：显示
        _startTimeTipLab.superview.hidden = NO;
        _startTimeTipLab.hidden = NO;
        
        // 如果是预告
        NSString *month = [livePlayDetailsModel.PlanStartTime substringWithRange:NSMakeRange(5, 2)];
        NSString *day = [livePlayDetailsModel.PlanStartTime substringWithRange:NSMakeRange(8, 2)];
        NSString *hour = [livePlayDetailsModel.PlanStartTime substringWithRange:NSMakeRange(11, 2)];
        NSString *minute = [livePlayDetailsModel.PlanStartTime substringWithRange:NSMakeRange(14, 2)];
        _startTimeTipLab.text = [NSString stringWithFormat:@"开播时间：%@/%@ %@:%@",month,day,hour,minute];
    }
    else {
        
        // 开始时间提示窗：隐藏
        _startTimeTipLab.superview.hidden = YES;
        _startTimeTipLab.hidden = YES;
    }
    
//    // 发消息、联系他、送礼、点赞、分享
//    if (livePlayDetailsModel.isPlayView) {
//        
//        // 是拉流界面
//        // 发消息：显示
//        _sendMessageBtn.hidden = NO;
//        
//        // 联系他：显示
//        _connectBtn.hidden = NO;
//        
//        // 送礼：显示
//        _sendGiftBtn.hidden = NO;
//        
//        // 点赞：显示
//        _likeBtn.hidden = NO;
//        
//        // 切换镜头：隐藏
//        _changeCameraBtn.hidden = YES;
//        
//        // 分享：显示
//        _shareBtn.hidden = NO;
//    }
//    else {
//        
//        // 不是拉流界面，则为推流界面
//        // 发消息：隐藏
//        _sendMessageBtn.hidden = YES;
//        
//        // 联系他：隐藏
//        _connectBtn.hidden = YES;
//        
//        // 送礼：隐藏
//        _sendGiftBtn.hidden = YES;
//        
//        // 点赞：隐藏
//        _likeBtn.hidden = YES;
//        
//        // 切换镜头：显示
//        _changeCameraBtn.hidden = NO;
//        
//        // 分享：显示
//        _shareBtn.hidden = NO;
//        
//    }
    
}

@end
