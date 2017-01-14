//
//  CYChatListVC.h
//  nzny
//
//  Created by 男左女右 on 2016/11/16.
//  Copyright © 2016年 nznychina. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>


// 好友申请：View
#import "CYFriendApplyView.h"


@interface CYChatListVC : RCConversationListViewController

// 当前用户Id：
@property (nonatomic, copy) NSString *currentUserId;
// 当前用户token：
@property (nonatomic, copy) NSString *currentUserToken;

// 我的好友申请列表：array
@property (nonatomic, strong) NSMutableArray *myFriendApplyListArr;


// 好友申请：View
@property (nonatomic, strong) CYFriendApplyView *friendApplyView;



// 提示框：hud
@property (nonatomic,strong)MBProgressHUD *hud;

@end
