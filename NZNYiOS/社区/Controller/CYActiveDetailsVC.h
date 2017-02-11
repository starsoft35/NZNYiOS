//
//  CYActiveDetailsVC.h
//  nzny
//
//  Created by 男左女右 on 2017/2/4.
//  Copyright © 2017年 nznychina. All rights reserved.
//

#import "CYBaseViewController.h"

// 模型
#import "CYActiveDetailsVCModel.h"


@interface CYActiveDetailsVC : CYBaseViewController

// 模型
@property (nonatomic, strong) CYActiveDetailsVCModel *activeDetailsVCModel;

// 活动的id
@property (nonatomic, copy) NSString *activeId;


@end
