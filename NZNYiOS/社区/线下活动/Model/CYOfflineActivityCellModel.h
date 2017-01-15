//
//  CYOfflineActivityCellModel.h
//  nzny
//
//  Created by 张春咏 on 2017/1/14.
//  Copyright © 2017年 nznychina. All rights reserved.
//

#import "CYBaseModel.h"

@interface CYOfflineActivityCellModel : CYBaseModel


//// 活动主键
//@property (nonatomic, copy) NSString *ActivityContentId;
//
//
//// 所属类别
//@property (nonatomic, copy) NSString *ActivityCategoryId;
//
//
//// 所属机构
//@property (nonatomic, copy) NSString *OrganizeId;
//
//
//// 标题
//@property (nonatomic, copy) NSString *Title;
//
//// 副标题
//@property (nonatomic, copy) NSString *SubTitle;
//
//// 简介
//@property (nonatomic, copy) NSString *Summary;
//
//// 举办时间
//@property (nonatomic, copy) NSDate *HoldingTime;
//
//
//// 来源
//@property (nonatomic, copy) NSString *Origin;
//
//// 关键字
//@property (nonatomic, copy) NSString *KeyWords;
//
//// 导航图片
//@property (nonatomic, copy) NSString *PictureUrl;
//
//// 附件
//@property (nonatomic, copy) NSString *Attachment;
//
//// 活动详情
//@property (nonatomic, copy) NSString *Content;
//
//// 状态 0-无效 1-有效
//@property (nonatomic, assign) NSInteger EnabledMark;
//
//// 排序
//@property (nonatomic, assign) NSInteger SortCode;
//
//// 点击量
//@property (nonatomic, assign) NSInteger Hits;
//
//// 添加日期
//@property (nonatomic, copy) NSDate *CreateDate;
//
//// 添加者主键
//@property (nonatomic, copy) NSString *CreateUserId;
//
//// 添加者
//@property (nonatomic, copy) NSString *CreateUserName;
//
//// 修改日期
//@property (nonatomic, copy) NSDate *ModifyDate;
//
//// 修改者主键
//@property (nonatomic, copy) NSString *ModifyUserId;
//
//// 修改者
//@property (nonatomic, copy) NSString *ModifyUserName;







// 活动主键
@property (nonatomic, copy) NSString *ActivityContentId;

// 导航图片
@property (nonatomic, copy) NSString *PictureUrl;

// 所属类别
@property (nonatomic, copy) NSString *ActivityCategoryName;

// 标题
@property (nonatomic, copy) NSString *Title;

// 简介
@property (nonatomic, copy) NSString *Summary;

// 发布时间
@property (nonatomic, copy) NSDate *CreateDate;



@end
