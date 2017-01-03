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
    _mineHeadImgView.image = [CYUtilities setUrlImgWithHostUrl:cHostUrl andUrl:mineMainHeaderViewModel.portrait];
    
    _mineHeadImgView.layer.cornerRadius = _mineHeadImgView.frame.size.height / 2;
    NSLog(@"headerView.mineHeadImgView.frame.size.height / 2:%lf",_mineHeadImgView.frame.size.height / 2);
    
    // 姓名：label
    _userNameLab.text = mineMainHeaderViewModel.userName;
    
    // 活跃天数：label
    _userActiveDaysLab.text = mineMainHeaderViewModel.userActiveDays;
    
    // ID：label
    _userIDLab.text = mineMainHeaderViewModel.fId;
    
    // 地址：label
    _userAddressLab.text = mineMainHeaderViewModel.userAddress;
    
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
