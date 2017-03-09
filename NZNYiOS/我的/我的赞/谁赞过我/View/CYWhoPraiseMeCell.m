//
//  CYWhoPraiseMeCell.m
//  nzny
//
//  Created by 男左女右 on 2016/12/18.
//  Copyright © 2016年 nznychina. All rights reserved.
//

#import "CYWhoPraiseMeCell.h"

@implementation CYWhoPraiseMeCell


{
    float _nowStarLever;
}


// 模型赋值
- (void)setWhoPraiseMeCellModel:(CYWhoPraiseMeCellModel *)whoPraiseMeCellModel{
    
    _whoPraiseMeCellModel = whoPraiseMeCellModel;
    
    
    // 头像
//    _headImgView.image = [CYUtilities setUrlImgWithHostUrl:cHostUrl andUrl:whoPraiseMeCellModel.Portrait];
    if ([whoPraiseMeCellModel.Portrait isEqualToString:@""]) {
        
        _headImgView.image = [UIImage imageNamed:@"默认头像"];
    }
    else {
        
        [_headImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",cHostUrl,whoPraiseMeCellModel.Portrait]] placeholderImage:[UIImage imageNamed:@"默认头像"]];
    }
    
    // 姓名
    _nameLab.text = whoPraiseMeCellModel.RealName;
    
    // 性别
    if ([whoPraiseMeCellModel.Gender isEqualToString:@"男"]) {
        
        _genderImgView.image = [UIImage imageNamed:@"资料性别男"];
        
    }
    else {
        
        _genderImgView.image = [UIImage imageNamed:@"资料性别女"];
    }
    
    // 年龄
    _ageLab.text = [NSString stringWithFormat:@"%ld 岁",(long)whoPraiseMeCellModel.Age];
    
    // 诚信等级
    // 星级：
    _nowStarLever = whoPraiseMeCellModel.CertificateLevel;
    
    // 星一：
    //        _creditRatingView
    _firstStarImgView.image = [UIImage imageNamed:[self getStarImgNameWithNowStarLevel:_nowStarLever]];
    
    // 星二：
    _secondStarImgView.image = [UIImage imageNamed:[self getStarImgNameWithNowStarLevel:_nowStarLever]];
    
    // 星三：
    _thirdStarImgView.image = [UIImage imageNamed:[self getStarImgNameWithNowStarLevel:_nowStarLever]];
    
    // 星四：
    _fourStarImgView.image = [UIImage imageNamed:[self getStarImgNameWithNowStarLevel:_nowStarLever]];
    
    // 星五：
    _fiveStarImgView.image = [UIImage imageNamed:[self getStarImgNameWithNowStarLevel:_nowStarLever]];
    
    // 爱情宣言
    _declarationLab.text = whoPraiseMeCellModel.Declaration;
    
    
    // 点赞背景
    if (whoPraiseMeCellModel.isPraise) {
        
        // 是点赞
        _praiseImgView.image = [UIImage imageNamed:@"点赞"];
        // 点赞数量
        _praiseCountLab.text = [NSString stringWithFormat:@"%ld 个赞",(long)whoPraiseMeCellModel.Count];
    }
    else {
        
        // 不是点赞，则为送礼
        _praiseImgView.image = [UIImage imageNamed:@"玫瑰花"];
        // 送礼数量
        _praiseCountLab.text = [NSString stringWithFormat:@"%ld 朵花",(long)whoPraiseMeCellModel.Count];
    }
}

// 获取星级图片的名字
- (NSString *)getStarImgNameWithNowStarLevel:(float)nowStarLevel{
    
    NSLog(@"_nowStarLever:%lf",_nowStarLever);
    
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
