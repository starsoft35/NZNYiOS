//
//  CYCommunityViewController.m
//  NZNYiOS
//
//  Created by 男左女右 on 16/8/17.
//  Copyright © 2016年 NZNY. All rights reserved.
//

#import "CYCommunityViewController.h"



// 消息列表
#import "CYChatListVC.h"

@interface CYCommunityViewController ()

@end

@implementation CYCommunityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    // 设置navigationBarButtonItem
    [self setNavBarBtnItem];
    
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



@end
