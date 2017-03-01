//
//  CYAskFeedBackCellModel.h
//  nzny
//
//  Created by 男左女右 on 2017/2/22.
//  Copyright © 2017年 nznychina. All rights reserved.
//

#import "CYBaseModel.h"

@interface CYAskFeedBackCellModel : CYBaseModel


// 问
@property (nonatomic, copy) NSString *Ask;

// 答
@property (nonatomic, copy) NSString *Answer;

// 创建时间
@property (nonatomic, copy) NSString *CreateDate;

@end
