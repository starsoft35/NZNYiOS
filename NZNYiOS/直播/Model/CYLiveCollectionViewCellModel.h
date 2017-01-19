//
//  CYLiveCollectionViewCellModel.h
//  nzny
//
//  Created by 男左女右 on 2016/11/19.
//  Copyright © 2016年 nznychina. All rights reserved.
//

#import "CYBaseModel.h"

@interface CYLiveCollectionViewCellModel : CYBaseModel


// 聊天室Id
@property (nonatomic, copy) NSString *DiscussionId;

// 直播背景图
@property (nonatomic, copy) NSString *Pictrue;

// 用户ID
@property (nonatomic, copy) NSString *LiveUserId;

// 直播ID
@property (nonatomic, copy) NSString *LiveId;


// 性别
@property (nonatomic, copy) NSString *LiveUserGender;

// 直播状态背景图
@property (nonatomic, copy) NSString *liveStatusBgImgName;

// 直播状态title
@property (nonatomic, copy) NSString *liveStatusTitle;

// 是否是观看人数，不是则为直播时间
@property (nonatomic, assign) BOOL isWatchCount;

// 观看人数
@property (nonatomic, assign) NSInteger WatchCount;

// 直播时间
@property (nonatomic, copy) NSString *PlanStartTime;

// 姓名
@property (nonatomic, copy) NSString *LiveUserName;


// 联系TA：button
//@property (nonatomic, copy) NSString *contactBtn;

// 直播标题
@property (nonatomic, copy) NSString *Title;


@end
