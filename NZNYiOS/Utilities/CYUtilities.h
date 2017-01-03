//
//  CYUtilities.h
//  NZNYiOS
//
//  Created by 男左女右 on 16/9/6.
//  Copyright © 2016年 NZNY. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CYUtilities : NSObject

// 提示框：hud
@property (nonatomic,strong)MBProgressHUD *hud;

// button
+ (UIButton *)createBtnFrame:(CGRect)frame title:(NSString *)title imgName:(NSString *)imgName bgImgName:(NSString*)bgImgName selectedBgImgName:(NSString *)selectedBgImgName target:(id)target action:(SEL)action;


// 加载带主机地址的网络图片
+ (UIImage *)setUrlImgWithHostUrl:(NSString *)hostUrl andUrl:(NSString *)url;

// 检查手机号格式是否正确
+ (BOOL)checkTel:(NSString *)tel;

// 检查密码格式是否正确
+ (BOOL)checkPassword:(NSString *)password;

// 检查验证码格式是否正确
+ (BOOL)checkVerificationCode:(NSString *)verificationCode;

// 检查用户名格式是否正确
+ (BOOL)checkUserName:(NSString *)userName;

//// 判断手机号、验证码、密码：是否输入、格式是否正确
//+ (BOOL)checkTel:(NSString *)tel andVerificationCode:(NSString *)verificationCode andPassword:(NSString *)password;

// 设置默认navigationBar样式
+ (UINavigationController *)createDefaultNavCWithRootVC:(UIViewController *)rootVC BgColor:(UIColor *)bgColor TintColor:(UIColor *)tintColor translucent:(BOOL)translucent titleColor:(UIColor *)titleColor title:(NSString *)title bgImg:(UIImage *)bgImg;


// 设置时间：精确到分
+ (NSString *)setYearMouthDayHourMinuteWithYearMouthDayHourMinuteSecond:(NSString *)time;

// 提示框
//+ (void)showHubWithLabelText:(NSString *)text andHidAfterDelay:(double)afterDelay;

@end
