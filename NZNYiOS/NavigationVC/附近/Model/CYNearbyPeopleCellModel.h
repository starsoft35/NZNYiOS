//
//  CYNearbyPeopleCellModel.h
//  nzny
//
//  Created by 张春咏 on 2017/1/6.
//  Copyright © 2017年 nznychina. All rights reserved.
//

#import "CYBaseModel.h"

@interface CYNearbyPeopleCellModel : CYBaseModel


// 用户Id
@property (nonatomic,copy) NSString *UserId;

// 头像
@property (nonatomic,copy) NSString *Portrait;

// 姓名
@property (nonatomic,copy) NSString *RealName;

// 性别
@property (nonatomic,copy) NSString *Gender;

// 年龄
@property (nonatomic , assign) NSInteger Age;

// 距离
@property (nonatomic,assign) float Distance;

// 爱情宣言
@property (nonatomic,copy) NSString *Declaration;



@end
