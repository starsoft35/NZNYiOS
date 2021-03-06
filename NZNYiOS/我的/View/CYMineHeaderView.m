//
//  CYMineHeaderView.m
//  NZNYiOS
//
//  Created by 男左女右 on 16/9/29.
//  Copyright © 2016年 NZNY. All rights reserved.
//

#import "CYMineHeaderView.h"



@implementation CYMineHeaderView



// 属性赋值
- (void)setMineMainHeaderViewModel:(CYMineHeaderViewModel *)mineMainHeaderViewModel{
    
    // 模型赋值
    _mineMainHeaderViewModel = mineMainHeaderViewModel;
    
    // 头像
//    _mineHeadImgView.image = [CYUtilities setUrlImgWithHostUrl:cHostUrl andUrl:mineMainHeaderViewModel.portrait];
    if ([mineMainHeaderViewModel.portrait isEqualToString:@""]) {
        
        _mineHeadImgView.image = [UIImage imageNamed:@"默认头像"];
    }
    else {
        
        [_mineHeadImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",cHostUrl,mineMainHeaderViewModel.portrait]] placeholderImage:[UIImage imageNamed:@"默认头像"]];
    }
    
    
    _mineHeadImgView.layer.cornerRadius = (100.0 / 1334.0) * cScreen_Height;
    NSLog(@"headerView.mineHeadImgView.frame.size.height / 2:%lf",_mineHeadImgView.frame.size.height / 2);
    NSLog(@"cScreen_Height:%f",cScreen_Height);
    
    // 姓名：label
    _userNameLab.text = mineMainHeaderViewModel.userName;
    
    
    // ID：label
    _userIDLab.text = mineMainHeaderViewModel.fId;
    
    // 地址：label
    if ([mineMainHeaderViewModel.userAddress isEqualToString:@""]) {
        
        _userAddressLab.text = [NSString stringWithFormat:@"暂无地址信息"];
    }
    else {
        
        _userAddressLab.text = [NSString stringWithFormat:@"%@",mineMainHeaderViewModel.userAddress];
    }
    
    
    // 性别：imgView
    NSString *genderImgName = [[NSString alloc] init];
    if ([mineMainHeaderViewModel.userGender isEqualToString:@"男"]) {
        
        genderImgName = @"资料性别男";
    }
    else {
        genderImgName = @"资料性别女";
    }
    _userGenderImgView.image = [UIImage imageNamed:genderImgName];
    
    
    // 视频数量
    _videoCountLab.text = [NSString stringWithFormat:@"%ld",(long)mineMainHeaderViewModel.VideoCount];
    // 直播数量
    _liveCountLab.text = [NSString stringWithFormat:@"%ld",(long)mineMainHeaderViewModel.LiveCount];
    // 粉丝数量
    _fansCountLab.text = [NSString stringWithFormat:@"%ld",(long)mineMainHeaderViewModel.FansCount];
    // 关注数量
    _followCountLab.text = [NSString stringWithFormat:@"%ld",(long)mineMainHeaderViewModel.FollowsCount];
    
    
}





@end
