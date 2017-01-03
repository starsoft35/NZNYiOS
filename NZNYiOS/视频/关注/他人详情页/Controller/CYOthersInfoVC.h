//
//  CYOthersInfoVC.h
//  nzny
//
//  Created by 男左女右 on 2016/11/22.
//  Copyright © 2016年 nznychina. All rights reserved.
//

#import "CYBaseViewController.h"

// 主视图
#import "CYOthersInfoView.h"

#import "CYOtherDetailsVC.h"
#import "CYOtherVideoVC.h"
#import "CYOtherLiveVC.h"


@interface CYOthersInfoVC : CYBaseViewController


// 主视图
@property (nonatomic, strong) CYOthersInfoView *othersInfoView;

// 资料
@property (nonatomic, strong) CYOtherDetailsVC *otherInfoVC;

// 视频
@property (nonatomic, strong) CYOtherVideoVC *otherVideoVC;

// 直播
@property (nonatomic, strong) CYOtherLiveVC *otherLiveVC;

// 所查看的用户Id
@property (nonatomic, copy) NSString *oppUserId;


@end
