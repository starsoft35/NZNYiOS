//
//  CYLivePushDetailsVC.h
//  nzny
//
//  Created by 男左女右 on 2016/12/18.
//  Copyright © 2016年 nznychina. All rights reserved.
//

#import "CYBaseViewController.h"

// 直播推流详情页
#import "CYLivePushDetailsView.h"

@interface CYLivePushDetailsVC : CYBaseViewController


// 直播推流详情页
@property (nonatomic, strong) CYLivePushDetailsView *livePushDetailsView;


// 所查看的用户Id
@property (nonatomic, copy) NSString *oppUserId;

// 直播ID
@property (nonatomic, copy) NSString *liveID;


// 直播推流地址
@property (nonatomic, copy) NSString *url;

@end
