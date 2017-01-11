//
//  CYOtherLiveCellModel.h
//  nzny
//
//  Created by 男左女右 on 2016/11/28.
//  Copyright © 2016年 nznychina. All rights reserved.
//

#import "CYBaseModel.h"

@interface CYOtherLiveCellModel : CYBaseModel

// 直播Id
@property (nonatomic, copy) NSString *LiveId;

// 直播主题
@property (nonatomic, copy) NSString *Title;

// 预计开始时间
@property (nonatomic, copy) NSString *PlanStartTime;

// 观看人数
@property (nonatomic, assign) NSInteger LookCount;

// 实际开始时间
@property (nonatomic, assign) NSInteger Status;



@end
