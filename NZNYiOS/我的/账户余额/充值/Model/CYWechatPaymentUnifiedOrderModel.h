//
//  CYWechatPaymentUnifiedOrderModel.h
//  nzny
//
//  Created by 男左女右 on 2017/1/22.
//  Copyright © 2017年 nznychina. All rights reserved.
//

#import "CYBaseModel.h"

@interface CYWechatPaymentUnifiedOrderModel : CYBaseModel


// appId：微信的id
@property (nonatomic, copy) NSString *appId;



// 随机字符串
@property (nonatomic, copy) NSString *nonceStr;

// 扩展字段
@property (nonatomic, copy) NSString *package;


// 商户号
@property (nonatomic, copy) NSString *partnerId;
// 预支付交易会话标识
@property (nonatomic, copy) NSString *prepayId;

// 业务结果
//@property (nonatomic, copy) NSString *result_code;

// 返回状态码:是通信标识，非交易标识
@property (nonatomic, copy) NSString *return_code;

// 返回信息：如非空，为错误原因：签名失败、参数格式校验错误
//@property (nonatomic, copy) NSString *return_msg;

// 签名
@property (nonatomic, copy) NSString *sign;

// 时间戳
@property (nonatomic, copy) NSString *timeStamp;

// 交易类型
@property (nonatomic, copy) NSString *trade_type;


@end
