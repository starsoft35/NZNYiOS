//
//  CYMyUserInfoAgeVC.m
//  nzny
//
//  Created by 男左女右 on 2017/1/5.
//  Copyright © 2017年 nznychina. All rights reserved.
//

#import "CYMyUserInfoAgeVC.h"

#import "ASBirthSelectSheet.h"



@interface CYMyUserInfoAgeVC ()

@end

@implementation CYMyUserInfoAgeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // 添加选择器视图
    [self addAgeSelectView];
    
}


// 添加选择器视图
- (void)addAgeSelectView{
    
//    self.ageLab.text = [NSString stringWithFormat:@"%@ 岁",self.onlyUser.RealName];
    
    ASBirthSelectSheet *datesheet = [[ASBirthSelectSheet alloc] initWithFrame:self.view.bounds];
    datesheet.selectDate = @"2015-12-08";
    datesheet.GetSelectDate = ^(NSString *dateStr) {
        
        
        
        // 网络请求：修改年龄
        [self requestChangeUserInfoAgeWithBirthday:dateStr];
        
    };
    [self.view addSubview:datesheet];
    
}

// 网络请求：修改年龄
- (void)requestChangeUserInfoAgeWithBirthday:(NSString *)birthday{
    
    // 请求数据：修改年龄
    NSString *newUrl = [NSString stringWithFormat:@"%@?userId=%@&birthday=%@",cModifyAgeUrl,self.onlyUser.userID,birthday];
    
    // 编码：url里面有中文
    NSString *tempUrl = [newUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"newUrl:%@",tempUrl);
    // 显示加载
    [self showLoadingView];
    
    // 请求数据：修改年龄
    [CYNetWorkManager postRequestWithUrl:tempUrl params:nil progress:^(NSProgress *uploadProgress) {
        NSLog(@"修改年龄进度：%@",uploadProgress);
        
    } whenSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"修改年龄：请求成功！");
        
        [self hidenLoadingView];
        
        // 1、
        NSString *code = responseObject[@"code"];
        
        // 1.2.1.1.2、和成功的code 匹配
        if ([code isEqualToString:@"0"]) {
            NSLog(@"修改年龄：获取成功！");
            NSLog(@"修改年龄：%@",responseObject);
            
            
            // 修改年龄
            // 此界面显示
            
            // 网络请求：获取年龄
            [self requestGetUserAge];
            
            // 返回上一个界面
            //            [self.navigationController popViewControllerAnimated:YES];
            
        }
        else{
            NSLog(@"修改年龄：获取失败:responseObject:%@",responseObject);
            NSLog(@"修改年龄：获取失败:responseObject:res:msg:%@",responseObject[@"res"][@"msg"]);
            // 1.2.1.1.2.2、获取失败：弹窗提示：获取失败的返回信息
            //            [self showHubWithLabelText:responseObject[@"res"][@"msg"] andHidAfterDelay:3.0];
            
        }
        
        
    } whenFailure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"修改年龄：请求失败！:error:%@",error);
        
        [self showHubWithLabelText:@"请检查网络，重新加载" andHidAfterDelay:3.0];
        
    } withToken:self.onlyUser.userToken];
    
}


// 网络请求：获取年龄
- (void)requestGetUserAge{
    
    // 请求数据：获取年龄
    NSDictionary *params = @{
                             @"userId":self.onlyUser.userID
                             };
    // 显示加载
    [self showLoadingView];
    
    // 请求数据：获取年龄
    [CYNetWorkManager getRequestWithUrl:cModifyAgeUrl params:params progress:^(NSProgress *uploadProgress) {
        NSLog(@"获取年龄进度：%@",uploadProgress);
        
    } whenSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"获取年龄：请求成功！");
        
        [self hidenLoadingView];
        
        // 1、
        NSString *code = responseObject[@"code"];
        
        // 1.2.1.1.2、和成功的code 匹配
        if ([code isEqualToString:@"0"]) {
            NSLog(@"获取年龄：获取成功！");
            NSLog(@"获取年龄：%@",responseObject);
            
            
            // 获取年龄
            // 此界面显示
            NSString *newAgeStr = responseObject[@"res"][@"data"][@"age"];
            ;
            // 网络请求：获取年龄
            self.ageLab.text = [NSString stringWithFormat:@"%ld 岁",(long)[newAgeStr integerValue]];;
            
            // 返回上一个界面
            //            [self.navigationController popViewControllerAnimated:YES];
            
        }
        else{
            NSLog(@"获取年龄：获取失败:responseObject:%@",responseObject);
            NSLog(@"获取年龄：获取失败:responseObject:res:msg:%@",responseObject[@"res"][@"msg"]);
            // 1.2.1.1.2.2、获取失败：弹窗提示：获取失败的返回信息
            //            [self showHubWithLabelText:responseObject[@"res"][@"msg"] andHidAfterDelay:3.0];
            
        }
        
        
    } whenFailure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"获取年龄：请求失败！:error:%@",error);
        
        [self showHubWithLabelText:@"请检查网络，重新加载" andHidAfterDelay:3.0];
        
    } withToken:self.onlyUser.userToken];
    
}


@end
