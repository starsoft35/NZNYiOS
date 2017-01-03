//
//  CYMyFansVC.m
//  nzny
//
//  Created by 男左女右 on 2016/11/29.
//  Copyright © 2016年 nznychina. All rights reserved.
//

#import "CYMyFansVC.h"

// 粉丝cell
#import "CYSearchViewCell.h"


// 他人详情页
#import "CYOthersInfoVC.h"



@interface CYMyFansVC ()

@end

@implementation CYMyFansVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"粉丝";
    
    // 加载数据
    [self loadData];
    
    // 提前注册
    
    [self.baseTableView registerNib:[UINib nibWithNibName:@"CYSearchViewCell" bundle:nil] forCellReuseIdentifier:@"CYSearchViewCell"];
}

// 加载数据
- (void)loadData{
    
    // 参数
    NSDictionary *params = @{
                             @"userId":self.onlyUser.userID
                             };
    
    [self showLoadingView];
    
    // 网络请求：我的粉丝
    [CYNetWorkManager getRequestWithUrl:cFansList params:params progress:^(NSProgress *uploadProgress) {
        NSLog(@"我的粉丝请求：进度：%@",uploadProgress);
        
    } whenSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"我的粉丝请求：请求成功！");
        // 1、
        NSString *code = responseObject[@"code"];
        
        // 1.2.1.1.2、和成功的code 匹配
        if ([code isEqualToString:@"0"]) {
            NSLog(@"我的粉丝：结果成功！");
            NSLog(@"我的粉丝：responseObject：%@",responseObject);
            
            // 清空：每次刷新都需要
            [self.dataArray removeAllObjects];
            
            // 解析数据，模型存到数组
            [self.dataArray addObjectsFromArray:[CYSearchViewCellModel arrayOfModelsFromDictionaries:responseObject[@"res"][@"data"][@"list"]]];
            
            // 刷新数据
            [self.baseTableView reloadData];
            
            // 请求数据结束，取消加载
            [self hidenLoadingView];
            
        }
        else{
            NSLog(@"我的粉丝：结果失败:responseObject:%@",responseObject);
            NSLog(@"我的粉丝：结果失败:responseObject:res:msg:%@",responseObject[@"res"][@"msg"]);
            // 1.2.1.1.2.2、我的粉丝失败：弹窗提示：获取失败的返回信息
            [self showHubWithLabelText:responseObject[@"res"][@"msg"] andHidAfterDelay:3.0];
            
        }
        
    } whenFailure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"我的粉丝请求：请求失败！");
        
        [self showHubWithLabelText:@"请检查网络" andHidAfterDelay:3.0];
        
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

// cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CYSearchViewCell *searchViewCell = [tableView dequeueReusableCellWithIdentifier:@"CYSearchViewCell" forIndexPath:indexPath];
    
    // 加关注：点击事件
    [searchViewCell.followBtn addTarget:self action:@selector(followBtnClickWithBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    searchViewCell.searchModel = self.dataArray[indexPath.row];
    
    
    
    return searchViewCell;
    
}

// 加关注：点击事件
- (void)followBtnClickWithBtn:(UIButton *)followBtn{
    NSLog(@"加关注：点击事件");
    
    // button的父类的父类
    UIView *tempView = [[followBtn superview] superview];
    
    // tempView的父类的父类为当前的tableView
    NSIndexPath *indexPath = [(UITableView *)[[tempView superview] superview] indexPathForCell:tempView];
    
    CYSearchViewCellModel *searchViewCellModel = self.dataArray[indexPath.row];
    
    // 如果已关注，则取消关注
    if (searchViewCellModel.Follow == YES) {
        // 网络请求：取消关注
        [self delFollowWithSearchViewCellModel:searchViewCellModel];
    }
    // 如果没关注，则加关注
    else {
        
        // 网络请求：加关注
        [self addFollowWithSearchViewCellModel:searchViewCellModel];
    }
    
    
    
    
}

// 网络请求：取消关注
- (void)delFollowWithSearchViewCellModel:(CYSearchViewCellModel *)searchViewCellModel{
    
    // 网络请求：取消关注
    // 参数
    NSString *newUrl = [NSString stringWithFormat:@"%@?userId=%@&oppUserId=%@",cDelFollowUrl,self.onlyUser.userID,searchViewCellModel.Id];
    
    [self showLoadingView];
    
    // 取消关注
    [CYNetWorkManager postRequestWithUrl:newUrl params:nil progress:^(NSProgress *uploadProgress) {
        NSLog(@"取消关注：progress:%@",uploadProgress);
        
        
    } whenSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"取消关注：请求成功！");
        
        
        // 2.3.1.1、获取code 值
        NSString *code = responseObject[@"code"];
        
        // 2.3.1.2、判断返回值
        if ([code isEqualToString:@"0"]) {
            NSLog(@"取消关注：取消成功！");
            
            // 隐藏菊花
//            [self hidenLoadingView];
            
            // 刷新数据
//            [self.baseTableView reloadData];
            [self loadData];
            
        }
        else{
            NSLog(@"取消关注：取消失败！");
            NSLog(@"msg:%@",responseObject[@"res"][@"msg"]);
            
            
            // 2.3.1.2.2、取消关注失败，弹窗
            [self showHubWithLabelText:responseObject[@"res"][@"msg"] andHidAfterDelay:3.0];
        }
        
    } whenFailure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"取消关注：请求失败！");
        NSLog(@"error:%@",error);
        
        // 取消关注：请求：失败，加载菊花消失
        [self hidenLoadingView];
        
        // 2.3.1.2.2、取消取消失败，弹窗
        [self showHubWithLabelText:@"网络错误，请重新上传！" andHidAfterDelay:3.0];
        
        
    } withToken:self.onlyUser.userToken];
}

// 网络请求：加关注
- (void)addFollowWithSearchViewCellModel:(CYSearchViewCellModel *)searchViewCellModel{
    
    // 网络请求：加关注
    // 参数
    NSString *newUrl = [NSString stringWithFormat:@"%@?userId=%@&oppUserId=%@",cAddFollowUrl,self.onlyUser.userID,searchViewCellModel.Id];
    
    [self showLoadingView];
    
    // 加关注
    [CYNetWorkManager postRequestWithUrl:newUrl params:nil progress:^(NSProgress *uploadProgress) {
        NSLog(@"加关注：progress:%@",uploadProgress);
        
        
    } whenSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"加关注：请求成功！");
        
        
        // 2.3.1.1、获取code 值
        NSString *code = responseObject[@"code"];
        
        // 2.3.1.2、判断返回值
        if ([code isEqualToString:@"0"]) {
            NSLog(@"加关注：关注成功！");
            
            // 隐藏菊花
//            [self hidenLoadingView];
            
            // 刷新数据
//            [self.baseTableView reloadData];
            [self loadData];
            
        }
        else{
            NSLog(@"加关注：关注失败！");
            NSLog(@"msg:%@",responseObject[@"res"][@"msg"]);
            
            
            // 2.3.1.2.2、加关注失败，弹窗
            [self showHubWithLabelText:responseObject[@"res"][@"msg"] andHidAfterDelay:3.0];
        }
        
    } whenFailure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"加关注：请求失败！");
        NSLog(@"error:%@",error);
        
        // 加关注：请求：失败，加载菊花消失
        [self hidenLoadingView];
        
        // 2.3.1.2.2、加关注请求失败，弹窗
        [self showHubWithLabelText:@"网络错误，请重新上传！" andHidAfterDelay:3.0];
        
        
    } withToken:self.onlyUser.userToken];
}

// cell：点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"点击了第 %ld 行 cell",indexPath.row);
    
    //当离开某行时，让某行的选中状态消失
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CYSearchViewCellModel *currentCellModel = self.dataArray[indexPath.row];
    
    
    // 他人详情页
    CYOthersInfoVC *othersInfoVC = [[CYOthersInfoVC alloc] init];
    
    //    othersInfoVC.view.frame = CGRectMake(0, 0, 400, 400);
    
    othersInfoVC.oppUserId = currentCellModel.Id;
    
    othersInfoVC.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:othersInfoVC animated:YES];
    
}

// cell 的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return (190.0 / 1108) * self.view.frame.size.height;
}

// 为了设置第一行距顶部navigation 的距离
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.1;
}

@end
