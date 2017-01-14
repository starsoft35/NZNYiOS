//
//  CYChatListVC.m
//  nzny
//
//  Created by 男左女右 on 2016/11/16.
//  Copyright © 2016年 nznychina. All rights reserved.
//

#import "CYChatListVC.h"



// 好友申请：View
#import "CYFriendApplyView.h"


// 好友申请列表
#import "CYMyFriendApplyListVC.h"

// 模型
#import "CYMyFriendApplyListCellModel.h"


// 聊天界面
#import "CYChatVC.h"

// 我的好友VC
#import "CYMyFriendVC.h"



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
    
    
    // 右边BarButtonItem：好友
    [self setFriendsRightBarButtonItem];
    
    
    
    _friendApplyView = [[[NSBundle mainBundle] loadNibNamed:@"CYFriendApplyView" owner:nil options:nil] lastObject];
    
    
}

// 界面将要显示：刷新数据
- (void)viewWillAppear:(BOOL)animated{
    
    
    // 加载数据
    [self loadData];
    
}

// 点击空白：弹窗消失、隐藏键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    // 弹窗消失
    [self.hud hide:YES];
    
}

// 加载数据：我的好友申请列表
- (void)loadData{
    
    // 网络请求：我的好友申请列表
    // url参数
    NSDictionary *params = @{
                             @"userId":self.currentUserId
                             };
    
    
    // 网络请求：
    [CYNetWorkManager getRequestWithUrl:cApplyFriendsListUrl params:params progress:^(NSProgress *uploadProgress) {
        NSLog(@"我的好友申请列表：网络请求：进度：%@",uploadProgress);
        
    } whenSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"我的好友申请列表：网络请求：请求成功");
        
        // 1、
        NSString *code = responseObject[@"code"];
        
        // 1.2.1.1.2、和成功的code 匹配
        if ([code isEqualToString:@"0"]) {
            NSLog(@"获取我的好友申请列表：获取成功！");
            NSLog(@"获取我的好友申请列表：%@",responseObject);
            
            // 清空：每次刷新都需要
            [self.myFriendApplyListArr removeAllObjects];
            
            // 解析数据，模型存到数组
            [self.myFriendApplyListArr addObjectsFromArray:[CYMyFriendApplyListCellModel arrayOfModelsFromDictionaries:responseObject[@"res"][@"data"][@"list"]]];
            
            
            if (self.myFriendApplyListArr.count == 0) {
                
                self.friendApplyView.unReadCountLab.text = [NSString stringWithFormat:@""];
                self.friendApplyView.unReadCountImgView.hidden = YES;
                
            }
            else if (self.myFriendApplyListArr.count >= 10) {
                
                self.friendApplyView.unReadCountLab.text = [NSString stringWithFormat:@"9+"];
                self.friendApplyView.unReadCountImgView.hidden = NO;
            }
            else {
                //                self.unReadCountLab.text = [NSString stringWithFormat:@"9+"];
                self.friendApplyView.unReadCountLab.text = [NSString stringWithFormat:@"%ld",self.myFriendApplyListArr.count];
                self.friendApplyView.unReadCountImgView.hidden = NO;
            }
            
            
        }
        else{
            NSLog(@"获取我的好友申请列表：获取失败:responseObject:%@",responseObject);
            NSLog(@"获取我的好友申请列表：获取失败:responseObject:res:msg:%@",responseObject[@"res"][@"msg"]);
            // 1.2.1.1.2.2、获取失败：弹窗提示：获取失败的返回信息
        }
        
    } whenFailure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"我的好友申请列表：网络请求：请求失败");
        
        
    } withToken:self.currentUserToken];
    
}


- (void)viewDidAppear:(BOOL)animated{
    NSLog(@"界面已经显示~~~~~~~~");
    [super viewWillAppear:animated];
    
    
    [self.conversationListTableView reloadData];
    
}

// header
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    
    // 好友申请：View：点击事件
    _friendApplyView.userInteractionEnabled = YES;
    [_friendApplyView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(applyFriendViewClick)]];
    
    
    return _friendApplyView;
}


// 好友申请：View：点击事件
- (void)applyFriendViewClick{
    NSLog(@"好友申请：View：点击事件");
    
    CYMyFriendApplyListVC *friendApplyListVC = [[CYMyFriendApplyListVC alloc] init];
    
    
    [self.navigationController pushViewController:friendApplyListVC animated:YES];
    
}


// header 的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 180.0 / 1334.0 * cScreen_Height;
}



// 融云代理：选中的会话列表项
- (void)onSelectedTableRow:(RCConversationModelType)conversationModelType conversationModel:(RCConversationModel *)model atIndexPath:(NSIndexPath *)indexPath{
    
    
    // 网络请求：判断是否为好友
    // 模型
    
    // Url参数
    NSString *newUrlStr = [NSString stringWithFormat:@"%@?userId=%@&oppUserId=%@",cIfIsFriendUrl,self.currentUserId,model.targetId];
    
    // 网络请求：判断是否为好友
    [CYNetWorkManager postRequestWithUrl:newUrlStr params:nil progress:^(NSProgress *uploadProgress) {
        NSLog(@"判断是否为好友进度：%@",uploadProgress);
    } whenSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"判断是否为好友：请求成功！");
        
        // 2.3.1.1、获取code 值
        NSString *code = responseObject[@"code"];
        
        // 2.3.1.2、判断返回值
        if ([code isEqualToString:@"0"]) {
            NSLog(@"判断是否为好友：判断成功！");
            
            
            
            if (responseObject[@"res"][@"IsFriend"] == YES) {
                
                // 如果是好友：则打开聊天界面；
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
            else {
                
                // 不是好友，则提示申请加好友
                [self showHubWithLabelText:@"你们还不是好友" andHidAfterDelay:3.0];
                
            }
            
            
        }
        else{
            NSLog(@"判断是否为好友：判断失败！");
            NSLog(@"msg:%@",responseObject[@"res"][@"msg"]);
            
            // 2.3.1.2.2、上传图片失败，弹窗
            [self showHubWithLabelText:responseObject[@"res"][@"msg"] andHidAfterDelay:3.0];
        }
        
    } whenFailure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"判断是否为好友：请求失败");
        
        [self showHubWithLabelText:@"网络有误" andHidAfterDelay:3.0];
        
    } withToken:self.currentUserToken];
    
}


// 右边BarButtonItem：好友
- (void)setFriendsRightBarButtonItem{
    
    // 好友
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"好友" style:2 target:self action:@selector(friendsRightBarButtonItemClick)];
    
}

// 右边BarButtonItem：好友：点击事件
- (void)friendsRightBarButtonItemClick{
    
    // 我的好友
    CYMyFriendVC *myFriendVC = [[CYMyFriendVC alloc] init];
    
    // 隐藏tabbar
    myFriendVC.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:myFriendVC animated:YES];
    
}


// 懒加载
- (NSMutableArray *)myFriendApplyListArr {
    
    if (_myFriendApplyListArr == nil) {
        
        _myFriendApplyListArr = [[NSMutableArray alloc] init];
    }
    
    return _myFriendApplyListArr;
}

// 懒加载弹窗
- (MBProgressHUD *)hud{
    
    if (_hud == nil) {
        
        _hud = [[MBProgressHUD alloc] init];
        
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = @"加载中~~";
        
        [self.view addSubview:_hud];
    }
    
    return _hud;
}

// 提示框
- (void)showHubWithLabelText:(NSString *)text andHidAfterDelay:(double)afterDelay{
    
    self.hud.labelText = text;
    
    
    [self.hud show:YES];
    [self.hud hide:YES afterDelay:afterDelay];
}

@end
