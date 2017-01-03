//
//  CYMyLiveRecordCell.m
//  nzny
//
//  Created by 男左女右 on 2016/12/18.
//  Copyright © 2016年 nznychina. All rights reserved.
//

#import "CYMyLiveRecordCell.h"

@implementation CYMyLiveRecordCell

// 模型赋值
- (void)setMyLiveRecordCellModel:(CYMyLiveRecordCellModel *)myLiveRecordCellModel{
    
    _myLiveRecordCellModel = myLiveRecordCellModel;
    
    
    // 开始时间
    _startTimeLab.text = [CYUtilities setYearMouthDayHourMinuteWithYearMouthDayHourMinuteSecond:myLiveRecordCellModel.StartTime];
    
    // 标题
    _titleLab.text = myLiveRecordCellModel.Title;
    
    // 观看人数
    _watchCountLab.text = [NSString stringWithFormat:@"%ld",myLiveRecordCellModel.LookerCount];
    
    // 下一页图标
//    _nextPageImgView.image = [UIImage imageNamed:@""];
    
    
}

@end
