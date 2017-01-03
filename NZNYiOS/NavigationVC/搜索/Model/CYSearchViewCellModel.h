//
//  CYSearchViewCellModel.h
//  nzny
//
//  Created by 男左女右 on 2016/11/20.
//  Copyright © 2016年 nznychina. All rights reserved.
//

#import "CYBaseModel.h"

@interface CYSearchViewCellModel : CYBaseModel


// 用户ID
@property (nonatomic, copy) NSString *Id;

// 头像：imageView
@property (copy, nonatomic) NSString *Portrait;


// 姓名：label
@property (copy, nonatomic) NSString *RealName;

// 昵称：label
@property (nonatomic, copy) NSString *Nickname;

// 性别：imageView
@property (copy, nonatomic) NSString *Gender;


// 年龄：label
@property (copy, nonatomic) NSString *Age;


// 星级：评级string
@property (nonatomic,assign) float CertificateLevel;


// 爱情宣言：label
@property (copy, nonatomic) NSString *Declaration;


// 是关注和不关注 or 关注和相互关注
@property (nonatomic, copy) NSString *followOrNoFollowOrMutualFollow;


// 是否关注
@property (nonatomic, assign) BOOL Follow;



@end
