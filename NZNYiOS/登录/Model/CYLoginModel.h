//
//  CYLoginModel.h
//  NZNYiOS
//
//  Created by 男左女右 on 16/9/18.
//  Copyright © 2016年 NZNY. All rights reserved.
//

#import "JSONModel.h"

@interface CYLoginModel : JSONModel

// 头像imageView
@property (weak, nonatomic)NSString *HeadImgView;

// 手机号textField
@property (weak, nonatomic)NSString *cellNumTF;

// 密码textField
@property (weak, nonatomic)NSString *passwordTF;

// 密码隐藏还是显示ImgView
@property (weak, nonatomic)NSString *psdShowOrHideImgName;


// 先逛一逛button
@property (weak, nonatomic) UIButton *FirstGoBtn;

// 登录button
@property (weak, nonatomic) UIButton *loginBtn;

// 注册button
@property (weak, nonatomic) UIButton *registerBtn;

// 忘记密码button
@property (weak, nonatomic) UIButton *forgetPSBtn;

// 微信登录button
@property (weak, nonatomic) UIButton *weChatLoginBtn;


@end
