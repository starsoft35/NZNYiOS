//
//  CYVideoDetailsView.m
//  nzny
//
//  Created by 男左女右 on 2016/11/27.
//  Copyright © 2016年 nznychina. All rights reserved.
//

#import "CYVideoDetailsView.h"

@implementation CYVideoDetailsView


// 赋值：模型：视频详情页
- (void)setVideoDetailsViewModel:(CYVideoDetailsViewModel *)videoDetailsViewModel{
    
    
    _videoDetailsViewModel = videoDetailsViewModel;
    
    
    // 视频详情页背景
    //    _bgImgView.image = [CYUtilities setUrlImgWithHostUrl:cHostUrl andUrl:othersInfoVM.Portrait];
    if ([videoDetailsViewModel.VideoUserPortrait isEqualToString:@""]) {
        
        _headImgView.image = [UIImage imageNamed:@"默认头像"];
    }
    else {
        
        [_bgImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",cHostUrl,videoDetailsViewModel.VideoUserPortrait]] placeholderImage:[UIImage imageNamed:@"默认头像"]];
    }
    
    // 头像
    //    _headImgView.image = [CYUtilities setUrlImgWithHostUrl:cHostUrl andUrl:othersInfoVM.Portrait];
    if ([videoDetailsViewModel.VideoUserPortrait isEqualToString:@""]) {
        
        _headImgView.image = [UIImage imageNamed:@"默认头像"];
    }
    else {
        
        [_headImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",cHostUrl,videoDetailsViewModel.VideoUserPortrait]] placeholderImage:[UIImage imageNamed:@"默认头像"]];
    }
    
    
    _headImgView.layer.cornerRadius = (30.0 / 1334.0) * cScreen_Height;
    
    // 姓名
    _nameLab.text = videoDetailsViewModel.VideoUserName;
    
    // ID
    _idLab.text = [NSString stringWithFormat:@"ID：%ld",videoDetailsViewModel.VideoUserFId];
    
    
    // 关注
    // 如果已经关注，则隐藏
    if (videoDetailsViewModel.IsFollow == YES) {
        
        _topHeadNameIDFollowBgImgView.hidden = YES;
        
        _topAllreadyFollowBgImgView.hidden = NO;
        _topHeadNameIDFollowView.frame = _topAllreadyFollowBgImgView.frame;
        
        _followBtn.hidden = YES;
        
        
    }
    // 如果没有关注，则显示
    else {
        
        _topAllreadyFollowBgImgView.hidden = YES;
        
        _topHeadNameIDFollowBgImgView.hidden = NO;
        _topHeadNameIDFollowView.frame = _topHeadNameIDFollowBgImgView.frame;
        
        
        _followBtn.hidden = NO;
    }
    
    
    // 标签赋值
    [self setTagValureWithOthersInfoViewModel:videoDetailsViewModel];
    
    
    // 宣言
    _declarationLab.text = [NSString stringWithFormat:@"爱情宣言：%@",videoDetailsViewModel.VideoUserDeclaration];
    
    
}

// 赋值：模型：他人详情页
- (void)setOthersInfoVM:(CYOthersInfoViewModel *)othersInfoVM{
    
}


// 标签赋值
- (void)setTagValureWithOthersInfoViewModel:(CYVideoDetailsViewModel *)videoDetailsViewModel{
    
    int tempCount = 1;
    NSString *tagStr = [[NSString alloc] init];
    for (CYOtherTagModel * tempTagModel in videoDetailsViewModel.VideoUserTagList) {
        
        if (videoDetailsViewModel.VideoUserTagList.count >= 1) {
            
            if (tempCount == 1) {
                
                tagStr = [tagStr stringByAppendingString:[NSString stringWithFormat:@"%@ ",tempTagModel.Name]];
            }
            else {
                
                tagStr = [tagStr stringByAppendingString:[NSString stringWithFormat:@"/ %@ ",tempTagModel.Name]];
            }
            
            tempCount += 1;
        }
    }
    // 标签
    _tagLab.text = [NSString stringWithFormat:@"标签：%@",tagStr];
    
}

@end
