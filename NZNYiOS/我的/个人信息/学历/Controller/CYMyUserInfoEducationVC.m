//
//  CYMyUserInfoEducationVC.m
//  nzny
//
//  Created by 张春咏 on 2017/1/2.
//  Copyright © 2017年 nznychina. All rights reserved.
//

#import "CYMyUserInfoEducationVC.h"

// 选中cell
#import "CYMyUserInfoGenderCell.h"


@interface CYMyUserInfoEducationVC ()

@end

@implementation CYMyUserInfoEducationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"学历";
    
    // 提前注册
    [self.baseTableView registerNib:[UINib nibWithNibName:@"CYMyUserInfoGenderCell" bundle:nil] forCellReuseIdentifier:@"CYMyUserInfoGenderCell"];
    
    // 加载数据
    [self loadData];
}


// 加载数据
- (void)loadData{
    
    
    NSArray *arr = @[
                     @{
                         @"title":@"硕士以上"
                         },
                     @{
                         @"title":@"研究生"
                         },
                     @{
                         @"title":@"本科"
                         },
                     @{
                         @"title":@"大专"
                         },
                     @{
                         @"title":@"中专／高中"
                         },
                     @{
                         @"title":@"研初及以下"
                         },
                     ];
    
    self.dataArray = (NSMutableArray *)arr;
    
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
    
    // 性别
    cell.genderLab.text = self.dataArray[indexPath.row][@"title"];
    
    // 选中状态
    if ([self.dataArray[indexPath.row][@"title"] isEqualToString:self.onlyUser.Education]) {
        
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
    
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        
        // 网络请求：修改学历
        [self requestChangeGenderWithGender:self.dataArray[indexPath.row][@"title"]];
        
    }
    else if (indexPath.section == 0 && indexPath.row == 1) {
        
        // 网络请求：修改学历
        [self requestChangeGenderWithGender:self.dataArray[indexPath.row][@"title"]];
    }
    else if (indexPath.section == 0 && indexPath.row == 2) {
        
        // 网络请求：修改学历
        [self requestChangeGenderWithGender:self.dataArray[indexPath.row][@"title"]];
    }
    else if (indexPath.section == 0 && indexPath.row == 3) {
        
        // 网络请求：修改学历
        [self requestChangeGenderWithGender:self.dataArray[indexPath.row][@"title"]];
    }
    else if (indexPath.section == 0 && indexPath.row == 4) {
        
        // 网络请求：修改学历
        [self requestChangeGenderWithGender:self.dataArray[indexPath.row][@"title"]];
    }
    else if (indexPath.section == 0 && indexPath.row == 5) {
        
        // 网络请求：修改学历
        [self requestChangeGenderWithGender:self.dataArray[indexPath.row][@"title"]];
    }
    
}

// 网络请求：修改学历
- (void)requestChangeGenderWithGender:(NSString *)gender{
    NSLog(@"网络请求：修改学历");
    
    // 请求数据：修改学历
    NSString *newUrl = [NSString stringWithFormat:@"%@?userId=%@&education=%@",cModifyEducationUrl,self.onlyUser.userID,gender];
    
    // 编码：url里面有中文
    NSString *tempUrl = [newUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"newUrl:%@",tempUrl);
    // 显示加载
    [self showLoadingView];
    
    // 请求数据：修改学历
    [CYNetWorkManager postRequestWithUrl:tempUrl params:nil progress:^(NSProgress *uploadProgress) {
        NSLog(@"修改学历进度：%@",uploadProgress);
        
    } whenSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"修改学历：请求成功！");
        
        [self hidenLoadingView];
        
        // 1、
        NSString *code = responseObject[@"code"];
        
        // 1.2.1.1.2、和成功的code 匹配
        if ([code isEqualToString:@"0"]) {
            NSLog(@"修改学历：获取成功！");
            NSLog(@"修改学历：%@",responseObject);
            
            
            // 修改性别
            
            // 返回上一个界面
            [self.navigationController popViewControllerAnimated:YES];
            
        }
        else{
            NSLog(@"修改学历：获取失败:responseObject:%@",responseObject);
            NSLog(@"修改学历：获取失败:responseObject:res:msg:%@",responseObject[@"res"][@"msg"]);
            // 1.2.1.1.2.2、获取失败：弹窗提示：获取失败的返回信息
            //            [self showHubWithLabelText:responseObject[@"res"][@"msg"] andHidAfterDelay:3.0];
            
        }
        
        
    } whenFailure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"修改学历：请求失败！:error:%@",error);
        
        [self showHubWithLabelText:@"请检查网络，重新加载" andHidAfterDelay:3.0];
        
    } withToken:self.onlyUser.userToken];
    
}

// cell 的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return (88.0 / 1334.0) * cScreen_Height;
}

// header 的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 5;
}


@end
