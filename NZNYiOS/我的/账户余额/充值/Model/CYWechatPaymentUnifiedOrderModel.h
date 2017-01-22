//
//  CYWechatPaymentUnifiedOrderModel.h
//  nzny
//
//  Created by 男左女右 on 2017/1/22.
//  Copyright © 2017年 nznychina. All rights reserved.
//

#import "CYBaseModel.h"

@interface CYWechatPaymentUnifiedOrderModel : CYBaseModel

// 商户号
@property (nonatomic, copy) NSString *mch_id;

// 随机字符串
@property (nonatomic, copy) NSString *nonce_str;

// 预支付交易会话标识
@property (nonatomic, copy) NSString *prepay_id;

// 业务结果
@property (nonatomic, copy) NSString *result_code;

// 返回状态码:是通信标识，非交易标识
@property (nonatomic, copy) NSString *return_code;

// 返回信息：如非空，为错误原因：签名失败、参数格式校验错误
@property (nonatomic, copy) NSString *return_msg;

// 签名
@property (nonatomic, copy) NSString *sign;

// 交易类型
@property (nonatomic, copy) NSString *trade_type;


@end
