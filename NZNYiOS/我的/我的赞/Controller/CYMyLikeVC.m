//
//  CYMyLikeVC.m
//  nzny
//
//  Created by 男左女右 on 2016/12/18.
//  Copyright © 2016年 nznychina. All rights reserved.
//

#import "CYMyLikeVC.h"

// 谁赞过我
#import "CYWhoPraiseMeVC.h"

// 我赞过谁
#import "CYWhoIPraiseVC.h"

// 主要滑动视图
#import "CYBaseSwipeViewController.h"


@interface CYMyLikeVC ()

@end

@implementation CYMyLikeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的赞";
    
    // 添加视图
//    [self addView];
    
}


- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    
    // 添加视图
    [self addView];

}


// 添加视图
- (void)addView{
    
    
    CGFloat tableStartY = (76.0 / 1334.0) * self.view.frame.size.height;
    CGFloat tableViewHeight = cScreen_Height - 50 - tableStartY;
    
    // 谁赞过我：VC
    CYWhoPraiseMeVC *whoPraiseMeVC = [[CYWhoPraiseMeVC alloc] init];
    whoPraiseMeVC.view.frame = CGRectMake(0, 0, cScreen_Width, tableViewHeight);
    whoPraiseMeVC.baseTableView.frame = CGRectMake(0, 0, cScreen_Width, tableViewHeight);
    
    // 记录：VC
    CYWhoIPraiseVC *whoIPraiseVC = [[CYWhoIPraiseVC alloc] init];
    whoIPraiseVC.view.frame = CGRectMake(0, 0, cScreen_Width, tableViewHeight);
    whoIPraiseVC.baseTableView.frame = CGRectMake(0, 0, cScreen_Width, tableViewHeight);
    
    // 中部滑动视图
    CYBaseSwipeViewController *praiseVC = [[CYBaseSwipeViewController alloc] initWithSubVC:@[whoPraiseMeVC,whoIPraiseVC] andTitles:@[@"谁赞过我",@"我赞过谁"]];
    praiseVC.view.frame = CGRectMake(0, 0, cScreen_Width, tableViewHeight);
    praiseVC.bgScrollView.frame = CGRectMake(0, tableStartY, cScreen_Width, tableViewHeight);
    
    self.view.frame = CGRectMake(0, tableStartY, cScreen_Width, tableViewHeight);
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:praiseVC.view];
    
}


@end
