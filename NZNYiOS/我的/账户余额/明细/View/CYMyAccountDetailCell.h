//
//  CYMyAccountDetailCell.h
//  nzny
//
//  Created by 男左女右 on 2016/12/25.
//  Copyright © 2016年 nznychina. All rights reserved.
//

#import <UIKit/UIKit.h>

// 模型
#import "CYMyAccountDetailCellModel.h"


@interface CYMyAccountDetailCell : UITableViewCell

// 模型
@property (nonatomic, strong) CYMyAccountDetailCellModel *myAccountDetailCellModel;

// 周几
@property (weak, nonatomic) IBOutlet UILabel *weekLab;

// 日期
@property (weak, nonatomic) IBOutlet UILabel *dateLab;

// 花费详情
@property (weak, nonatomic) IBOutlet UILabel *introductionLab;

// 花费金额
@property (weak, nonatomic) IBOutlet UILabel *moneyLab;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *moneyLabRightDistance;


@end
