//
//  CYCommunityHomePageCellModel.h
//  nzny
//
//  Created by 张春咏 on 2017/1/15.
//  Copyright © 2017年 nznychina. All rights reserved.
//

#import "CYBaseModel.h"

@interface CYCommunityHomePageCellModel : CYBaseModel


// 活动主键
@property (nonatomic,copy) NSString *ActivityContentId;

// 导航图片
@property (nonatomic,copy) NSString *PictureUrl;

// 所属类别
@property (nonatomic,copy) NSString *ActivityCategoryName;

// 标题
@property (nonatomic,copy) NSString *Title;

// 简介
@property (nonatomic,copy) NSString *Summary;

// 发布时间
@property (nonatomic,copy) NSString *CreateDate;




@end
