//
//  CYNearbyPeopleCell.m
//  nzny
//
//  Created by 张春咏 on 2017/1/6.
//  Copyright © 2017年 nznychina. All rights reserved.
//

#import "CYNearbyPeopleCell.h"

@implementation CYNearbyPeopleCell


// 模型
- (void)setNearbyPeopleCellModel:(CYNearbyPeopleCellModel *)nearbyPeopleCellModel{
    
    _nearbyPeopleCellModel = nearbyPeopleCellModel;
    
    // 头像
//    _headerImgView.image = [CYUtilities setUrlImgWithHostUrl:cHostUrl andUrl:nearbyPeopleCellModel.Portrait];
    if ([nearbyPeopleCellModel.Portrait isEqualToString:@""]) {
        
        _headerImgView.image = [UIImage imageNamed:@"默认头像"];
    }
    else {
        
        [_headerImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",cHostUrl,nearbyPeopleCellModel.Portrait]]];
    }
    
    _headerImgView.layer.cornerRadius = (75.0 / 1334.0) * cScreen_Height;
    
    // 姓名
    _nameLab.text = nearbyPeopleCellModel.RealName;
    
    // 性别
    if ([nearbyPeopleCellModel.Gender isEqualToString:@"男"]) {
        
        _genderImgView.image = [UIImage imageNamed:@"资料性别男"];
    }
    else {
        
        _genderImgView.image = [UIImage imageNamed:@"资料性别女"];
    }
    
    // 年龄
    _ageLab.text = [NSString stringWithFormat:@"%ld 岁",nearbyPeopleCellModel.Age];
    
    // 距离
    _distanceLab.text = [NSString stringWithFormat:@"距离 %.2lf 米以内",nearbyPeopleCellModel.Distance];
    
    // 爱情宣言
    _declarationLab.text = nearbyPeopleCellModel.Declaration;
    
    
}







@end
