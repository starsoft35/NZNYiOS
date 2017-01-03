//
//  CYMyUserInfoDeclarationVC.m
//  nzny
//
//  Created by 张春咏 on 2017/1/2.
//  Copyright © 2017年 nznychina. All rights reserved.
//

#import "CYMyUserInfoDeclarationVC.h"

@interface CYMyUserInfoDeclarationVC ()

@end

@implementation CYMyUserInfoDeclarationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"爱情宣言";
    
    
    // 设置视图
    [self setPortraitView];
    
    // 设置navigationBarButtonItem
    [self setNavBarBtnItem];
}


// 设置视图
- (void)setPortraitView{
    
    self.declarationTF.text = self.onlyUser.Declaration;
    
//    self.declarationTF.text
    
    self.declarationTF.clearButtonMode = UITextFieldViewModeAlways;
    
}

// 右边BarButtonItem：保存
- (void)setNavBarBtnItem{
    
    // 保存
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:2 target:self action:@selector(saveBarButtonItemClick)];
}

// 保存：leftBarButtonItem：点击事件
- (void)saveBarButtonItemClick{
    NSLog(@"保存：leftBarButtonItem：点击事件");
    
    // 请求数据：修改爱情宣言
    NSString *newUrl = [NSString stringWithFormat:@"%@?userId=%@&declaration=%@",cModifyDeclarationUrl,self.onlyUser.userID,self.declarationTF.text];
    
    // 编码：url里面有中文
    NSString *tempUrl = [newUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"newUrl:%@",tempUrl);
    // 显示加载
    [self showLoadingView];
    
    // 请求数据：修改爱情宣言
    [CYNetWorkManager postRequestWithUrl:tempUrl params:nil progress:^(NSProgress *uploadProgress) {
        NSLog(@"修改爱情宣言进度：%@",uploadProgress);
        
    } whenSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"修改爱情宣言：请求成功！");
        
        [self hidenLoadingView];
        
        // 1、
        NSString *code = responseObject[@"code"];
        
        // 1.2.1.1.2、和成功的code 匹配
        if ([code isEqualToString:@"0"]) {
            NSLog(@"修改爱情宣言：获取成功！");
            NSLog(@"修改爱情宣言：%@",responseObject);
            
            
            // 修改爱情宣言
            
            // 返回上一个界面
            [self.navigationController popViewControllerAnimated:YES];
            
        }
        else{
            NSLog(@"修改爱情宣言：获取失败:responseObject:%@",responseObject);
            NSLog(@"修改爱情宣言：获取失败:responseObject:res:msg:%@",responseObject[@"res"][@"msg"]);
            // 1.2.1.1.2.2、获取失败：弹窗提示：获取失败的返回信息
            //            [self showHubWithLabelText:responseObject[@"res"][@"msg"] andHidAfterDelay:3.0];
            
        }
        
        
    } whenFailure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"修改爱情宣言：请求失败！:error:%@",error);
        
        [self showHubWithLabelText:@"请检查网络，重新加载" andHidAfterDelay:3.0];
        
    } withToken:self.onlyUser.userToken];
}

@end
