//
//  CYMyAccountBalanceVC.m
//  nzny
//
//  Created by 男左女右 on 2016/12/25.
//  Copyright © 2016年 nznychina. All rights reserved.
//

#import "CYMyAccountBalanceVC.h"

// 账户余额：模型
#import "CYMyAccountBalanceViewModel.h"

// 明细：VC
#import "CYMyAccountDetailVC.h"

// 充值：VC
#import "CYRechargeVC.h"




@interface CYMyAccountBalanceVC ()


// 明细：barButtonItem
@property (nonatomic,strong) UIBarButtonItem *detailBarBtnItem;

@end

@implementation CYMyAccountBalanceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"账户余额";
    
    
    // 加载数据
    [self loadData];
    
    // 添加视图
    [self addView];
    
}


// 加载数据
- (void)loadData{
    
    // 加载菊花
    //    [self showLoadingView];
    // 新地址
    NSString *newUrl = [NSString stringWithFormat:@"%@?userId=%@",cMyUserMoneyUrl,self.onlyUser.userID];
    
    
    
    // 请求数据：账户余额
    [CYNetWorkManager getRequestWithUrl:newUrl params:nil progress:^(NSProgress *uploadProgress) {
        NSLog(@"获取账户余额进度：%@",uploadProgress);
        
    } whenSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"获取账户余额：请求成功！");
        
        // 1、
        NSString *code = responseObject[@"code"];
        
        // 1.2.1.1.2、和成功的code 匹配
        if ([code isEqualToString:@"0"]) {
            NSLog(@"账户余额：获取成功！");
            
            
            // 清空：每次刷新都需要
            [self.dataArray removeAllObjects];
            
            // 解析数据，模型赋值
            _myAccountBalanceView.myAccountBalanceViewModel = [[CYMyAccountBalanceViewModel alloc] initWithDictionary:responseObject[@"res"][@"data"] error:nil];
            
            // 请求数据结束，取消加载
            [self hidenLoadingView];
            
        }
        else{
            NSLog(@"账户余额：获取失败！");
            
            // 1.2.1.1.2.2、获取失败：弹窗提示：获取失败的返回信息
            [self showHubWithLabelText:responseObject[@"res"][@"msg"] andHidAfterDelay:3.0];
            
        }
        
        
    } whenFailure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"账户余额：请求失败！");
        [self showHubWithLabelText:@"请求失败！" andHidAfterDelay:3.0];
        
    } withToken:self.onlyUser.userToken];
    
    
    
}


// 添加视图
- (void)addView{
    
    // 我的视频View
    _myAccountBalanceView = [[[NSBundle mainBundle] loadNibNamed:@"CYMyAccountBalanceView" owner:nil options:nil] lastObject];
    
    
    // 充值：button：点击事件
    [_myAccountBalanceView.rechargeBtn addTarget:self action:@selector(rechargeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    // 明细：button：点击事件
    _detailBarBtnItem = [[UIBarButtonItem alloc] initWithTitle:@"明细" style:2 target:self action:@selector(detailBarBtnItemClick)];
    self.navigationItem.rightBarButtonItem = _detailBarBtnItem;
    
    self.view = _myAccountBalanceView;
    
}


// 充值：button：点击事件
- (void)rechargeBtnClick{
    NSLog(@"充值：button：点击事件");
    
    CYRechargeVC *rechargeVC = [[CYRechargeVC alloc] init];
    
    [self.navigationController pushViewController:rechargeVC animated:YES];
    
}

// 明细：button：点击事件
- (void)detailBarBtnItemClick{
    NSLog(@"明细：button：点击事件");
    
    CYMyAccountDetailVC *myAccountDetailVC = [[CYMyAccountDetailVC alloc] init];
    
    
    [self.navigationController pushViewController:myAccountDetailVC animated:YES];
    
}


@end
