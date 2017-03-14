//
//  CYVideoDetailsViewModel.h
//  nzny
//
//  Created by 男左女右 on 2016/11/28.
//  Copyright © 2016年 nznychina. All rights reserved.
//

#import "CYBaseModel.h"


// 标签模型
#import "CYOtherTagModel.h"

// 协议：标签
@protocol CYOtherTagModel
@end

@interface CYVideoDetailsViewModel : CYBaseModel


// 是否已关注
@property (nonatomic, assign) BOOL IsFollow;


// 视频Id
@property (nonatomic, copy) NSString *VideoId;

// 视频地址
@property (nonatomic, copy) NSString *VideoUrl;

// 爱情宣言
@property (nonatomic, copy) NSString *VideoUserDeclaration;

// 视频FId
@property (nonatomic, assign) NSInteger VideoUserFId;

// 视频用户Id
@property (nonatomic, copy) NSString *VideoUserId;

// 视频用户名
@property (nonatomic, copy) NSString *VideoUserName;

// 视频头像
@property (nonatomic, copy) NSString *VideoUserPortrait;

// 视频标签列表
@property (nonatomic, copy) NSArray<CYOtherTagModel> *VideoUserTagList;


@end
