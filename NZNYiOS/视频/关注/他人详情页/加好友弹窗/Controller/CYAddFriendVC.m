//
//  CYAddFriendVC.m
//  nzny
//
//  Created by 男左女右 on 2016/11/23.
//  Copyright © 2016年 nznychina. All rights reserved.
//

#import "CYAddFriendVC.h"

// 加好友View
#import "CYAddFriendView.h"


@interface CYAddFriendVC ()

@end

@implementation CYAddFriendVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    // 添加视图
    [self addView];
    
    
}


// 添加视图
- (void)addView{
    
    
    CYAddFriendView *addFriendView = [[[NSBundle mainBundle] loadNibNamed:@"CYAddFriendView" owner:nil options:nil] lastObject];
    
    
    // 弹窗关闭：点击事件
    [addFriendView.tipCloseBtn addTarget:self action:@selector(tipCloseBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    // 添加好友：点击事件
    [addFriendView.addFriendBtn addTarget:self action:@selector(addFriendBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.view = addFriendView;
    
}


// 弹窗关闭：点击事件
- (void)tipCloseBtnClick{
    NSLog(@"弹窗关闭：点击事件");
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


// 添加好友：点击事件
- (void)addFriendBtnClick{
    NSLog(@"添加好友：点击事件");
    

    // 网络请求：添加好友
    // 参数
    NSDictionary *params = @{
                             @"UserId":self.onlyUser.userID,
                             @"OppUserId":self.OppUserId
                             };
    
    // 网络请求：添加好友
    [CYNetWorkManager postRequestWithUrl:cApplyFriendUrl params:params progress:^(NSProgress *uploadProgress) {
        NSLog(@"progress:%@",uploadProgress);
        
    } whenSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"添加好友：请求成功！");
        
        
        // 2.3.1.1、获取code 值
        NSString *code = responseObject[@"code"];
        
        // 2.3.1.2、判断返回值
        if ([code isEqualToString:@"0"]) {
            NSLog(@"添加好友：添加成功！");
            
            
            [self dismissViewControllerAnimated:YES completion:nil];
            
            // 添加好友成功，提示用户：保存成功
            [self showHubWithLabelText:@"申请成功！" andHidAfterDelay:3.0];
            
        }
        else{
            NSLog(@"添加好友：添加失败！");
            NSLog(@"msg:%@",responseObject[@"res"][@"msg"]);
            
            // 2.3.1.2.2、添加好友失败，弹窗
            [self showHubWithLabelText:responseObject[@"res"][@"msg"] andHidAfterDelay:3.0];
        }
        
    } whenFailure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"添加好友：请求失败！");
        NSLog(@"error:%@",error);
        [self showHubWithLabelText:@"添加好友失败，请检查网络" andHidAfterDelay:3.0];
        
    } withToken:self.onlyUser.userToken];
    
}


@end
