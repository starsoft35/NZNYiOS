//
//  CYAddFriendVC.h
//  nzny
//
//  Created by 男左女右 on 2016/11/23.
//  Copyright © 2016年 nznychina. All rights reserved.
//

#import "CYBaseViewController.h"


// 加好友View
#import "CYAddFriendView.h"

@interface CYAddFriendVC : CYBaseViewController


// 对方Id
@property (nonatomic, copy) NSString *OppUserId;


// 添加好友视图
@property (nonatomic, strong) CYAddFriendView *addFriendView;

@end
