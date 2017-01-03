//
//  CYUserInfoModel.h
//  nzny
//
//  Created by 男左女右 on 2016/12/10.
//  Copyright © 2016年 nznychina. All rights reserved.
//

#import "CYBaseModel.h"

@interface CYUserInfoModel : CYBaseModel


// 生日
//@property (nonatomic, copy) NSString *Birthday;
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
// 用户Id
@property (nonatomic, copy) NSString *Id;
// 结婚状态
@property (nonatomic, copy) NSString *Marriage;
// 昵称
@property (nonatomic, copy) NSString *Nickname;
// 头像
@property (nonatomic, copy) NSString *Portrait;
// 省
@property (nonatomic, copy) NSString *Province;
// 姓名
@property (nonatomic, copy) NSString *RealName;
// 融云token
@property (nonatomic, copy) NSString *RongToken;


@end
