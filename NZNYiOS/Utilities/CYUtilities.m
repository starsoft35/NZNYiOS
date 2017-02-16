//
//  CYUtilities.m
//  NZNYiOS
//
//  Created by 男左女右 on 16/9/6.
//  Copyright © 2016年 NZNY. All rights reserved.
//

#import "CYUtilities.h"

@implementation CYUtilities


// 创建button
+ (UIButton *)createBtnFrame:(CGRect)frame title:(NSString *)title imgName:(NSString *)imgName bgImgName:(NSString*)bgImgName selectedBgImgName:(NSString *)selectedBgImgName target:(id)target action:(SEL)action{
    
    //
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btn.frame = frame;
    
    [btn setTitle:title forState:UIControlStateNormal];
    
    // 字体颜色修改为黑色
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    // button图标
    if (imgName) {
        
        [btn setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
    }
    
    // 正常状态下背景图片
    if (bgImgName) {
        
        [btn setBackgroundImage:[UIImage imageNamed:bgImgName] forState:UIControlStateNormal];
    }
    
    // 选中状态下背景图片
    if (selectedBgImgName) {
        
        [btn setBackgroundImage:[UIImage imageNamed:selectedBgImgName] forState:UIControlStateSelected];
    }
    
    // 点击事件
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}

// 加载带主机地址的网络图片
+ (UIImage *)setUrlImgWithHostUrl:(NSString *)hostUrl andUrl:(NSString *)url{
    
    UIImage *image = [[UIImage alloc] init];
    // 头像
    if (url.length > 18) {
        
        NSString *portaitUrl = [url substringToIndex:18];
        if ([portaitUrl isEqualToString:@"/Uploads/AppImage/"]) {
            
            
            image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",hostUrl,url]]]];
            
        }
        else {
            
            image = [UIImage imageNamed:@"默认头像"];
        }
    }
    else {
        image = [UIImage imageNamed:@"默认头像"];
    }
    
    
    
    return image;
    
}

// 检查手机号是否正确
+ (BOOL)checkTel:(NSString *)tel{
    
    
    NSString *regex = @"^1[3|4|5|7|8][0-9]{9}$";
//    NSString *regex = @"^1[3|4|5|7|8][0-9]\\d{8}]$";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",regex];
    
    return [pred evaluateWithObject:tel];
    
}

// 检查密码格式是否正确
+ (BOOL)checkPassword:(NSString *)password{
    
    NSString *regex = @"^[A-Za-z0-9]{8,16}$";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",regex];
    
    return [pred evaluateWithObject:password];
}

// 检查验证码格式是否正确
+ (BOOL)checkVerificationCode:(NSString *)verificationCode{
    
    NSString *regex = @"[0-9]{4}$";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",regex];
    
    return [pred evaluateWithObject:verificationCode];
}

// 检查用户名格式是否正确
+ (BOOL)checkUserName:(NSString *)userName{
    
    NSString *regex = @"[\u4e00-\u9fa5]{2,4}$";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",regex];
    
    return [pred evaluateWithObject:userName];
}

// 设置默认navigationBar样式
+ (UINavigationController *)createDefaultNavCWithRootVC:(UIViewController *)rootVC BgColor:(UIColor *)bgColor TintColor:(UIColor *)tintColor translucent:(BOOL)translucent titleColor:(UIColor *)titleColor title:(NSString *)title bgImg:(UIImage *)bgImg{
    
    // navigationController
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:rootVC];
    // 设置导航条的样式
    nav.navigationBar.barStyle = UIBarStyleBlack;
    // bgColor
    nav.navigationBar.backgroundColor = bgColor;
    
    // tintColor
    nav.navigationBar.tintColor = tintColor;
    
    // translucent：是否透明（不透明，Y轴在navigation下面开始）
    nav.navigationBar.translucent = translucent;
    
    // titleColor
//    nav.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:titleColor};
    
    // title
    nav.navigationItem.title = title;
    
    // bgImg
    [nav.navigationBar setBackgroundImage:bgImg forBarMetrics:UIBarMetricsDefault];
    
    return nav;
}

// 设置时间：精确到分
+ (NSString *)setYearMouthDayHourMinuteWithYearMouthDayHourMinuteSecond:(NSString *)time{
    
    NSString *year = [time substringToIndex:4];
    NSString *month = [time substringWithRange:NSMakeRange(5, 2)];
    NSString *day = [time substringWithRange:NSMakeRange(8, 2)];
    NSString *hour = [time substringWithRange:NSMakeRange(11, 2)];
    NSString *minute = [time substringWithRange:NSMakeRange(14, 2)];
    return [NSString stringWithFormat:@"%@/%@/%@ %@:%@",year,month,day,hour,minute];
}
// 设置时间：精确到分：用xxxx年xx月xx日 xx时xx分表示
+ (NSString *)setYearMouthDayHourMinuteWithChineseYearMouthDayHourMinuteSecond:(NSString *)time{
    
    NSString *year = [time substringToIndex:4];
    NSString *month = [time substringWithRange:NSMakeRange(5, 2)];
    NSString *day = [time substringWithRange:NSMakeRange(8, 2)];
    NSString *hour = [time substringWithRange:NSMakeRange(11, 2)];
    NSString *minute = [time substringWithRange:NSMakeRange(14, 2)];
    return [NSString stringWithFormat:@"%@年%@月%@日 %@:%@",year,month,day,hour,minute];
}
// 设置时间：xx月xx日
+ (NSString *)setYearMouthDayHourMinuteWithChineseMouthDay:(NSString *)time{
    
    
    NSString *month = [time substringWithRange:NSMakeRange(5, 2)];
    NSString *day = [time substringWithRange:NSMakeRange(8, 2)];
    
    return [NSString stringWithFormat:@"%@月%@日",month,day];
}

// 提示框
//+ (void)showHubWithLabelText:(NSString *)text andHidAfterDelay:(double)afterDelay{
//    
//    _hud.labelText = text;
//    
//    
//    [self->hud show:YES];
//    [self.hud hide:YES afterDelay:afterDelay];
//}


@end
