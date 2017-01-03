//
//  CYRechargeVC.m
//  nzny
//
//  Created by 男左女右 on 2016/12/25.
//  Copyright © 2016年 nznychina. All rights reserved.
//

#import "CYRechargeVC.h"

@interface CYRechargeVC ()



@end

@implementation CYRechargeVC

{
    BOOL isWechat;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 加载数据
//    [self loadData];
    
    // 添加视图
    [self addView];
}

// 加载数据
- (void)loadData{
    
    
    
}

// 添加视图
- (void)addView{
    
    
    // 我的视频View
    _rechargeView = [[[NSBundle mainBundle] loadNibNamed:@"CYRechargeView" owner:nil options:nil] lastObject];
    
    // 微信支付：手势
    _rechargeView.weChatPayView.userInteractionEnabled = YES;
    [_rechargeView.weChatPayView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(weChatPayViewClick)]];
    
    // 默认微信支付：微信为选中状态
    isWechat = YES;
    _rechargeView.weChatPaySelectImgView.image = [UIImage imageNamed:@"视频选中"];
    _rechargeView.aliPaySelectImgView.image = [UIImage imageNamed:@"视频未选中"];
    
    // 支付宝：手势
    _rechargeView.aliPayView.userInteractionEnabled = YES;
    [_rechargeView.aliPayView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(aliPayViewClick)]];
    
    
    // 确认支付：button：点击事件
    [_rechargeView.confirmPayBtn addTarget:self action:@selector(confirmPayBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.view = _rechargeView;
    
}

// 微信支付：手势
- (void)weChatPayViewClick{
    NSLog(@"微信支付：手势");
    
    isWechat = YES;
    _rechargeView.weChatPaySelectImgView.image = [UIImage imageNamed:@"视频选中"];
    _rechargeView.aliPaySelectImgView.image = [UIImage imageNamed:@"视频未选中"];
    
}

// 支付宝：手势
- (void)aliPayViewClick{
    NSLog(@"支付宝：手势");
    
    isWechat = NO;
    _rechargeView.weChatPaySelectImgView.image = [UIImage imageNamed:@"视频未选中"];
    _rechargeView.aliPaySelectImgView.image = [UIImage imageNamed:@"视频选中"];
    
}

// 确认支付：button：点击事件
- (void)confirmPayBtnClick{
    NSLog(@"确认支付：button：点击事件");
    
    
    // 隐藏键盘
    [self.view endEditing:YES];
    
#warning 网络请求：充值支付
    
    // 如果是纯数字，则支付
    if ([self checkIfIsNum:_rechargeView.rechargeCountTF.text]) {
        
        // 如果选择的是微信支付：
        if (isWechat) {
            NSLog(@"当前为：微信支付");
            
        }
        // 否则，选择的是支付宝支付：
        else {
            NSLog(@"当前为：支付宝支付");
            
        }
        
    }
    
}




@end
