//
//  CYTitleAndDetailCell.m
//  nzny
//
//  Created by 男左女右 on 2016/10/20.
//  Copyright © 2016年 nznychina. All rights reserved.
//

#import "CYTitleAndDetailCell.h"

@implementation CYTitleAndDetailCell

// 模型赋值
- (void)setTitleAndDetailModel:(CYTitleAndDetailModel *)titleAndDetailModel{
    
    // 模型
    _titleAndDetailModel = titleAndDetailModel;
    
    // title
    _titleLab.text = titleAndDetailModel.title;
    
    // detail
    _detailLab.text = titleAndDetailModel.detail;
}

@end
