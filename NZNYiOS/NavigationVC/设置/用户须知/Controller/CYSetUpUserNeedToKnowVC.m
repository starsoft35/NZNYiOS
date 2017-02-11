//
//  CYSetUpUserNeedToKnowVC.m
//  nzny
//
//  Created by 男左女右 on 2017/2/4.
//  Copyright © 2017年 nznychina. All rights reserved.
//

#import "CYSetUpUserNeedToKnowVC.h"

@interface CYSetUpUserNeedToKnowVC ()

@end

@implementation CYSetUpUserNeedToKnowVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.title = @"用户须知";
    
    // 背景颜色
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 加载数据
    [self loadData];
    
}


// 加载数据：用户须知
- (void)loadData{
    
    
    [self showLoadingView];
    
    // 网络请求：用户须知
    [CYNetWorkManager getRequestWithUrl:cUserInstructionsUrl params:nil progress:^(NSProgress *uploadProgress) {
        NSLog(@"获取用户须知进度：%@",uploadProgress);
        
        
    } whenSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"用户须知：请求成功！");
        
        
        
        // 1、
        NSString *code = responseObject[@"code"];
        
        // 1.2.1.1.2、和成功的code 匹配
        if ([code isEqualToString:@"0"]) {
            NSLog(@"用户须知：获取成功！：%@",responseObject);
            
            
            // 解析数据，模型存到数组
            //            [self.dataArray addObject:[[CYSetUpAboutUsVCModel alloc] initWithDictionary:responseObject[@"res"][@"data"][@"model"] error:nil]];
            
            self.setUpAboutUsVCModel = [[CYSetUpAboutUsVCModel alloc] initWithDictionary:responseObject[@"res"][@"data"][@"model"] error:nil];
            
        }
        else{
            NSLog(@"用户须知：获取失败:responseObject:%@",responseObject);
            NSLog(@"用户须知：获取失败:responseObject:res:msg:%@",responseObject[@"res"][@"msg"]);
            
            
            // 1.2.1.1.2.2、获取失败：弹窗提示：获取失败的返回信息
            [self showHubWithLabelText:responseObject[@"res"][@"msg"] andHidAfterDelay:3.0];
            
        }
        
        
    } whenFailure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"用户须知：请求失败！失败原因：error：%@",error);
        
        [self showHubWithLabelText:@"请检查网络，重新加载" andHidAfterDelay:3.0];
    } withToken:self.onlyUser.userToken];
    
}


// 模型赋值
- (void)setSetUpAboutUsVCModel:(CYSetUpAboutUsVCModel *)setUpAboutUsVCModel{
    
    _setUpAboutUsVCModel = setUpAboutUsVCModel;
    
//    self.title = setUpAboutUsVCModel.Title;
    
//    [self showLoadingView];
    
    // 二、使用webView加载html
    UIWebView * webView = [[UIWebView alloc]initWithFrame:CGRectMake(25.0 / 750.0 * cScreen_Width, 18.0 / 1334.0 * cScreen_Height, cScreen_Width - 2 * 25.0 / 750.0 * cScreen_Width, cScreen_Height - 64 - 18.0 / 1334.0 * cScreen_Height)];
    
    webView.backgroundColor = [UIColor whiteColor];
    
    [webView loadHTMLString:setUpAboutUsVCModel.Content baseURL:nil];
    [self.view addSubview:webView];
    
//    [self hidenLoadingView];
    
}

@end
