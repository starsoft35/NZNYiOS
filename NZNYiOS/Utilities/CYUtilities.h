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

// 设置时间：精确到分：用xxxx年xx月xx日 xx时xx分表示
+ (NSString *)setYearMouthDayHourMinuteWithChineseYearMouthDayHourMinuteSecond:(NSString *)time;

// 设置时间：xx月xx日
+ (NSString *)setYearMouthDayHourMinuteWithChineseMouthDay:(NSString *)time;

// 提示框
//+ (void)showHubWithLabelText:(NSString *)text andHidAfterDelay:(double)afterDelay;



// 获取当前帧数下，视频的图片
+ (UIImage*) thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time;


// 获取视频文件的时长：单位是秒
+ (CGFloat)getVideoLengthWithVideoUrl:(NSURL *)URL;

// 获取视频文件的大小，返回的是单位是KB。
+ (CGFloat)getFileSizeWithPath:(NSString *)path;

// 压缩视频：返回压缩后视频的地址，该地址在沙盒目录中
+ (NSURL *)condenseVideoWithUrl:(NSURL *)url;

// 获取当前时间
+ (NSString *)getCurrentTime;


// 自动计算label的高度、宽度
+ (CGSize)labelAutoCalculateRectWith:(NSString *)text FontSize:(CGFloat)fontSize MaxSize:(CGSize)maxSize;

@end
