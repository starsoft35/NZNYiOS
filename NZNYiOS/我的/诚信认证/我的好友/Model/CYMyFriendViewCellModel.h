//
//  CYMyFriendViewCellModel.h
//  nzny
//
//  Created by 男左女右 on 2016/11/9.
//  Copyright © 2016年 nznychina. All rights reserved.
//

#import "CYBaseModel.h"

@interface CYMyFriendViewCellModel : CYBaseModel


// Id：关系主键
@property (nonatomic, copy) NSString *Id;

// userID：用户主键
@property (nonatomic, copy) NSString *UserId;

// 姓名
@property (nonatomic, copy) NSString *RealName;

// 昵称
@property (nonatomic, copy) NSString *Nickname;

// 性别
@property (nonatomic, copy) NSString *Gender;

// 年龄
@property (nonatomic, assign) int Age;

// 头像
@property (nonatomic, copy) NSString *Portrait;

// 爱情宣言
@property (nonatomic, copy) NSString *Declaration;

// 是否置顶
@property (nonatomic, assign) BOOL Top;


@end
