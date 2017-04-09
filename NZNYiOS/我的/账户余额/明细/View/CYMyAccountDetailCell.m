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
    NSString *tempMoney = [[NSString alloc] init];
    if (myAccountDetailCellModel.Money > 0) {
        
        
        tempMoney = [NSString stringWithFormat:@"+%.2lf",myAccountDetailCellModel.Money];
    }
    else {
        
        // 小叶给了-号
        tempMoney = [NSString stringWithFormat:@"%.2lf",myAccountDetailCellModel.Money];
    }
    _moneyLab.text = tempMoney;
    
    // 自动计算label的高度、宽度
    CGSize tempMoneySize = [CYUtilities labelAutoCalculateRectWith:tempMoney FontSize:14 MaxSize:CGSizeMake(240.0 / 375.0 * cScreen_Width, 80.0 / 667.0 * cScreen_Height)];
    _moneyLabRightDistance.constant = tempMoneySize.width;
}



@end
