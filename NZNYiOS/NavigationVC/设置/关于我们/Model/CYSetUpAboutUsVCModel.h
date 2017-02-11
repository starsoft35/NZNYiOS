//
//  CYSetUpAboutUsVCModel.h
//  nzny
//
//  Created by 男左女右 on 2017/2/4.
//  Copyright © 2017年 nznychina. All rights reserved.
//

#import "CYBaseModel.h"

@interface CYSetUpAboutUsVCModel : CYBaseModel


// 文章类别id
@property (nonatomic, copy) NSString *ArticleCategoryId;

// 文章内容id
@property (nonatomic, copy) NSString *ArticleContentId;
// 附件
@property (nonatomic, copy) NSString *Attachment;
// 内容
@property (nonatomic, copy) NSString *Content;
// 创建时间
@property (nonatomic, copy) NSString *CreateDate;
// 创建人id
@property (nonatomic, copy) NSString *CreateUserId;
// 创建人名字
@property (nonatomic, copy) NSString *CreateUserName;
// 允许标记
@property (nonatomic, assign) NSInteger EnabledMark;
// 页面元素的请求：一个页面中任何一个图片都算是一个页面元素;所以你如果想提高你的点击数的话;只需在你的页面中多放些图片就可以了
@property (nonatomic, assign) NSInteger Hits;
// 关键字
@property (nonatomic, copy) NSString *KeyWords;
// 修改日期
@property (nonatomic, copy) NSString *ModifyDate;
// 修改人id
@property (nonatomic, copy) NSString *ModifyUserId;
// 修改人名字
@property (nonatomic, copy) NSString *ModifyUserName;
// 组织id
@property (nonatomic, copy) NSString *OrganizeId;
// 出处
@property (nonatomic, copy) NSString *Origin;
// 图片地址
@property (nonatomic, copy) NSString *PictureUrl;
// 分类代码
@property (nonatomic, copy) NSString *SortCode;
// 子标题
@property (nonatomic, copy) NSString *SubTitle;
// 总结
@property (nonatomic, copy) NSString *Summary;
// 标题
@property (nonatomic, copy) NSString *Title;



@end
