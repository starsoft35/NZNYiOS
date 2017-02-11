//
//  RCLikeMessage.h
//  RongChatRoomDemo
//
//  Created by 杜立召 on 16/5/17.
//  Copyright © 2016年 rongcloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RongIMLib/RongIMLib.h>

#define RCDLiveGiftMessageIdentifier @"RC:GiftMsg"
/* 点赞消息
 *
 * 对于聊天室中发送频率较高，不需要存储的消息要使用状态消息，自定义消息继承RCMessageContent
 * 然后persistentFlag 方法返回 MessagePersistent_STATUS
 */
@interface RCDLiveGiftMessage : RCMessageContent

/*
 * 类型 0 小花，1，鼓掌
 */
@property(nonatomic, strong) NSString *type;




// 发送内容：为了解决融云直播聊天室发送文本和表情消息造成的阿里直播推流断开连接的问题
// 消息类型
@property (nonatomic, strong) NSString *tempMessageType;

// 消息内容
@property (nonatomic, strong) NSString *tempMessageContentStr;


// 安卓消息内容
@property (nonatomic, strong) NSString *content;





@end
