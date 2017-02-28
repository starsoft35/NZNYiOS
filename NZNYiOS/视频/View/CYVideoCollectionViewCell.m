//
//  CYVideoCollectionViewCell.m
//  nzny
//
//  Created by 男左女右 on 2016/11/22.
//  Copyright © 2016年 nznychina. All rights reserved.
//

#import "CYVideoCollectionViewCell.h"

@implementation CYVideoCollectionViewCell


// 模型赋值
- (void)setVideoCellModel:(CYVideoCollectionViewCellModel *)videoCellModel{
    
    
    // 模型赋值
    _videoCellModel = videoCellModel;
    
    // 视频背景
//    _videoBgImgView.image = [UIImage imageNamed:videoCellModel.videoBgImgName];
//    _videoBgImgView.image = [CYUtilities setUrlImgWithHostUrl:cHostUrl andUrl:videoCellModel.VideoUserPortrait];
    if ([videoCellModel.VideoUserPortrait isEqualToString:@""] || videoCellModel.VideoUserPortrait == nil) {
        
        _videoBgImgView.image = [UIImage imageNamed:@"默认头像"];
    }
    else {
        
        [_videoBgImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",cHostUrl,videoCellModel.VideoUserPortrait]]];
    }
    
    // 几零后、星座
    _ageAndStarSignLab.text = videoCellModel.ageAndStarSign;
    
    
    // 性别
    _genderImgView.image = [UIImage imageNamed:videoCellModel.VideoUserGender];
    
    // 姓名
    _nameLab.text = videoCellModel.VideoUserName;
    
    
    // 联系他:title
    [_connectBtn setTitle:videoCellModel.connectTitle forState:UIControlStateNormal];
    
    // 联系他背景
    _connectBtn.imageView.image = [UIImage imageNamed:videoCellModel.connectBgImgViewName];
    
}


@end
