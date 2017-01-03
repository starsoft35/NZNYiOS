//
//  CYWhoIPraiseVC.h
//  nzny
//
//  Created by 男左女右 on 2016/12/19.
//  Copyright © 2016年 nznychina. All rights reserved.
//

#import "CYBaseTableViewController.h"
#import "CYWhoPraiseMeVC.h"


// 模型
#import "CYMyExchangePraiseCellModel.h"


@interface CYWhoIPraiseVC : CYBaseTableViewController
//@interface CYWhoIPraiseVC : CYWhoPraiseMeVC


// 用户积累的赞、可兑换的赞：数组
@property (nonatomic, strong) CYMyExchangePraiseCellModel *exchangePraiseCellModel;


@end
