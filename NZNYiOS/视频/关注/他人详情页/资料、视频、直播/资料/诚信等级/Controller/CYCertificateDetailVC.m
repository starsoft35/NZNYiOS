//
//  CYCertificateDetailVC.m
//  nzny
//
//  Created by 男左女右 on 2016/11/30.
//  Copyright © 2016年 nznychina. All rights reserved.
//

#import "CYCertificateDetailVC.h"


// 背景认证模型
#import "CYBackCertifiViewModel.h"

// cell
#import "CYTitleAndDetailCell.h"



@interface CYCertificateDetailVC ()

@end

@implementation CYCertificateDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.title = @"认证详情";
    
    // 加载数据
    [self loadData];
    
    
    // 注册
    [self.baseTableView registerNib:[UINib nibWithNibName:@"CYTitleAndDetailCell" bundle:nil] forCellReuseIdentifier:@"CYTitleAndDetailCell"];
    
}

// 加载数据
- (void)loadData{
    
    // 参数
    NSDictionary *params = @{
                             @"userId":self.oppUserId
                             };
    
    
    
    // 请求数据
    [CYNetWorkManager getRequestWithUrl:cCertificateListUrl params:params progress:^(NSProgress *uploadProgress) {
        NSLog(@"获取用户背景认证信息进度：%@",uploadProgress);
        
    } whenSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"获取登录用户的证件列表已经上传证件数量：请求成功！");
        
        // 1、
        NSString *code = responseObject[@"code"];
        
        // 1.2.1.1.2、和成功的code 匹配
        if ([code isEqualToString:@"0"]) {
            NSLog(@"获取登录用户的证件列表已经上传证件数量：获取成功！");
            
            
            // 清空：每次刷新都需要
            [self.dataArray removeAllObjects];
            
            // 解析数据，模型存到数组
            [self.dataArray addObjectsFromArray:[CYBackCertifiViewModel arrayOfModelsFromDictionaries:responseObject[@"res"][@"data"][@"list"]]];
            
            // 网络请求：获取用户信息：用户查看手机号是否认证
            [self requestOppuserInfo];
            
            // 请求数据结束，取消加载
            [self hidenLoadingView];
            
        }
        else{
            NSLog(@"获取登录用户的证件列表已经上传证件数量：获取失败！");
            
            // 1.2.1.1.2.2、获取失败：弹窗提示：获取失败的返回信息
            [self showHubWithLabelText:responseObject[@"res"][@"msg"] andHidAfterDelay:3.0];
            
        }
        
        
    } whenFailure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"获取登录用户的证件列表已经上传证件数量：请求失败！");
        
        
    } withToken:self.onlyUser.userToken];
    
    
}

// 网络请求：获取用户信息：用户查看手机号是否认证
- (void)requestOppuserInfo{
    
    // 参数
    NSDictionary *params = @{
                             @"userId":self.oppUserId
                             };
    
    // 显示加载
    //    [self showLoadingView];
    
    // 请求数据：获取用户个人信息
    [CYNetWorkManager getRequestWithUrl:cGetUserInfoUrl params:params progress:^(NSProgress *uploadProgress) {
        NSLog(@"获取用户个人信息进度：%@",uploadProgress);
        
    } whenSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"获取用户个人信息：请求成功！");
        
        // 1、
        NSString *code = responseObject[@"code"];
        
        // 1.2.1.1.2、和成功的code 匹配
        if ([code isEqualToString:@"0"]) {
            NSLog(@"获取用户个人信息：获取成功！");
            NSLog(@"获取用户个人信息：%@",responseObject);
            
            
            
            // 清空：每次刷新都需要
            [self.newCertificateArr removeAllObjects];
            
            
            
            NSString *tempDetail = [[NSString alloc] init];
            
            if (responseObject[@"res"][@"data"][@"userinfo"][@"Account"] != nil) {
                
                tempDetail = @"已认证";
            }
            else {
                
                tempDetail = @"未认证";
            }
            
            
            NSDictionary *tempDic = @{
                                      @"title":@"手机号认证",
                                      @"detail":tempDetail
                                      
                                      };
            
            [self.newCertificateArr addObject:tempDic];
            
            
            // 加载新数据：添加别的认证详情
            [self loadNewData];
            
            
            
        }
        else{
            NSLog(@"获取用户个人信息：获取失败:responseObject:%@",responseObject);
            NSLog(@"获取用户个人信息：获取失败:responseObject:res:msg:%@",responseObject[@"res"][@"msg"]);
            // 1.2.1.1.2.2、获取失败：弹窗提示：获取失败的返回信息
            //            [self showHubWithLabelText:responseObject[@"res"][@"msg"] andHidAfterDelay:3.0];
            
        }
        
        
    } whenFailure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"获取用户个人信息：请求失败！:error:%@",error);
        
        [self showHubWithLabelText:@"请检查网络，重新加载" andHidAfterDelay:3.0];
        
    } withToken:self.onlyUser.userToken];
    
}
// 加载数据
- (void)loadNewData{
    
    
    
    NSString *tempTitle = [[NSString alloc] init];
    NSString *tempDetail = [[NSString alloc] init];
    
    for (CYBackCertifiViewModel *tempBackCerModel in self.dataArray) {
        
        if ([tempBackCerModel.Name isEqualToString:@"certificate1"]) {
            
            tempTitle = @"学历证认证";
            
        }
        else if ([tempBackCerModel.Name isEqualToString:@"certificate2"]) {
            
            tempTitle = @"身份证认证";
        }
        else if ([tempBackCerModel.Name isEqualToString:@"certificate3"]) {
            
            tempTitle = @"工资条认证";
        }
        else if ([tempBackCerModel.Name isEqualToString:@"certificate4"]) {
            
            tempTitle = @"房产证认证";
        }
        else if ([tempBackCerModel.Name isEqualToString:@"certificate5"]) {
            
            tempTitle = @"行驶证认证";
        }
        else if ([tempBackCerModel.Name isEqualToString:@"certificate6"]) {
            
            tempTitle = @"其他认证";
        }
        else if ([tempBackCerModel.Name isEqualToString:@"certificate7"]) {
            
            tempTitle = @"其他认证";
        }
        else if ([tempBackCerModel.Name isEqualToString:@"certificate8"]) {
            
            tempTitle = @"其他认证";
        }
        else if ([tempBackCerModel.Name isEqualToString:@"certificate9"]) {
            
            tempTitle = @"其他认证";
        }
        
        
        
        if (tempBackCerModel.AuditStatus == 3) {
            
            // 审核通过
            // AuditStatus:1:未上传、2：审核中、3：审核通过、4：审核不通过
            tempDetail = @"已认证";
            
            
        }
        else {
            
            tempDetail = @"未认证";
        }
        
        if ([tempTitle isEqualToString:@"其他认证"] && [tempDetail isEqualToString:@"未认证"]) {
            
            // 如果是其他未认证，则不显示
        }
        else {
            
            NSDictionary *tempDic = @{
                                      @"title":tempTitle,
                                      @"detail":tempDetail
                                      
                                      };
            
            [self.newCertificateArr addObject:tempDic];
            
        }
    }
    
    [self.baseTableView reloadData];
    
}


// tableView代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return self.newCertificateArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    CYTitleAndDetailCell *titleAndDetailCell = [tableView dequeueReusableCellWithIdentifier:@"CYTitleAndDetailCell" forIndexPath:indexPath];
    
    CYTitleAndDetailModel *titleAndDetailCellModel = [[CYTitleAndDetailModel alloc] init];
    
    titleAndDetailCellModel.title = self.newCertificateArr[indexPath.row][@"title"];
    titleAndDetailCellModel.detail = self.newCertificateArr[indexPath.row][@"detail"];
    
    titleAndDetailCell.titleAndDetailModel = titleAndDetailCellModel;
    
    titleAndDetailCell.nextImgView.image = [UIImage imageNamed:@""];
    
    if ([titleAndDetailCellModel.detail isEqualToString:@"已认证"]) {
        
        
        [titleAndDetailCell.detailLab setTextColor:[UIColor colorWithRed:0.91 green:0.51 blue:0.23 alpha:1.00]];
        
    }
    else {
        
        [titleAndDetailCell.detailLab setTextColor:[UIColor colorWithRed:0.50 green:0.50 blue:0.50 alpha:1.00]];
    }
    
    
    // 居右
    titleAndDetailCell.detailLab.textAlignment = NSTextAlignmentRight;
    
    
    return titleAndDetailCell;
        
}

// cell：点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"点击了第 %ld 行",indexPath.row);
    
    
    //当离开某行时，让某行的选中状态消失
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}

// cell 的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return (88.0 / 1334.0) * cScreen_Height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.1;
}


//
- (NSMutableArray *)newCertificateArr{
    
    if (_newCertificateArr == nil) {
        
        _newCertificateArr = [[NSMutableArray alloc] init];
    }
    
    return _newCertificateArr;
}



@end
