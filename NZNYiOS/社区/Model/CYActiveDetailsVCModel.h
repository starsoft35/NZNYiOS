//
//  CYActiveDetailsVCModel.h
//  nzny
//
//  Created by 男左女右 on 2017/2/4.
//  Copyright © 2017年 nznychina. All rights reserved.
//

#import "CYBaseModel.h"

@interface CYActiveDetailsVCModel : CYBaseModel


// 活动类别的id
@property (nonatomic, copy) NSString *ActivityCategoryId;

// 活动内容的id
@property (nonatomic, copy) NSString *ActivityContentId;

// 是否允许申请
@property (nonatomic, assign) BOOL AllowApply;

// 附件
@property (nonatomic, copy) NSString *Attachment;

// 最大男生报名数
@property (nonatomic, assign) NSInteger BoyMaxCount;

// 内容
@property (nonatomic, copy) NSString *Content;

// 创建时间
@property (nonatomic, copy) NSString *CreateDate;

// 创建者id
@property (nonatomic, copy) NSString *CreateUserId;

// 创建者名字
@property (nonatomic, copy) NSString *CreateUserName;

// 允许的标记
@property (nonatomic, assign) NSInteger EnabledMark;

// 报名费
@property (nonatomic, assign) NSInteger Fee;

// 最大女生报名数
@property (nonatomic, assign) NSInteger GirlMaxCount;

// 每个页面元素的请求
@property (nonatomic, assign) NSInteger Hits;

// 持续时间
@property (nonatomic, copy) NSString *HoldingTime;

// 关键字
@property (nonatomic, copy) NSString *KeyWords;

// 修改时间
@property (nonatomic, copy) NSString *ModifyDate;

// 修改人的id
@property (nonatomic, copy) NSString *ModifyUserId;

// 修改人的名字
@property (nonatomic, copy) NSString *ModifyUserName;

// 组织者id
@property (nonatomic, copy) NSString *OrganizeId;

// 出处
@property (nonatomic, copy) NSString *Origin;

// 图片地址
@property (nonatomic, copy) NSString *PictureUrl;

// 分类代码
@property (nonatomic, copy) NSString *SortCode;

// 子标题
@property (nonatomic, copy) NSString *SubTitle;

// 摘要
@property (nonatomic, copy) NSString *Summary;

// 标题
@property (nonatomic, copy) NSString *Title;



@end
