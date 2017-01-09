//
//  CYOthersInfoView.m
//  nzny
//
//  Created by 男左女右 on 2016/11/22.
//  Copyright © 2016年 nznychina. All rights reserved.
//

#import "CYOthersInfoView.h"

@implementation CYOthersInfoView


// 模型赋值
- (void)setOthersInfoViewModel:(CYOthersInfoViewModel *)othersInfoViewModel{
    
    // 模型赋值
    _othersInfoViewModel = othersInfoViewModel;
    
    // 头像
    _headImgView.image = [CYUtilities setUrlImgWithHostUrl:cHostUrl andUrl:othersInfoViewModel.Portrait];
    
    // 工作
    _workLab.text = othersInfoViewModel.work;
    
    // 房车
    _houseAndCarLab.text = othersInfoViewModel.houseAndCar;
    
    // 爱好
    _hobbyLab.text = othersInfoViewModel.hobby;
    
    // 身高
    _heightLab.text = othersInfoViewModel.height;
    
    // 星座
    _starSignLab.text = othersInfoViewModel.starSign;
    
    // 姓名
    _nameLab.text = othersInfoViewModel.RealName;
    
    // 年龄
    _ageLab.text = [NSString stringWithFormat:@"%ld 岁",othersInfoViewModel.Age];
    
    // 性别
    
    if ([othersInfoViewModel.Gender isEqualToString:@"男"]) {
        _genderImgView.image = [UIImage imageNamed:@"资料性别男"];
        
    }
    else {
        
        _genderImgView.image = [UIImage imageNamed:@"资料性别女"];
    }
    
    // 关注人数
    _followCountLab.text = [NSString stringWithFormat:@"%ld",othersInfoViewModel.FollowsCount];
    
    // 粉丝人数
    _fansCountLab.text = [NSString stringWithFormat:@"%ld",othersInfoViewModel.FansCount];
    
    // 礼物数量
    _giftCountLab.text = [NSString stringWithFormat:@"%ld",othersInfoViewModel.GiftCount];
    
    // 关注
    //  没有关注，现在可以关注
    if (othersInfoViewModel.IsFollow == NO) {
        
        
//        [_followBtn setBackgroundImage:[UIImage imageNamed:@"关注"] forState:UIControlStateNormal];
        
//        _followBtn.imageView.image = [UIImage imageNamed:@"详情关注-"];
        [_followBtn setImage:[UIImage imageNamed:@"详情关注-"] forState:UIControlStateNormal];
        [_followBtn setTitle:@"加关注" forState:UIControlStateNormal];
        
        [_followBtn setTitleColor:[UIColor colorWithRed:0.37 green:0.65 blue:0.99 alpha:1.00] forState:UIControlStateNormal];
        
    }
    
    // 已经关注，显示取消关注
    else {
        
        [_followBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        
        [_followBtn setTitle:@"取消关注" forState:UIControlStateNormal];
        [_followBtn setTitleColor:[UIColor colorWithRed:234.0 / 255.0 green:130.0 / 255.0 blue:47.0 / 255.0 alpha:1.0] forState:UIControlStateNormal];
    }
    
    
}



@end
