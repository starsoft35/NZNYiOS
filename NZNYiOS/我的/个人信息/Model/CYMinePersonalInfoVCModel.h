//
//  CYMinePersonalInfoVCModel.h
//  nzny
//
//  Created by 男左女右 on 2016/11/2.
//  Copyright © 2016年 nznychina. All rights reserved.
//

//#import "CYBaseModel.h"

#import "JSONModel.h"

@interface CYMinePersonalInfoVCModel : JSONModel


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

// 融云Token
@property (nonatomic, copy) NSString *RongToken;

@end
