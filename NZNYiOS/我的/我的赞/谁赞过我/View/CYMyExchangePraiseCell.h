//
//  CYMyExchangePraiseCell.h
//  nzny
//
//  Created by 男左女右 on 2016/12/19.
//  Copyright © 2016年 nznychina. All rights reserved.
//

#import <UIKit/UIKit.h>

// 模型
#import "CYMyExchangePraiseCellModel.h"


@interface CYMyExchangePraiseCell : UITableViewCell


// 模型
@property (nonatomic, strong) CYMyExchangePraiseCellModel *exchangePraiseCellModel;

// 累计赞数量：label
@property (weak, nonatomic) IBOutlet UILabel *havePraiseCountLab;

// 可兑换数量：label
@property (weak, nonatomic) IBOutlet UILabel *canExchangeCountLab;


// 换钱：button
@property (weak, nonatomic) IBOutlet UIButton *changeMoneyBtn;



@end
