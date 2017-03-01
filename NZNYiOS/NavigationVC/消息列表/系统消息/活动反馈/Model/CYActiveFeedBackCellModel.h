//
//  CYActiveFeedBackCellModel.h
//  nzny
//
//  Created by 男左女右 on 2017/2/22.
//  Copyright © 2017年 nznychina. All rights reserved.
//

#import "CYBaseModel.h"

@interface CYActiveFeedBackCellModel : CYBaseModel


// 消息详情
@property (nonatomic, copy) NSString *detailInfo;

// 活动Id
@property (nonatomic, copy) NSString *ActivityId;

// 活动内容
@property (nonatomic, copy) NSString *Content;

// 创建时间
@property (nonatomic, copy) NSString *CreateDate;

// 标题
@property (nonatomic, copy) NSString *Title;


@end
