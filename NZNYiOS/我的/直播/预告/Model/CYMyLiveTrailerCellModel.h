//
//  CYMyLiveTrailerCellModel.h
//  nzny
//
//  Created by 男左女右 on 2016/12/14.
//  Copyright © 2016年 nznychina. All rights reserved.
//

#import "CYBaseModel.h"

@interface CYMyLiveTrailerCellModel : CYBaseModel


// 直播状态：是否可进入直播间
@property (nonatomic, assign) BOOL IsEnter;


// 直播ID
@property (nonatomic, copy) NSString *LiveId;

// 当前主播性别
@property (nonatomic, copy) NSString *LiveUserGender;

// 当前主播ID
@property (nonatomic, copy) NSString *LiveUserId;

// 当前主播姓名
@property (nonatomic, copy) NSString *LiveUserName;

// 直播背景
@property (nonatomic, copy) NSString *Pictrue;

// 直播创建时间
@property (nonatomic, copy) NSString *PlanStartTime;

// 直播标题
@property (nonatomic, copy) NSString *Title;


@end
