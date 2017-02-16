//
//  CYInfoHeaderCell.m
//  nzny
//
//  Created by 男左女右 on 2016/10/20.
//  Copyright © 2016年 nznychina. All rights reserved.
//

#import "CYInfoHeaderCell.h"

@implementation CYInfoHeaderCell

// 模型赋值
- (void)setInfoHeaderCellModel:(CYInfoHeaderCellModel *)infoHeaderCellModel{
    
    // 模型
    _infoHeaderCellModel = infoHeaderCellModel;
    
    // title
    _titleLab.text = infoHeaderCellModel.title;
    
    // headerImgView
//    _headImgView.image = [CYUtilities setUrlImgWithHostUrl:cHostUrl andUrl:infoHeaderCellModel.headImgName];
    if ([infoHeaderCellModel.headImgName isEqualToString:@""]) {
        
        _headImgView.image = [UIImage imageNamed:@"默认头像"];
    }
    else {
        
        [_headImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",cHostUrl,infoHeaderCellModel.headImgName]]];
    }
    
    _headImgView.layer.cornerRadius = (60.0 / 1334.0) * cScreen_Height;
    
    // nextImgView
    _nextImgView.image = [UIImage imageNamed:@"Right-"];
    
    
}

@end
