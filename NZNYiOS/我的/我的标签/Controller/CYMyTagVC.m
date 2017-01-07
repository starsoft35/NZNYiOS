//
//  CYMyTagVC.m
//  nzny
//
//  Created by 男左女右 on 2017/1/7.
//  Copyright © 2017年 nznychina. All rights reserved.
//

#import "CYMyTagVC.h"


// cell
#import "CYTitleAndDetailCell.h"



// 标签cell模型
#import "CYMyTagCellModel.h"

#import "CYTitleAndImageCellCheckVC.h"




@interface CYMyTagVC ()

@end

@implementation CYMyTagVC


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.title = @"我的标签";
    
    // 提前注册
    [self.baseTableView registerNib:[UINib nibWithNibName:@"CYTitleAndDetailCell" bundle:nil] forCellReuseIdentifier:@"CYTitleAndDetailCell"];
    
    
    // 加载数据
//    [self loadData];
    
}

//
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    // 加载数据
    [self loadData];
}


// 加载数据：我的所有标签
- (void)loadData{
    
    NSDictionary *params = @{
                             @"userId":self.onlyUser.userID,
                             };
    
    
    // 网络请求：我的所有标签
    [CYNetWorkManager getRequestWithUrl:cMyAllTagsListUrl params:params progress:^(NSProgress *uploadProgress) {
        NSLog(@"获取我的所有标签进度：%@",uploadProgress);
        
        
    } whenSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"我的所有标签：请求成功！");
        
        
        // 1、
        NSString *code = responseObject[@"code"];
        
        // 1.2.1.1.2、和成功的code 匹配
        if ([code isEqualToString:@"0"]) {
            NSLog(@"我的所有标签：获取成功！");
            NSLog(@"我的所有标签：%@",responseObject);
            
            
            [self.dataArray removeAllObjects];
            
            // 解析数据，模型存到数组
            [self.dataArray addObjectsFromArray:[CYMyTagCellModel arrayOfModelsFromDictionaries:responseObject[@"res"][@"data"][@"list"]]];
            
            
            [self.baseTableView reloadData];
            
        }
        else{
            NSLog(@"我的所有标签：获取失败:responseObject:%@",responseObject);
            NSLog(@"我的所有标签：获取失败:responseObject:res:msg:%@",responseObject[@"res"][@"msg"]);
            // 1.2.1.1.2.2、获取失败：弹窗提示：获取失败的返回信息
            [self showHubWithLabelText:responseObject[@"res"][@"msg"] andHidAfterDelay:3.0];
            
        }
        
        
    } whenFailure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"我的所有标签：请求失败！");
        NSLog(@"失败原因：error：%@",error);
        
        
        [self showHubWithLabelText:@"请检查网络，重新加载" andHidAfterDelay:3.0];
    } withToken:self.onlyUser.userToken];
    
    
}




- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"第 %ld 行~~~~~~~~~~~~~~~~~",(long)indexPath.row);
    
    
    // cell
    CYTitleAndDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CYTitleAndDetailCell" forIndexPath:indexPath];
    
    // cell：模型
    CYMyTagCellModel *myTagCellModel = self.dataArray[indexPath.row];
    
    CYTitleAndDetailModel *titleAndDetailModel = [[CYTitleAndDetailModel alloc] init];
    titleAndDetailModel.title = myTagCellModel.TagTypeName;
    
    if ([myTagCellModel.TagName isEqualToString:@""]) {
        
        titleAndDetailModel.detail = @"未选择";
        
        [cell.detailLab setTextColor:[UIColor colorWithRed:0.80 green:0.80 blue:0.80 alpha:1.00]];
    }
    else {
        
        titleAndDetailModel.detail = myTagCellModel.TagName;
        
        [cell.detailLab setTextColor:[UIColor colorWithRed:0.50 green:0.50 blue:0.50 alpha:1.00]];
    }
    
    
    // 假数据
    cell.titleAndDetailModel = titleAndDetailModel;
    
    
    return cell;
}

// 选择cell：单击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"点击cell:%ld,%ld",(long)indexPath.section,(long)indexPath.row);
    
    //当离开某行时，让某行的选中状态消失
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    // 模型
    CYMyTagCellModel *tempModel = self.dataArray[indexPath.row];
    
    
    CYTitleAndImageCellCheckVC *tempVC = [[CYTitleAndImageCellCheckVC alloc] init];
    
    tempVC.TagName = tempModel.TagTypeName;
    tempVC.Name = tempModel.TagName;
    
    tempVC.title = tempModel.TagTypeName;
    
    [self.navigationController pushViewController:tempVC animated:YES];
    
//    if (indexPath.section == 0 && indexPath.row == 0) {
//        
//        // 第一行：头像
//        CYPortraitVC *portraitVC = [[CYPortraitVC alloc] init];
//        
//        [self.navigationController pushViewController:portraitVC animated:YES];
//    }
//    else if (indexPath.section == 0 && indexPath.row == 1) {
//        
//        // 第二行：姓名
//        CYMyUserInfoNameVC *userInfoNameVC = [[CYMyUserInfoNameVC alloc] init];
//        
//        [self.navigationController pushViewController:userInfoNameVC animated:YES];
//    }
//    else if (indexPath.section == 0 && indexPath.row == 3) {
//        
//        // 第四行：性别
//        CYMyUserInfoGenderVC *userInfoGenderVC = [[CYMyUserInfoGenderVC alloc] init];
//        
//        [self.navigationController pushViewController:userInfoGenderVC animated:YES];
//    }
//    else if (indexPath.section == 0 && indexPath.row == 4) {
//        
//        // 第五行：年龄
//        CYMyUserInfoAgeVC *userInfoAgeVC = [[CYMyUserInfoAgeVC alloc] init];
//        
//        [self.navigationController pushViewController:userInfoAgeVC animated:YES];
//    }
    
}


// cell 的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return (88.0 / 1206.0) * self.view.frame.size.height;
}

// header 的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 5;
}




@end
