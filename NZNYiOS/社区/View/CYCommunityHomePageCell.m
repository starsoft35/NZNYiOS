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
    UIImage *navigationPictureImg = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:communityHomePageCellModel.PictureUrl]]];
    NSLog(@"navigationPictureImg.size.width:%f",navigationPictureImg.size.width);
    NSLog(@"navigationPictureImg.size.height:%f",navigationPictureImg.size.height);
    
    
    [_navigationPictureImgView setImage:navigationPictureImg];
    
    [_navigationPictureImgView setContentScaleFactor:[[UIScreen mainScreen] scale]];
    
    _navigationPictureImgView.contentMode =  UIViewContentModeScaleAspectFill;
    
    _navigationPictureImgView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    
    _navigationPictureImgView.clipsToBounds  = YES;
    
//    _navigationPictureImgView.image = navigationPictureImg;
//    _navigationPictureImgView.image = [UIImage imageNamed:@"117.jpg"];
    
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
