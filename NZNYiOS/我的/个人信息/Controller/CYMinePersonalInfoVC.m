//
//  CYMinePersonalInfoVC.m
//  nzny
//
//  Created by 男左女右 on 2016/10/19.
//  Copyright © 2016年 nznychina. All rights reserved.
//

#import "CYMinePersonalInfoVC.h"



// 模型
#import "CYMinePersonalInfoVCModel.h"



#import "CYInfoHeaderCell.h"
#import "CYTitleAndDetailCell.h"


// 头像：VC
#import "CYPortraitVC.h"
// 姓名：VC
#import "CYMyUserInfoNameVC.h"
// FId
// 性别：VC
#import "CYMyUserInfoGenderVC.h"
// 年龄：VC
// 学历：VC
#import "CYMyUserInfoEducationVC.h"
// 婚姻状况：VC
#import "CYMyUserInfoMarriageVC.h"
// 所在地区：VC
// 爱情宣言：VC
#import "CYMyUserInfoDeclarationVC.h"



@interface CYMinePersonalInfoVC ()

@end

@implementation CYMinePersonalInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.navigationItem.title = @"个人信息";
    
    
    
    
    // 提前注册
//    [_tableView registerNib:[UINib nibWithNibName:@"CYInfoHeaderCell" bundle:nil] forCellReuseIdentifier:@"CYInfoHeaderCell"];
    
    
    
}

// 界面将要显示：刷新数据
- (void)viewWillAppear:(BOOL)animated{
    
    
    // 加载数据
    [self loadData];
    
}

// 加载数据
- (void)loadData{
    
    // 请求数据
    // 参数
    NSDictionary *params = @{
                             @"userId":self.onlyUser.userID
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
            
            // 保存用户个人信息到本地
            [self saveUserInfoToLocalWithResPonseObject:responseObject];
            
            // 清空：每次刷新都需要
            if (self.dataArray != nil) {
                
                [self.dataArray removeAllObjects];
            }
            
            // 解析数据，模型存到数组
            NSDictionary *tempDic = responseObject[@"res"][@"data"][@"userinfo"];
            
            CYMinePersonalInfoVCModel *tempModel = [[CYMinePersonalInfoVCModel alloc] initWithDictionary:tempDic error:nil];
            
            [self.dataArray addObject:tempModel];
            
            [self loadNewData];
            
            [self.baseTableView reloadData];
            
            // 请求数据结束，取消加载
//            [self hidenLoadingView];
            
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

// 保存用户个人信息到本地
- (void)saveUserInfoToLocalWithResPonseObject:(id)responseObject{
    
    NSLog(@"保存用户个人信息到本地：responseObject：%@",responseObject);
    // 2、赋值
    self.onlyUser.Birthday = responseObject[@"res"][@"data"][@"userinfo"][@"Birthday"];
    self.onlyUser.City = responseObject[@"res"][@"data"][@"userinfo"][@"City"];
    self.onlyUser.Declaration = responseObject[@"res"][@"data"][@"userinfo"][@"Declaration"];
    self.onlyUser.Education = responseObject[@"res"][@"data"][@"userinfo"][@"Education"];
    self.onlyUser.FId = [responseObject[@"res"][@"data"][@"userinfo"][@"FId"] integerValue];
    self.onlyUser.Gender = responseObject[@"res"][@"data"][@"userinfo"][@"Gender"];
    self.onlyUser.Id = responseObject[@"res"][@"data"][@"userinfo"][@"Id"];
    self.onlyUser.Marriage = responseObject[@"res"][@"data"][@"userinfo"][@"Marriage"];
    self.onlyUser.Nickname = responseObject[@"res"][@"data"][@"userinfo"][@"Nickname"];
    
    self.onlyUser.Province = responseObject[@"res"][@"data"][@"userinfo"][@"Province"];
    self.onlyUser.RealName = responseObject[@"res"][@"data"][@"userinfo"][@"RealName"];
    self.onlyUser.RongToken = responseObject[@"res"][@"data"][@"userinfo"][@"RongToken"];
    
    // 头像
    NSString *portaitUrl = responseObject[@"res"][@"data"][@"userinfo"][@"Portrait"];
    if (portaitUrl.length > 18) {
        
        NSString *tempPortaitUrl = [portaitUrl substringToIndex:18];
        if ([tempPortaitUrl isEqualToString:@"/Uploads/AppImage/"]) {
            
            self.onlyUser.Portrait = responseObject[@"res"][@"data"][@"userinfo"][@"Portrait"];
        }
        else {
            self.onlyUser.Portrait = @"默认头像";
        }
    }
    else {
        self.onlyUser.Portrait = @"默认头像";
    }
    
}


- (void)loadNewData{
    
    
    // 假数据
    CYMinePersonalInfoVCModel *minePerInfoModel = self.dataArray[0];
    
    NSString *newFID = [NSString stringWithFormat:@"%ld",minePerInfoModel.FId];
    
    
    NSArray *newArr = @[
                        @[
                            @{
                                @"cellTitle" : @"头像",
                                @"cellIcon" : minePerInfoModel.Portrait
                                },
                            @{
                                @"cellTitle" : @"姓名",
                                @"cellDetailTitle" : minePerInfoModel.RealName
                                },
                            @{
                                @"cellTitle" : @"用户ID",
                                @"cellDetailTitle" : newFID
                                },
                            @{
                                @"cellTitle" : @"性别",
                                @"cellDetailTitle" : minePerInfoModel.Gender
                                },
                            @{
                                @"cellTitle" : @"年龄",
                                @"cellDetailTitle" : @""
                                },
                            @{
                                @"cellTitle":@"学历",
                                @"cellDetailTitle":minePerInfoModel.Education
                                },
                            @{
                                @"cellTitle" : @"婚姻状况",
                                @"cellDetailTitle" : minePerInfoModel.Marriage
                                },
                            @{
                                @"cellTitle" : @"所在地区",
                                @"cellDetailTitle" : minePerInfoModel.City
                                },
                            
                            
                            ],
                        @[
                            @{
                                @"cellTitle" : @"爱情宣言",
                                @"cellDetailTitle" : minePerInfoModel.Declaration
                                }
                            ]
                        ];
    
    // 创建好的最新dataArray
//    self.dataArray = (NSMutableArray *)newArr;
    self.userInfoDataArr = (NSMutableArray *)newArr;
    
}

// tableView有多少组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.userInfoDataArr.count;
}

// 每组多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.userInfoDataArr[section] count];
}

// 创建tableView（即tableView要展示的内容）
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
        //标示符
//        static NSString *cellId = @"cellID";
//    
//        // 从缓冲池查找ID对象，
//        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
//    
//        // 没有就创建
//        if (!cell) {
//    
//            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
//        }
//    
//        //设置箭头
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    
//        NSDictionary *tempCellDict = _dataArray[indexPath.section][indexPath.row];
//    
//        cell.textLabel.text = tempCellDict[@"cellTitle"];
//        cell.imageView.image = [UIImage imageNamed:tempCellDict[@"cellIcon"]];
//        cell.detailTextLabel.text = tempCellDict[@"cellDetailTitle"];
    
//    [_tableView registerNib:[UINib nibWithNibName:@"CYInfoHeaderCell" bundle:nil] forCellReuseIdentifier:@"CYInfoHeaderCell"];
    
    // 从缓冲池查找ID对象，
    if (indexPath.section == 0 && indexPath.row == 0) {
        
        
        // 注册
        [self.baseTableView registerNib:[UINib nibWithNibName:@"CYInfoHeaderCell" bundle:nil] forCellReuseIdentifier:@"CYInfoHeaderCell"];
        
        
        CYInfoHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CYInfoHeaderCell" forIndexPath:indexPath];
        
        CYInfoHeaderCellModel *headerModel = [[CYInfoHeaderCellModel alloc] init];
        
//        // 假数据
        headerModel.title = self.userInfoDataArr[indexPath.section][indexPath.row][@"cellTitle"];
        headerModel.headImgName = self.userInfoDataArr[indexPath.section][indexPath.row][@"cellIcon"];
        
        
        cell.headImgView.layer.cornerRadius = cell.headImgView.frame.size.height / 2;
        
        // cell赋值
        // 通过模型赋值
        cell.infoHeaderCellModel = headerModel;
        
        //直接给cell赋值
//        cell.titleLab.text = self.dataArray[indexPath.section][indexPath.row][@"cellTitle"];
//        cell.headImgView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:headerModel.headImgName]]];
        
        
        return cell;
    }
    else {
        
        
        [self.baseTableView registerNib:[UINib nibWithNibName:@"CYTitleAndDetailCell" bundle:nil] forCellReuseIdentifier:@"CYTitleAndDetailCell"];
        
        // cell
        CYTitleAndDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CYTitleAndDetailCell" forIndexPath:indexPath];
        
        CYTitleAndDetailModel *titleDetailModel = [[CYTitleAndDetailModel alloc] init];
        
        
        // 假数据
        titleDetailModel.title = self.userInfoDataArr[indexPath.section][indexPath.row][@"cellTitle"];
        titleDetailModel.detail = self.userInfoDataArr[indexPath.section][indexPath.row][@"cellDetailTitle"];
        
        
        cell.titleAndDetailModel = titleDetailModel;
        
        if ([cell.titleLab.text isEqualToString:@"用户ID"]) {
            
            cell.nextImgView.hidden = YES;
        }
        
        [cell.detailLab setTextColor:[UIColor colorWithRed:0.50 green:0.50 blue:0.50 alpha:1.00]];
        
        return cell;
    }
    
    
    
    
    
//#warning model 的假数据
//    CYInfoHeaderCellModel *model = [[CYInfoHeaderCellModel alloc] init];
//    model.title = self.dataArray[0][indexPath.row];
//    //    model.mineCellInfo = self.dataArray[1][indexPath.row];
//    
//    
//    cell.infoHeaderCellModel = model;
    
    
    
}


// 选择cell：单击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"点击cell:%ld,%ld",(long)indexPath.section,(long)indexPath.row);
    
    //当离开某行时，让某行的选中状态消失
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        
        // 第一行：头像
        CYPortraitVC *portraitVC = [[CYPortraitVC alloc] init];
        
        [self.navigationController pushViewController:portraitVC animated:YES];
    }
    else if (indexPath.section == 0 && indexPath.row == 1) {
        
        // 第二行：姓名
        CYMyUserInfoNameVC *userInfoNameVC = [[CYMyUserInfoNameVC alloc] init];
        
        [self.navigationController pushViewController:userInfoNameVC animated:YES];
    }
    else if (indexPath.section == 0 && indexPath.row == 3) {
        
        // 第四行：性别
        CYMyUserInfoGenderVC *userInfoGenderVC = [[CYMyUserInfoGenderVC alloc] init];
        
        [self.navigationController pushViewController:userInfoGenderVC animated:YES];
    }
    else if (indexPath.section == 0 && indexPath.row == 4) {
        
        // 第五行：年龄
        CYMyUserInfoGenderVC *userInfoGenderVC = [[CYMyUserInfoGenderVC alloc] init];
        
        [self.navigationController pushViewController:userInfoGenderVC animated:YES];
    }
    else if (indexPath.section == 0 && indexPath.row == 5) {
        
        // 第六行：学历
        CYMyUserInfoEducationVC *userInfoEducationVC = [[CYMyUserInfoEducationVC alloc] init];
        
        [self.navigationController pushViewController:userInfoEducationVC animated:YES];
    }
    else if (indexPath.section == 0 && indexPath.row == 6) {
        
        // 第七行：婚姻状况
        CYMyUserInfoMarriageVC *userInfoMarriageVC = [[CYMyUserInfoMarriageVC alloc] init];
        
        [self.navigationController pushViewController:userInfoMarriageVC animated:YES];
    }
    else if (indexPath.section == 0 && indexPath.row == 7) {
        
        // 第八行：所在地区
        CYMyUserInfoGenderVC *userInfoGenderVC = [[CYMyUserInfoGenderVC alloc] init];
        
        [self.navigationController pushViewController:userInfoGenderVC animated:YES];
    }
    else if (indexPath.section == 1 && indexPath.row == 0) {
        
        // 第九行：爱情宣言
        CYMyUserInfoDeclarationVC *userInfoDeclarationVC = [[CYMyUserInfoDeclarationVC alloc] init];
        
        [self.navigationController pushViewController:userInfoDeclarationVC animated:YES];
    }
    
}

// cell 的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0 && indexPath.row == 0 ) {
        
        return (140.0 / 1246.0) * self.view.frame.size.height;
    }
    else {
        
        return (88.0 / 1246.0) * self.view.frame.size.height;
    }
}

// header 的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        
        return 0.1;
    }
    else {
        
        return 20.0 / 1246 * self.view.frame.size.height;
    }
}



@end
