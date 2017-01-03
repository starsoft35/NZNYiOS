//
//  CYLivePlayDetailsVC.h
//  nzny
//
//  Created by 男左女右 on 2016/12/10.
//  Copyright © 2016年 nznychina. All rights reserved.
//

#import "CYBaseViewController.h"

// 直播详情页
#import "CYLivePlayDetailsView.h"


@interface CYLivePlayDetailsVC : CYBaseViewController

// 直播详情页：view
@property (nonatomic, strong) CYLivePlayDetailsView *livePlayDetailsView;


// 所查看的用户Id
@property (nonatomic, copy) NSString *oppUserId;

// 直播ID
@property (nonatomic, copy) NSString *liveID;

// 是否是预告，不是则为直播
@property (nonatomic, assign) BOOL isTrailer;

@end
