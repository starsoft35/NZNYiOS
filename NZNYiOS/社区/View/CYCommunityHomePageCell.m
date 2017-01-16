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
//    _navigationPictureImgView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:communityHomePageCellModel.PictureUrl]]];
    _navigationPictureImgView.image = [UIImage imageNamed:@"117.jpg"];
    
    // 所属类别
    _categoryLab.text = [NSString stringWithFormat:@"【%@】",communityHomePageCellModel.ActivityCategoryName];
    
    // 标题
    _titleLab.text = communityHomePageCellModel.Title;
    
    // 简介
    _summaryLab.text = [NSString stringWithFormat:@"        %@",communityHomePageCellModel.Summary];
    
    // 发布时间
    _releaseTimeLab.text = [NSString stringWithFormat:@"%@",communityHomePageCellModel.CreateDate];
    
}



@end
