//
//  CYMyFriendApplyListCell.m
//  nzny
//
//  Created by 男左女右 on 2017/1/14.
//  Copyright © 2017年 nznychina. All rights reserved.
//

#import "CYMyFriendApplyListCell.h"

@implementation CYMyFriendApplyListCell

// 模型
- (void)setFriendApplyListCellModel:(CYMyFriendApplyListCellModel *)friendApplyListCellModel{
    
    _friendApplyListCellModel = friendApplyListCellModel;
    
    
    // 头像
//    _headImgView.image = [CYUtilities setUrlImgWithHostUrl:cHostUrl andUrl:friendApplyListCellModel.Portrait];
    if ([friendApplyListCellModel.Portrait isEqualToString:@""]) {
        
        _headImgView.image = [UIImage imageNamed:@"默认头像"];
    }
    else {
        
        [_headImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",cHostUrl,friendApplyListCellModel.Portrait]] placeholderImage:[UIImage imageNamed:@"默认头像"]];
    }
    
    _headImgView.layer.cornerRadius = (50.0 / 1334.0) * cScreen_Height;
    
    // 姓名
    _nameLab.text = friendApplyListCellModel.RealName;
    
    // 备注
    _descriptionLab.text = [NSString stringWithFormat:@"并说：%@",friendApplyListCellModel.Remark];
    
    
}

@end
