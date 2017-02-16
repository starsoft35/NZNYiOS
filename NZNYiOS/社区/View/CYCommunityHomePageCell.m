//
//  CYCommunityHomePageCell.m
//  nzny
//
//  Created by 男左女右 on 2017/1/15.
//  Copyright © 2017年 nznychina. All rights reserved.
//

#import "CYCommunityHomePageCell.h"


@implementation CYCommunityHomePageCell


// 模型赋值
- (void)setCommunityHomePageCellModel:(CYCommunityHomePageCellModel *)communityHomePageCellModel{
    
    _communityHomePageCellModel = communityHomePageCellModel;
    
    
    // 导航图片
    [_navigationPictureImgView sd_setImageWithURL:[NSURL URLWithString:communityHomePageCellModel.PictureUrl] placeholderImage:[UIImage imageNamed:@"默认头像"]];
    [_navigationPictureImgView setContentScaleFactor:[[UIScreen mainScreen] scale]];
    _navigationPictureImgView.contentMode =  UIViewContentModeScaleAspectFill;
    
    _navigationPictureImgView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    
    _navigationPictureImgView.clipsToBounds  = YES;
    
    
    // 所属类别
    _categoryLab.text = [NSString stringWithFormat:@"【%@】",communityHomePageCellModel.ActivityCategoryName];
    
    // 标题
    _titleLab.text = communityHomePageCellModel.Title;
    
    // 简介
    _summaryLab.text = [NSString stringWithFormat:@"%@",communityHomePageCellModel.Summary];
    
    // 发布时间
    _releaseTimeLab.text = [NSString stringWithFormat:@"%@",communityHomePageCellModel.CreateDate];
    
}



@end
