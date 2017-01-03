//
//  CYNetWorkManager.h
//  NZNYiOS
//
//  Created by 男左女右 on 16/9/22.
//  Copyright © 2016年 NZNY. All rights reserved.
//

#import <Foundation/Foundation.h>


// 上传数据
typedef void (^ConstructingBodyWithBlock)(id<AFMultipartFormData> formData);

// 上传进度
typedef void (^Progress)(NSProgress *uploadProgress);

// 请求成功：宏定义
typedef void (^Success)(NSURLSessionDataTask *task, id responseObject);

// 请求失败：宏定义(重定义AFNetworking里面的类，方便调用)
typedef void (^Failure)(NSURLSessionDataTask *task, NSError *error);



// 请求失败：宏定义(重定义AFNetworking里面的类，方便调用)
//typedef void (^Failure)(AFHTTPRequestOperation *operation, NSError *error);
//
//// 请求成功：宏定义
//typedef void (^Success)(AFHTTPRequestOperation *operation, id responseObject);


@interface CYNetWorkManager : NSObject

// 在这里统一请求接口，方便管理：自写请求接口类

// 登录请求，提交信息：用户名、密码
+ (void)loginPostRequestWithAccount:(NSString *)account andPassword:(NSString *)password progress:(Progress)progress WhenSuccess:(Success)success andFailure:(Failure)failure;

// 注册请求，提交信息：账户、密码、（验证码)
+ (void)registerPostRequestWithAccount:(NSString *)account andMobileCode:(NSString *)mobileCode andPassword:(NSString *)password progress:(Progress)progress whenSuccess:(Success)success andFailure:(Failure)failure;

// 请求数据：GET
+ (void)getRequestWithUrl:(NSString *)urlStr params:(NSDictionary *)params progress:(Progress)progress whenSuccess:(Success)success whenFailure:(Failure)failure withToken:(NSString *)token;

// 请求数据：POST
+ (void)postRequestWithUrl:(NSString *)urlStr params:(NSDictionary *)params progress:(Progress)progress whenSuccess:(Success)success whenFailure:(Failure)failure withToken:(NSString *)token;



// 上传图片：test
+ (void)uploadImgRequestWithUrl:(NSString *)urlStr params:(NSDictionary *)params constructingBodyWithBlock:(ConstructingBodyWithBlock)construct progress:(Progress)progress whenSuccess:(Success)success whenFailure:(Failure)failure withToken:(NSString *)token;



@end
