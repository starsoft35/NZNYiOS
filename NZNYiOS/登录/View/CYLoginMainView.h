//
//  CYLoginMainView.h
//  NZNYiOS
//
//  Created by 男左女右 on 16/9/14.
//  Copyright © 2016年 NZNY. All rights reserved.
//

#import <UIKit/UIKit.h>

// 模型
#import "CYLoginModel.h"

@interface CYLoginMainView : UIView


#pragma --模型
// 模型
@property (strong,nonatomic)CYLoginModel *loginM;


#pragma --属性
// 先逛一逛button
@property (weak, nonatomic) IBOutlet UIButton *firstGoBtn;

// 头像imageView
@property (weak, nonatomic) IBOutlet UIImageView *headImgView;

// 手机号textField
@property (weak, nonatomic) IBOutlet UITextField *cellNumTF;

// 密码textField
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;

// 密码隐藏还是显示ImgView
@property (weak, nonatomic) IBOutlet UIImageView *passwordDisplayOrHideImgView;

// 登录button
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

// 注册button
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;

// 忘记密码button
@property (weak, nonatomic) IBOutlet UIButton *forgetPSBtn;

// 微信登录button
@property (weak, nonatomic) IBOutlet UIButton *weChatLoginBtn;

// 微信登录视图：View
@property (weak, nonatomic) IBOutlet UIView *weChatLoginMainView;




@end
