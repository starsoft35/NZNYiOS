//
//  CYAskFeedBackVC.m
//  nzny
//
//  Created by 男左女右 on 2017/3/1.
//  Copyright © 2017年 nznychina. All rights reserved.
//

#import "CYAskFeedBackVC.h"


// cell：
#import "CYAskFeedBackCell.h"
// 模型：
#import "CYAskFeedBackCellModel.h"

// 系统消息：列表：模型(可以用为总的模型)
#import "CYSystemNewsCellModel.h"

// header时间：cell
#import "CYHeaderTimeCell.h"

// 活动反馈：cell
#import "CYActiveFeedBackCell.h"
// 活动反馈：模型
#import "CYActiveFeedBackCellModel.h"



// 问答反馈：cell
#import "CYAskFeedBackCell.h"
// 问答反馈：模型
#import "CYAskFeedBackCellModel.h"


@interface CYAskFeedBackVC ()

@end

@implementation CYAskFeedBackVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"活动提示";
    
    // 添加下拉刷新
    self.baseTableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self refresh];
        
    }];
    
    // 添加上拉加载
    self.baseTableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        [self loadMore];
        
    }];
    
    
    self.baseTableView.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1.00];
    
    
    // 加载数据
    [self loadData];
    
    // 提前注册
    [self.baseTableView registerNib:[UINib nibWithNibName:@"CYAskFeedBackCell" bundle:nil] forCellReuseIdentifier:@"CYAskFeedBackCell"];
    
}

// 创建视图
- (void)creatView{
    
    // 创建tableView
    self.baseTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, cScreen_Width, cScreen_Height - 64) style:UITableViewStylePlain];
    
    // 代理
    self.baseTableView.delegate = self;
    self.baseTableView.dataSource = self;
    
    //    self.view = _baseTableView;
    
    // 添加到控制器
    [self.view addSubview:self.baseTableView];
    
}

// 加载数据
- (void)loadData{
    
    
    // 网络请求：问答反馈列表
    // url参数
    NSDictionary *params = @{
                             @"userId":self.onlyUser.userID,
                             @"pageNum":@(self.curPage),
                             @"pageSize":@(10)
                             };
    
    // 加载
    [self showLoadingView];
    
    // 网络请求：
    [CYNetWorkManager getRequestWithUrl:cAskSysMessageListUrl params:params progress:^(NSProgress *uploadProgress) {
        NSLog(@"问答反馈列表：网络请求：进度：%@",uploadProgress);
        
    } whenSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"问答反馈列表：网络请求：请求成功");
        
        // 停止刷新
        [self.baseTableView.header endRefreshing];
        [self.baseTableView.footer endRefreshing];
        
        // 1、
        NSString *code = responseObject[@"code"];
        
        // 1.2.1.1.2、和成功的code 匹配
        if ([code isEqualToString:@"0"]) {
            NSLog(@"问答反馈列表：获取成功！：%@",responseObject);
            
            // 清空：每次刷新都需要：但是上拉加载、下拉刷新的不需要；
            if (self.curPage == 1) {
                
                [self.dataArray removeAllObjects];
            }
            
            
            // 先把没有数据label删除
            [self.noDataLab removeFromSuperview];
            
            // 解析数据，模型存到数组
            [self.dataArray addObjectsFromArray:[CYAskFeedBackCellModel arrayOfModelsFromDictionaries:responseObject[@"res"][@"data"][@"list"]]];
            
            
            if (self.dataArray.count == 0) {
                
                // 如果没有活动反馈，添加提示
                [self addLabelToShowNoVideo];
            }
            
            [self hidenLoadingView];
            
            // 刷新数据
            [self.baseTableView reloadData];
            
            
        }
        else{
            NSLog(@"问答反馈：获取失败:responseObject:%@",responseObject);
            NSLog(@"问答反馈：获取失败:responseObject:res:msg:%@",responseObject[@"res"][@"msg"]);
            
            
            // 1.2.1.1.2.2、获取失败：弹窗提示：获取失败的返回信息
            [self showHubWithLabelText:responseObject[@"res"][@"msg"] andHidAfterDelay:3.0];
            
        }
        
    } whenFailure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"问答反馈列表：网络请求：请求失败");
        
        
        // 停止刷新
        [self.baseTableView.header endRefreshing];
        [self.baseTableView.footer endRefreshing];
        
        
        [self showHubWithLabelText:@"请检查网络，重新加载" andHidAfterDelay:3.0];
        
    } withToken:self.onlyUser.userToken];
    
    
    
    
    
}
// 如果没有视频，添加提示
- (void)addLabelToShowNoVideo{
    NSLog(@"如果没有视频，添加提示");
    
    self.noDataLab = [[UILabel alloc] initWithFrame:CGRectMake((12.0 / 750.0) * cScreen_Width, (80.0 / 1334.0) * cScreen_Height, (726.0 / 750.0) * cScreen_Width, (30.0 / 1334.0) * cScreen_Height)];
    
    
    self.noDataLab.text = @"暂时没有消息";
    
    self.noDataLab.textAlignment = NSTextAlignmentCenter;
    self.noDataLab.font = [UIFont systemFontOfSize:15];
    
    self.noDataLab.textColor = [UIColor colorWithRed:0.50 green:0.50 blue:0.50 alpha:1.00];
    
    [self.baseTableView addSubview:self.noDataLab];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    //
    //    if (section == 2) {
    //
    //        return 10;
    //    }
    return 1;
}

// 代理
// 设置Header 的title
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//
//    if (section == 0) {
//        return @"男神";
//    }
//
//    return @"女神";
//}

// header
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    
    
    
    CYHeaderTimeCell *timeCell = [[[NSBundle mainBundle] loadNibNamed:@"CYHeaderTimeCell" owner:nil options:nil] lastObject];
    
    CYAskFeedBackCellModel *askFeedBackCellModel = self.dataArray[section];
    
    timeCell.timeLab.text = askFeedBackCellModel.CreateDate;
    
    //    timeCell.backgroundColor = [UIColor redColor];
    timeCell.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1.00];
    
    return timeCell;
}

// height：header
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 40;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.1;
}

// cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //    UITableViewCell *cell = [[UITableViewCell alloc] init];
    
    CYAskFeedBackCellModel *askFeedBackCellModel = self.dataArray[indexPath.section];
    
    //    if (activeFeedBackCellModel.Type == 1) {
    
    
    
    // 问答fank
    
    
    
    // cell
    CYAskFeedBackCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CYAskFeedBackCell" forIndexPath:indexPath];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    cell.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1.00];
    
    
    // 问
    cell.askLab.text = askFeedBackCellModel.Ask;
//    cell.askLab.textColor = [UIColor colorWithRed:0.37 green:0.65 blue:0.99 alpha:1.00];
    
    // 答
    cell.answerLab.text = askFeedBackCellModel.Answer;
    
    
    
    
    
    
    
    //        // 赋值
    //        cell.askLab.font = [UIFont systemFontOfSize:15];
    //        cell.askLab.adjustsFontSizeToFitWidth = NO;
    //        cell.answerLab.font = [UIFont systemFontOfSize:15];
    //        cell.answerLab.adjustsFontSizeToFitWidth = NO;
    //
    //
    //
    //        // 自动计算label的高度、宽度
    //        CGSize tempAskLabelSize = [self labelAutoCalculateRectWith:cell.askLab.text FontSize:15 MaxSize:CGSizeMake(333.0 / 375.0 * cScreen_Width, 300.0 / 667.0 * cScreen_Height)];
    //        CGRect tempAskDetailLabRect = CGRectMake(cell.askLab.frame.origin.x, cell.askLab.frame.origin.y, tempAskLabelSize.width, tempAskLabelSize.height);
    cell.askLab.numberOfLines = 0;
    //        cell.askLab.frame = tempAskDetailLabRect;
    //
    //        // 自动计算label的高度、宽度
    //        CGSize tempAnswerLabelSize = [self labelAutoCalculateRectWith:cell.answerLab.text FontSize:15 MaxSize:CGSizeMake(333.0 / 375.0 * cScreen_Width, 300.0 / 667.0 * cScreen_Height)];
    //        CGRect tempAnswerDetailLabRect = CGRectMake(cell.answerLab.frame.origin.x, cell.answerLab.frame.origin.y, tempAnswerLabelSize.width, tempAnswerLabelSize.height);
    cell.answerLab.numberOfLines = 0;
    //        cell.answerLab.frame = tempAnswerDetailLabRect;
    //
    //        NSLog(@"tempAskDetailLabRect.size.height:%f",tempAskDetailLabRect.size.height);
    //        NSLog(@"tempAnswerDetailLabRect.size.height:%f",tempAnswerDetailLabRect.size.height);
    
    
    return cell;
    
    
    
    
    
    //    }
    //
    //    else {
    //
    //
    //        // 活动反馈
    //        // 提前注册
    //        [self.baseTableView registerNib:[UINib nibWithNibName:@"CYActiveFeedBackCell" bundle:nil] forCellReuseIdentifier:@"CYActiveFeedBackCell"];
    //
    //
    //        // cell
    //        CYActiveFeedBackCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CYActiveFeedBackCell" forIndexPath:indexPath];
    //        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //        // cell：模型
    //        //    CYOfflineActivityCellModel *offlineActivityCellModel = self.dataArray[indexPath.row];
    //
    //
    //        // 假数据
    //        //    cell.offlineActiveCellModel = offlineActivityCellModel;
    //
    //
    //        cell.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1.00];
    //
    //
    //        cell.detailInfoLab.text = systemNewsCellModel.Content;
    //
    //
    //        // 自动计算label的高度、宽度
    //        //        CGSize tempLabelSize = [self labelAutoCalculateRectWith:cell.detailInfoLab.text FontSize:15 MaxSize:CGSizeMake(cScreen_Width - 42, 500.0 / 667.0 * cScreen_Height)];
    //        //        CGRect tempDetailLabRect = CGRectMake(cell.detailInfoLab.frame.origin.x, cell.detailInfoLab.frame.origin.y, tempLabelSize.width, tempLabelSize.height);
    //        cell.detailInfoLab.numberOfLines = 0;
    //        //        cell.detailInfoLab.font = [UIFont systemFontOfSize:15];
    //        //        cell.detailInfoLab.adjustsFontSizeToFitWidth = NO;
    //        //        cell.detailInfoLab.frame = tempDetailLabRect;
    //
    //
    //
    //
    //
    //        return cell;
    //
    //
    //    }
    
}


// height：cell
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"indexPath.section:%ld",(long)indexPath.section);
    NSLog(@"indexPath.row:%ld",(long)indexPath.row);
    
    CYAskFeedBackCellModel *askFeedBackCellModel = self.dataArray[indexPath.section];
    
    //    if (systemNewsCellModel.Type == 1) {
    
    // 自动计算label的高度、宽度
    CGSize tempAskLabelSize = [self labelAutoCalculateRectWith:askFeedBackCellModel.Ask FontSize:15 MaxSize:CGSizeMake(cScreen_Width - 42, 500.0 / 667.0 * cScreen_Height)];
    
    CGSize tempAnswerLabelSize = [self labelAutoCalculateRectWith:askFeedBackCellModel.Answer FontSize:15 MaxSize:CGSizeMake(cScreen_Width - 42, 500.0 / 667.0 * cScreen_Height)];
    
    //        NSLog(@"self.dataArray.Ask:%@",self.dataArray[indexPath.section][@"Ask"]);
    //        NSLog(@"self.dataArray.Answer:%@",self.dataArray[indexPath.section][@"Answer"]);
    
    NSLog(@"tempAskLabelSize.height:%f",tempAskLabelSize.height);
    NSLog(@"tempAnswerLabelSize.height:%f",tempAnswerLabelSize.height);
    
    float tempHeight = (61) + (tempAskLabelSize.height) + (tempAnswerLabelSize.height);
    
    NSLog(@"tempHeight:%f",tempHeight);
    
    return tempHeight;
    
    //    }
    //    else {
    //
    //        // 自动计算label的高度、宽度
    //        CGSize tempLabelSize = [self labelAutoCalculateRectWith:systemNewsCellModel.Content FontSize:15 MaxSize:CGSizeMake(cScreen_Width - 42, 500.0 / 667.0 * cScreen_Height)];
    //
    //        //        return ((146.0 / 1334.0) * cScreen_Height) + (tempLabelSize.height);
    //        return (73.0) + (tempLabelSize.height);
    //
    //    }
    
}

// cell：点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"点击了第%ld组第%ld行",(long)indexPath.section,(long)indexPath.row);
    
    //当离开某行时，让某行的选中状态消失
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}




@end
