//
//  CYMyFriendVC.m
//  nzny
//
//  Created by 男左女右 on 2016/11/9.
//  Copyright © 2016年 nznychina. All rights reserved.
//

#import "CYMyFriendVC.h"

// cellView
#import "CYMyFriendViewCell.h"


// 模型：cell
#import "CYMyFriendViewCellModel.h"

// 融云：SDK-初始化
#import <RongIMKit/RongIMKit.h>

// 聊天界面
#import "CYChatVC.h"




@interface CYMyFriendVC ()

// 当前要删除的好友的indexPath
@property (nonatomic,copy) NSIndexPath *deleteIndexPath;


@end

@implementation CYMyFriendVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.title = @"我的好友";
    
    
    // 提前注册:cell
    [self.baseTableView registerNib:[UINib nibWithNibName:@"CYMyFriendViewCell" bundle:nil] forCellReuseIdentifier:@"CYMyFriendViewCell"];
    
    // 加载数据
    [self loadData];
}


// 加载数据
- (void)loadData{
    
    // 网络请求：我的好友列表
    // url参数
    NSDictionary *params = @{
                             @"userId":self.onlyUser.userID
                             };
    
    // 加载
    [self showLoadingView];
    
    // 网络请求：
    [CYNetWorkManager getRequestWithUrl:cMyFriendsListUrl params:params progress:^(NSProgress *uploadProgress) {
        NSLog(@"我的好友列表：网络请求：进度：%@",uploadProgress);
        
    } whenSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"我的好友列表：网络请求：请求成功");
        
        // 1、
        NSString *code = responseObject[@"code"];
        
        // 1.2.1.1.2、和成功的code 匹配
        if ([code isEqualToString:@"0"]) {
            NSLog(@"获取用户个人信息：获取成功！");
            NSLog(@"获取用户个人信息：%@",responseObject);
            
            // 清空：每次刷新都需要
            [self.dataArray removeAllObjects];
            
            // 解析数据，模型存到数组
            [self.dataArray addObjectsFromArray:[CYMyFriendViewCellModel arrayOfModelsFromDictionaries:responseObject[@"res"][@"data"][@"list"]]];
            
            if (self.dataArray.count == 0) {
                
                // 如果没有直播，添加提示
                [self addLabelToShowNoFriend];
            }
            
            // 刷新数据、界面
            [self.baseTableView reloadData];
            
            // 请求数据结束，取消加载
            [self hidenLoadingView];
            
        }
        else{
            NSLog(@"获取用户个人信息：获取失败:responseObject:%@",responseObject);
            NSLog(@"获取用户个人信息：获取失败:responseObject:res:msg:%@",responseObject[@"res"][@"msg"]);
            // 1.2.1.1.2.2、获取失败：弹窗提示：获取失败的返回信息
            [self showHubWithLabelText:responseObject[@"res"][@"msg"] andHidAfterDelay:3.0];
            
        }
        
    } whenFailure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"我的好友列表：网络请求：请求失败");
        
        [self showHubWithLabelText:@"请检查网络，重新加载" andHidAfterDelay:3.0];
        
    } withToken:self.onlyUser.userToken];
    
}

// 如果没有好友，添加提示
- (void)addLabelToShowNoFriend{
    NSLog(@"如果没有好友，添加提示");
    
    UILabel *tipLab = [[UILabel alloc] initWithFrame:CGRectMake((12.0 / 750.0) * cScreen_Width, (80.0 / 1334.0) * cScreen_Height, (726.0 / 750.0) * cScreen_Width, (30.0 / 1334.0) * cScreen_Height)];
    
    
    tipLab.text = @"暂时没有好友";
    
    tipLab.textAlignment = NSTextAlignmentCenter;
    tipLab.font = [UIFont systemFontOfSize:15];
    
    tipLab.textColor = [UIColor colorWithRed:0.50 green:0.50 blue:0.50 alpha:1.00];
    
    [self.baseTableView addSubview:tipLab];
}

#pragma --tableView代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    //
    CYMyFriendViewCell *myFriendViewCell = [tableView dequeueReusableCellWithIdentifier:@"CYMyFriendViewCell" forIndexPath:indexPath];
    
    
    // 赋值
    myFriendViewCell.myFriendViewCellModel = self.dataArray[indexPath.row];
    
    
    
    return myFriendViewCell;
    
}


// cell：点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"点击了第几行：%ld",(long)indexPath.row);
    
    //当离开某行时，让某行的选中状态消失
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // 模型
    CYMyFriendViewCellModel *tempMyFriendModel = self.dataArray[indexPath.row];
    
    
    
    // 融云SDK
    // 新建一个聊天会话viewController 对象
    CYChatVC *chatVC = [[CYChatVC alloc] init];
    
    
    // 设置会话的类型，如单聊、讨论组、群聊、聊天室、客服、公众服务会话等
    chatVC.conversationType = ConversationType_PRIVATE;
    
    // 设置会话的目标会话ID。（单聊、客服、公众服务号会话为对方的ID，讨论组、群聊、聊天室为会话的ID）
    chatVC.targetId = tempMyFriendModel.UserId;
    
    // 设置聊天会话界面要显示的标题
    chatVC.title = tempMyFriendModel.RealName;
    

    // 显示聊天会话界面
    [self.navigationController pushViewController:chatVC animated:YES];
    
}





//// 设置左划编辑样式
//- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    
//    return UITableViewCellEditingStyleDelete;
//}
//
//// 左划弹出框的文字
//- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
//    
////    if (indexPath.row == 0) {
////        
////        return @"置顶";
////    }
////    else {
////        
//        return @"删除";
////    }
//    
//}
//
//// 实现编辑后的功能，并实现左划的效果
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    
//    // 如果是删除样式，则删除好友
//#warning 网络请求删除数据
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        
//        
//#warning 首先删除数据源中的数据
//        // 这里删除假数据
//        [self.dataArray removeObjectAtIndex:indexPath.row];
//        
//        //  然后，从tableView 中删除（自带刷新）
//        [self.baseTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
//        
//        
//    }
//    
//}


// 左滑：效果：删除、置顶
- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    // 赋值：选择的当前行数
    _deleteIndexPath = indexPath;
    
    // 模型
    CYMyFriendViewCellModel *tempMyFriendModel = self.dataArray[indexPath.row];
    
    
    // 1、添加一个删除按钮
    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除好友" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        NSLog(@"第：%@ 行，点击了删除",indexPath);
        
        
        
        // 左滑删除好友：点击事件：提示框
        [self deleteRowActionClick];
        
        
//        // 1、更新数据
//        NSMutableArray *arrModel = self.dataArray[indexPath.row];
//        [arrModel removeObjectAtIndex:indexPath.row];
//        
//        NSLog(@"self.dataArray:%@",self.dataArray);
//        
//        // 2、更新UI
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
    }];
    
    
    if (tempMyFriendModel.Top) {
        
        // 已经置顶，则取消置顶
        
        
        // 2、添加一个取消置顶按钮
        UITableViewRowAction *deleteTopRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"取消置顶" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
            NSLog(@"点击了取消置顶");
            
            
            // 左滑好友取消置顶：点击事件
            [self deleteFriendToTopRowActionClickWithIndexPath:self.deleteIndexPath];
            
        }];
        
        
        
        deleteTopRowAction.backgroundColor = [UIColor colorWithRed:0.91 green:0.51 blue:0.23 alpha:1.00];
        
        // 将设置好的按钮放到数组中返回
        return @[deleteRowAction,deleteTopRowAction];
        
        
    }
    else {
        
        // 没有置顶，则置顶
        
        // 3、添加一个置顶按钮
        UITableViewRowAction *topRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"置顶" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
            NSLog(@"点击了置顶");
            
            
            // 左滑好友置顶：点击事件
            [self addFriendToTopRowActionClickWithIndexPath:self.deleteIndexPath];
            
            
            //
            //        // 1、更新数据
            //        [self.dataArray insertObject:self.dataArray[indexPath.row] atIndex:0];
            //        [self.dataArray removeObjectAtIndex:(indexPath.row + 1)];
            //
            //        NSLog(@"self.dataArray:%@",self.dataArray);
            //
            //        // 2、更新UI
            //        NSIndexPath *firstIndexPath = [NSIndexPath indexPathForRow:0 inSection:indexPath.section];
            //        [tableView moveRowAtIndexPath:indexPath toIndexPath:firstIndexPath];
            
            
        }];
        
        
        
        topRowAction.backgroundColor = [UIColor colorWithRed:0.91 green:0.51 blue:0.23 alpha:1.00];
        
        // 将设置好的按钮放到数组中返回
        return @[deleteRowAction,topRowAction];
        
    }
    
    
    // 将设置好的按钮放到数组中返回
//    return @[deleteRowAction];
}


// 左滑好友置顶：点击事件
- (void)addFriendToTopRowActionClickWithIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"左滑好友置顶：点击事件");
    
    
    // 模型
    CYMyFriendViewCellModel *tempMyFriendModel = self.dataArray[indexPath.row];
    
    // Url参数
    NSString *newUrlStr = [NSString stringWithFormat:@"%@?id=%@",cAddFriendToTopUrl,tempMyFriendModel.Id];
    
    // 网络请求：好友置顶
    [CYNetWorkManager postRequestWithUrl:newUrlStr params:nil progress:^(NSProgress *uploadProgress) {
        NSLog(@"好友置顶进度：%@",uploadProgress);
    } whenSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"好友置顶：请求成功！");
        
        // 2.3.1.1、获取code 值
        NSString *code = responseObject[@"code"];
        
        // 2.3.1.2、判断返回值
        if ([code isEqualToString:@"0"]) {
            NSLog(@"好友置顶：置顶成功！");
            
            // 更新数据
            [self loadData];
            
        }
        else{
            NSLog(@"好友置顶：置顶失败！");
            NSLog(@"msg:%@",responseObject[@"res"][@"msg"]);
            
            // 2.3.1.2.2、上传图片失败，弹窗
            [self showHubWithLabelText:responseObject[@"res"][@"msg"] andHidAfterDelay:3.0];
        }
        
    } whenFailure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"好友置顶：请求失败");
        
        [self showHubWithLabelText:@"好友置顶失败，请检查网络" andHidAfterDelay:3.0];
        
    } withToken:self.onlyUser.userToken];
    
}


// 左滑取消好友置顶：点击事件
- (void)deleteFriendToTopRowActionClickWithIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"取消好友置顶：点击事件");
    
    
    // 模型
    CYMyFriendViewCellModel *tempMyFriendModel = self.dataArray[indexPath.row];
    
    // Url参数
    NSString *newUrlStr = [NSString stringWithFormat:@"%@?id=%@",cDelFriendToTopUrl,tempMyFriendModel.Id];
    
    // 网络请求：取消好友置顶
    [CYNetWorkManager postRequestWithUrl:newUrlStr params:nil progress:^(NSProgress *uploadProgress) {
        NSLog(@"取消好友置顶进度：%@",uploadProgress);
    } whenSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"取消好友置顶：请求成功！");
        
        // 2.3.1.1、获取code 值
        NSString *code = responseObject[@"code"];
        
        // 2.3.1.2、判断返回值
        if ([code isEqualToString:@"0"]) {
            NSLog(@"取消好友置顶：取消置顶成功！");
            
            // 更新数据
            [self loadData];
            
        }
        else{
            NSLog(@"取消好友置顶：取消置顶失败！");
            NSLog(@"msg:%@",responseObject[@"res"][@"msg"]);
            
            // 2.3.1.2.2、上传图片失败，弹窗
            [self showHubWithLabelText:responseObject[@"res"][@"msg"] andHidAfterDelay:3.0];
        }
        
    } whenFailure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"取消好友置顶：请求失败");
        
        [self showHubWithLabelText:@"取消好友置顶失败，请检查网络" andHidAfterDelay:3.0];
        
    } withToken:self.onlyUser.userToken];
    
}

// 左滑删除好友：点击事件
- (void)deleteRowActionClick{
    NSLog(@"左滑删除好友：点击事件");
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"删除好友将不能回复，并删除聊天记录" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"删除好友", nil];
    
    sheet.tag = 256;
    
    [sheet showInView:self.view];
}

// 选择框：选择的是哪一个：代理事件
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (actionSheet.tag == 256) {
        
        switch (buttonIndex) {
            case 0:
                // 取消
                break;
                
            case 1:
                // 删除好友
                
                [self requestDeleteFriendWithIndexPath:self.deleteIndexPath];
                break;
                
            default:
                break;
        }
    }
    
}


// 网络请求：删除好友
- (void)requestDeleteFriendWithIndexPath:(NSIndexPath *)indexPath{
    
    
    // 模型
    CYMyFriendViewCellModel *tempMyFriendModel = self.dataArray[indexPath.row];
    
    // Url参数
    NSString *newUrlStr = [NSString stringWithFormat:@"%@?id=%@",cDeleteFriendUrl,tempMyFriendModel.Id];
    
    // 网络请求：删除好友
    [CYNetWorkManager postRequestWithUrl:newUrlStr params:nil progress:^(NSProgress *uploadProgress) {
        NSLog(@"删除好友进度：%@",uploadProgress);
    } whenSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"删除好友：请求成功！");
        
        // 2.3.1.1、获取code 值
        NSString *code = responseObject[@"code"];
        
        // 2.3.1.2、判断返回值
        if ([code isEqualToString:@"0"]) {
            NSLog(@"删除好友：删除成功！");
            
            // 更新数据
            [self loadData];
            
        }
        else{
            NSLog(@"删除好友：删除失败！");
            NSLog(@"msg:%@",responseObject[@"res"][@"msg"]);
            
            // 2.3.1.2.2、上传图片失败，弹窗
            [self showHubWithLabelText:responseObject[@"res"][@"msg"] andHidAfterDelay:3.0];
        }
        
    } whenFailure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"删除好友：请求失败");
        
        [self showHubWithLabelText:@"删除好友失败，请检查网络" andHidAfterDelay:3.0];
        
    } withToken:self.onlyUser.userToken];
    
}



// cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return (140.0 / 1334.0) * cScreen_Height;
}


// header的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return (5.0 / 1334.0) * cScreen_Height;
}


- (NSIndexPath *)deleteIndexPath{
    
    if (!_deleteIndexPath) {
        _deleteIndexPath = [[NSIndexPath alloc] init];
        
        
    }
    
    return _deleteIndexPath;
}


@end
