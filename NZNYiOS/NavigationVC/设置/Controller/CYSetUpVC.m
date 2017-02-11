//
//  CYSetUpVC.m
//  nzny
//
//  Created by 男左女右 on 2017/1/7.
//  Copyright © 2017年 nznychina. All rights reserved.
//

#import "CYSetUpVC.h"

// cell
#import "CYTitleAndDetailCell.h"

// cell的模型
#import "CYTitleAndDetailModel.h"


// 用户须知：VC
#import "CYSetUpUserNeedToKnowVC.h"

// 关于我们：VC
#import "CYSetUpAboutUsVC.h"




@interface CYSetUpVC ()

@end

@implementation CYSetUpVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.title = @"设置";
    
    // 加载数据
    [self loadData];
    
    
    // 提前注册
    [self.baseTableView registerNib:[UINib nibWithNibName:@"CYTitleAndDetailCell" bundle:nil] forCellReuseIdentifier:@"CYTitleAndDetailCell"];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    // 隐藏tabbar
    self.hidesBottomBarWhenPushed = YES;
}

// 加载数据
- (void)loadData{
    
    NSArray *tempArr = @[
                         @[
                             @{
                                 @"title":@"用户须知",
                                 @"detail":@"",
                                 },
                             @{
                                 @"title":@"关于我们",
                                 @"detail":@"",
                                 },
                             @{
                                 @"title":@"联系我们",
                                 @"detail":@"021-31116836",
                                 },
                             @{
                                 @"title":@"版本号",
                                 @"detail":@"1.1.0",
                                 },
                             ],
                         @[
                             @{
                                 @"title":@"",
                                 @"detail":@"退出账号",
                                 }
                             ]
                         
                         ];
    
//    [self.dataArray addObjectsFromArray:[CYTitleAndDetailModel arrayOfModelsFromDictionaries:tempArr]];
    
    self.dataArray = (NSMutableArray *)tempArr;
    
}

// tableView有多少组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.dataArray.count;
}

// 每组多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.dataArray[section] count];
}

// 创建tableView（即tableView要展示的内容）
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    // cell
    CYTitleAndDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CYTitleAndDetailCell" forIndexPath:indexPath];
    
    
    
    
    // 假数据
//    titleDetailModel.title = self.userInfoDataArr[indexPath.section][indexPath.row][@"cellTitle"];
//    titleDetailModel.detail = self.userInfoDataArr[indexPath.section][indexPath.row][@"cellDetailTitle"];
    
    
    // 模型
    CYTitleAndDetailModel *titleAndDetailModel = [[CYTitleAndDetailModel alloc] init];
    
    titleAndDetailModel.title = self.dataArray[indexPath.section][indexPath.row][@"title"];
    titleAndDetailModel.detail = self.dataArray[indexPath.section][indexPath.row][@"detail"];
    
    
    cell.titleAndDetailModel = titleAndDetailModel;
    
    if ([titleAndDetailModel.title isEqualToString:@"联系我们"]) {
        
        cell.nextImgView.hidden = YES;
        [cell.detailLab setTextColor:[UIColor colorWithRed:0.37 green:0.65 blue:0.99 alpha:1.00]];
    }
    if ([titleAndDetailModel.title isEqualToString:@"版本号"]) {
        
        cell.nextImgView.hidden = YES;
        [cell.detailLab setTextColor:[UIColor colorWithRed:0.50 green:0.50 blue:0.50 alpha:1.00]];
    }
    if ([titleAndDetailModel.detail isEqualToString:@"退出账号"]) {
        
        [cell.detailLab removeFromSuperview];
        
        
        
        cell.detailLab.textAlignment = NSTextAlignmentLeft;
        
        float width = cScreen_Width;
        float height = (30.0 / 1334.0) * cScreen_Height;
        float x = 0;
        float y = ((88.0 / 1334.0) * cScreen_Height - height) / 2;
        CGRect tempRect = CGRectMake(x, y, width, height);
        
        UILabel *quitLab = [[UILabel alloc] initWithFrame:tempRect];
        
        quitLab.text = @"退出账号";
        quitLab.textAlignment = NSTextAlignmentCenter;
        quitLab.font = [UIFont systemFontOfSize:15];
        
        quitLab.textColor = [UIColor redColor];
        
        [cell addSubview:quitLab];
        
        
        cell.nextImgView.hidden = YES;
    }
    
    
    return cell;
    
    
    
}


// 选择cell：单击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"点击cell:%ld,%ld",(long)indexPath.section,(long)indexPath.row);
    
    //当离开某行时，让某行的选中状态消失
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        
        // 用户须知
        CYSetUpUserNeedToKnowVC *userNeedToKnowVC = [[CYSetUpUserNeedToKnowVC alloc] init];
        
        userNeedToKnowVC.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:userNeedToKnowVC animated:YES];
    }
    else if (indexPath.section == 0 && indexPath.row == 1) {
        
        // 关于我们
        CYSetUpAboutUsVC *aboutUsVC = [[CYSetUpAboutUsVC alloc] init];
        
        aboutUsVC.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:aboutUsVC animated:YES];
        
    }
    else if (indexPath.section == 0 && indexPath.row == 2) {
        
        // 联系我们
        
    }
    else if (indexPath.section == 0 && indexPath.row == 3) {
        
        // 版本号
        
    }
    else if (indexPath.section == 1 && indexPath.row == 0) {
        
        // 退出账号
        
    }
    
}

// cell 的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return (88.0 / 1334.0) * cScreen_Height;
}

// header 的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        
        return 10;
    }
    else {
        
        return 20.0 / 1334 * cScreen_Height;
    }
}


@end
