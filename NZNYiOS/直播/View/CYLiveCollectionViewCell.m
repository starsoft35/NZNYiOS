//
//  CYLiveCollectionViewCell.m
//  nzny
//
//  Created by 男左女右 on 2016/11/19.
//  Copyright © 2016年 nznychina. All rights reserved.
//

#import "CYLiveCollectionViewCell.h"

@implementation CYLiveCollectionViewCell


// 属性赋值
- (void)setLiveCellModel:(CYLiveCollectionViewCellModel *)liveCellModel{
    
    // 模型赋值
    _liveCellModel = liveCellModel;
    
    // 直播背景
//    _liveBgImgView.image = [CYUtilities setUrlImgWithHostUrl:cHostUrl andUrl:liveCellModel.Pictrue];
    if ([liveCellModel.Pictrue isEqualToString:@""]) {
        
        _liveBgImgView.image = [UIImage imageNamed:@"默认头像"];
    }
    else {
        
        
        [_liveBgImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",cHostUrl,liveCellModel.Pictrue]] placeholderImage:[UIImage imageNamed:@"默认头像"]];
    }
    
    // 直播状态
    _liveStatusTitleLab.text = liveCellModel.liveStatusTitle;
    
    // 直播状态背景图
    _liveStatusBgImgView.image = [UIImage imageNamed:liveCellModel.liveStatusBgImgName];
    
    // 直播时间或观看人数
    if (liveCellModel.isWatchCount) {
        
        
        _liveTimeOrWatchNumLab.text = [NSString stringWithFormat:@"%ld 人",(long)liveCellModel.WatchCount];
    }
    else {
        _liveTimeOrWatchNumLab.text = [CYUtilities setYearMouthDayHourMinuteWithYearMouthDayHourMinuteSecond:liveCellModel.PlanStartTime];
    }
    
    // 性别：imageView
    _liveGenderImgView.image = [UIImage imageNamed:liveCellModel.LiveUserGender];
    
    // 姓名
    _liveNameLab.text = liveCellModel.LiveUserName;
    
    // 联系他
    
    
    // 直播标题
    _liveTitleLab.text = liveCellModel.Title;
    
    
}


@end
