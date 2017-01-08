//
//  CYChatListVC.m
//  nzny
//
//  Created by 男左女右 on 2016/11/16.
//  Copyright © 2016年 nznychina. All rights reserved.
//

#import "CYChatListVC.h"

// 聊天界面
#import "CYChatVC.h"

// 融云：SDK-初始化
#import <RongIMKit/RongIMKit.h>

@interface CYChatListVC ()

@end

@implementation CYChatListVC


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // 隐藏tabbar
    self.hidesBottomBarWhenPushed = YES;
    
    
    self.title = @"消息";
    
    //设置需要显示哪些类型的会话
    [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE),
                                        @(ConversationType_DISCUSSION),
                                        @(ConversationType_CHATROOM),
                                        @(ConversationType_GROUP),
                                        @(ConversationType_APPSERVICE),
                                        @(ConversationType_SYSTEM)]];
    //设置需要将哪些类型的会话在会话列表中聚合显示
    [self setCollectionConversationType:@[@(ConversationType_DISCUSSION),
                                          @(ConversationType_GROUP)]];
    
    
}

- (void)viewDidAppear:(BOOL)animated{
    NSLog(@"界面已经显示~~~~~~~~");
    [super viewWillAppear:animated];
    
    
    [self.conversationListTableView reloadData];
    
}

// 融云代理：选中的会话列表项
- (void)onSelectedTableRow:(RCConversationModelType)conversationModelType conversationModel:(RCConversationModel *)model atIndexPath:(NSIndexPath *)indexPath{
    
    
    // 融云SDK
    // 新建一个聊天会话viewController 对象
    CYChatVC *chatVC = [[CYChatVC alloc] init];
    
    
    // 设置会话的类型，如单聊、讨论组、群聊、聊天室、客服、公众服务会话等
    chatVC.conversationType = model.conversationType;
    
    
    // 设置会话的目标会话ID。（单聊、客服、公众服务号会话为对方的ID，讨论组、群聊、聊天室为会话的ID）
    chatVC.targetId = model.targetId;
    NSLog(@"chatVC.targetId:%@",model.targetId);
    
    // 设置聊天会话界面要显示的标题
    chatVC.title = model.conversationTitle;
    NSLog(@"chatVC.title:%@",model.conversationTitle);
    NSLog(@"chatVC.model:%@",model);
    
    
//    chatVC.conversation = model;
    
//    self.hidesBottomBarWhenPushed = YES;
    
    // 显示聊天会话界面
    [self.navigationController pushViewController:chatVC animated:YES];
    
    
}


@end
