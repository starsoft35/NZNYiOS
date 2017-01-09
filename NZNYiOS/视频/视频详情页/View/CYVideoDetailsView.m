//
//  CYVideoDetailsView.m
//  nzny
//
//  Created by 男左女右 on 2016/11/27.
//  Copyright © 2016年 nznychina. All rights reserved.
//

#import "CYVideoDetailsView.h"

@implementation CYVideoDetailsView

// 模型赋值
//- (void)setVideoDetailsViewModel:(CYVideoDetailsViewModel *)videoDetailsViewModel{
//    
//    _videoDetailsViewModel = videoDetailsViewModel;
//    
//    // 头像
//    _headImgView.image = [CYUtilities setUrlImgWithHostUrl:cHostUrl andUrl:videoDetailsViewModel.VideoUserPortrait];
//    
//    // 姓名
//    _nameLab.text = videoDetailsViewModel.VideoUserName;
//    
//    // ID
//    _idLab.text = [NSString stringWithFormat:@"ID：%ld",videoDetailsViewModel.VideoUserFId];
//    
//    
//    // 关注
//    
//    
//}




// 赋值：模型：他人详情页
- (void)setOthersInfoVM:(CYOthersInfoViewModel *)othersInfoVM{
    
    _othersInfoVM = othersInfoVM;
    
    
    // 视频详情页背景
    _bgImgView.image = [CYUtilities setUrlImgWithHostUrl:cHostUrl andUrl:othersInfoVM.Portrait];
    
    // 头像
    _headImgView.image = [CYUtilities setUrlImgWithHostUrl:cHostUrl andUrl:othersInfoVM.Portrait];
    
    // 姓名
    _nameLab.text = othersInfoVM.RealName;
    
    // ID
    _idLab.text = [NSString stringWithFormat:@"ID：%ld",othersInfoVM.FId];
    
    
    
    // 关注
    // 如果已经关注，则隐藏
    if (othersInfoVM.IsFollow == YES) {
        
        float topHeadNameIdFollowViewX = _topHeadNameIDFollowView.frame.origin.x;
        float topHeadNameIdFollowViewY = _topHeadNameIDFollowView.frame.origin.y;
        float topHeadNameIdFollowViewWidth = _topHeadNameIDFollowView.frame.size.width;
        float topHeadNameIdFollowViewHeight = _topHeadNameIDFollowView.frame.size.height;
        
        float followBtnX = _followBtn.frame.origin.x;
        float followBtnY = _followBtn.frame.origin.y;
        float followBtnWidth = _followBtn.frame.size.width;
        float followBtnHeight = _followBtn.frame.size.height;
        
        float newTopHeadNameIdFollowVieyX = topHeadNameIdFollowViewX;
        float newTopHeadNameIdFollowVieyY = topHeadNameIdFollowViewY;
//        float newTopHeadNameIdFollowVieyWidth = topHeadNameIdFollowViewWidth - (10 + followBtnWidth);
        float newTopHeadNameIdFollowVieyWidth = _headImgView.frame.size.width + _nameLab.frame.size.width + 30;
        float newTopHeadNameIdFollowVieyHeight = topHeadNameIdFollowViewHeight;
        
        CGRect newTopHeadNaemIdFollowViewRect = CGRectMake(newTopHeadNameIdFollowVieyX, newTopHeadNameIdFollowVieyY, newTopHeadNameIdFollowVieyWidth, newTopHeadNameIdFollowVieyHeight);
        CGRect newTopHeadNaemIdFollowBgImgViewRect = CGRectMake(0, 0, newTopHeadNameIdFollowVieyWidth, newTopHeadNameIdFollowVieyHeight);
        
//        _topHeadNameIDFollowView.frame = CGRectMake(topHeadNameIdFollowViewX, topHeadNameIdFollowViewY, topHeadNameIdFollowViewWidth - followBtnWidth, topHeadNameIdFollowViewHeight);
        _topHeadNameIDFollowView.frame = newTopHeadNaemIdFollowViewRect;
        
        
        
//        
//        _topHeadNameIDFollowBgImgView.frame = CGRectMake(0, 0, 20, 20);
//        CGSize imageSize = CGSizeMake(20, 20);
//        _topHeadNameIDFollowBgImgView.clipsToBounds  = YES;
//        _topHeadNameIDFollowBgImgView.contentMode = UIViewContentModeScaleToFill;
        _topHeadNameIDFollowBgImgView.hidden = YES;
        
        UIImage *img = [UIImage imageNamed:@"关注名字背景"];
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:newTopHeadNaemIdFollowBgImgViewRect];
        imgView.image = img;
        [_topHeadNameIDFollowView addSubview:imgView];
        
        _followBtn.hidden = YES;
        
        
        
//        [_followBtn removeFromSuperview];
//        CGRect topFrame = _topHeadNameIDFollowView.frame;
//        _topHeadNameIDFollowView.frame = CGRectMake(13, 0, 50, 50);
        
    }
    // 如果没有关注，则显示
    else {
        
        _followBtn.hidden = NO;
    }
    
    
#warning 标签：先空着
    // 标签
    _tagLab.text = [NSString stringWithFormat:@"标签："];
    
    // 宣言
    _declarationLab.text = [NSString stringWithFormat:@"爱情宣言：%@",othersInfoVM.Declaration];
    
    
}


@end
