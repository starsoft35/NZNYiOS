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
    _headImgView.image = [CYUtilities setUrlImgWithHostUrl:cHostUrl andUrl:friendApplyListCellModel.Portrait];
    
    // 姓名
    _nameLab.text = friendApplyListCellModel.RealName;
    
    // 备注
    _descriptionLab.text = [NSString stringWithFormat:@"并说：%@",friendApplyListCellModel.Remark];
    
    
}

@end
