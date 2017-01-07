//
//  CYTitleAndImageCellCheckCellModel.h
//  nzny
//
//  Created by 男左女右 on 2017/1/7.
//  Copyright © 2017年 nznychina. All rights reserved.
//

#import "CYBaseModel.h"

@interface CYTitleAndImageCellCheckCellModel : CYBaseModel

// 标签主键
@property (nonatomic, copy) NSString *Id;

// 标签类别Id
@property (nonatomic, copy) NSString *TagTypeId;

// 标签名字
@property (nonatomic, copy) NSString *Name;

// 排序
@property (nonatomic, assign) NSInteger Sort;



@end
