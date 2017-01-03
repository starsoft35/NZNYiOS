//
//  CYMineMainTableViewCell.m
//  nzny
//
//  Created by 男左女右 on 16/10/8.
//  Copyright © 2016年 nznychina. All rights reserved.
//

#import "CYMineMainTableViewCell.h"



@implementation CYMineMainTableViewCell
{
    float _nowStarLever;
}

// 属性赋值
- (void)setMineMainCellModel:(CYMineMainCellModel *)mineMainCellModel{
    
    // 模型
    _mineMainCellModel = mineMainCellModel;
    
    // 标题
    _mineCellTitleLab.text = mineMainCellModel.mineCellTitle;
    
    // 星级：
    _nowStarLever = mineMainCellModel.mineStarLevel;
    
    
    // 星级
    // 直接给切好图片，会更好
    
    if (mineMainCellModel.isStarLevelCell) {
        
        // 星一：
        //        _creditRatingView
        _firstStarImgView.image = [UIImage imageNamed:[self getStarImgNameWithNowStarLevel:_nowStarLever]];
        
        // 星二：
        _secStarImgView.image = [UIImage imageNamed:[self getStarImgNameWithNowStarLevel:_nowStarLever]];
        
        // 星三：
        _thirdImgView.image = [UIImage imageNamed:[self getStarImgNameWithNowStarLevel:_nowStarLever]];
        
        // 星四：
        _fourStarImgView.image = [UIImage imageNamed:[self getStarImgNameWithNowStarLevel:_nowStarLever]];
        
        // 星五：
        _fiveImgView.image = [UIImage imageNamed:[self getStarImgNameWithNowStarLevel:_nowStarLever]];
        
    }
    else {
        
//        [_creditRatingView removeFromSuperview];
        _creditRatingView.hidden = YES;
    }
    
    
    // 文本
    _mineCellInfoLab.text = mineMainCellModel.mineCellInfo;
    
    
    // 下一页
    _nextImgView.image = [UIImage imageNamed:mineMainCellModel.nextImgName];
    
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
