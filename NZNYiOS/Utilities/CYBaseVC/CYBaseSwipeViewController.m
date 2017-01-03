//
//  CYBaseSwipeViewController.m
//  nzny
//
//  Created by 男左女右 on 2016/11/22.
//  Copyright © 2016年 nznychina. All rights reserved.
//

#import "CYBaseSwipeViewController.h"

@interface CYBaseSwipeViewController ()

@end

@implementation CYBaseSwipeViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // 设置navigationBarButtonItem
    [self setNavBarBtnItem];
    
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
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchLeftBarBtnItemClick)];
    
}


// 右边BarButtonItem：附近的人、消息
- (void)setNearAndNewsRightBarButtonItem{
    
    // 右边BarButtonItem：附近的人
    UIBarButtonItem *nearBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"附近" style:2 target:self action:@selector(nearRightBarBtnItemClick)];
    
    // 右边BarButtonItem：消息
    UIBarButtonItem *newsBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"bubble"] style:UIBarButtonItemStylePlain target:self action:@selector(newsRightBarBtnItemClick)];
    
    NSArray *arr = [NSArray arrayWithObjects:newsBarButtonItem,nearBarButtonItem, nil];
    
    [self.navigationItem setRightBarButtonItems:arr];
    
#warning rightBarButtonItem的字体大小，设置了，为什么不起作用？？？
    // rightBarButtonItem的字体大小，设置了，为什么不起作用？？？？？
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:8],NSFontAttributeName, nil] forState:UIControlStateNormal];
    
}

@end
