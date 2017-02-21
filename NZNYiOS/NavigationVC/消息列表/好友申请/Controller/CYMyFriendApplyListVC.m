//
//  CYMyFriendApplyListVC.m
//  nzny
//
//  Created by 男左女右 on 2017/1/14.
//  Copyright © 2017年 nznychina. All rights reserved.
//

#import "CYMyFriendApplyListVC.h"


// 模型
#import "CYMyFriendApplyListCellModel.h"

// cell
#import "CYMyFriendApplyListCell.h"

@interface CYMyFriendApplyListVC ()

// 当前要删除的好友的indexPath
@property (nonatomic,copy) NSIndexPath *deleteIndexPath;

@end

@implementation CYMyFriendApplyListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.title = @"好友申请";
    
    // 提前注册
    [self.baseTableView registerNib:[UINib nibWithNibName:@"CYMyFriendApplyListCell" bundle:nil] forCellReuseIdentifier:@"CYMyFriendApplyListCell"];
    
}

// 界面将要显示：刷新数据
- (void)viewWillAppear:(BOOL)animated{
    
    
    // 加载数据
    [self loadData];
    
    // 隐藏tabbar
    self.hidesBottomBarWhenPushed = YES;
}


// 加载数据：我的好友申请列表
- (void)loadData{
    
    // 网络请求：我的好友申请列表
    // url参数
    NSDictionary *params = @{
                             @"userId":self.onlyUser.userID
                             };
    
    // 加载
    [self showLoadingView];
    
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
            [self.dataArray removeAllObjects];
            
            // 解析数据，模型存到数组
            [self.dataArray addObjectsFromArray:[CYMyFriendApplyListCellModel arrayOfModelsFromDictionaries:responseObject[@"res"][@"data"][@"list"]]];
            
            if (self.dataArray.count == 0) {
                
                // 如果没有好友申请，添加提示
                [self addLabelToShowNoFriend];
            }
            
            // 刷新数据、界面
            [self.baseTableView reloadData];
            
            // 请求数据结束，取消加载
            [self hidenLoadingView];
            
        }
        else{
            NSLog(@"获取我的好友申请列表：获取失败:responseObject:%@",responseObject);
            NSLog(@"获取我的好友申请列表：获取失败:responseObject:res:msg:%@",responseObject[@"res"][@"msg"]);
            // 1.2.1.1.2.2、获取失败：弹窗提示：获取失败的返回信息
            [self showHubWithLabelText:responseObject[@"res"][@"msg"] andHidAfterDelay:3.0];
            
        }
        
    } whenFailure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"我的好友申请列表：网络请求：请求失败");
        
        [self showHubWithLabelText:@"请检查网络，重新加载" andHidAfterDelay:3.0];
        
    } withToken:self.onlyUser.userToken];
    
}

// 如果没有好友申请，添加提示
- (void)addLabelToShowNoFriend{
    NSLog(@"如果没有好友申请，添加提示");
    
    UILabel *tipLab = [[UILabel alloc] initWithFrame:CGRectMake((12.0 / 750.0) * cScreen_Width, (80.0 / 1334.0) * cScreen_Height, (726.0 / 750.0) * cScreen_Width, (30.0 / 1334.0) * cScreen_Height)];
    
    
    tipLab.text = @"暂时没有好友申请";
    
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
    CYMyFriendApplyListCell *friendApplyListCell = [tableView dequeueReusableCellWithIdentifier:@"CYMyFriendApplyListCell" forIndexPath:indexPath];
    
    
    // 同意：button
    [friendApplyListCell.agreeBtn addTarget:self action:@selector(agreeBtnClickWithBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    // 赋值
    friendApplyListCell.friendApplyListCellModel = self.dataArray[indexPath.row];
    
    return friendApplyListCell;
    
}

// 同意：button：点击事件
- (void)agreeBtnClickWithBtn:(UIButton *)agreeBtn{
    NSLog(@"同意：button：点击事件");
    
    UITableViewCell *tempView = (UITableViewCell *)[[agreeBtn superview] superview];
    
    // tableView类 调用方法，获取cell的indexPath
    NSIndexPath *indexPath = [self.baseTableView indexPathForCell:tempView];
    
    // 网络请求：同意添加好友
    // 模型
    CYMyFriendApplyListCellModel *tempFriendApplyListCellModel = self.dataArray[indexPath.row];
    
    // Url参数
    NSString *newUrlStr = [NSString stringWithFormat:@"%@?id=%@",cAddApplyFriendUrl,tempFriendApplyListCellModel.Id];
    
    // 网络请求：同意添加好友
    [CYNetWorkManager postRequestWithUrl:newUrlStr params:nil progress:^(NSProgress *uploadProgress) {
        NSLog(@"同意添加好友进度：%@",uploadProgress);
    } whenSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"同意添加好友：请求成功！");
        
        // 2.3.1.1、获取code 值
        NSString *code = responseObject[@"code"];
        
        // 2.3.1.2、判断返回值
        if ([code isEqualToString:@"0"]) {
            NSLog(@"同意添加好友：同意成功！");
            
            [self showHubWithLabelText:@"添加好友成功" andHidAfterDelay:3.0];
            
            
            // 更新数据
            [self loadData];
            
            
        }
        else{
            NSLog(@"同意添加好友：同意失败！");
            NSLog(@"msg:%@",responseObject[@"res"][@"msg"]);
            
            // 2.3.1.2.2、上传图片失败，弹窗
            [self showHubWithLabelText:responseObject[@"res"][@"msg"] andHidAfterDelay:3.0];
        }
        
    } whenFailure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"同意添加好友：请求失败");
        
        [self showHubWithLabelText:@"同意添加好友，请检查网络" andHidAfterDelay:3.0];
        
    } withToken:self.onlyUser.userToken];
}


// cell：点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"点击了第几行：%ld",(long)indexPath.row);
    
    //当离开某行时，让某行的选中状态消失
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // 模型
//    CYMyFriendApplyListCellModel *tempFriendApplyListCellModel = self.dataArray[indexPath.row];
    
    
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
    
    
    // 添加一个删除按钮
    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        NSLog(@"第：%@ 行，点击了删除",indexPath);
        
        
        // 网络请求：删除好友
        // 1、更新数据
        
        _deleteIndexPath = indexPath;
        // 左滑删除好友：点击事件：提示框
        [self deleteRowActionClick];
        
        
        //        NSMutableArray *arrModel = self.dataArray[indexPath.row];
        //        [arrModel removeObjectAtIndex:indexPath.row];
        
        NSLog(@"self.dataArray:%@",self.dataArray);
        
        // 2、更新UI
        //        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
    }];
    
    // 添加一个置顶按钮
    UITableViewRowAction *topRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"置顶" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        NSLog(@"点击了置顶");
        
#warning 网络请求：置顶
        
        // 置顶
        // 1、更新数据
        [self.dataArray insertObject:self.dataArray[indexPath.row] atIndex:0];
        [self.dataArray removeObjectAtIndex:(indexPath.row + 1)];
        
        NSLog(@"self.dataArray:%@",self.dataArray);
        
        // 2、更新UI
        NSIndexPath *firstIndexPath = [NSIndexPath indexPathForRow:0 inSection:indexPath.section];
        [tableView moveRowAtIndexPath:indexPath toIndexPath:firstIndexPath];
    }];
    
    topRowAction.backgroundColor = [UIColor colorWithRed:0.91 green:0.51 blue:0.23 alpha:1.00];
    
    
    // 将设置好的按钮放到数组中返回
    //    return @[deleteRowAction,topRowAction];
    return @[deleteRowAction];
}

// 左滑删除好友：点击事件
- (void)deleteRowActionClick{
    NSLog(@"左滑删除好友申请：点击事件");
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"删除后将不能回复" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"删除", nil];
    
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
                // 删除好友申请：网络请求：拒绝好友申请
                
                [self requestDeleteFriendWithIndexPath:self.deleteIndexPath];
                break;
                
            default:
                break;
        }
    }
    
}


// 网络请求：删除好友申请：拒绝好友申请
- (void)requestDeleteFriendWithIndexPath:(NSIndexPath *)indexPath{
    
    
    // 模型
    CYMyFriendApplyListCellModel *tempFriendApplyListCellModel = self.dataArray[indexPath.row];
    
    // Url参数
    NSString *newUrlStr = [NSString stringWithFormat:@"%@?id=%@",cDelApplyFriendUrl,tempFriendApplyListCellModel.Id];
    
    // 网络请求：拒绝好友申请
    [CYNetWorkManager postRequestWithUrl:newUrlStr params:nil progress:^(NSProgress *uploadProgress) {
        NSLog(@"拒绝好友申请进度：%@",uploadProgress);
    } whenSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"拒绝好友申请：请求成功！");
        
        // 2.3.1.1、获取code 值
        NSString *code = responseObject[@"code"];
        
        // 2.3.1.2、判断返回值
        if ([code isEqualToString:@"0"]) {
            NSLog(@"拒绝好友申请：拒绝成功！");
            
            // 更新数据
            [self loadData];
            
        }
        else{
            NSLog(@"拒绝好友申请：拒绝失败！");
            NSLog(@"msg:%@",responseObject[@"res"][@"msg"]);
            
            // 2.3.1.2.2、上传图片失败，弹窗
            [self showHubWithLabelText:responseObject[@"res"][@"msg"] andHidAfterDelay:3.0];
        }
        
    } whenFailure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"拒绝好友申请：请求失败");
        
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
