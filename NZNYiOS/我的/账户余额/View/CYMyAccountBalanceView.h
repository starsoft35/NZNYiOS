//
//  CYMyAccountBalanceView.h
//  nzny
//
//  Created by 男左女右 on 2016/12/25.
//  Copyright © 2016年 nznychina. All rights reserved.
//

#import <UIKit/UIKit.h>

// 账户余额：模型
#import "CYMyAccountBalanceViewModel.h"


@interface CYMyAccountBalanceView : UIView

// 账户余额：模型
@property (nonatomic, strong) CYMyAccountBalanceViewModel *myAccountBalanceViewModel;



// 余额：label
@property (weak, nonatomic) IBOutlet UILabel *accountBalanceLab;


// 充值：button
@property (weak, nonatomic) IBOutlet UIButton *rechargeBtn;



@end
