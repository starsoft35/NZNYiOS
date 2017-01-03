//
//  CYOtherLiveCellModel.h
//  nzny
//
//  Created by 男左女右 on 2016/11/28.
//  Copyright © 2016年 nznychina. All rights reserved.
//

#import "CYBaseModel.h"

@interface CYOtherLiveCellModel : CYBaseModel

// Id：直播
@property (nonatomic, copy) NSString *Id;

// 观看的用户Id
@property (nonatomic, copy) NSString *UserId;

// 直播形象图片
@property (nonatomic, copy) NSString *Pictrue;

// 预计开始时间
@property (nonatomic, copy) NSString *PlanStartTime;

// 实际开始时间
@property (nonatomic, copy) NSString *StartTime;

// 预计结束时间
@property (nonatomic, copy) NSString *PlanEndTime;

// 实际结束时间
@property (nonatomic, copy) NSString *EndTime;

// 直播主题
@property (nonatomic, copy) NSString *Title;

// 直播报名手机号
@property (nonatomic, copy) NSString *Mobile;

// 直播分类
@property (nonatomic, copy) NSString *Category;

// 审核人
@property (nonatomic, copy) NSString *AuditUserId;

// 审核意见
@property (nonatomic, copy) NSString *AuditIdea;

// 当前状态 1-申请中 2-正在直播 3-直播结束
@property (nonatomic, assign) NSInteger Status;

// 观看人数
@property (nonatomic, assign) NSInteger LookerCount;

// 最高观看人数
@property (nonatomic, assign) NSInteger HLookerCount;

// 最低观看人数
@property (nonatomic, assign) NSInteger LLookerCount;

// 创建时间
@property (nonatomic, copy) NSString *CreateDate;


@end
