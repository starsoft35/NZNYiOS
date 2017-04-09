//
//  CYMyLiveSignUpVC.m
//  nzny
//
//  Created by 男左女右 on 2016/12/11.
//  Copyright © 2016年 nznychina. All rights reserved.
//

#import "CYMyLiveSignUpVC.h"

// 直播报名View
#import "CYMyLiveSignUpView.h"

// 余额不足弹窗：VC
//#import "CYBalanceNotEnoughVC.h"
// 余额不足弹窗：View
#import "CYBalanceNotEnoughView.h"


// 充值界面：VC
#import "CYRechargeVC.h"


@interface CYMyLiveSignUpVC ()


// 余额不足弹窗：View
@property(nonatomic, strong) CYBalanceNotEnoughView *balanceNotEnoughView;


@end

@implementation CYMyLiveSignUpVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.title = @"直播报名";
    
    
    // 添加视图
    [self addView];
    
    
}

// 添加视图
- (void)addView{
    
    _myLiveSignUpView = [[[NSBundle mainBundle] loadNibNamed:@"CYMyLiveSignUpView" owner:nil options:nil] lastObject];
    
    // 姓名：
    _myLiveSignUpView.nameLab.text = self.onlyUser.RealName;
    
    // 我要上直播：点击事件
    [_myLiveSignUpView.gotoLiveBtn addTarget:self action:@selector(gotoLiveBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.view = _myLiveSignUpView;
}


// 我要上直播：点击事件
- (void)gotoLiveBtnClick{
    NSLog(@"// 我要上直播：点击事件");
    
    if (![self checkTel:self.myLiveSignUpView.phoneNumTF.text]) {
        
        // 不是手机号
        [self showHubWithLabelText:@"请输入正确手机号" andHidAfterDelay:3.0];
    }
    else if ([self.myLiveSignUpView.liveTitleTF.text isEqualToString:@""]) {
        
        // 主题为空
        [self showHubWithLabelText:@"请输入直播主题" andHidAfterDelay:3.0];
        
    }
    else {
        
        
        // 网络请求：用户余额：余额够，则点赞请求，不够则充值弹窗
        [self requestUserBalanceIfIsEnoughWithUserId:self.onlyUser.userID andCost:(30.0)];
    }
    
}

// 网络请求：用户余额：余额够，则点赞请求，不够则充值弹窗
- (void)requestUserBalanceIfIsEnoughWithUserId:(NSString *)userId andCost:(float)cost{
    NSLog(@"用户余额：网络请求！");
    
    [self showLoadingView];
    
    // 新地址
    NSString *newUrl = [NSString stringWithFormat:@"%@?userId=%@",cUserMoneyUrl,userId];
    
    // 网络请求：用户余额
    [CYNetWorkManager getRequestWithUrl:newUrl params:nil progress:^(NSProgress *uploadProgress) {
        NSLog(@"用户余额：%@",uploadProgress);
        
        
    } whenSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"用户余额：请求成功！");
        
        // 1、
        NSString *code = responseObject[@"code"];
        
        // 1.2.1.1.2、和成功的code 匹配
        if ([code isEqualToString:@"0"]) {
            NSLog(@"用户余额：获取成功！");
            NSLog(@"用户余额：%@",responseObject);
            
            
            
            // 请求数据结束，取消加载
            [self hidenLoadingView];
            
            
            NSString * tempMoneyStr = responseObject[@"res"][@"data"][@"money"];
            float tempMoney = [tempMoneyStr floatValue];
            
            // 如果余额够支付，则赞、支付
            if (tempMoney >= cost) {
                
                
                // 网络请求：申请直播报名
                [self requestApplyGoToLive];
                
            }
            // 余额不足，则弹到充值界面
            else {
                
                // 请求数据结束，取消加载
                [self hidenLoadingView];
                
                
                // 余额不足弹窗：VC
//                CYBalanceNotEnoughVC *balanceNotEnoughVC = [[CYBalanceNotEnoughVC alloc] init];
//                
//                [self.navigationController pushViewController:balanceNotEnoughVC animated:YES];
                // 余额不足弹窗：View
                [self addBalanceNotEnoughView];
                
            }
        }
        else{
            NSLog(@"用户余额：获取失败:responseObject:%@",responseObject);
            NSLog(@"用户余额：获取失败:responseObject:res:msg:%@",responseObject[@"res"][@"msg"]);
            // 1.2.1.1.2.2、获取失败：弹窗提示：获取失败的返回信息
            [self showHubWithLabelText:responseObject[@"res"][@"msg"] andHidAfterDelay:3.0];
            
        }
        
        
    } whenFailure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"用户余额：请求失败！");
        NSLog(@"点一个赞：error：%@",error);
        
        [self showHubWithLabelText:@"请检查网络，重新加载" andHidAfterDelay:3.0];
    } withToken:self.onlyUser.userToken];
    
}

// 余额不足弹窗View
- (void)addBalanceNotEnoughView{
    NSLog(@"余额不足弹窗View");
    
    
    _balanceNotEnoughView = [[[NSBundle mainBundle] loadNibNamed:@"CYBalanceNotEnoughView" owner:nil options:nil] lastObject];
    
    _balanceNotEnoughView.frame = CGRectMake(0, -64, cScreen_Width, cScreen_Height);
    
    
    
    _balanceNotEnoughView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    _balanceNotEnoughView.balanceNotEnoughBgImgView.hidden = YES;
    
    // 余额不足：弹窗关闭：button：点击事件
    [_balanceNotEnoughView.closeBtn addTarget:self action:@selector(balanceNotEnoughCloseBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    // 立即充值：button：点击事件
    [_balanceNotEnoughView.instantRechargeBtn addTarget:self action:@selector(balanceNotEnoughInstantRechargeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    // 隐藏键盘
    [self.view endEditing:YES];
    
    
    [self.view addSubview:_balanceNotEnoughView];
    
    
}


// 余额不足：弹窗关闭：button：点击事件
- (void)balanceNotEnoughCloseBtnClick{
    NSLog(@"余额不足：弹窗关闭：button：点击事件");
    
    [self.balanceNotEnoughView removeFromSuperview];
    
}

// 余额不足：立即充值：button：点击事件
- (void)balanceNotEnoughInstantRechargeBtnClick{
    NSLog(@"余额不足：立即充值：button：点击事件");
    
    
    // 充值界面
    CYRechargeVC *rechargeVC = [[CYRechargeVC alloc] init];
    
    [[self navigationControllerWithView:self.view] setNavigationBarHidden:NO animated:YES];
    
    // 导航VC：获取当前视图所在位置的导航控制器
    [[self navigationControllerWithView:self.view] pushViewController:rechargeVC animated:YES];
    
    [self.balanceNotEnoughView removeFromSuperview];
}


// 网络请求：申请直播报名
- (void)requestApplyGoToLive{
    
    // 网络请求：申请直播报名
    // 参数：
    NSDictionary *params = @{
                             @"UserId":self.onlyUser.userID,
                             @"Mobile":self.myLiveSignUpView.phoneNumTF.text,
                             @"Title":self.myLiveSignUpView.liveTitleTF.text
                             };
    
    [self showLoadingView];
    
    // 网络请求：
    [CYNetWorkManager postRequestWithUrl:cMyLiveApplyUrl params:params progress:^(NSProgress *uploadProgress) {
        NSLog(@"申请直播报名请求：进度：%@",uploadProgress);
        
    } whenSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"申请直播报名请求：请求成功！");
        // 1、
        NSString *code = responseObject[@"code"];
        
        // 1.2.1.1.2、和成功的code 匹配
        if ([code isEqualToString:@"0"]) {
            NSLog(@"申请直播报名：获取成功！");
            NSLog(@"申请直播报名：%@",responseObject);
            
            // 申请成功：提示信息
            [self showHubWithLabelText:responseObject[@"res"][@"msg"] andHidAfterDelay:3.0];
            
        }
        else{
            NSLog(@"申请直播报名：获取失败:responseObject:%@",responseObject);
            NSLog(@"申请直播报名：获取失败:responseObject:res:msg:%@",responseObject[@"res"][@"msg"]);
            // 1.2.1.1.2.2、获取失败：弹窗提示：获取失败的返回信息
            [self showHubWithLabelText:responseObject[@"res"][@"msg"] andHidAfterDelay:3.0];
            
        }
        
    } whenFailure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"申请直播报名：请求失败！");
        
        [self showHubWithLabelText:@"请求失败！" andHidAfterDelay:3.0];
        
    } withToken:self.onlyUser.userToken];
}


@end
