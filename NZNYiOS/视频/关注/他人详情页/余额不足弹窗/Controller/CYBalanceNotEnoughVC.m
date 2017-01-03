//
//  CYBalanceNotEnoughVC.m
//  nzny
//
//  Created by 男左女右 on 2017/1/2.
//  Copyright © 2017年 nznychina. All rights reserved.
//

#import "CYBalanceNotEnoughVC.h"

// 余额不足：view
#import "CYBalanceNotEnoughView.h"

// 充值界面：VC
#import "CYRechargeVC.h"



@interface CYBalanceNotEnoughVC ()

@end

@implementation CYBalanceNotEnoughVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // 添加视图
    [self addView];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    // 隐藏导航栏
    self.navigationController.navigationBarHidden = YES;
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    // 显示导航栏
    self.navigationController.navigationBarHidden = NO;
    
}

// 添加视图
- (void)addView{
    
    
    CYBalanceNotEnoughView *balanceNotEnoughView = [[[NSBundle mainBundle] loadNibNamed:@"CYBalanceNotEnoughView" owner:nil options:nil] lastObject];
    
    
    // 弹窗关闭：点击事件
    [balanceNotEnoughView.closeBtn addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    // 立即充值：点击事件
    [balanceNotEnoughView.instantRechargeBtn addTarget:self action:@selector(instantRechargeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.view = balanceNotEnoughView;
    
}


// 弹窗关闭：点击事件
- (void)closeBtnClick{
    NSLog(@"弹窗关闭：点击事件");
    
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

// 立即充值：点击事件
- (void)instantRechargeBtnClick{
    NSLog(@"立即充值：点击事件");
    
    // 充值界面
    CYRechargeVC *rechargeVC = [[CYRechargeVC alloc] init];
    
    [self.navigationController pushViewController:rechargeVC animated:YES];
    
}

@end
