//
//  CYSearchViewCell.m
//  nzny
//
//  Created by 男左女右 on 2016/11/20.
//  Copyright © 2016年 nznychina. All rights reserved.
//

#import "CYSearchViewCell.h"

@implementation CYSearchViewCell

{
    float _nowStarLever;
}


// 模型赋值
- (void)setSearchModel:(CYSearchViewCellModel *)searchModel{
    
    // 模型赋值
    _searchModel = searchModel;
    
    // 头像
    
//    _headImgView.image = [CYUtilities setUrlImgWithHostUrl:cHostUrl andUrl:searchModel.Portrait];
    if ([searchModel.Portrait isEqualToString:@""]) {
        
        _headImgView.image = [UIImage imageNamed:@"默认头像"];
    }
    else {
        
        [_headImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",cHostUrl,searchModel.Portrait]] placeholderImage:[UIImage imageNamed:@"默认头像"]];
    }
    
    
    _headImgView.layer.cornerRadius = (75.0 / 1334.0) * cScreen_Height;
    
    // 姓名
    _nameLab.text = searchModel.RealName;
    
    // 性别
    if ([searchModel.Gender isEqualToString:@"男"]) {
        
        _genderImgView.image = [UIImage imageNamed:@"资料性别男"];
        
    }
    else {
        _genderImgView.image = [UIImage imageNamed:@"资料性别女"];
    }
    
    // 年龄
    _ageLab.text = [NSString stringWithFormat:@"%@ 岁",searchModel.Age];
    
    // 诚信等级
    // 星级：
    _nowStarLever = searchModel.CertificateLevel;
    
    if (1) {
        
        // 星一：
        //        _creditRatingView
        _firStarImgView.image = [UIImage imageNamed:[self getStarImgNameWithNowStarLevel:_nowStarLever]];
        
        // 星二：
        _secStarImgView.image = [UIImage imageNamed:[self getStarImgNameWithNowStarLevel:_nowStarLever]];
        
        // 星三：
        _thirdStarImgView.image = [UIImage imageNamed:[self getStarImgNameWithNowStarLevel:_nowStarLever]];
        
        // 星四：
        _fourthStarImgView.image = [UIImage imageNamed:[self getStarImgNameWithNowStarLevel:_nowStarLever]];
        
        // 星五：
        _fifthStarImgView.image = [UIImage imageNamed:[self getStarImgNameWithNowStarLevel:_nowStarLever]];
        
    }
    else {
        
        //        [_creditRatingView removeFromSuperview];
//        _creditRatingView.hidden = YES;
    }
    
    
    // 爱情宣言
    _declarationLab.text = searchModel.Declaration;
    
    
    // 关注
    // 如果是已关注和互相关注
    if ([searchModel.followOrNoFollowOrMutualFollow isEqualToString:@"关注和互相关注"]) {
        
        //  没有互相关注，显示已关注
        if (searchModel.Follow == NO) {
            
            
            [_followBtn setBackgroundImage:[UIImage imageNamed:@"已关注-"] forState:UIControlStateNormal];
        }
        
        // 已经互相关注，显示互相关注
        else {
            
            [_followBtn setBackgroundImage:[UIImage imageNamed:@"互相关注-"] forState:UIControlStateNormal];
        }
        
    }
    // 如果是未关注和已关注
    else {
        
        
        //  没有关注，现在可以关注
        if (searchModel.Follow == NO) {
            
            
            [_followBtn setBackgroundImage:[UIImage imageNamed:@"关注"] forState:UIControlStateNormal];
        }
        
        // 已经关注，显示取消关注
        else {
            
            [_followBtn setBackgroundImage:[UIImage imageNamed:@"已关注-"] forState:UIControlStateNormal];
        }
    }
    
}



// 获取星级图片的名字
- (NSString *)getStarImgNameWithNowStarLevel:(float)nowStarLevel{
    
    if (nowStarLevel >= 1) {
        
        _nowStarLever -= 1;
        
        // 全星
        return @"资料-已上传认证";
        
    }
    else if (nowStarLevel == 0.5) {
        
        _nowStarLever -= 0.5;
        
        // 半星
        return @"资料-已上传半颗星";
        
    }
    else
    {
        
        // 空星
        return @"资料未上传认证";
    }
    
}


@end
