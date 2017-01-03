//
//  AppDelegate.h
//  NZNYiOS
//
//  Created by 男左女右 on 16/8/16.
//  Copyright © 2016年 NZNY. All rights reserved.
//

#import <UIKit/UIKit.h>


// 微信登录SDK：API
#import "WXApi.h"
// 融云：SDK-初始化
#import <RongIMKit/RongIMKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate,WXApiDelegate>

@property (strong, nonatomic) UIWindow *window;


// 提示框：hud
@property (nonatomic,strong)MBProgressHUD *hud;


- (void)onResp:(BaseResp *)resp;

@end

