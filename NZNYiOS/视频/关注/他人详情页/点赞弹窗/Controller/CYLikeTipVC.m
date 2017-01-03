//
//  CYLikeTipVC.m
//  nzny
//
//  Created by 男左女右 on 2016/11/23.
//  Copyright © 2016年 nznychina. All rights reserved.
//

#import "CYLikeTipVC.h"

// 点赞弹窗：View
#import "CYLikeTipView.h"

// 余额不足弹窗：VC
#import "CYBalanceNotEnoughVC.h"


@interface CYLikeTipVC ()

@end

@implementation CYLikeTipVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // 添加视图
    [self addView];
    
    
}

// 添加视图
- (void)addView{
    
    
    _likeTipView = [[[NSBundle mainBundle] loadNibNamed:@"CYLikeTipView" owner:nil options:nil] lastObject];
    
    
    // 弹窗关闭：点击事件
    [_likeTipView.tipCloseBtn addTarget:self action:@selector(tipCloseBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    // 1个赞：点击事件
    [_likeTipView.oneLikeBtn addTarget:self action:@selector(oneLikeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    // 10个赞：点击事件
    [_likeTipView.tenLikeBtn addTarget:self action:@selector(tenLikeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    // 32个赞：点击事件
    [_likeTipView.thirtyTwoLikeBtn addTarget:self action:@selector(thirtyTwoLikeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    // 300个赞：点击事件
    [_likeTipView.threeHundredLikeBtn addTarget:self action:@selector(threeHundredLikeBtnBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    // 520个赞：点击事件
    [_likeTipView.fiveHundredTwentyLikeBtn addTarget:self action:@selector(fiveHundredTwentyLikeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    // 点赞：button：点击事件
    [_likeTipView.likeBtn addTarget:self action:@selector(likeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.view = _likeTipView;
    
}


// 弹窗关闭：点击事件
- (void)tipCloseBtnClick{
    NSLog(@"弹窗关闭：点击事件");
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

// 1个赞：点击事件
- (void)oneLikeBtnClick{
    NSLog(@"1个赞：点击事件");
    
    NSInteger likeCount = 1;
    
#warning 还需要接支付功能
    // 网络请求：用户余额：余额够，则点赞请求，不够则充值弹窗
    [self requestUserBalanceIfIsEnoughWithUserId:self.onlyUser.userID andOppUserId:self.oppUserId andLikeCount:likeCount andCost:(1.0 * likeCount)];
    
//    // 如果余额够支付，则赞、支付
//    if (self.isEnoughForPay) {
//        
//        // 网路请求：点一个赞
//        [self requestLikeWithUserId:self.onlyUser.userID andReceiveUserId:self.oppUserId andGiftCount:likeCount];
//    }
//    // 余额不足，则弹到充值界面
//    else {
//        
//        // 余额不足弹窗：VC
//        CYBalanceNotEnoughVC *balanceNotEnoughVC = [[CYBalanceNotEnoughVC alloc] init];
//        
//        [self.navigationController pushViewController:balanceNotEnoughVC animated:YES];
//        
//    }
}

// 网络请求：用户余额：余额够，则点赞请求，不够则充值弹窗
- (void)requestUserBalanceIfIsEnoughWithUserId:(NSString *)userId andOppUserId:(NSString *)oppUserId andLikeCount:(NSInteger)likeCount andCost:(float)cost{
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
            //            [self hidenLoadingView];
            
            
            NSString * tempMoneyStr = responseObject[@"res"][@"data"][@"userinfo"][@"Money"];
            float tempMoney = [tempMoneyStr floatValue];
            
            // 如果余额够支付，则赞、支付
            if (tempMoney >= cost) {
                
                self.isEnoughForPay = YES;
                
                // 网路请求：点一个赞
                [self requestLikeWithUserId:self.onlyUser.userID andReceiveUserId:oppUserId andGiftCount:likeCount];
                
            }
            // 余额不足，则弹到充值界面
            else {
                
                // 请求数据结束，取消加载
                [self hidenLoadingView];
                
                
                // 余额不足弹窗：VC
                CYBalanceNotEnoughVC *balanceNotEnoughVC = [[CYBalanceNotEnoughVC alloc] init];
                
                UINavigationController *tempBalanceNotEnoughNav = [CYUtilities createDefaultNavCWithRootVC:balanceNotEnoughVC BgColor:nil TintColor:[UIColor whiteColor] translucent:NO titleColor:[UIColor whiteColor] title:@"" bgImg:[UIImage imageNamed:@"Title1"]];
                
                [balanceNotEnoughVC.navigationController setNavigationBarHidden:YES animated:YES];
                
//                [self showViewController:tempVideoNav sender:self];
                [self presentViewController:tempBalanceNotEnoughNav animated:YES completion:nil];
                
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

// 10个赞：点击事件
- (void)tenLikeBtnClick{
    NSLog(@"10个赞：点击事件");
    
    NSInteger likeCount = 10;
    
#warning 还需要接支付功能
    // 网络请求：用户余额：余额够，则点赞请求，不够则充值弹窗
    [self requestUserBalanceIfIsEnoughWithUserId:self.onlyUser.userID andOppUserId:self.oppUserId andLikeCount:likeCount andCost:(1.0 * likeCount)];
    
}

// 32个赞：点击事件
- (void)thirtyTwoLikeBtnClick{
    NSLog(@"32个赞：点击事件");
    
    NSInteger likeCount = 32;
    
#warning 还需要接支付功能
    // 网络请求：用户余额：余额够，则点赞请求，不够则充值弹窗
    [self requestUserBalanceIfIsEnoughWithUserId:self.onlyUser.userID andOppUserId:self.oppUserId andLikeCount:likeCount andCost:(1.0 * likeCount)];
}

// 300个赞：点击事件
- (void)threeHundredLikeBtnBtnClick{
    NSLog(@"300个赞：点击事件");
    
    NSInteger likeCount = 300;
    
#warning 还需要接支付功能
    // 网路请求：点300个赞
    // 网络请求：用户余额：余额够，则点赞请求，不够则充值弹窗
    [self requestUserBalanceIfIsEnoughWithUserId:self.onlyUser.userID andOppUserId:self.oppUserId andLikeCount:likeCount andCost:(1.0 * likeCount)];
    
}

// 520个赞：点击事件
- (void)fiveHundredTwentyLikeBtnClick{
    NSLog(@"520个赞：点击事件");
    
    NSInteger likeCount = 520;
    
    
#warning 还需要接支付功能
    // 网路请求：点520个赞
    // 网络请求：用户余额：余额够，则点赞请求，不够则充值弹窗
    [self requestUserBalanceIfIsEnoughWithUserId:self.onlyUser.userID andOppUserId:self.oppUserId andLikeCount:likeCount andCost:(1.0 * likeCount)];
    
}

// 点赞：button：点击事件
- (void)likeBtnClick{
    NSLog(@"点赞：button：点击事件");
    
    NSScanner *scan = [NSScanner scannerWithString:self.likeTipView.likeCountTextField.text];
    
    NSInteger flag;
    
    if ([scan scanInteger:&flag] && [scan isAtEnd]) {
        
        NSInteger likeCount = [self.likeTipView.likeCountTextField.text integerValue];
        
#warning 还需要接支付功能
        // 网络请求：点 n 个赞
        // 网络请求：用户余额：余额够，则点赞请求，不够则充值弹窗
        [self requestUserBalanceIfIsEnoughWithUserId:self.onlyUser.userID andOppUserId:self.oppUserId andLikeCount:likeCount andCost:(1.0 * likeCount)];
        
    }
    else {
        
        [self showHubWithLabelText:@"请输入数字" andHidAfterDelay:3.0];
    }
    
}


@end
