//
//  CYMyFriendViewCell.m
//  nzny
//
//  Created by 男左女右 on 2016/11/9.
//  Copyright © 2016年 nznychina. All rights reserved.
//

#import "CYMyFriendViewCell.h"

@implementation CYMyFriendViewCell


- (void)setMyFriendViewCellModel:(CYMyFriendViewCellModel *)myFriendViewCellModel{
    
    
    _myFriendViewCellModel = myFriendViewCellModel;
    
    // 头像
//    _headImgView.image = [CYUtilities setUrlImgWithHostUrl:cHostUrl andUrl:myFriendViewCellModel.Portrait];
    if ([myFriendViewCellModel.Portrait isEqualToString:@""]) {
        
        _headImgView.image = [UIImage imageNamed:@"默认头像"];
    }
    else {
        
        
        [_headImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",cHostUrl,myFriendViewCellModel.Portrait]] placeholderImage:[UIImage imageNamed:@"默认头像"]];
    }
    
    _headImgView.layer.cornerRadius = (50.0 / 1334.0) * cScreen_Height;
    
    // 姓名
    _nameLab.text = myFriendViewCellModel.RealName;
    
    // 性别
    if ([myFriendViewCellModel.Gender isEqualToString:@"男"]) {
        
        _genderImgView.image = [UIImage imageNamed:@"资料性别男"];
    }
    else {
        
        _genderImgView.image = [UIImage imageNamed:@"资料性别女"];
    }
    
    // 年龄
    _ageLab.text = [NSString stringWithFormat:@"%d 岁",myFriendViewCellModel.Age];
    
    // 爱情宣言
    _declarationLab.text = myFriendViewCellModel.Declaration;
    
    // 置顶
    if (myFriendViewCellModel.Top) {
        
        
        _topLab.text = @"已置顶";
//        _topLab.hidden = NO;
        
        _topLabWidth.constant = 37;
        _topLabRigntDistance.constant = 13;
    }
    else {
        
        _topLab.text = @"";
//        _topLab.hidden = YES;
        _topLabWidth.constant = 0;
        _topLabRigntDistance.constant = 0;
        
        
    }
    
    
    
    
}


- (void)layoutSubviews{
    [super layoutSubviews];
    
    
}

@end
