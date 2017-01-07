//
//  CYMyTagCellModel.h
//  nzny
//
//  Created by 男左女右 on 2017/1/7.
//  Copyright © 2017年 nznychina. All rights reserved.
//

#import "CYBaseModel.h"

@interface CYMyTagCellModel : CYBaseModel

// 标签名字
@property (nonatomic, copy) NSString *TagName;

// 标签Id
@property (nonatomic, copy) NSString *TagTypeId;

// 标签类型名
@property (nonatomic, copy) NSString *TagTypeName;

@end
