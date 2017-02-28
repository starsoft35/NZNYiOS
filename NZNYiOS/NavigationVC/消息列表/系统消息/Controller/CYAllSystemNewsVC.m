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

// 活动提示：VC
#import "CYActiveFeedBackVC.h"
// 我的问答：VC
// 其他消息：VC



@interface CYAllSystemNewsVC ()

@end

@implementation CYAllSystemNewsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"系统消息";
    
    // 加载数据
    [self loadData];
    
    // 提前注册
    [self.baseTableView registerNib:[UINib nibWithNibName:@"CYTitleAndDetailCell" bundle:nil] forCellReuseIdentifier:@"CYTitleAndDetailCell"];
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
    
    
    
    NSArray *tempArr = @[
                         
                         
                         @{
                             @"title":@"活动提示",
                             },
                         
                         @{
                             @"title":@"我的问答",
                             },
                         @{
                             @"title":@"其他消息",
                             }
                         
                         ];
    
    self.dataArray = (NSMutableArray *)tempArr;
}

// tableView有多少组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

// 每组多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

// 创建tableView（即tableView要展示的内容）
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    // cell
    CYTitleAndDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CYTitleAndDetailCell" forIndexPath:indexPath];
    
    CYTitleAndDetailModel *titleDetailModel = [[CYTitleAndDetailModel alloc] init];
    
    
    // 假数据
    titleDetailModel.title = self.dataArray[indexPath.row][@"title"];
    titleDetailModel.detail = @"";
    
    
    cell.titleAndDetailModel = titleDetailModel;
    
    //    cell.titleLab.font = [UIFont systemFontOfSize:15];
    cell.titleLab.textColor = [UIColor colorWithRed:0.37 green:0.65 blue:0.99 alpha:1.00];
    
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
        
        [self.navigationController pushViewController:activeFeedBackVC animated:YES];
    }
    
}

// cell 的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return (88.0 / 1334.0) * cScreen_Height;
    
}

// header 的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 30.0 / 1334 * cScreen_Height;
}


@end
