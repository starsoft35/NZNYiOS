//
//  CYRegisterModel.h
//  NZNYiOS
//
//  Created by 男左女右 on 16/9/18.
//  Copyright © 2016年 NZNY. All rights reserved.
//

#import "JSONModel.h"

@interface CYRegisterModel : JSONModel


// 区号label
@property (weak, nonatomic)NSString *areaNumLab;

// 手机号textField
@property (weak, nonatomic)NSString *cellNumTF;

// 验证码textField
@property (weak, nonatomic)NSString *verificationTF;

// 发送验证码button
@property (weak, nonatomic) IBOutlet UIButton *sendVerificationBtn;

// 密码textField
@property (weak, nonatomic)NSString *passwordTF;

// 密码显示或隐藏imageView
@property (weak, nonatomic)NSString *passwordDisplayOrHideImgView;

// 提示密码格式label
@property (weak, nonatomic)NSString *promptPSFormatLab;

// 注册button
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;

// 已有账号，去登录button
@property (weak, nonatomic) IBOutlet UIButton *goLoginBtn;

// 微信登录button
@property (weak, nonatomic) IBOutlet UIButton *WeChatLoginBtn;

@end
