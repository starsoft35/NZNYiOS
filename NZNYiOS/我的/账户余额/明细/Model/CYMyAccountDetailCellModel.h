//
//  CYMyAccountDetailCellModel.h
//  nzny
//
//  Created by 男左女右 on 2016/12/25.
//  Copyright © 2016年 nznychina. All rights reserved.
//

#import "CYBaseModel.h"

@interface CYMyAccountDetailCellModel : CYBaseModel


// 创建时间
@property (nonatomic, copy) NSString *CreateDate;

// 花费明细
@property (nonatomic, copy) NSString *Introduction;

// 花费金额
@property (nonatomic, assign) float Money;

// 周几
@property (nonatomic, copy) NSString *Week;



@end
