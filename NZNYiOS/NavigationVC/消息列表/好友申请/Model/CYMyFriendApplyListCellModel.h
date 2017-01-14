//
//  CYMyFriendApplyListCellModel.h
//  nzny
//
//  Created by 男左女右 on 2017/1/14.
//  Copyright © 2017年 nznychina. All rights reserved.
//

#import "CYBaseModel.h"

@interface CYMyFriendApplyListCellModel : CYBaseModel


// 性别
@property (nonatomic, copy) NSString *Gender;

// Id
@property (nonatomic, copy) NSString *Id;

// 昵称
@property (nonatomic, copy) NSString *Nickname;

// 头像
@property (nonatomic, copy) NSString *Portrait;

// 姓名
@property (nonatomic, copy) NSString *RealName;

// 备注
@property (nonatomic, copy) NSString *Remark;

// UserId
@property (nonatomic, copy) NSString *UserId;



@end
