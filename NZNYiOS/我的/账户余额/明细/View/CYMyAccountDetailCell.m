//
//  CYMyAccountDetailCell.m
//  nzny
//
//  Created by 男左女右 on 2016/12/25.
//  Copyright © 2016年 nznychina. All rights reserved.
//

#import "CYMyAccountDetailCell.h"

@implementation CYMyAccountDetailCell


// 模型赋值
- (void)setMyAccountDetailCellModel:(CYMyAccountDetailCellModel *)myAccountDetailCellModel{
    
    
    _myAccountDetailCellModel = myAccountDetailCellModel;
    
    // 周几
    _weekLab.text = myAccountDetailCellModel.Week;
    
    // 日期
    _dateLab.text = [[CYUtilities setYearMouthDayHourMinuteWithYearMouthDayHourMinuteSecond:myAccountDetailCellModel.CreateDate] substringFromIndex:5];
    
    // 花费详情
    _introductionLab.text = myAccountDetailCellModel.Introduction;
    
    // 花费金额
    _moneyLab.text = [NSString stringWithFormat:@"%.2lf",myAccountDetailCellModel.Money];
}



@end
