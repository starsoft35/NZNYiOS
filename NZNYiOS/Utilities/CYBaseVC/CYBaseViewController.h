//
//  CYBaseViewController.h
//  NZNYiOS
//
//  Created by 男左女右 on 16/8/16.
//  Copyright © 2016年 NZNY. All rights reserved.
//

#import <UIKit/UIKit.h>

// 定位需要导入这个头文件。并实现代理
#import <CoreLocation/CoreLocation.h>

// 微信登录SDK：API
//#import "WXApi.h"

// 融云：SDK-初始化
#import "RCDLive.h"
#import <RongIMKit/RongIMKit.h>
#import <RongIMLib/RongIMLib.h>
#import "RCDLiveGiftMessage.h"


@interface CYBaseViewController : UIViewController<
//WXApiDelegate,
CLLocationManagerDelegate,
UIActionSheetDelegate,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
UIApplicationDelegate,
RCIMUserInfoDataSource,
RCIMGroupInfoDataSource,
RCIMReceiveMessageDelegate,
RCIMClientReceiveMessageDelegate,
RCConnectionStatusChangeDelegate
>

// 提示框：hud
@property (nonatomic,strong)MBProgressHUD *hud;

// 当前用户
@property (nonatomic ,strong) CYUser *onlyUser;

// 密码flag
@property (nonatomic,assign)NSInteger passwordFlag;

// 倒计时时间
@property (nonatomic,assign)NSInteger repeatSendVerifiTime;

// 定时器
@property (nonatomic,strong)NSTimer *timer;


// 账户余额 是否够支付：BOOL
@property (nonatomic, assign) BOOL isEnoughForPay;


// 数据源
@property (nonatomic,strong)NSMutableArray *dataArray;


// 定位
@property (nonatomic,strong) CLLocationManager *locationManager;
// 是否打开附近的人界面
@property (nonatomic,assign) BOOL ifOpenNearbyPeopleVC;


// 暂时没有内容提示：label
@property (nonatomic, strong) UILabel *noDataLab;


// 融云：Kitb：初始化
- (void)setRongCloudKitWithCurrentUser:(CYUser *)currentUser andRongToken:(NSString *)rongToken;

// 融云：初始化：使用RCDLive进行初始化
- (void)setRongCloudWithRCDLiveWithCurrentUser:(CYUser *)currentUser andRongToken:(NSString *)rongToken;

// 经纬度 -> 地理位置（地理位置反编码）
- (void)locationWithLatitude:(CLLocationDegrees)latitude andLongitude:(CLLocationDegrees)longitude;

// 搜索：左边BarButtonItem：点击事件：
- (void)searchLeftBarBtnItemClick;

// 设置：左边BarButtonItem：点击事件
- (void)setLeftBarBtnItemClick;

// 附近的人：右边，nearBarButtonItem：点击事件
- (void)nearRightBarBtnItemClick;

// 定位：获取位置信息，地理位置编码、反编码
- (void)getLocationManager;

// 新消息：右边，newsBarButtonItem：点击事件
- (void)newsRightBarBtnItemClick;

// 加载数据
- (void)loadData;

// 显示加载
- (void)showLoadingView;
// 隐藏加载
- (void)hidenLoadingView;

// 提示框显示，并在定义时间后，自动消失。
- (void)showHubWithLabelText:(NSString *)text andHidAfterDelay:(double)afterDelay;

// 密码显示隐藏：点击事件
- (void)passwordDisplayOrHideImgViewClickWithImgView:(UIImageView *)imgView andTexeField:(UITextField *)textField;

// 验证码button定时器：执行的方法
- (void)timerCountdownWithRepeatBtn:(UIButton *)repeatBtn andCountdownTime:(NSInteger)countdownTime andBtnDisabledTitle:(NSString *)btnDisabledTitle andNormalTitle:(NSString *)btnNormalTitle;

// 检查金额：是否输入、格式是否正确：纯数字
- (BOOL)checkIfIsNum:(NSString *)number;

// 检查手机号：是否输入、格式是否正确
- (BOOL)checkTel:(NSString *)tel;

// 检查密码：是否输入、格式是否正确
- (BOOL)checkPassword:(NSString *)password;

// 检查手机号、密码：是否输入、格式是否正确
- (BOOL)checkTel:(NSString *)tel andPassword:(NSString *)password;

// 检查手机号、验证码、密码：是否输入、格式是否正确
- (BOOL)checkTel:(NSString *)tel andVerificationCode:(NSString *)verificationCode andPassword:(NSString *)password;

// 头像点击事件：手势
- (void)headImgViewChangeClick;


// 登录：网络请求
- (void)loginRequestWithAccount:(NSString *)userAccount andUserPSW:(NSString *)userPSW;

// 登录成功，设置当前登录的用户。
- (void)setCurrentUser:(id)responseObject;

// 登录成功，创建mainTabbar，设置为根视图控制器
- (void)loginSuccess;

// 保存用户的账号、密码。
- (void)setCurrentUserWithUserAccount:(NSString *)userAccount andUserPSW:(NSString *)userPSW;

// 用户余额：网络请求
//- (void)requestUserBalanceIfIsEnoughWithUserId:(NSString *)userId andOppUserId:(NSString *)oppUserId andLikeCount:(NSInteger)likeCount andCost:(float)cost;


// 获取并保存用户个人信息到本地
- (void)requestAndSaveUserInfo;



// 点赞：网络请求
- (void)requestLikeWithUserId:(NSString *)userId andReceiveUserId:(NSString *)receiveUserId andGiftCount:(NSInteger)likeCount andAddLikeUrl:(NSString *)addLikeUrl;

// 送礼：网络请求
- (void)requestGiveGiftWithUserId:(NSString *)userId andReceiveUserId:(NSString *)receiveUserId andGiftCount:(NSInteger)giftCount;


// 分享：微信分享：文字类型分享
- (void)sharedToWeChatWithText:(NSString *)text bText:(BOOL)bText andScene:(int)scene;

// 分享：微信分享：图片类型分享
- (void)shareToWechatWithThumbImage:(UIImage *)thumbImage andImageData:(NSData *)thumbImageData andbText:(BOOL)bText andScene:(int)scene;

// 分享：微信分享：网页类型分享
- (void)sharedToWeChatWithWebpageWithShareTitle:(NSString *)shareTitle andDescription:(NSString *)shareDescription andImage:(UIImage *)image andWebpageUrl:(NSString *)webPageUrl andbText:(BOOL)bText andScene:(int)scene;

@end
