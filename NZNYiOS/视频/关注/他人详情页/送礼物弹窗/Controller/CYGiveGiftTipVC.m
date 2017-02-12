//
//  CYGiveGiftTipVC.m
//  nzny
//
//  Created by 男左女右 on 2016/11/23.
//  Copyright © 2016年 nznychina. All rights reserved.
//

#import "CYGiveGiftTipVC.h"

// 送礼弹窗
#import "CYGiveGiftTipView.h"

// 余额不足弹窗：VC
#import "CYBalanceNotEnoughVC.h"

@interface CYGiveGiftTipVC ()<UITextFieldDelegate>

@end

@implementation CYGiveGiftTipVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // 添加视图
    [self addView];
    
    
}


// 添加视图
- (void)addView{
    
    
    _giveGiftView = [[[NSBundle mainBundle] loadNibNamed:@"CYGiveGiftTipView" owner:nil options:nil] lastObject];
    
    // 弹窗关闭：点击事件
    [_giveGiftView.tipCloseBtn addTarget:self action:@selector(tipCloseBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    // 一支玫瑰花：点击事件
    [_giveGiftView.oneRoseBtn addTarget:self action:@selector(oneRoseBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    // 三支玫瑰花：点击事件
    [_giveGiftView.threeRoseBtn addTarget:self action:@selector(threeRoseBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    // 九支玫瑰花：点击事件
    [_giveGiftView.nineRoseBtn addTarget:self action:@selector(nineRoseBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    // 九十九支玫瑰花：点击事件
    [_giveGiftView.ninetyNineRoseBtn addTarget:self action:@selector(ninetyNineRoseBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    // 九百九十九支玫瑰花：点击事件
    [_giveGiftView.ninehundredNitetyNineRoseBtn addTarget:self action:@selector(ninehundredNitetyNineRoseBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    // 送礼：button：点击事件
    [_giveGiftView.giveGiftBtn addTarget:self action:@selector(giveGiftBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    _giveGiftView.giftCountTextField.delegate = self;
    
//    [self.view addSubview:giveGiftView];
    self.view = _giveGiftView;
    
}


// 弹窗关闭：点击事件
- (void)tipCloseBtnClick{
    NSLog(@"弹窗关闭：点击事件");
    
    // 隐藏键盘
    [self.view endEditing:YES];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


// 网络请求：用户余额：余额够，则送礼请求，不够则充值弹窗
- (void)requestUserBalanceIfIsEnoughWithUserId:(NSString *)userId andOppUserId:(NSString *)oppUserId andLikeCount:(NSInteger)likeCount andCost:(float)cost{
    NSLog(@"用户余额：网络请求！");
    
    [self showLoadingView];
    
    // 新地址
    NSString *newUrl = [NSString stringWithFormat:@"%@?userId=%@",cUserMoneyUrl,userId];
    
    // 网络请求：用户余额
    [CYNetWorkManager getRequestWithUrl:newUrl params:nil progress:^(NSProgress *uploadProgress) {
        NSLog(@"用户余额：%@",uploadProgress);
        
        
    } whenSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"用户余额：请求成功！");
        
        // 1、
        NSString *code = responseObject[@"code"];
        
        // 1.2.1.1.2、和成功的code 匹配
        if ([code isEqualToString:@"0"]) {
            NSLog(@"用户余额：获取成功！");
            NSLog(@"用户余额：%@",responseObject);
            
            
            
            // 请求数据结束，取消加载
            //            [self hidenLoadingView];
            
            
            NSString * tempMoneyStr = responseObject[@"res"][@"data"][@"money"];
            float tempMoney = [tempMoneyStr floatValue];
            
            NSLog(@"tempMoneyStr:%@",tempMoneyStr);
            NSLog(@"tempMoney:%lf",tempMoney);
            NSLog(@"cost:%lf",cost);
            
            // 如果余额够支付，则赞、支付
            if (tempMoney >= cost) {
                
                self.isEnoughForPay = YES;
                
                // 网路请求：送礼
                [self requestGiveGiftWithUserId:self.onlyUser.userID andReceiveUserId:self.oppUserId andGiftCount:likeCount];
                
            }
            // 余额不足，则弹到充值界面
            else {
                
                // 请求数据结束，取消加载
                [self hidenLoadingView];
                
                
                // 余额不足弹窗：VC
                CYBalanceNotEnoughVC *balanceNotEnoughVC = [[CYBalanceNotEnoughVC alloc] init];
                
                
//                UINavigationController *tempBalanceNotEnoughNav = [CYUtilities createDefaultNavCWithRootVC:balanceNotEnoughVC BgColor:nil TintColor:[UIColor whiteColor] translucent:NO titleColor:[UIColor whiteColor] title:@"" bgImg:[UIImage imageNamed:@"Title1"]];
//                
//                [balanceNotEnoughVC.navigationController setNavigationBarHidden:YES animated:YES];
                
                //                [self showViewController:tempVideoNav sender:self];
//                [self presentViewController:tempBalanceNotEnoughNav animated:YES completion:nil];
                [self presentViewController:balanceNotEnoughVC animated:YES completion:nil];
                
            }
        }
        else{
            NSLog(@"用户余额：获取失败:responseObject:%@",responseObject);
            NSLog(@"用户余额：获取失败:responseObject:res:msg:%@",responseObject[@"res"][@"msg"]);
            // 1.2.1.1.2.2、获取失败：弹窗提示：获取失败的返回信息
            [self showHubWithLabelText:responseObject[@"res"][@"msg"] andHidAfterDelay:3.0];
            
        }
        
        
    } whenFailure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"用户余额：请求失败！");
        NSLog(@"点一个赞：error：%@",error);
        
        [self showHubWithLabelText:@"请检查网络，重新加载" andHidAfterDelay:3.0];
    } withToken:self.onlyUser.userToken];
    
}

// 一支玫瑰花：点击事件
- (void)oneRoseBtnClick{
    NSLog(@"一支玫瑰花：点击事件");
    
    // 送礼：玫瑰花数量
    NSInteger roseCount = 1;
    
    // 网络请求：送一支玫瑰花
    [self requestUserBalanceIfIsEnoughWithUserId:self.onlyUser.userID andOppUserId:self.oppUserId andLikeCount:roseCount andCost:(2.0 * roseCount)];
    
}



// 三支玫瑰花：点击事件
- (void)threeRoseBtnClick{
    NSLog(@"三支玫瑰花：点击事件");
    
    // 送礼：玫瑰花数量
    NSInteger roseCount = 3;
    
    // 网络请求：送三支玫瑰花
    [self requestUserBalanceIfIsEnoughWithUserId:self.onlyUser.userID andOppUserId:self.oppUserId andLikeCount:roseCount andCost:(2.0 * roseCount)];
    
}

// 九支玫瑰花：点击事件
- (void)nineRoseBtnClick{
    NSLog(@"九支玫瑰花：点击事件");
    
    // 送礼：玫瑰花数量
    NSInteger roseCount = 9;
    
    // 网络请求：送九支玫瑰花
    [self requestUserBalanceIfIsEnoughWithUserId:self.onlyUser.userID andOppUserId:self.oppUserId andLikeCount:roseCount andCost:(2.0 * roseCount)];
    
}

// 九十九支玫瑰花：点击事件
- (void)ninetyNineRoseBtnClick{
    NSLog(@"九十九支玫瑰花：点击事件");
    
    // 送礼：玫瑰花数量
    NSInteger roseCount = 99;
    
    // 网络请求：送九十九支玫瑰花
    [self requestUserBalanceIfIsEnoughWithUserId:self.onlyUser.userID andOppUserId:self.oppUserId andLikeCount:roseCount andCost:(2.0 * roseCount)];
}

// 九百九十九支玫瑰花：点击事件
- (void)ninehundredNitetyNineRoseBtnClick{
    NSLog(@"九百九十九支玫瑰花：点击事件");
    
    // 送礼：玫瑰花数量
    NSInteger roseCount = 999;
    
    // 网络请求：送九百九十九支玫瑰花
    [self requestUserBalanceIfIsEnoughWithUserId:self.onlyUser.userID andOppUserId:self.oppUserId andLikeCount:roseCount andCost:(2.0 * roseCount)];
}

// 送礼：button：点击事件
- (void)giveGiftBtnClick{
    NSLog(@"送礼：button：点击事件");
    
    NSScanner *scan = [NSScanner scannerWithString:self.giveGiftView.giftCountTextField.text];
    
    NSInteger flag;
    
    if ([scan scanInteger:&flag] && [scan isAtEnd]) {
        
        // 送礼：玫瑰花数量
        NSInteger roseCount = [self.giveGiftView.giftCountTextField.text integerValue];
        
        // 网络请求：送 n 支玫瑰花
        [self requestUserBalanceIfIsEnoughWithUserId:self.onlyUser.userID andOppUserId:self.oppUserId andLikeCount:roseCount andCost:(2.0 * roseCount)];
        
    }
    else {
        
        [self showHubWithLabelText:@"请输入数字" andHidAfterDelay:3.0];
    }
    
    
}



// 重写touchsBegan，点击旁边空白时，让UIView 类的子类，失去第一响应者
#pragma mark --重写touchsBegan
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    
    //
    [UIView animateWithDuration:0.5 animations:^{
        self.view.bounds = CGRectMake(0, 0, cScreen_Width, cScreen_Height);
        
    }];
    
    for (UIView *tempView in self.view.subviews) {
        if ([tempView isKindOfClass:[UIView class]]) {
            // 失去第一响应者
            [tempView resignFirstResponder];
        }
    }
    
}

#pragma mark --UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    //
    [UIView animateWithDuration:0.5 animations:^{
        self.view.bounds = CGRectMake(0, 128, cScreen_Width, cScreen_Height);
    }];
    
}



@end
