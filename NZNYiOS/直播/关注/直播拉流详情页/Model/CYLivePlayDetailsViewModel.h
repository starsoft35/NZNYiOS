//
//  CYLivePlayDetailsViewModel.h
//  nzny
//
//  Created by 男左女右 on 2016/12/12.
//  Copyright © 2016年 nznychina. All rights reserved.
//

#import "CYBaseModel.h"

@interface CYLivePlayDetailsViewModel : CYBaseModel


// 是否拉流，不是则为推流
@property (nonatomic, assign) BOOL isPlayView;

// 是否是预告，不是则为直播
@property (nonatomic, assign) BOOL isTrailer;

// 直播ID
@property (nonatomic, copy) NSString *LiveId;
// 爱情宣言
@property (nonatomic, copy) NSString *LiveUserDeclaration;
// 直播用户FId
@property (nonatomic, assign) NSInteger LiveUserFId;
// 直播用户ID
@property (nonatomic, copy) NSString *LiveUserId;
// 直播用户名
@property (nonatomic, copy) NSString *LiveUserName;
// 直播用户头像
@property (nonatomic, copy) NSString *LiveUserPortrait;
// 标签列表
@property (nonatomic, copy) NSArray *LiveUserTagList;
// 直播列表背景
@property (nonatomic, copy) NSString *Pictrue;
// 直播开始时间
@property (nonatomic, copy) NSString *PlanStartTime;
// 直播标题
@property (nonatomic, copy) NSString *Title;



@end
