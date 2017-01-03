//
//  CYOtherTagModel.h
//  nzny
//
//  Created by 男左女右 on 2016/11/28.
//  Copyright © 2016年 nznychina. All rights reserved.
//

#import "CYBaseModel.h"

@interface CYOtherTagModel : CYBaseModel

// Id：标签
@property (nonatomic, copy) NSString *Id;

// 用户UserId
@property (nonatomic, copy) NSString *UserId;
// TagId
@property (nonatomic, copy) NSString *TagId;
//// Tag
//@property (nonatomic, copy) NSString *Tag;

@end
