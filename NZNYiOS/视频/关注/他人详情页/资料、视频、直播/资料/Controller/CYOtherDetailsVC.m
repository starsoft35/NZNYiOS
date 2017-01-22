//
//  CYOtherDetailsVC.m
//  nzny
//
//  Created by 男左女右 on 2016/11/23.
//  Copyright © 2016年 nznychina. All rights reserved.
//

#import "CYOtherDetailsVC.h"

// 带星级的cell
#import "CYMineMainTableViewCell.h"
// 模型
#import "CYMineMainCellModel.h"


// titleAndDetailCell
#import "CYTitleAndDetailCell.h"
#import "CYTitleAndDetailModel.h"

// 诚信认证：VC
#import "CYCertificateDetailVC.h"



@interface CYOtherDetailsVC ()

{
    
    // 星级数组
    NSMutableArray *_starModelArr;
}


@end

@implementation CYOtherDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    // 加载数据
    [self loadData];
    
    
}



// 加载数据
- (void)loadData{
    
    
    // 网络请求：他人详情页
    
    // 新地址
    NSDictionary *params = @{
                             @"userId":self.onlyUser.userID,
                             @"oppUserId":self.oppUserId,
                             };
    NSLog(@"params:oppUserId:%@",self.oppUserId);
    
    //    [self showLoadingView];
    
    // 网络请求：他人详情页
    [CYNetWorkManager getRequestWithUrl:cOppUserInfoUrl params:params progress:^(NSProgress *uploadProgress) {
        NSLog(@"获取他人详情页进度：%@",uploadProgress);
        
        
    } whenSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"他人详情页：请求成功！");
        
        // 1、
        NSString *code = responseObject[@"code"];
        
        // 1.2.1.1.2、和成功的code 匹配
        if ([code isEqualToString:@"0"]) {
            NSLog(@"他人详情页：获取成功！");
            NSLog(@"他人详情页：%@",responseObject);
            
            // 清空：每次刷新都需要
            [self.dataArray removeAllObjects];
            
            // 解析数据，模型存到数组
            [self.dataArray addObject:[[CYOtherDetailsModel alloc] initWithDictionary:responseObject[@"res"][@"data"][@"model"] error:nil]];
            
            
            
//            [self.baseTableView reloadData];
            
            [self loadNewData];
            
            
            // 请求数据结束，取消加载
            [self hidenLoadingView];
            
        }
        else{
            NSLog(@"他人详情页：获取失败:responseObject:%@",responseObject);
            NSLog(@"他人详情页：获取失败:responseObject:res:msg:%@",responseObject[@"res"][@"msg"]);
            // 1.2.1.1.2.2、获取失败：弹窗提示：获取失败的返回信息
            [self showHubWithLabelText:responseObject[@"res"][@"msg"] andHidAfterDelay:3.0];
            
        }
        
        
    } whenFailure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"他人详情页：请求失败！");
        NSLog(@"失败原因：error：%@",error);
        
        [self showHubWithLabelText:@"请检查网络，重新加载" andHidAfterDelay:3.0];
    } withToken:self.onlyUser.userToken];
    
}

// 加载数据
- (void)loadNewData{
    NSLog(@"self.otherDetailsModel:%@",self.otherDetailsModel);
    
    CYOtherDetailsModel *tempModel = self.dataArray[0];
    
    // titleAndDetail数据
    NSArray *titleAndDetailArr = @[
                                   @[
                                       @{
                                           @"mineCellTitle":@"诚信等级",
                                           @"mineStarLevel":@(tempModel.CertificateLevel),
                                           },
                                       @{
                                           @"title":@"用户ID",
                                           @"detail":[NSString stringWithFormat:@"%ld",tempModel.FId],
                                           },
                                       @{
                                           @"title":@"学历",
                                           @"detail":tempModel.Education,
                                           },
                                       @{
                                           @"title":@"婚姻状况",
                                           @"detail":tempModel.Marriage,
                                           },
                                       @{
                                           @"title":@"所在区域",
                                           @"detail":tempModel.City,
                                           },
                                       
                                       ],
                                   @[
                                       @{
                                           @"title":@"爱情宣言",
                                           @"detail":tempModel.Declaration,
                                           }
                                       ]
                                   
                                   ];
    
    
    // 清空：每次刷新都需要
    [self.dataArray removeAllObjects];
    
    self.dataArray = (NSMutableArray *)titleAndDetailArr;
    
    [self.baseTableView reloadData];
    
}

// tableView代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.dataArray.count;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return [self.dataArray[section] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        
        // 注册
        [self.baseTableView registerNib:[UINib nibWithNibName:@"CYMineMainTableViewCell" bundle:nil] forCellReuseIdentifier:@"CYMineMainTableViewCell"];
        
        CYMineMainTableViewCell *starCell = [tableView dequeueReusableCellWithIdentifier:@"CYMineMainTableViewCell" forIndexPath:indexPath];
        
        CYMineMainCellModel *starCellModel = [[CYMineMainCellModel alloc] init];
        starCellModel.mineCellTitle = self.dataArray[indexPath.section][indexPath.row][@"mineCellTitle"];
        starCellModel.mineStarLevel = [self.dataArray[indexPath.section][indexPath.row][@"mineStarLevel"] floatValue];
        
        starCellModel.isStarLevelCell = YES;
        
        starCellModel.mineCellInfo = @"点击查看详情";
        
        
        starCell.mineMainCellModel = starCellModel;
        
        starCell.mineCellInfoLab.textColor = [UIColor colorWithRed:0.37 green:0.65 blue:0.99 alpha:1.00];
        starCell.mineCellInfoLab.font = [UIFont systemFontOfSize:12];
        starCell.nextImgView.image = [UIImage imageNamed:@""];
        
        return starCell;
    }
    
    else {
        
        // 注册
        [self.baseTableView registerNib:[UINib nibWithNibName:@"CYTitleAndDetailCell" bundle:nil] forCellReuseIdentifier:@"CYTitleAndDetailCell"];
        
        CYTitleAndDetailCell *titleAndDetailCell = [tableView dequeueReusableCellWithIdentifier:@"CYTitleAndDetailCell" forIndexPath:indexPath];
        
        CYTitleAndDetailModel *titleAndDetailCellModel = [[CYTitleAndDetailModel alloc] init];
        
        titleAndDetailCellModel.title = self.dataArray[indexPath.section][indexPath.row][@"title"];
        titleAndDetailCellModel.detail = self.dataArray[indexPath.section][indexPath.row][@"detail"];
        
        titleAndDetailCell.titleAndDetailModel = titleAndDetailCellModel;
        
        titleAndDetailCell.nextImgView.image = [UIImage imageNamed:@""];
        
        [titleAndDetailCell.detailLab setTextColor:[UIColor colorWithRed:0.50 green:0.50 blue:0.50 alpha:1.00]];
        // 居左
        titleAndDetailCell.detailLab.textAlignment = NSTextAlignmentLeft;
        
        if ([titleAndDetailCell.titleLab.text isEqualToString:@"爱情宣言"]) {
            
            titleAndDetailCell.detailLab.font = [UIFont systemFontOfSize:15];
            titleAndDetailCell.detailLab.adjustsFontSizeToFitWidth = NO;
            
            // 自动计算label的高度、宽度
            CGSize tempLabelSize = [self labelAutoCalculateRectWith:titleAndDetailCell.detailLab.text FontSize:15 MaxSize:CGSizeMake(240.0 / 375.0 * cScreen_Width, 80.0 / 667.0 * cScreen_Height)];
            
            
            CGRect tempDetailLabRect = CGRectMake(titleAndDetailCell.detailLab.frame.origin.x, titleAndDetailCell.detailLab.frame.origin.y, tempLabelSize.width, tempLabelSize.height);
            
            titleAndDetailCell.detailLab.numberOfLines = 0;
            titleAndDetailCell.detailLab.frame = tempDetailLabRect;
            
            
            // 首行缩进
            NSMutableParagraphStyle *paraStyle01 = [[NSMutableParagraphStyle alloc] init];
            paraStyle01.alignment = NSTextAlignmentLeft;  //对齐
            paraStyle01.headIndent = 0.0f;//行首缩进
            //参数：（字体大小17号字乘以2，34f即首行空出两个字符）
            CGFloat emptylen = titleAndDetailCell.detailLab.font.pointSize * 2;
            paraStyle01.firstLineHeadIndent = emptylen;// 首行缩进
            NSAttributedString *attrText = [[NSAttributedString alloc] initWithString:titleAndDetailCell.detailLab.text attributes:@{NSParagraphStyleAttributeName:paraStyle01}];
            titleAndDetailCell.detailLab.attributedText = attrText;
            
        }
        
        return titleAndDetailCell;
    }
}

// cell：点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"点击了第 %ld 行",indexPath.row);
    
    
    //当离开某行时，让某行的选中状态消失
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        
        // 诚信认证详情
        CYCertificateDetailVC *certificateDetailVC = [[CYCertificateDetailVC alloc] init];
        
        // 导航VC
        UINavigationController *nav = [CYUtilities createDefaultNavCWithRootVC:certificateDetailVC BgColor:nil TintColor:[UIColor whiteColor] translucent:NO titleColor:[UIColor whiteColor] title:@"登录" bgImg:[UIImage imageNamed:@"Title1"]];
        
//        [self presentViewController:nav animated:nil completion:nil];
//        [self.navigationController pushViewController:certificateDetailVC animated:YES];
        [[self navigationControllerWithView:self.view] pushViewController:certificateDetailVC animated:YES];
    }
    
}



// cell 的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.section == 1 && indexPath.row == 0) {
        
        // 自动计算label的高度、宽度
        CGSize tempLabelSize = [self labelAutoCalculateRectWith:self.dataArray[indexPath.section][indexPath.row][@"detail"] FontSize:15 MaxSize:CGSizeMake(240.0 / 375.0 * cScreen_Width, 80.0 / 667.0 * cScreen_Height)];
        
        return ((88.0 / 1334.0) * self.view.frame.size.height) + (tempLabelSize.height / 2);
    }
    else {
        
        return (88.0 / 1334.0) * self.view.frame.size.height;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.1;
}


- (CYOtherDetailsModel *)otherDetailsModel{
    
    if (_otherDetailsModel == nil) {
        
        _otherDetailsModel = [[CYOtherDetailsModel alloc] init];
        
        
    }
    
    return _otherDetailsModel;
}


@end
