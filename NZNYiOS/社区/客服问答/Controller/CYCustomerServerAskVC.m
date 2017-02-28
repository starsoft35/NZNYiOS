//
//  CYCustomerServerAskVC.m
//  nzny
//
//  Created by 男左女右 on 2017/2/5.
//  Copyright © 2017年 nznychina. All rights reserved.
//

#import "CYCustomerServerAskVC.h"

// cell
#import "CYTitleAndDetailCell.h"

// cell 的 模型
#import "CYCustomerServerAskCellModel.h"

// 反馈：VC
#import "CYServiceAskFeedBackVC.h"



// 社区活动详情:VC
#import "CYActiveDetailsVC.h"


@interface CYCustomerServerAskVC ()

@end

@implementation CYCustomerServerAskVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"客服问答";
    
    // 右侧navigationBar：反馈
    [self setFeedBackRightNavigationBar];
    
    // 加载数据
    [self loadData];
    
    
    // 提前注册
    [self.baseTableView registerNib:[UINib nibWithNibName:@"CYTitleAndDetailCell" bundle:nil] forCellReuseIdentifier:@"CYTitleAndDetailCell"];
    
    
}

// 反馈：右侧navigationBar
- (void)setFeedBackRightNavigationBar{
    NSLog(@"设置反馈：右侧navigationBar");
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"反馈" style:2 target:self action:@selector(feedBackLeftBarBtnItemClick)];
}
// 反馈：右侧navigationBar：点击事件
- (void)feedBackLeftBarBtnItemClick{
    NSLog(@"反馈：右侧navigationBar：点击事件");
    
    CYServiceAskFeedBackVC *feedBackVC = [[CYServiceAskFeedBackVC alloc] init];
    
    feedBackVC.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:feedBackVC animated:YES];
    
}

// 加载数据
- (void)loadData{
    
    // 请求数据：客服问答
    NSDictionary *params = @{
                             @"pageNum":@(self.curPage),
                             @"pageSize":@(10)
                             };
    
    
    // 请求数据：客服问答
    [CYNetWorkManager getRequestWithUrl:cServiceActivityListUrl params:params progress:^(NSProgress *uploadProgress) {
        NSLog(@"获取客服问答进度：%@",uploadProgress);
        
    } whenSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"客服问答：请求成功！");
        
        // 1、
        NSString *code = responseObject[@"code"];
        
        // 1.2.1.1.2、和成功的code 匹配
        if ([code isEqualToString:@"0"]) {
            NSLog(@"客服问答：获取成功！");
            NSLog(@"客服问答：%@",responseObject);
            
            // 解析数据，模型存到数组
            [self.dataArray addObjectsFromArray:[CYCustomerServerAskCellModel arrayOfModelsFromDictionaries:responseObject[@"res"][@"data"][@"list"]]];
            
            
            [self.baseTableView reloadData];
            
            
        }
        else{
            NSLog(@"客服问答：获取失败:responseObject:%@",responseObject);
            NSLog(@"客服问答：获取失败:responseObject:res:msg:%@",responseObject[@"res"][@"msg"]);
            // 1.2.1.1.2.2、获取失败：弹窗提示：获取失败的返回信息
            [self showHubWithLabelText:responseObject[@"res"][@"msg"] andHidAfterDelay:3.0];
            
        }
        
        
    } whenFailure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"客服问答：请求失败！:error:%@",error);
        
        [self showHubWithLabelText:@"请检查网络，重新加载" andHidAfterDelay:3.0];
        
    } withToken:self.onlyUser.userToken];
    
    
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
    
    CYCustomerServerAskCellModel *customerServerAskCellModel = self.dataArray[indexPath.row];
    
    // 假数据
    titleDetailModel.title = customerServerAskCellModel.Title;
    titleDetailModel.detail = @"";
    
    
    cell.titleAndDetailModel = titleDetailModel;
    
//    cell.titleLab.font = [UIFont systemFontOfSize:15];
    
    return cell;
    
}


// 选择cell：单击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"点击cell:%ld,%ld",(long)indexPath.section,(long)indexPath.row);
    
    //当离开某行时，让某行的选中状态消失
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    
    CYCustomerServerAskCellModel *customerServerAskCellModel = self.dataArray[indexPath.row];
    
    
    CYActiveDetailsVC *activeDetailsVC = [[CYActiveDetailsVC alloc] init];
    
    activeDetailsVC.activeId = customerServerAskCellModel.ActivityContentId;
    NSLog(@"activeId:%@",activeDetailsVC.activeId);
    
    
    activeDetailsVC.hidesBottomBarWhenPushed = YES;
    
    
    //    [self.navigationController pushViewController:activeDetailsVC animated:YES];
    [[self navigationControllerWithView:self.view] pushViewController:activeDetailsVC animated:YES];
    
}

// cell 的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return (88.0 / 1334.0) * cScreen_Height;
    
}

// header 的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 5.0 / 1334 * cScreen_Height;
}


@end
