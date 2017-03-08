//
//  CYSystemOtherNewsCellModel.h
//  nzny
//
//  Created by 男左女右 on 2017/3/8.
//  Copyright © 2017年 nznychina. All rights reserved.
//

#import "CYBaseModel.h"

@interface CYSystemOtherNewsCellModel : CYBaseModel


// 主键
@property (nonatomic, copy) NSString *Id;

// 用户ID
@property (nonatomic, copy) NSString *UserId;


// 内容
@property (nonatomic, copy) NSString *Content;

// 创建时间
@property (nonatomic, copy) NSString *CreateDate;


@end
