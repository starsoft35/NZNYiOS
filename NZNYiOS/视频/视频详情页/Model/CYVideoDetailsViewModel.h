//
//  CYVideoDetailsViewModel.h
//  nzny
//
//  Created by 男左女右 on 2016/11/28.
//  Copyright © 2016年 nznychina. All rights reserved.
//

#import "CYBaseModel.h"

@interface CYVideoDetailsViewModel : CYBaseModel

// 视频Id
@property (nonatomic, copy) NSString *VideoId;

// 视频地址
@property (nonatomic, copy) NSString *VideoUrl;

// 视频简介
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
@property (nonatomic, copy) NSArray *VideoUserTagList;


@end
