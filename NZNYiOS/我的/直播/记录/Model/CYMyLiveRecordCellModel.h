//
//  CYMyLiveRecordCellModel.h
//  nzny
//
//  Created by 男左女右 on 2016/12/18.
//  Copyright © 2016年 nznychina. All rights reserved.
//

#import "CYBaseModel.h"

@interface CYMyLiveRecordCellModel : CYBaseModel

// 直播ID
@property (nonatomic, copy) NSString *LiveId;

// 观看人数
@property (nonatomic, assign) NSInteger LookerCount;

// 开始时间
@property (nonatomic, copy) NSString *StartTime;

// 标题
@property (nonatomic, copy) NSString *Title;


@end
