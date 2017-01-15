//
//  CYVideoDetailsView.m
//  nzny
//
//  Created by 男左女右 on 2016/11/27.
//  Copyright © 2016年 nznychina. All rights reserved.
//

#import "CYVideoDetailsView.h"

@implementation CYVideoDetailsView


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
    [self setTagValureWithOthersInfoViewModel:othersInfoVM];
    
    
    // 宣言
    _declarationLab.text = [NSString stringWithFormat:@"爱情宣言：%@",othersInfoVM.Declaration];
    
    
}


// 标签赋值
- (void)setTagValureWithOthersInfoViewModel:(CYOthersInfoViewModel *)othersInfoViewModel{
    
    int tempCount = 1;
    NSString *tagStr = [[NSString alloc] init];
    for (CYOtherTagModel * tempTagModel in othersInfoViewModel.UserTagList) {
        
        if (othersInfoViewModel.UserTagList.count >= 1) {
            
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
