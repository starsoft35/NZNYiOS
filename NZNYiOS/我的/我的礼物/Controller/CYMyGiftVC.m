//
//  CYMyGiftVC.m
//  nzny
//
//  Created by 男左女右 on 2016/12/20.
//  Copyright © 2016年 nznychina. All rights reserved.
//

#import "CYMyGiftVC.h"

// 我收到的
#import "CYMyReceivedVC.h"

// 我送出的
#import "CYMySentVC.h"

// 主要滑动视图
#import "CYBaseSwipeViewController.h"

@interface CYMyGiftVC ()

@end

@implementation CYMyGiftVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 添加视图
    [self addView];
    
}

// 添加视图
- (void)addView{
    
    
    CGFloat tableStartY = (76.0 / 1334.0) * self.view.frame.size.height;
    CGFloat tableViewHeight = cScreen_Height - 50 - tableStartY;
    
    // 谁赞过我：VC
    CYMyReceivedVC *myReceivedVC = [[CYMyReceivedVC alloc] init];
    myReceivedVC.view.frame = CGRectMake(0, 0, cScreen_Width, tableViewHeight);
    myReceivedVC.baseTableView.frame = CGRectMake(0, 0, cScreen_Width, tableViewHeight);
    
    // 记录：VC
    CYMySentVC *mySentVC = [[CYMySentVC alloc] init];
    mySentVC.view.frame = CGRectMake(0, 0, cScreen_Width, tableViewHeight);
    mySentVC.baseTableView.frame = CGRectMake(0, 0, cScreen_Width, tableViewHeight);
    
    // 中部滑动视图
    CYBaseSwipeViewController *praiseVC = [[CYBaseSwipeViewController alloc] initWithSubVC:@[myReceivedVC,mySentVC] andTitles:@[@"我收到的",@"我送出的"]];
    praiseVC.view.frame = CGRectMake(0, 0, cScreen_Width, tableViewHeight);
    praiseVC.bgScrollView.frame = CGRectMake(0, tableStartY, cScreen_Width, tableViewHeight);
    
    self.view.frame = CGRectMake(0, tableStartY, cScreen_Width, tableViewHeight);
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:praiseVC.view];
    
}

@end
