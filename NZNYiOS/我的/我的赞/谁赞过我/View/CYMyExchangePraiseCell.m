//
//  CYMyExchangePraiseCell.m
//  nzny
//
//  Created by 男左女右 on 2016/12/19.
//  Copyright © 2016年 nznychina. All rights reserved.
//

#import "CYMyExchangePraiseCell.h"

@implementation CYMyExchangePraiseCell


// 模型赋值
- (void)setExchangePraiseCellModel:(CYMyExchangePraiseCellModel *)exchangePraiseCellModel{
    
    _exchangePraiseCellModel = exchangePraiseCellModel;
    
    // 累计赞的数量
    _havePraiseCountLab.text = [NSString stringWithFormat:@"%ld",(long)exchangePraiseCellModel.TotalLikeCount];
    
    // 可兑换赞的数量
    _canExchangeCountLab.text = [NSString stringWithFormat:@"%ld",(long)exchangePraiseCellModel.LikeCount];
}

@end
