//
//  CYVideoIsFriendModel.h
//  nzny
//
//  Created by 男左女右 on 2016/12/7.
//  Copyright © 2016年 nznychina. All rights reserved.
//

#import "CYBaseModel.h"

@interface CYVideoIsFriendModel : CYBaseModel


// 是否为朋友
@property (nonatomic, assign) BOOL IsFriend;

// 返回信息
@property (nonatomic, copy) NSString *msg;


@end
