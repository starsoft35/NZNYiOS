//
//  CYMemberViewCellModel.h
//  nzny
//
//  Created by 男左女右 on 2017/3/16.
//  Copyright © 2017年 nznychina. All rights reserved.
//

#import "CYBaseModel.h"


// 协议：标签
@protocol CYOtherTagModel
@end



@interface CYMemberViewCellModel : CYBaseModel



// 年龄
@property (nonatomic, assign) NSInteger Age;

// 诚信等级
@property (nonatomic, assign) float CertificateLevel;

// 性别
@property (nonatomic, copy) NSString *Gender;

// Id：用户
@property (nonatomic, copy) NSString *Id;

// 昵称
@property (nonatomic, copy) NSString *Nickname;

// 头像
@property (nonatomic, copy) NSString *Portrait;

// 姓名
@property (nonatomic, copy) NSString *RealName;

// 标签列表
@property (nonatomic, copy) NSArray<CYOtherTagModel> *UserTagList;



@end
