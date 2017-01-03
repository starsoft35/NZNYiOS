//
//  CYLikeTipVC.h
//  nzny
//
//  Created by 男左女右 on 2016/11/23.
//  Copyright © 2016年 nznychina. All rights reserved.
//

#import "CYBaseViewController.h"

// 点赞：主视图
#import "CYLikeTipView.h"


@interface CYLikeTipVC : CYBaseViewController


// 主视图
@property (nonatomic, strong) CYLikeTipView *likeTipView;

// 所查看的用户Id
@property (nonatomic, copy) NSString *oppUserId;

@end
