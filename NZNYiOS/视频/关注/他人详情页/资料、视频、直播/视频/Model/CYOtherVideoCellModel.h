//
//  CYOtherVideoCellModel.h
//  nzny
//
//  Created by 男左女右 on 2016/11/28.
//  Copyright © 2016年 nznychina. All rights reserved.
//

#import "CYBaseModel.h"

@interface CYOtherVideoCellModel : CYBaseModel

// 12个属性



// 审核数据
@property (nonatomic, copy) NSString *AuditDate;

// 审核建议
@property (nonatomic, copy) NSString *AuditIdea;

// 审核状态
@property (nonatomic, assign) NSInteger AuditStatus;

// 审核人
@property (nonatomic, copy) NSString *AuditUserId;

// 创建时间
@property (nonatomic, copy) NSString *CreateDate;

// 默认使用
@property (nonatomic, assign) BOOL Default;

// 热门
@property (nonatomic, assign) BOOL Hot;

// Id：视频
@property (nonatomic, copy) NSString *Id;

// 介绍
@property (nonatomic, copy) NSString *Introduction;

// 视频大小
@property (nonatomic, assign) double Size;

// 所选择的用户Id
@property (nonatomic, copy) NSString *UserId;

// 视频地址
@property (nonatomic, copy) NSString *Video;



@end
