//
//  CYMineHeaderViewModel.h
//  nzny
//
//  Created by 男左女右 on 16/10/11.
//  Copyright © 2016年 nznychina. All rights reserved.
//

#import "JSONModel.h"

@interface CYMineHeaderViewModel : JSONModel


// 头像
@property (nonatomic, copy) NSString *portrait;

// 姓名
@property (copy, nonatomic) NSString *userName;


// 活跃天数
@property (copy, nonatomic) NSString *userActiveDays;


// fId
@property (copy, nonatomic) NSString *fId;


// 地址
@property (copy, nonatomic) NSString *userAddress;

// 性别
@property (nonatomic,copy) NSString *userGender;

// 视频数量
@property (nonatomic, assign) NSInteger VideoCount;
// 直播数量
@property (nonatomic, assign) NSInteger LiveCount;
// 粉丝数量
@property (nonatomic, assign) NSInteger FansCount;
// 关注数量
@property (nonatomic, assign) NSInteger FollowsCount;



@end
