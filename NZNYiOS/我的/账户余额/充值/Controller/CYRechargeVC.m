//
//  CYRechargeVC.m
//  nzny
//
//  Created by 男左女右 on 2016/12/25.
//  Copyright © 2016年 nznychina. All rights reserved.
//

#import "CYRechargeVC.h"


// 微信登录SDK：API
#import "WXApi.h"


// 支付宝SDK
#import <AlipaySDK/AlipaySDK.h>


// 微信支付-统一下单：返回值：模型
#import "CYWechatPaymentUnifiedOrderModel.h"



@interface CYRechargeVC ()



@end

@implementation CYRechargeVC

{
    BOOL isWechat;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.title = @"充值";
    // 加载数据
//    [self loadData];
    
    // 添加视图
    [self addView];
}

// 加载数据
- (void)loadData{
    
    
    
}

// 添加视图
- (void)addView{
    
    
    // 我的视频View
    _rechargeView = [[[NSBundle mainBundle] loadNibNamed:@"CYRechargeView" owner:nil options:nil] lastObject];
    
    // 微信支付：手势
    _rechargeView.weChatPayView.userInteractionEnabled = YES;
    [_rechargeView.weChatPayView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(weChatPayViewClick)]];
    
    // 默认微信支付：微信为选中状态
    isWechat = YES;
    _rechargeView.weChatPaySelectImgView.image = [UIImage imageNamed:@"视频选中"];
    _rechargeView.aliPaySelectImgView.image = [UIImage imageNamed:@"视频未选中"];
    
    // 支付宝：手势
    _rechargeView.aliPayView.userInteractionEnabled = YES;
    [_rechargeView.aliPayView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(aliPayViewClick)]];
    
    
    // 确认支付：button：点击事件
    [_rechargeView.confirmPayBtn addTarget:self action:@selector(confirmPayBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.view = _rechargeView;
    
}

// 微信支付：手势
- (void)weChatPayViewClick{
    NSLog(@"微信支付：手势");
    
    isWechat = YES;
    _rechargeView.weChatPaySelectImgView.image = [UIImage imageNamed:@"视频选中"];
    _rechargeView.aliPaySelectImgView.image = [UIImage imageNamed:@"视频未选中"];
    
}

// 支付宝：手势
- (void)aliPayViewClick{
    NSLog(@"支付宝：手势");
    
    isWechat = NO;
    _rechargeView.weChatPaySelectImgView.image = [UIImage imageNamed:@"视频未选中"];
    _rechargeView.aliPaySelectImgView.image = [UIImage imageNamed:@"视频选中"];
    
}

// 确认支付：button：点击事件
- (void)confirmPayBtnClick{
    NSLog(@"确认支付：button：点击事件");
    
    
    // 获取时间戳
    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970];
    NSLog(@"interval:%f",interval);
    
    // 隐藏键盘
    [self.view endEditing:YES];
    
#warning 网络请求：充值支付
    
    // 如果是纯数字，则支付
    if ([self checkIfIsNum:_rechargeView.rechargeCountTF.text]) {
        
        // 如果选择的是微信支付：
        if (isWechat) {
            NSLog(@"当前为：微信支付");
            
            // 微信支付
            [self WXPay];
            
        }
        // 否则，选择的是支付宝支付：
        else {
            NSLog(@"当前为：支付宝支付");
            
        }
        
    }
    
}







// 微信支付
- (void)WXPay{
    
    
    
    
    // 网络请求：微信支付-统一下单
    NSString *newUrl = [NSString stringWithFormat:@"%@?total_fee=%d&spbill_create_ip=%@",cWechatPaymentUnifiedOrderUrl,[_rechargeView.rechargeCountTF.text intValue],[self getIPAddress]];
    NSLog(@"newUrl:weChatPay:%@",newUrl);
    
    
    [self showLoadingView];
    
    // 网络请求：微信支付-统一下单
    [CYNetWorkManager postRequestWithUrl:newUrl params:nil progress:^(NSProgress *uploadProgress) {
        NSLog(@"微信支付-统一下单：进度：%@",uploadProgress);
        
    } whenSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"微信支付-统一下单：请求成功！");
        // 1、
        // 通信标识
        NSString *return_code = responseObject[@"return_code"];
        // 业务结果
        NSString *result_code = responseObject[@"result_code"];
        
        
        // 通信:
        if ([return_code isEqualToString:@"SUCCESS"]) {
            NSLog(@"微信支付-统一下单：通信标识：结果成功！");
            NSLog(@"微信支付-统一下单：responseObject：%@",responseObject);
            
            
            // 业务
            if ([result_code isEqualToString:@"SUCCESS"]) {
                
                
                // 清空：每次刷新都需要
                [self.dataArray removeAllObjects];
                
                // 解析数据，模型存到数组
                [self.dataArray addObject:[[CYWechatPaymentUnifiedOrderModel alloc] initWithDictionary:responseObject error:nil]];
                
                // 向微信发起请求：支付
                [self requestWeChatPay];
                
            }
            else {
                
                NSLog(@"微信支付-统一下单：业务：结果失败:responseObject:%@",responseObject);
                
                // 1.2.1.1.2.2、我的粉丝失败：弹窗提示：获取失败的返回信息
                [self showHubWithLabelText:@"请求失败" andHidAfterDelay:3.0];

            }
            
            
            // 请求数据结束，取消加载
            [self hidenLoadingView];
            
        }
        else{
            NSLog(@"微信支付-统一下单：通信标识：结果失败:responseObject:%@",responseObject);
            // 1.2.1.1.2.2、我的粉丝失败：弹窗提示：获取失败的返回信息
            [self showHubWithLabelText:@"请求失败" andHidAfterDelay:3.0];
            
        }
        
    } whenFailure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"微信支付-统一下单请求：请求失败！");
        
        [self showHubWithLabelText:@"请检查网络" andHidAfterDelay:3.0];
        
    } withToken:self.onlyUser.userToken];
    
    
    
    
#warning 现在提示错误：APPID未关联PaySignKey：
    // APPID未关联PaySignKey
    
    
}
// 向微信发起请求：支付
- (void)requestWeChatPay{
    
    
    if (self.dataArray.count > 0) {
        
        
        CYWechatPaymentUnifiedOrderModel *tempWeChatPayModel = self.dataArray[0];
        
        
        // 向微信注册
        //    [WXApi registerApp:cWXAppID withDescription:@"nzny:1.4"];
        
        //    PayReq *request = [[[PayReq alloc] init] autorelease];
        PayReq *request = [[PayReq alloc] init];
        
        // 商户号
        request.partnerId = tempWeChatPayModel.mch_id;
        
        // 预支付交易会话ID
        request.prepayId= tempWeChatPayModel.prepay_id;
        
        // 扩展字段
        request.package = @"Sign=WXPay";
        
        // 随机字符串
        request.nonceStr= tempWeChatPayModel.nonce_str;
        
        // 时间戳
        // 获取时间戳
        NSTimeInterval interval = [[NSDate date] timeIntervalSince1970];
        NSLog(@"interval:%f",interval);
        
        request.timeStamp = interval;
        NSLog(@"request.timeStamp:%d",request.timeStamp);
        
        
        // 签名
        request.sign= tempWeChatPayModel.sign;
        
        
        [WXApi sendReq:request];
        
    }
    
    
}


// 支付宝支付




@end
