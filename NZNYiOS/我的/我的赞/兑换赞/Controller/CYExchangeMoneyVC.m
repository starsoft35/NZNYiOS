//
//  CYExchangeMoneyVC.m
//  nzny
//
//  Created by 男左女右 on 2016/12/20.
//  Copyright © 2016年 nznychina. All rights reserved.
//

#import "CYExchangeMoneyVC.h"

// 兑换赞：view
#import "CYExchangeMoneyView.h"


@interface CYExchangeMoneyVC ()

@end

@implementation CYExchangeMoneyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // 添加视图
    [self addView];
}


// 添加视图
- (void)addView{
    
    CYExchangeMoneyView *exchangeMoneyView = [[[NSBundle mainBundle] loadNibNamed:@"CYExchangeMoneyView" owner:nil options:nil] lastObject];
    
    
    // 关闭：点击事件
    [exchangeMoneyView.closeBtn addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    // 取消兑换：点击事件
    [exchangeMoneyView.cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    // 确认兑换：点击事件
    [exchangeMoneyView.confirmBtn addTarget:self action:@selector(confirmBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.view = exchangeMoneyView;
    
}

// 关闭：点击事件
- (void)closeBtnClick{
    NSLog(@"// 关闭：点击事件");
    
//    [self dismissViewControllerAnimated:YES completion:nil];
    
}

// 取消兑换：点击事件
- (void)cancelBtnClick{
    NSLog(@"// 取消兑换：点击事件");
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

// 确认兑换：点击事件
- (void)confirmBtnClick{
    NSLog(@"// 确认兑换：点击事件");
    
    // 网络请求：兑换赞
    NSString *newUrl = [NSString stringWithFormat:@"%@?userId=%@",cLikeExChangeMoneyUrl,self.onlyUser.userID];
    
    // 网络请求：兑换赞
    [CYNetWorkManager postRequestWithUrl:newUrl params:nil progress:^(NSProgress *uploadProgress) {
        NSLog(@"获取兑换赞进度：%@",uploadProgress);
        
        
    } whenSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"兑换赞：请求成功！");
        
        // 1、
        NSString *code = responseObject[@"code"];
        
        // 1.2.1.1.2、和成功的code 匹配
        if ([code isEqualToString:@"0"]) {
            NSLog(@"兑换赞：获取成功！");
            NSLog(@"兑换赞：%@",responseObject);
            
            // 1.2.1.1.2.2、获取成功：弹窗提示：获取成功的返回信息
            [self showHubWithLabelText:responseObject[@"res"][@"msg"] andHidAfterDelay:3.0];
            
            
        }
        else{
            NSLog(@"兑换赞：获取失败:responseObject:%@",responseObject);
            NSLog(@"兑换赞：获取失败:responseObject:res:msg:%@",responseObject[@"res"][@"msg"]);
            // 1.2.1.1.2.2、获取失败：弹窗提示：获取失败的返回信息
            [self showHubWithLabelText:responseObject[@"res"][@"msg"] andHidAfterDelay:3.0];
        }
        
        
    } whenFailure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"兑换赞：请求失败！");
        NSLog(@"失败原因：error：%@",error);
        
        [self showHubWithLabelText:@"请检查网络，重新加载" andHidAfterDelay:3.0];
    } withToken:self.onlyUser.userToken];
    
}



@end
