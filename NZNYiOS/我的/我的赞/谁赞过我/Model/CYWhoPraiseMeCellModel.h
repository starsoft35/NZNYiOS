//
//  CYWhoPraiseMeCellModel.h
//  nzny
//
//  Created by 男左女右 on 2016/12/18.
//  Copyright © 2016年 nznychina. All rights reserved.
//

#import "CYBaseModel.h"

@interface CYWhoPraiseMeCellModel : CYBaseModel

// 是点赞还是送礼
@property (nonatomic, assign) BOOL isPraise;

// 年龄
@property (nonatomic, assign) NSInteger Age;

// 诚信等级
@property (nonatomic, assign) float CertificateLevel;

// 点赞数量
@property (nonatomic, assign) NSInteger Count;

// 爱情宣言
@property (nonatomic, copy) NSString *Declaration;

// 性别
@property (nonatomic, copy) NSString *Gender;

// 头像
@property (nonatomic, copy) NSString *Portrait;

// 姓名
@property (nonatomic, copy) NSString *RealName;

// 所查看的用户ID
@property (nonatomic, copy) NSString *UserId;




@end
