//
//  CYMyUserInfoNameVC.m
//  nzny
//
//  Created by 男左女右 on 2017/1/2.
//  Copyright © 2017年 nznychina. All rights reserved.
//

#import "CYMyUserInfoNameVC.h"

@interface CYMyUserInfoNameVC ()

@end

@implementation CYMyUserInfoNameVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"姓名";
    
    
    // 设置视图
    [self setPortraitView];
    
    
    // 设置navigationBarButtonItem
    [self setNavBarBtnItem];
    
}



// 设置视图
- (void)setPortraitView{
    
    self.nameTF.text = self.onlyUser.RealName;
    
    self.nameTF.clearButtonMode = UITextFieldViewModeAlways;
    
}


// 右边BarButtonItem：保存
- (void)setNavBarBtnItem{
    
    // 保存
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:2 target:self action:@selector(saveBarButtonItemClick)];
}

// 保存：leftBarButtonItem：点击事件
- (void)saveBarButtonItemClick{
    NSLog(@"保存：leftBarButtonItem：点击事件");
    
    BOOL canChangeName = YES;
    
    
    // 先判断是否符合修改条件（一个季度只能修改一次）
    if (canChangeName) {
        
        // 符合条件，则可以修改姓名
        // 网络请求：修改姓名
        [self requestChangeUserName];
    }
    else {
        
        // 不符合条件，则不能修改
        [self showHubWithLabelText:@"每个季度最多修改一次" andHidAfterDelay:3.0];
    }
}


// 网络请求：修改姓名
- (void)requestChangeUserName{
    NSLog(@"网络请求：修改姓名");
    
    
    // 请求数据：修改姓名
    NSString *newUrl = [NSString stringWithFormat:@"%@?userId=%@&realName=%@",cModifyRealNameUrl,self.onlyUser.userID,self.nameTF.text];
    
    // 编码：url里面有中文
    NSString *tempUrl = [newUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"newUrl:%@",tempUrl);
    // 显示加载
    [self showLoadingView];
    
    // 请求数据：修改姓名
    [CYNetWorkManager postRequestWithUrl:tempUrl params:nil progress:^(NSProgress *uploadProgress) {
        NSLog(@"修改姓名进度：%@",uploadProgress);
        
    } whenSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"修改姓名：请求成功！");
        
        [self hidenLoadingView];
        
        // 1、
        NSString *code = responseObject[@"code"];
        
        // 1.2.1.1.2、和成功的code 匹配
        if ([code isEqualToString:@"0"]) {
            NSLog(@"修改姓名：获取成功！");
            NSLog(@"修改姓名：%@",responseObject);
            
            
            // 修改姓名
            
            // 返回上一个界面
            [self.navigationController popViewControllerAnimated:YES];
            
        }
        else{
            NSLog(@"修改姓名：获取失败:responseObject:%@",responseObject);
            NSLog(@"修改姓名：获取失败:responseObject:res:msg:%@",responseObject[@"res"][@"msg"]);
            // 1.2.1.1.2.2、获取失败：弹窗提示：获取失败的返回信息
            //            [self showHubWithLabelText:responseObject[@"res"][@"msg"] andHidAfterDelay:3.0];
            
        }
        
        
    } whenFailure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"修改姓名：请求失败！:error:%@",error);
        
        [self showHubWithLabelText:@"请检查网络，重新加载" andHidAfterDelay:3.0];
        
    } withToken:self.onlyUser.userToken];
}

@end
