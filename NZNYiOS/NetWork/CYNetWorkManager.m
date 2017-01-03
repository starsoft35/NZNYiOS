
//
//  CYNetWorkManager.m
//  NZNYiOS
//
//  Created by 男左女右 on 16/9/22.
//  Copyright © 2016年 NZNY. All rights reserved.
//

#import "CYNetWorkManager.h"



@implementation CYNetWorkManager

// 登录请求，提交信息：账户、密码
+ (void)loginPostRequestWithAccount:(NSString *)account andPassword:(NSString *)password progress:(Progress)progress WhenSuccess:(Success)success andFailure:(Failure)failure{
    
    // 拼接参数
    NSDictionary *params = @{
                             @"Account":account,
                             @"Password":password
                             };
    
    // 请求数据：登录
//    [self postRequestWithUrl:cHostUrl params:params whenSuccess:success whenFailure:failure withContentTypes:nil];
    [self postRequestWithUrl:cHostUrl params:params progress:progress whenSuccess:success whenFailure:failure withToken:nil];
}

// 注册请求，提交信息：账户、密码、（验证码)
+ (void)registerPostRequestWithAccount:(NSString *)account andMobileCode:(NSString *)mobileCode andPassword:(NSString *)password progress:(Progress)progress whenSuccess:(Success)success andFailure:(Failure)failure{
    
    
    // 拼接参数
    NSDictionary *params = @{
                             @"Account":account,
                             @"Password":password,
                             @"MobileCode":mobileCode,
                             @"ConfirmPassword":password
                             };
    
    // 请求数据
//    [self postRequestWithUrl:cHostUrl params:params whenSuccess:success whenFailure:failure withContentTypes:nil];
    [self postRequestWithUrl:cHostUrl params:params progress:progress whenSuccess:success whenFailure:failure withToken:nil];
    
}


// 请求数据：POST
+ (void)postRequestWithUrl:(NSString *)urlStr params:(NSDictionary *)params progress:(Progress)progress whenSuccess:(Success)success whenFailure:(Failure)failure withToken:(NSString *)token{
    
    // 获取 请求管理类 对象
//        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // 可以设置主机地址，然后让别的接口拼接进来。（AFNetWorking 会自动进行拼接，前提是你给了baseURL）
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager manager] initWithBaseURL:[NSURL URLWithString:cHostUrl]];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    // 头字段
    if (token != nil) {
        
        NSString *newToken = [NSString stringWithFormat:@"bearer %@",token];
        [manager.requestSerializer setValue:newToken forHTTPHeaderField:@"Authorization"];
        NSLog(@"~~~~~~~Authorization：%@",newToken);
    }
//    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    // 数据类型
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"application/xml", @"text/xml",
//                                                         @"text/html",
                                                         nil];
    
    // 请求数据：POST
    [manager POST:urlStr parameters:params progress:progress success:success failure:failure];
    
    
}

// 请求数据：GET
+ (void)getRequestWithUrl:(NSString *)urlStr params:(NSDictionary *)params progress:(Progress)progress whenSuccess:(Success)success whenFailure:(Failure)failure withToken:(NSString *)token{
    
    // 可以设置主机地址，然后让别的接口拼接进来。（AFNetWorking 会自动进行拼接，前提是你给了baseURL）
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager manager] initWithBaseURL:[NSURL URLWithString:cHostUrl]];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    // 头字段
    if (token != nil) {
        
        NSString *newToken = [NSString stringWithFormat:@"bearer %@",token];
        [manager.requestSerializer setValue:newToken forHTTPHeaderField:@"Authorization"];
        NSLog(@"~~~~~~~Authorization：%@",newToken);
    }
    
    // 数据类型
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"application/xml", @"text/xml", nil];
    
    // 请求数据：GET
    [manager GET:urlStr parameters:params progress:progress success:success failure:failure];
    
}


// 上传图片：test
+ (void)uploadImgRequestWithUrl:(NSString *)urlStr params:(NSDictionary *)params constructingBodyWithBlock:(ConstructingBodyWithBlock)construct progress:(Progress)progress whenSuccess:(Success)success whenFailure:(Failure)failure withToken:(NSString *)token{
    NSLog(@"~~~~~~~~~~token:%@",token);
    
    // 参数
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager manager] initWithBaseURL:[NSURL URLWithString:cHostUrl]];
    
//    manager.requestSerializer = [AFJSONRequestSerializer serializer];
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    // 头字段
    if (token != nil) {
        
        NSString *newToken = [NSString stringWithFormat:@"bearer %@",token];
        [manager.requestSerializer setValue:newToken forHTTPHeaderField:@"Authorization"];
        NSLog(@"~~~~~~~Authorization：%@",newToken);
    }
    
    // 数据类型
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"application/xml", @"text/xml",nil];
    
    
    
    [manager POST:urlStr parameters:params constructingBodyWithBlock:construct progress:progress success:success failure:failure];
    
    
}

@end
