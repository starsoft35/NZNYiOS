//
//  CYVideoCollectionViewCellModel.h
//  nzny
//
//  Created by 男左女右 on 2016/11/22.
//  Copyright © 2016年 nznychina. All rights reserved.
//

#import "CYBaseModel.h"

@interface CYVideoCollectionViewCellModel : CYBaseModel

// 视频背景
@property (nonatomic, copy) NSString *videoBgImgName;


// 几零后、星座
@property (nonatomic, copy) NSString *ageAndStarSign;


// 联系他：文字
@property (nonatomic, copy) NSString *connectTitle;

// 联系他： 背景
@property (nonatomic, copy) NSString *connectBgImgViewName;



// 标签：array
@property (nonatomic, strong) NSArray *LiveUserTagList;

// 视频Id
@property (nonatomic, copy) NSString *VideoId;

// 视频地址
@property (nonatomic, copy) NSString *VideoUrl;

// 视频用户性别
@property (nonatomic, copy) NSString *VideoUserGender;

// 视频用户Id
@property (nonatomic, copy) NSString *VideoUserId;

// 视频用户姓名
@property (nonatomic, copy) NSString *VideoUserName;

// 视频用户头像
@property (nonatomic, copy) NSString *VideoUserPortrait;


@end
