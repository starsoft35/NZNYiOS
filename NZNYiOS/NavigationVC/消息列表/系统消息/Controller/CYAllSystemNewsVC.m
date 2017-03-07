//
//  CYAllSystemNewsVC.m
//  nzny
//
//  Created by 男左女右 on 2017/2/28.
//  Copyright © 2017年 nznychina. All rights reserved.
//

#import "CYAllSystemNewsVC.h"

// cell
#import "CYTitleAndDetailCell.h"

// cell 的 模型
//#import "CYCustomerServerAskCellModel.h"

// 系统消息：未读信息条数：模型
#import "CYSystemNewsCellModel.h"



// 活动提示：VC
#import "CYActiveFeedBackVC.h"
// 我的问答：VC
#import "CYAskFeedBackVC.h"
// 其他消息：VC
#import "CYSystemOtherNewsVC.h"


@interface CYAllSystemNewsVC ()


// 未读信息条数：数组
@property (nonatomic, strong) NSArray *allUnReadNewsCountTempArr;

@end

@implementation CYAllSystemNewsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"系统消息";
    
    
    // 提前注册
    [self.baseTableView registerNib:[UINib nibWithNibName:@"CYTitleAndDetailCell" bundle:nil] forCellReuseIdentifier:@"CYTitleAndDetailCell"];
}

// 界面将要显示：刷新数据
- (void)viewWillAppear:(BOOL)animated{
    
    
    // 加载数据
    [self loadData];
    
}

// 加载数据
- (void)loadData{
    
//    // 请求数据：客服问答
//    NSDictionary *params = @{
//                             @"pageNum":@(self.curPage),
//                             @"pageSize":@(10)
//                             };
//    
//    
//    // 请求数据：客服问答
//    [CYNetWorkManager getRequestWithUrl:cServiceActivityListUrl params:params progress:^(NSProgress *uploadProgress) {
//        NSLog(@"获取客服问答进度：%@",uploadProgress);
//        
//    } whenSuccess:^(NSURLSessionDataTask *task, id responseObject) {
//        NSLog(@"客服问答：请求成功！");
//        
//        // 1、
//        NSString *code = responseObject[@"code"];
//        
//        // 1.2.1.1.2、和成功的code 匹配
//        if ([code isEqualToString:@"0"]) {
//            NSLog(@"客服问答：获取成功！");
//            NSLog(@"客服问答：%@",responseObject);
//            
//            // 解析数据，模型存到数组
//            [self.dataArray addObjectsFromArray:[CYCustomerServerAskCellModel arrayOfModelsFromDictionaries:responseObject[@"res"][@"data"][@"list"]]];
//            
//            
//            [self.baseTableView reloadData];
//            
//            
//        }
//        else{
//            NSLog(@"客服问答：获取失败:responseObject:%@",responseObject);
//            NSLog(@"客服问答：获取失败:responseObject:res:msg:%@",responseObject[@"res"][@"msg"]);
//            // 1.2.1.1.2.2、获取失败：弹窗提示：获取失败的返回信息
//            [self showHubWithLabelText:responseObject[@"res"][@"msg"] andHidAfterDelay:3.0];
//            
//        }
//        
//        
//    } whenFailure:^(NSURLSessionDataTask *task, NSError *error) {
//        NSLog(@"客服问答：请求失败！:error:%@",error);
//        
//        [self showHubWithLabelText:@"请检查网络，重新加载" andHidAfterDelay:3.0];
//        
//    } withToken:self.onlyUser.userToken];
    
    
    NSArray *tempArr = [[NSArray alloc] init];
    
    // 清空：每次刷新都需要
//    [self.dataArray removeAllObjects];
    self.allUnReadNewsCountTempArr = @[
                                       
                                       
                                       @{
                                           @"title":@"活动提示",
                                           @"detail":@""
                                           },
                                       
                                       @{
                                           @"title":@"我的问答",
                                           @"detail":@""
                                           },
                                       
                                       @{
                                           @"title":@"其他消息",
                                           @"detail":@""
                                           }
                                       
                                       ];
    
//    self.dataArray = (NSMutableArray *)self.allUnReadNewsCountTempArr;
    
    [self.dataArray addObjectsFromArray:self.allUnReadNewsCountTempArr];
    
    
    // url参数
    NSDictionary *params = @{
                             @"userId":self.onlyUser.userID
                             };
    
    
    // 网络请求：系统消息：未读消息
    [CYNetWorkManager getRequestWithUrl:cSysUnreadMessageUrl params:params progress:^(NSProgress *uploadProgress) {
        NSLog(@"系统消息列表：系统消息：未读消息：进度：%@",uploadProgress);
        
    } whenSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"系统消息列表：系统消息：未读消息：请求成功");
        
        // 1、
        NSString *code = responseObject[@"code"];
        
        // 1.2.1.1.2、和成功的code 匹配
        if ([code isEqualToString:@"0"]) {
            NSLog(@"系统消息列表：系统消息：未读消息：获取成功！");
            NSLog(@"系统消息列表：系统消息：未读消息：%@",responseObject);
            
            // 清空：每次刷新都需要
            [self.dataArray removeAllObjects];
            
            
            // 解析数据，模型存到数组
            //            [self.systemNewsListArr addObjectsFromArray:[CYSystemNewsCellModel arrayOfModelsFromDictionaries:responseObject[@"res"][@"data"][@"model"]]];
            [self.dataArray addObject:[[CYSystemNewsCellModel alloc] initWithDictionary:responseObject[@"res"][@"data"][@"model"] error:nil]];
            
            CYSystemNewsCellModel *systemNewsCellModel = self.dataArray[0];
            
            
            //
            NSString *tempUnreadActivityCountStr;
            NSString *tempUnreadFeedbackCountStr;
            NSString *tempUnreadOtherCountStr;
            
            
            // 活动消息未读
            if (systemNewsCellModel.UnreadActivityCount == 0) {
                tempUnreadActivityCountStr = @"";
            }
            else {
                
                tempUnreadActivityCountStr = [NSString stringWithFormat:@"%ld条未读",(long)systemNewsCellModel.UnreadActivityCount];
            }
            
            
            // 问答反馈未读
            if (systemNewsCellModel.UnreadFeedbackCount == 0) {
                tempUnreadFeedbackCountStr = @"";
            }
            else {
                
                tempUnreadFeedbackCountStr = [NSString stringWithFormat:@"%ld条未读",(long)systemNewsCellModel.UnreadFeedbackCount];
            }
            
            
            // 其他消息未读
            if (systemNewsCellModel.UnreadOtherCount == 0) {
                tempUnreadOtherCountStr = @"";
            }
            else {
                
                tempUnreadOtherCountStr = [NSString stringWithFormat:@"%ld条未读",(long)systemNewsCellModel.UnreadOtherCount];
            }
            
            
            self.allUnReadNewsCountTempArr = @[
                        
                        
                        @{
                            @"title":@"活动提示",
                            @"detail":tempUnreadActivityCountStr
                            },
                        
                        @{
                            @"title":@"我的问答",
                            @"detail":tempUnreadFeedbackCountStr
                            },
                        
                        @{
                            @"title":@"其他消息",
                            @"detail":tempUnreadOtherCountStr
                            }
                        
                        ];
            
//            self.dataArray = (NSMutableArray *)self.allUnReadNewsCountTempArr;
            
            // 清空：每次刷新都需要
            [self.dataArray removeAllObjects];
            [self.dataArray addObjectsFromArray:self.allUnReadNewsCountTempArr];
            
            [self.baseTableView reloadData];
        }
        else{
            NSLog(@"系统消息列表：系统消息：未读消息：获取失败:responseObject:%@",responseObject);
            NSLog(@"系统消息列表：系统消息：未读消息：获取失败:responseObject:res:msg:%@",responseObject[@"res"][@"msg"]);
            // 1.2.1.1.2.2、获取失败：弹窗提示：获取失败的返回信息
        }
        
    } whenFailure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"系统消息列表：系统消息：未读消息：网络请求：请求失败");
        
        
    } withToken:self.onlyUser.userToken];
    
    
    
    
}

// tableView有多少组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.dataArray.count;
}

// 每组多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

// 创建tableView（即tableView要展示的内容）
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    // cell
    CYTitleAndDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CYTitleAndDetailCell" forIndexPath:indexPath];
    
    CYTitleAndDetailModel *titleDetailModel = [[CYTitleAndDetailModel alloc] init];
    
    
    CYSystemNewsCellModel *systemNewsCellModel = [[CYSystemNewsCellModel alloc] init];
    if (self.dataArray.count != 0) {
        
        
        systemNewsCellModel = self.dataArray[0];
    }
    
    // 假数据
    titleDetailModel.title = self.dataArray[indexPath.section][@"title"];
    titleDetailModel.detail = self.dataArray[indexPath.section][@"detail"];
    
    cell.titleAndDetailModel = titleDetailModel;
    
    
    
    cell.detailLab.font = [UIFont systemFontOfSize:12];
    cell.detailLab.textColor = [UIColor colorWithRed:0.91 green:0.51 blue:0.23 alpha:1.00];
    
    
    return cell;
    
}


// 选择cell：单击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"点击cell:%ld,%ld",(long)indexPath.section,(long)indexPath.row);
    
    //当离开某行时，让某行的选中状态消失
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        
        // 第一行：活动提示
        CYActiveFeedBackVC *activeFeedBackVC = [[CYActiveFeedBackVC alloc] init];
        
        
        // 网络请求：系统消息栏目点击
        [self requestSystemNewsCellClickWithColumnType:1];
        
        
        
        [self.navigationController pushViewController:activeFeedBackVC animated:YES];
    }
    else if (indexPath.section == 1 && indexPath.row == 0) {
        
        // 第二行：问答反馈
        CYAskFeedBackVC *askFeedBackVC = [[CYAskFeedBackVC alloc] init];
        
        
        // 网络请求：系统消息栏目点击
        [self requestSystemNewsCellClickWithColumnType:2];
        
        
        
        
        [self.navigationController pushViewController:askFeedBackVC animated:YES];
    }
    else if (indexPath.section == 2 && indexPath.row == 0) {
        
        // 第三行：其他消息
        CYSystemOtherNewsVC *otherNewsVC = [[CYSystemOtherNewsVC alloc] init];
        
        
        // 网络请求：系统消息栏目点击
        [self requestSystemNewsCellClickWithColumnType:0];
        
        
        
        [self.navigationController pushViewController:otherNewsVC animated:YES];
        
        
    }
}


// 网络请求：系统消息栏目点击
- (void)requestSystemNewsCellClickWithColumnType:(NSInteger)columnType{
    NSLog(@"网络请求：系统消息栏目点击");
    
    // 网络请求：系统消息栏目点击
    // url参数
    NSString *newUrl = [NSString stringWithFormat:@"%@?userId=%@&columnType=%ld",cSysMessageColumnClickUrl,self.onlyUser.userID,(long)columnType];
    
    
    // 加载
//    [self showLoadingView];
    
    // 网络请求：
    [CYNetWorkManager postRequestWithUrl:newUrl params:nil progress:^(NSProgress *uploadProgress) {
        NSLog(@"系统消息栏目点击：网络请求：进度：%@",uploadProgress);
        
    } whenSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"系统消息栏目点击：网络请求：请求成功");
        
        
        // 1、
        NSString *code = responseObject[@"code"];
        
        // 1.2.1.1.2、和成功的code 匹配
        if ([code isEqualToString:@"0"]) {
            NSLog(@"系统消息栏目点击：获取成功！：%@",responseObject);
            
            
        }
        else{
            NSLog(@"系统消息栏目点击：获取失败:responseObject:%@",responseObject);
            NSLog(@"系统消息栏目点击：获取失败:responseObject:res:msg:%@",responseObject[@"res"][@"msg"]);
            
            
            // 1.2.1.1.2.2、获取失败：弹窗提示：获取失败的返回信息
//            [self showHubWithLabelText:responseObject[@"res"][@"msg"] andHidAfterDelay:3.0];
            
        }
        
    } whenFailure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"系统消息栏目点击：网络请求：请求失败");
        
        
//        [self showHubWithLabelText:@"请检查网络，重新加载" andHidAfterDelay:3.0];
        
    } withToken:self.onlyUser.userToken];
}


// cell 的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return (88.0 / 1334.0) * cScreen_Height;
    
}

// header 的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 30.0 / 1334 * cScreen_Height;
}
// footer 的高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.1 / 1334 * cScreen_Height;
}

// 懒加载
- (NSArray *)allUnReadNewsCountTempArr{
    
    if (_allUnReadNewsCountTempArr == nil) {
        
        _allUnReadNewsCountTempArr = [[NSArray alloc] init];
        
    }
    
    return _allUnReadNewsCountTempArr;
}

@end
