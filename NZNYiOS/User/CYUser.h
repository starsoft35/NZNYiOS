//
//  CYUser.h
//  nzny
//
//  Created by 男左女右 on 16/10/9.
//  Copyright © 2016年 nznychina. All rights reserved.
//

#import <Foundation/Foundation.h>

// 用来表示当前登录的用户
@interface CYUser : NSObject<NSCoding>

// 用户ID：用户的唯一标志
@property (nonatomic,copy)NSString *userID;

// 用户account：手机号
@property (nonatomic,copy)NSString *userAccount;

// 用户password：密码
@property (nonatomic,copy)NSString *userPSW;

// token：获取用户信息的标示
@property (nonatomic,copy)NSString *userToken;

// 融云：userId
@property (nonatomic, copy) NSString *RCUserId;

// 融云：userToken
@property (nonatomic, copy) NSString *RongToken;

// 出生日期
@property (nonatomic, copy) NSString *Birthday;

// 城市
@property (nonatomic, copy) NSString *City;

// 爱情宣言
@property (nonatomic, copy) NSString *Declaration;

// 学历
@property (nonatomic, copy) NSString *Education;

// FId
@property (nonatomic, assign) NSInteger FId;

// 性别
@property (nonatomic, copy) NSString *Gender;

// Id
@property (nonatomic, copy) NSString *Id;

// 婚姻状况
@property (nonatomic, copy) NSString *Marriage;

// 昵称
@property (nonatomic, copy) NSString *Nickname;

// 头像
@property (nonatomic, copy) NSString *Portrait;

// 省
@property (nonatomic, copy) NSString *Province;

// 真是姓名
@property (nonatomic, copy) NSString *RealName;


// 因为当前登录的用户只能有一个，所以做成一个单例
+ (instancetype)currentUser;

@end
