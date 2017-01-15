//
//  CYCommunityViewController.m
//  NZNYiOS
//
//  Created by 男左女右 on 16/8/17.
//  Copyright © 2016年 NZNY. All rights reserved.
//

#import "CYCommunityViewController.h"


// 活动：VC
#import "CYCommunityActiveCellVC.h"






@interface CYCommunityViewController ()

@end

@implementation CYCommunityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    // 设置navigationBarButtonItem
    [self setNavBarBtnItem];
    
    
    // 添加视图
    [self addView];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
    // tabbar：显示
    self.hidesBottomBarWhenPushed = NO;
    
}

// 设置navigationBarButtonItem
- (void)setNavBarBtnItem{
    
    // 左边BarButtonItem：搜索
    [self setSearchLeftBarButtonItem];
    
    // 右边BarButtonItem：附近的人、消息
    [self setNearAndNewsRightBarButtonItem];
}

// 左边BarButtonItem：搜索
- (void)setSearchLeftBarButtonItem{
    
    // 搜索
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchLeftBarBtnItemClick)];
    
}

// 右边BarButtonItem：附近的人、消息
- (void)setNearAndNewsRightBarButtonItem{
    
    // 右边BarButtonItem：附近的人
    UIBarButtonItem *nearBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"附近" style:2 target:self action:@selector(nearRightBarBtnItemClick)];
    //    UIBarButtonItem *newsBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(newsRightBarBtnItemSearchClick)];
    
    
    // 右边BarButtonItem：消息
    UIBarButtonItem *newsBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"bubble"] style:UIBarButtonItemStylePlain target:self action:@selector(newsRightBarBtnItemClick)];
    
    NSArray *arr = [NSArray arrayWithObjects:newsBarButtonItem,nearBarButtonItem, nil];
    
    [self.navigationItem setRightBarButtonItems:arr];
    
#warning rightBarButtonItem的字体大小，设置了，为什么不起作用？？？
    // rightBarButtonItem的字体大小，设置了，为什么不起作用？？？？？
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:8],NSFontAttributeName, nil] forState:UIControlStateNormal];
    
}


// 添加视图
- (void)addView{
    
    
    // 上部
    _topView = [[[NSBundle mainBundle] loadNibNamed:@"CYCommunityHeaderView" owner:nil options:nil] lastObject];
    
    _topView.frame = CGRectMake(0, 0, cScreen_Width, 294.0 / 1334.0 * cScreen_Height);
    
    // 线下活动：imageView：点击事件
    _topView.offlineActiveImgView.userInteractionEnabled = YES;
    [_topView.offlineActiveImgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(offlineActiveImgViewClick)]];
    // 往期回顾：imageView：点击事件
    _topView.pastReViewImgView.userInteractionEnabled = YES;
    [_topView.pastReViewImgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pastReViewImgViewClick)]];
    // 客服问答：imageView：点击事件
    _topView.customQuestionImgView.userInteractionEnabled = YES;
    [_topView.customQuestionImgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(customQuestionImgViewClick)]];
    // 活动公告：View：点击事件
    _topView.activeNotiveView.userInteractionEnabled = YES;
    [_topView.activeNotiveView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(activeNotiveViewClick)]];
    
    [self.view addSubview:_topView];
    
    
    
    
    
    
    CYCommunityActiveCellVC *communityActiveCellVC = [[CYCommunityActiveCellVC alloc] init];
    
    communityActiveCellVC.view.frame = CGRectMake(0, 294.0 / 1334.0 * cScreen_Height, cScreen_Width, cScreen_Height - 294.0 / 1334.0 * cScreen_Height - 49);
//    tempChatListVC.view.frame = CGRectMake(0, 294.0 / 1334.0 * cScreen_Height, cScreen_Width, 407);
    communityActiveCellVC.baseTableView.frame = CGRectMake(0, 0, cScreen_Width, cScreen_Height - 294.0 / 1334.0 * cScreen_Height - 64 - 49);
    [self.view addSubview:communityActiveCellVC.view];
}

// 线下活动：imageView：点击事件
- (void)offlineActiveImgViewClick{
    NSLog(@"线下活动：imageView：点击事件");
    
    
}
// 往期回顾：imageView：点击事件
- (void)pastReViewImgViewClick{
    NSLog(@"往期回顾：imageView：点击事件");
    
    
}

// 客服问答：imageView：点击事件
- (void)customQuestionImgViewClick{
    NSLog(@"客服问答：imageView：点击事件");
    
    
}

// 活动公告：View：点击事件
- (void)activeNotiveViewClick{
    NSLog(@"活动公告：View：点击事件");
    
    
}



@end
