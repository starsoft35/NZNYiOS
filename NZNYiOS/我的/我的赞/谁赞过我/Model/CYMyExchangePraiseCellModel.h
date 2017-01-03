//
//  CYMyExchangePraiseCellModel.h
//  nzny
//
//  Created by 男左女右 on 2016/12/19.
//  Copyright © 2016年 nznychina. All rights reserved.
//

#import "CYBaseModel.h"

@interface CYMyExchangePraiseCellModel : CYBaseModel


// 累积的赞
@property (nonatomic, assign) NSInteger TotalLikeCount;

// 可兑换的赞
@property (nonatomic, assign) NSInteger LikeCount;

@end
