//
//  CYOthersInfoViewModel.h
//  nzny
//
//  Created by 男左女右 on 2016/11/22.
//  Copyright © 2016年 nznychina. All rights reserved.
//

#import "CYBaseModel.h"


// 标签模型
#import "CYOtherTagModel.h"
// 视频模型
#import "CYOtherVideoCellModel.h"

// 直播模型
//#import "CYOtherLiveCellModel.h"

// 协议：标签
@protocol CYOtherTagModel
@end

// 协议：视频
@protocol CYOtherVideoCellModel
@end

// 协议：直播
@protocol CYOtherLiveCellModel
@end


@interface CYOthersInfoViewModel : CYBaseModel


// 用户Id
@property (nonatomic, copy) NSString *Id;

#pragma 上部
// 头像：imageView
@property (nonatomic, copy) NSString *Portrait;

// 标签列表
@property (nonatomic, copy) NSArray<CYOtherTagModel> *UserTagList;

// 职业：label
@property (nonatomic, copy) NSString *work;

// 房车：label
@property (nonatomic, copy) NSString *houseAndCar;

// 宠物控：label
@property (nonatomic, copy) NSString *hobby;

// 身高：label
@property (nonatomic, copy) NSString *height;

// 星座：label
@property (nonatomic, copy) NSString *starSign;

// 姓名：label
@property (nonatomic, copy) NSString *RealName;

// 年龄：label
@property (nonatomic, assign) NSInteger Age;

// 性别：imageView
@property (nonatomic, copy) NSString *Gender;

// 关注人数：label
@property (nonatomic, assign) NSInteger FollowsCount;

// 粉丝人数：label
@property (nonatomic, assign) NSInteger FansCount;

// 礼物数量：label
@property (nonatomic, assign) NSInteger GiftCount;


#pragma 中部：资料
// 诚信等级
@property (nonatomic, assign) float CertificateLevel;

// FId
@property (nonatomic, assign) NSInteger FId;

// 学历
@property (nonatomic, copy) NSString *Education;

// 婚姻状况
@property (nonatomic, copy) NSString *Marriage;

// 城市
@property (nonatomic, copy) NSString *City;

// 爱情宣言
@property (nonatomic, copy) NSString *Declaration;


#pragma 中部：视频
@property (nonatomic, copy) NSArray<CYOtherVideoCellModel> *UserVideoList;

#pragma 中部：直播
// 直播列表
@property (nonatomic, copy) NSArray<CYOtherLiveCellModel> *LiveList;

#pragma 下部
// 是否为好友
@property (nonatomic, assign) BOOL IsFriend;
// 是否关注
@property (nonatomic, assign) BOOL IsFollow;


@end

//@interface CYOtherVideoCellModel : CYBaseModel
//
//// 审核数据
//@property (nonatomic, copy) NSString *AuditDate;
//
//// 审核建议
//@property (nonatomic, copy) NSString *AuditIdea;
//
//// 审核状态
//@property (nonatomic, assign) NSInteger AuditStatus;
//
//// 审核人
//@property (nonatomic, copy) NSString *AuditUserId;
//
//// 创建时间
//@property (nonatomic, copy) NSString *CreateDate;
//
//// 默认使用
//@property (nonatomic, assign) BOOL Default;
//
//// 热门
//@property (nonatomic, assign) BOOL Hot;
//
//// Id：视频
//@property (nonatomic, copy) NSString *Id;
//
//// 介绍
//@property (nonatomic, copy) NSString *Introduction;
//
//// 视频大小
//@property (nonatomic, assign) double Size;
//
//// 所选择的用户Id
//@property (nonatomic, copy) NSString *UserId;
//
//// 视频地址
//@property (nonatomic, copy) NSString *Video;
//
//
//
//@end


