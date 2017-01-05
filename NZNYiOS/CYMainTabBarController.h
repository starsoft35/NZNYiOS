//
//  CYMainTabBarController.h
//  NZNYiOS
//
//  Created by 男左女右 on 16/8/16.
//  Copyright © 2016年 NZNY. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "CYBaseViewController.h"


// 个人信息：模型
#import "CYUserInfoModel.h"

//// 定位需要导入这个头文件。并实现代理
//#import <CoreLocation/CoreLocation.h>

// 融云：SDK-初始化
#import "RCDLive.h"
#import <RongIMKit/RongIMKit.h>
#import <RongIMLib/RongIMLib.h>
#import "RCDLiveGiftMessage.h"

// 阿里播放器：初始化
#import <AliyunPlayerSDK/AliyunPlayerSDK.h>

@interface CYMainTabBarController : UITabBarController<
//CLLocationManagerDelegate,
RCIMUserInfoDataSource,
RCIMGroupInfoDataSource,
RCIMReceiveMessageDelegate,
RCIMClientReceiveMessageDelegate,
RCConnectionStatusChangeDelegate,
UINavigationControllerDelegate,
AliVcAccessKeyProtocol>



// 个人信息：模型
@property (nonatomic, strong) CYUserInfoModel *userInfoModel;

// 融云User信息
@property (nonatomic, strong) RCUserInfo *rcUserInfo;

// 提示框：hud
@property (nonatomic,strong)MBProgressHUD *hud;



// 视图数组
@property (nonatomic,strong) NSMutableArray *viewsArr;




@end
