//
//  CYTitleAndImageCellCheckVC.m
//  nzny
//
//  Created by 男左女右 on 2017/1/7.
//  Copyright © 2017年 nznychina. All rights reserved.
//

#import "CYTitleAndImageCellCheckVC.h"

// cell
#import "CYMyUserInfoGenderCell.h"

// 模型
#import "CYTitleAndImageCellCheckCellModel.h"


@interface CYTitleAndImageCellCheckVC ()

@end

@implementation CYTitleAndImageCellCheckVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 加载数据：所对应的标签列表
    [self loadDataWithTagName:self.TagName];
    
    
    // 提前注册
    [self.baseTableView registerNib:[UINib nibWithNibName:@"CYMyUserInfoGenderCell" bundle:nil] forCellReuseIdentifier:@"CYMyUserInfoGenderCell"];
    
}

// 加载数据
- (void)loadDataWithTagName:(NSString *)tagName{
    
    NSString *urlStr = [[NSString alloc] init];
    
    if ([tagName isEqualToString:@"星座"]) {
        
        urlStr = cXingZuoTagListUrl;
    }
    else if ([tagName isEqualToString:@"房车"]) {
        
        urlStr = cFangCheTagListUrl;
    }
    else if ([tagName isEqualToString:@"身高"]) {
        
        urlStr = cShenGaoTagListUrl;
    }
    else if ([tagName isEqualToString:@"职业"]) {
        
        urlStr = cZhiYeTagListUrl;
    }
    else if ([tagName isEqualToString:@"爱好"]) {
        
        urlStr = cAiHaoTagListUrl;
    }
    
    
    // 网络请求：所对应的标签列表
    [CYNetWorkManager getRequestWithUrl:urlStr params:nil progress:^(NSProgress *uploadProgress) {
        NSLog(@"获取所对应的标签列表进度：%@",uploadProgress);
        
        
    } whenSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"所对应的标签列表：请求成功！");
        
        
        // 1、
        NSString *code = responseObject[@"code"];
        
        // 1.2.1.1.2、和成功的code 匹配
        if ([code isEqualToString:@"0"]) {
            NSLog(@"所对应的标签列表：获取成功！");
            NSLog(@"所对应的标签列表：%@",responseObject);
            
            [self.dataArray removeAllObjects];
            
            // 解析数据，模型存到数组
            [self.dataArray addObjectsFromArray:[CYTitleAndImageCellCheckCellModel arrayOfModelsFromDictionaries:responseObject[@"res"][@"data"][@"list"]]];
            
            
            [self.baseTableView reloadData];
            
        }
        else{
            NSLog(@"所对应的标签列表：获取失败:responseObject:%@",responseObject);
            NSLog(@"所对应的标签列表：获取失败:responseObject:res:msg:%@",responseObject[@"res"][@"msg"]);
            // 1.2.1.1.2.2、获取失败：弹窗提示：获取失败的返回信息
            [self showHubWithLabelText:responseObject[@"res"][@"msg"] andHidAfterDelay:3.0];
            
        }
        
        
    } whenFailure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"所对应的标签列表：请求失败！");
        NSLog(@"失败原因：error：%@",error);
        
        
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
    
    
    
    CYMyUserInfoGenderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CYMyUserInfoGenderCell" forIndexPath:indexPath];
    
    
    // 模型
    CYTitleAndImageCellCheckCellModel *tempModel = self.dataArray[indexPath.row];
    
    
    
    // 性别
    cell.genderLab.text = tempModel.Name;
    
    // 选中状态
    if ([tempModel.Name isEqualToString:self.Name]) {
        
        cell.ifCheckedImgView.image = [UIImage imageNamed:@"视频选中"];
        
    }
    else {
        
        cell.ifCheckedImgView.image = [UIImage imageNamed:@"视频未选中"];
    }
    
    return cell;
    
}


// 选择cell：单击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"点击cell:%ld,%ld",(long)indexPath.section,(long)indexPath.row);
    
    //当离开某行时，让某行的选中状态消失
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    // 模型
    CYTitleAndImageCellCheckCellModel *tempModel = self.dataArray[indexPath.row];
    
    
    NSDictionary *params = @{
                             @"UserId":self.onlyUser.userID,
                             @"TagId":tempModel.Id
                             };
    
    
    // 网络请求：添加、修改标签
    [self requestReSetTagWithRequestUrl:cTagAddUrl andParams:params];
    
}

// 网络请求：添加、修改标签
- (void)requestReSetTagWithRequestUrl:(NSString *)requestUrl andParams:(NSDictionary *)params{
    
    
    // 显示加载
    [self showLoadingView];
    
    // 请求数据：添加、修改标签
    [CYNetWorkManager postRequestWithUrl:requestUrl params:params progress:^(NSProgress *uploadProgress) {
        NSLog(@"添加、修改标签进度：%@",uploadProgress);
        
    } whenSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"添加、修改标签：请求成功！");
        
        [self hidenLoadingView];
        
        // 1、
        NSString *code = responseObject[@"code"];
        
        // 1.2.1.1.2、和成功的code 匹配
        if ([code isEqualToString:@"0"]) {
            NSLog(@"添加、修改标签：获取成功！");
            NSLog(@"添加、修改标签：%@",responseObject);
            
            
            // 添加、修改标签
            
            // 返回上一个界面
            [self.navigationController popViewControllerAnimated:YES];
            
        }
        else{
            NSLog(@"添加、修改标签：获取失败:responseObject:%@",responseObject);
            NSLog(@"添加、修改标签：获取失败:responseObject:res:msg:%@",responseObject[@"res"][@"msg"]);
            
            // 1.2.1.1.2.2、获取失败：弹窗提示：获取失败的返回信息
            [self showHubWithLabelText:responseObject[@"res"][@"msg"] andHidAfterDelay:3.0];
            
        }
        
        
    } whenFailure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"添加、修改标签：请求失败！:error:%@",error);
        
        [self showHubWithLabelText:@"请检查网络，重新加载" andHidAfterDelay:3.0];
        
    } withToken:self.onlyUser.userToken];
}


// cell 的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return (88.0 / 1246.0) * self.view.frame.size.height;
}

// header 的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 5;
}


@end
