//
//  CYUser.m
//  nzny
//
//  Created by 男左女右 on 16/10/9.
//  Copyright © 2016年 nznychina. All rights reserved.
//

#import "CYUser.h"

@implementation CYUser

// 因为当前登录的用户只能有一个，所以做成一个单例
+ (instancetype)currentUser{
    
    static CYUser *user = nil;
    
    if (user == nil) {
        
        user = [[CYUser alloc] init];
    }
    
    return user;
}

#pragma --归档的两个协议方法
// （归档需遵守NSCoding 协议，并一定要实现这两个方法）
// 保存用户信息：归档
- (void)encodeWithCoder:(NSCoder *)aCoder{
    
    // 保存属性
    [aCoder encodeObject:self.userID forKey:@"userid"];
    [aCoder encodeObject:self.userToken forKey:@"token"];
    [aCoder encodeObject:self.userAccount forKey:@"userAccount"];
    [aCoder encodeObject:self.userPSW forKey:@"userPSW"];
    
    [aCoder encodeObject:self.RCUserId forKey:@"RCUserId"];
    [aCoder encodeObject:self.RongToken forKey:@"RongToken"];
    [aCoder encodeObject:self.Birthday forKey:@"Birthday"];
    [aCoder encodeObject:self.City forKey:@"City"];
    [aCoder encodeObject:self.Declaration forKey:@"Declaration"];
    [aCoder encodeObject:self.Education forKey:@"Education"];
    NSString *FIdStr = [NSString stringWithFormat:@"%ld",self.FId];
    [aCoder encodeObject:FIdStr forKey:@"FId"];
    [aCoder encodeObject:self.Gender forKey:@"Gender"];
    [aCoder encodeObject:self.Id forKey:@"Id"];
    [aCoder encodeObject:self.Marriage forKey:@"Marriage"];
    [aCoder encodeObject:self.Nickname forKey:@"Nickname"];
    [aCoder encodeObject:self.Portrait forKey:@"Portrait"];
    [aCoder encodeObject:self.Province forKey:@"Province"];
    [aCoder encodeObject:self.RealName forKey:@"RealName"];
    
}

// 读取用户信息：解归档
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    self = [super init];
    
    if (self) {
        
        // 读取属性
        self.userID = [aDecoder decodeObjectForKey:@"userid"];
        self.userToken = [aDecoder decodeObjectForKey:@"token"];
        self.userAccount = [aDecoder decodeObjectForKey:@"userAccount"];
        self.userPSW = [aDecoder decodeObjectForKey:@"userPSW"];
        
        
        
        self.RCUserId = [aDecoder decodeObjectForKey:@"RCUserId"];
        self.RongToken = [aDecoder decodeObjectForKey:@"RongToken"];
        self.Birthday = [aDecoder decodeObjectForKey:@"Birthday"];
        self.City = [aDecoder decodeObjectForKey:@"City"];
        self.Declaration = [aDecoder decodeObjectForKey:@"Declaration"];
        self.Education = [aDecoder decodeObjectForKey:@"Education"];
        self.FId = [[aDecoder decodeObjectForKey:@"FId"] integerValue];
        self.Gender = [aDecoder decodeObjectForKey:@"Gender"];
        self.Id = [aDecoder decodeObjectForKey:@"Id"];
        self.Marriage = [aDecoder decodeObjectForKey:@"Marriage"];
        self.Nickname = [aDecoder decodeObjectForKey:@"Nickname"];
        self.Portrait = [aDecoder decodeObjectForKey:@"Portrait"];
        self.Province = [aDecoder decodeObjectForKey:@"Province"];
        self.RealName = [aDecoder decodeObjectForKey:@"RealName"];
        
    }
    
    return self;
}


@end
