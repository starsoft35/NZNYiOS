//
//  CYMyAccountBalanceView.m
//  nzny
//
//  Created by 男左女右 on 2016/12/25.
//  Copyright © 2016年 nznychina. All rights reserved.
//

#import "CYMyAccountBalanceView.h"

@implementation CYMyAccountBalanceView

// 模型赋值
- (void)setMyAccountBalanceViewModel:(CYMyAccountBalanceViewModel *)myAccountBalanceViewModel{
    
    
    _myAccountBalanceViewModel = myAccountBalanceViewModel;
    
    
    // 余额
    _accountBalanceLab.text = [NSString stringWithFormat:@"￥ %.2lf",myAccountBalanceViewModel.money];
}

@end
