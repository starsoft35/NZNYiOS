//
//  CYSystemNewsVC.m
//  nzny
//
//  Created by 男左女右 on 2017/2/18.
//  Copyright © 2017年 nznychina. All rights reserved.
//

#import "CYSystemNewsVC.h"



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




@interface CYSystemNewsVC ()

@end

@implementation CYSystemNewsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"系统消息";
    
    
    // 加载数据
    [self loadData];
    
    
    // 创建tableView
//    self.baseTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
//    self.baseTableView.frame = CGRectMake(0, 0, cScreen_Width, cScreen_Height - 64);
    
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
    
    
    NSArray *tempArr = @[
                         
                         
                         @{
                             @"type":@"active",
                             @"detailInfo":@"你瞅啥1",
                             @"time":@"2016年08月25日 17:30"
                             },
                         
                         
                         @{
                             @"type":@"ask",
                             @"detailInfo":@"ask你瞅啥1",
                             @"time":@"2016年08月25日 17:30",
                             @"ask":@"ask你瞅啥1ask你瞅啥1ask你瞅啥1ask你瞅啥1ask你瞅啥1ask你瞅啥1ask你瞅啥1ask你瞅啥1ask你瞅啥1ask你瞅啥1ask你瞅啥1ask你瞅啥1ask你瞅啥1ask你瞅啥1ask你瞅啥1ask你瞅啥1ask你瞅啥1ask你瞅啥1",
                             @"answer":@"answer瞅你咋地answer瞅你咋地answer瞅你咋地answer瞅你咋地answer瞅你咋地answer瞅你咋地answer瞅你咋地answer瞅你咋地answer瞅你咋地answer瞅你咋地answer瞅你咋地answer瞅你咋地answer瞅你咋地answer瞅你咋地answer瞅你咋地answer瞅你咋地"
                             
                             },
                         
                         @{
                             @"type":@"active",
                             @"detailInfo":@"你瞅啥2你瞅啥2你瞅啥2你瞅啥2你瞅啥2你瞅啥2你瞅啥2你瞅啥2你瞅啥2你瞅啥2你瞅啥2你瞅啥2你瞅啥2你瞅啥2你瞅啥2你瞅啥2你瞅啥2你瞅啥2你瞅啥2你瞅啥2你瞅啥2你瞅啥2你瞅啥2你瞅啥2你瞅啥2你瞅啥2你瞅啥2你瞅啥2你瞅啥2你瞅啥2你瞅啥2你瞅啥2你瞅啥2你瞅啥2",
                             @"time":@"2016年08月26日 17:30"
                             },
  
                         @{
                             @"type":@"active",
                             @"detailInfo":@"你瞅啥3你瞅啥3你瞅啥3你瞅啥3你瞅啥3你瞅啥3你瞅啥3你瞅啥3你瞅啥3你瞅啥3你瞅啥3你瞅啥3你瞅啥3你瞅啥3你瞅啥3",
                             @"time":@"2016年08月27日 17:30"
                             },
                         @{
                             @"type":@"active",
                             @"detailInfo":@"你瞅啥4",
                             @"time":@"2016年08月28日 17:30"
                             },
                         @{
                             @"type":@"active",
                             @"detailInfo":@"你瞅啥5",
                             @"time":@"2016年08月29日 17:30"
                             },
                         @{
                             @"type":@"active",
                             @"detailInfo":@"你瞅啥6",
                             @"time":@"2016年08月30日 17:30"
                             },
                         @{
                             @"type":@"active",
                             @"detailInfo":@"你瞅啥7",
                             @"time":@"2016年08月31日 17:30"
                             },
                         @{
                             @"type":@"active",
                             @"detailInfo":@"你瞅啥8",
                             @"time":@"2016年09月01日 17:30"
                             },
                         @{
                             @"type":@"active",
                             @"detailInfo":@"你瞅啥9",
                             @"time":@"2016年09月02日 17:30"
                             },
                         @{
                             @"type":@"active",
                             @"detailInfo":@"你瞅啥10",
                             @"time":@"2016年09月03日 17:30"
                             },
                         
                         ];
    
    
    self.dataArray = (NSMutableArray *)tempArr;
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    if (section == 2) {
        
        return 10;
    }
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
    
    timeCell.timeLab.text = self.dataArray[section][@"time"];
    
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
    
    
    
    if ([self.dataArray[indexPath.section][@"type"] isEqualToString:@"ask"]) {
        
        
        // 提前注册
        [self.baseTableView registerNib:[UINib nibWithNibName:@"CYAskFeedBackCell" bundle:nil] forCellReuseIdentifier:@"CYAskFeedBackCell"];
        
        
        // cell
        CYAskFeedBackCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CYAskFeedBackCell" forIndexPath:indexPath];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        cell.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1.00];
        
        
        cell.askLab.text = self.dataArray[indexPath.section][@"ask"];
        cell.answerLab.text = self.dataArray[indexPath.section][@"answer"];
        
        
        
        
        
        
        
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
    }
    else {
        
        
        // 提前注册
        [self.baseTableView registerNib:[UINib nibWithNibName:@"CYActiveFeedBackCell" bundle:nil] forCellReuseIdentifier:@"CYActiveFeedBackCell"];
        
        
        // cell
        CYActiveFeedBackCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CYActiveFeedBackCell" forIndexPath:indexPath];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        // cell：模型
        //    CYOfflineActivityCellModel *offlineActivityCellModel = self.dataArray[indexPath.row];
        
        
        // 假数据
        //    cell.offlineActiveCellModel = offlineActivityCellModel;
        
        
        cell.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1.00];
        
        
        cell.detailInfoLab.text = self.dataArray[indexPath.section][@"detailInfo"];
        
        
        
        
        
        
        
        
        cell.detailInfoLab.font = [UIFont systemFontOfSize:15];
        cell.detailInfoLab.adjustsFontSizeToFitWidth = NO;
        
        // 自动计算label的高度、宽度
        CGSize tempLabelSize = [self labelAutoCalculateRectWith:cell.detailInfoLab.text FontSize:15 MaxSize:CGSizeMake(333.0 / 375.0 * cScreen_Width, 300.0 / 667.0 * cScreen_Height)];
        
        
        CGRect tempDetailLabRect = CGRectMake(cell.detailInfoLab.frame.origin.x, cell.detailInfoLab.frame.origin.y, tempLabelSize.width, tempLabelSize.height);
        
        cell.detailInfoLab.numberOfLines = 0;
        cell.detailInfoLab.frame = tempDetailLabRect;
        
        
        
        
        
        return cell;
        
    }
    
}


// height：cell
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"indexPath.section:%ld",indexPath.section);
    NSLog(@"indexPath.row:%ld",indexPath.row);
    
    
    if ([self.dataArray[indexPath.section][@"type"] isEqualToString:@"ask"]) {
        
        // 自动计算label的高度、宽度
        CGSize tempAskLabelSize = [self labelAutoCalculateRectWith:self.dataArray[indexPath.section][@"ask"] FontSize:15 MaxSize:CGSizeMake(333.0 / 375.0 * cScreen_Width, 300.0 / 667.0 * cScreen_Height)];
        
        CGSize tempAnswerLabelSize = [self labelAutoCalculateRectWith:self.dataArray[indexPath.section][@"answer"] FontSize:15 MaxSize:CGSizeMake(333.0 / 375.0 * cScreen_Width, 300.0 / 667.0 * cScreen_Height)];
        
        NSLog(@"self.dataArray.ask:%@",self.dataArray[indexPath.section][@"ask"]);
        NSLog(@"self.dataArray.answer:%@",self.dataArray[indexPath.section][@"answer"]);
        
        NSLog(@"tempAskLabelSize.height:%f",tempAskLabelSize.height);
        NSLog(@"tempAnswerLabelSize.height:%f",tempAnswerLabelSize.height);
        
        float tempHeight = (61) + (tempAskLabelSize.height) + (tempAnswerLabelSize.height);
        
        NSLog(@"tempHeight:%f",tempHeight);
        
        return tempHeight;
        
    }
    else {
        
        // 自动计算label的高度、宽度
        CGSize tempLabelSize = [self labelAutoCalculateRectWith:self.dataArray[indexPath.section][@"detailInfo"] FontSize:15 MaxSize:CGSizeMake(333.0 / 375.0 * cScreen_Width, 300.0 / 667.0 * cScreen_Height)];
        
        return ((146.0 / 1334.0) * cScreen_Height) + (tempLabelSize.height);
        
    }
    
}

// cell：点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"点击了第%ld组第%ld行",(long)indexPath.section,(long)indexPath.row);
    
    //当离开某行时，让某行的选中状态消失
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


@end
