//
//  CYMineVCModel.h
//  nzny
//
//  Created by 男左女右 on 2016/11/8.
//  Copyright © 2016年 nznychina. All rights reserved.
//

#import "CYBaseModel.h"

@interface CYMineVCModel : CYBaseModel

// 诚信认证星级
@property (nonatomic, assign) float CertificateLevel;

// 城市
//@property (nonatomic, copy) NSString *City;

// 粉丝数量
@property (nonatomic, assign) NSInteger FansCount;

// FId
@property (nonatomic, assign) NSInteger FId;

// 关注的数量
@property (nonatomic, assign) NSInteger FollowsCount;

// 性别
@property (nonatomic, copy) NSString *Gender;

// ID
@property (nonatomic, copy) NSString *Id;

// 等级
//@property (nonatomic, copy) NSString *Level;

// 喜欢的数量
@property (nonatomic, assign) NSInteger LikeCount;

// 直播的次数
@property (nonatomic, assign) NSInteger LiveCount;

// 现金
@property (nonatomic, assign) float Money;

// 昵称
//@property (nonatomic, copy) NSString *Nickname;

// 头像
@property (nonatomic, copy) NSString *Portrait;

// 省
//@property (nonatomic, copy) NSString *Province;

// 姓名
@property (nonatomic, copy) NSString *RealName;

// 视频数量
@property (nonatomic, assign) NSInteger VideoCount;



@end
