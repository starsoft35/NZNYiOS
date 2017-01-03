//
//  CYRechargeView.h
//  nzny
//
//  Created by 男左女右 on 2016/12/25.
//  Copyright © 2016年 nznychina. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CYRechargeView : UIView


// 充值金额：textField
@property (weak, nonatomic) IBOutlet UITextField *rechargeCountTF;


// 微信支付：View
@property (weak, nonatomic) IBOutlet UIView *weChatPayView;

// 微信支付：选中状态：imageView
@property (weak, nonatomic) IBOutlet UIImageView *weChatPaySelectImgView;



// 支付宝：View
@property (weak, nonatomic) IBOutlet UIView *aliPayView;
// 支付宝：选中状态：imageView
@property (weak, nonatomic) IBOutlet UIImageView *aliPaySelectImgView;

// 确认支付：button
@property (weak, nonatomic) IBOutlet UIButton *confirmPayBtn;


@end
