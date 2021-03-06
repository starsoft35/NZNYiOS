//
//  CYOtherVideoVC.m
//  nzny
//
//  Created by 男左女右 on 2016/11/23.
//  Copyright © 2016年 nznychina. All rights reserved.
//

#import "CYOtherVideoVC.h"


// videoCollectionCell
#import "CYVideoCollectionViewCell.h"

// 视频详情页：VC
#import "CYVideoDetailsVC.h"

// 模型：他人详情页
#import "CYOthersInfoViewModel.h"

// 模型：数据请求
#import "CYOtherVideoCellModel.h"


#define cVideoCollectionCellWidth ((340.0 / 750.0) * cScreen_Width)
#define cVideoCollectionCellHeight ((340.0 / 1334.0) * cScreen_Height)

@interface CYOtherVideoVC ()

@end

@implementation CYOtherVideoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 加载数据
    [self loadData];
    
    
    // 提前注册
    [self.baseCollectionView registerNib:[UINib nibWithNibName:@"CYVideoCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"CYVideoCollectionViewCell"];
    
}

//- (void)viewDidAppear:(BOOL)animated{
//    [super viewDidAppear:animated];
//    
//    [self.baseCollectionView reloadData];
//    
//}

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
            
            
            // 先把没有数据label删除
            [self.noDataLab removeFromSuperview];
            
            // 解析数据，模型存到数组
            [self.dataArray addObject:[[CYOthersInfoViewModel alloc] initWithDictionary:responseObject[@"res"][@"data"][@"model"] error:nil]];
            
            if (self.dataArray.count != 0) {
                
                // 有视频，创建新的视频数据源
                [self loadNewData];
            }
            
            [self.baseCollectionView reloadData];
            
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


// 有视频，创建新的视频数据源
- (void)loadNewData{
    
    // 他人详情页模型
    CYOthersInfoViewModel *tempOthersInfoModel = self.dataArray[0];
    
    
    // 清空：每次刷新都需要
    [self.videoListDataArr removeAllObjects];
    
    for (CYOtherVideoCellModel *tempVideoCellModel in tempOthersInfoModel.UserVideoList) {
        
        if (tempVideoCellModel.Default) {
            
            // 如果是默认视频，则添加到数组
            [self.videoListDataArr addObject:tempVideoCellModel];
        }
    }
    
    if (self.videoListDataArr.count == 0) {
        
        // 如果没有视频，添加提示
        [self addLabelToShowNoVideo];
    }
    
    
    NSLog(@"self.videoListDataArr:%@",self.videoListDataArr);
    
}

// 如果没有视频，添加提示
- (void)addLabelToShowNoVideo{
    NSLog(@"如果没有视频，添加提示");
    
    self.noDataLab = [[UILabel alloc] initWithFrame:CGRectMake((12.0 / 750.0) * cScreen_Width, (80.0 / 1334.0) * cScreen_Height, (726.0 / 750.0) * cScreen_Width, (30.0 / 1334.0) * cScreen_Height)];
    
    
    self.noDataLab.text = @"暂时没有视频";
    
    self.noDataLab.textAlignment = NSTextAlignmentCenter;
    self.noDataLab.font = [UIFont systemFontOfSize:15];
    
    self.noDataLab.textColor = [UIColor colorWithRed:0.50 green:0.50 blue:0.50 alpha:1.00];
    
    [self.baseCollectionView addSubview:self.noDataLab];
}

// 几个cell
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    
    
    return self.videoListDataArr.count;
}

// cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    // cell
    CYVideoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CYVideoCollectionViewCell" forIndexPath:indexPath];
    
    // 放到上层：必须的
    [cell bringSubviewToFront:cell.playBtn];
    [cell bringSubviewToFront:cell.connectBtn];
    
    cell.playBtn.hidden = NO;
    
    // 播放：点击事件
    [cell.playBtn addTarget:self action:@selector(playBtnClickWithBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    
    // 联系他按钮：分享：点击事件
    [cell.connectBtn addTarget:self action:@selector(connectBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    // 联系他：背景图片
    [cell.connectBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    
    
    // 他人详情页：模型
    CYOthersInfoViewModel *othersInfoViewModel = [[CYOthersInfoViewModel alloc] init];
    if (self.dataArray.count > 0) {
        
        othersInfoViewModel = self.dataArray[indexPath.row];
    }
    
    
    // 视频cell：模型
    CYOtherVideoCellModel *videoCellModel = self.videoListDataArr[indexPath.row];
    
    
    // 构建模型
    CYVideoCollectionViewCellModel *tempCollectionModel = [[CYVideoCollectionViewCellModel alloc] init];
    
    tempCollectionModel.videoBgImgName = @"117.jpg";
    
    tempCollectionModel.VideoUserPortrait = othersInfoViewModel.Portrait;
    
    tempCollectionModel.VideoUserName = [NSString stringWithFormat:@"%.1f M",videoCellModel.Size];
    tempCollectionModel.connectTitle = [NSString stringWithFormat:@"分享"];
    
    
    // 模型赋值
    cell.videoCellModel = tempCollectionModel;
//    cell.connectBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
//    cell.connectBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
    cell.connectBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [cell.connectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    cell.videoBgForTextToShowImgView.image = [UIImage imageNamed:@"我的视频底部阴影"];
//    cell.videoBgForTextToShowImgView.frame.size.height = 20;
    
    return cell;
}


// playBtn
- (void)playBtnClickWithBtn:(UIButton *)btn{
    NSLog(@"视频playBtn:点击事件");
    
    
    
    
    NSIndexPath *currentIndexPath = [[self.baseCollectionView indexPathsForVisibleItems] firstObject];
    NSLog(@"currentIndexPath.section:%ld",currentIndexPath.section);
    NSLog(@"currentIndexPath.row:%ld",(long)currentIndexPath.row);
    
    
    
    // 视频cell：模型
    CYOtherVideoCellModel *videoCellModel = self.videoListDataArr[currentIndexPath.row];
    
    // 视频详情页
    CYVideoDetailsVC *videoDetailsVC = [[CYVideoDetailsVC alloc] init];
    
    videoDetailsVC.oppUserId = self.oppUserId;
    //    videoDetailsVC.indexPath = indexPath;
    videoDetailsVC.videoId = videoCellModel.Id;
    
    
    
    
    
    
    
    
    
    
    // 网络请求：他人详情页
    // URL参数
    NSDictionary *params = @{
                             @"userId":self.onlyUser.userID,
                             @"oppUserId":self.oppUserId,
                             };
    
    [self showLoadingView];
    
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
            
            // 解析数据，模型存到数组
            CYOthersInfoViewModel *otherInfoModel = [[CYOthersInfoViewModel alloc] initWithDictionary:responseObject[@"res"][@"data"][@"model"] error:nil];
            
            
            // 模型赋值
            if (otherInfoModel.UserVideoList.count != 0) {
                
                
                NSInteger tempCount = 0;
                NSInteger tempFlag = 0;
                
                for (CYOtherVideoCellModel *tempOtherVideoCellModel in otherInfoModel.UserVideoList) {
                    
                    tempCount ++;
                    
                    if (tempOtherVideoCellModel.Default) {
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        tempFlag = 1;
                        
                        videoDetailsVC.videoId = tempOtherVideoCellModel.Id;
                        
                        
//                        //  导航条设置为不透明的（这样创建的视图（0，0）点，是在导航条左下角开始的。）
                        UINavigationController *tempVideoNav = [CYUtilities createDefaultNavCWithRootVC:videoDetailsVC BgColor:nil TintColor:[UIColor whiteColor] translucent:NO titleColor:[UIColor whiteColor] title:@"" bgImg:[UIImage imageNamed:@"Title1"]];
//
//                        
//                        [self showViewController:tempVideoNav sender:self];
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        NSInteger tmpCount = [self navigationControllerWithView:self.view].viewControllers.count;
                        NSInteger tmpFlag = 0;
                        BOOL ifHaveVC = NO;
                        
                        for (UIViewController *controller in [self navigationControllerWithView:self.view].viewControllers) {
                            
                            tmpFlag ++;
                            
                            if ([controller isKindOfClass:[CYVideoDetailsVC class]]) {
                                
                                [[self navigationControllerWithView:self.view] popToViewController:controller animated:YES];
//                                [self showViewController:controller sender:self];
                                
                                ifHaveVC = YES;
                                
                            }
                            else if (tmpCount == tmpFlag && ifHaveVC == NO){
                                
                                
                                
//                                [self.navigationController pushViewController:tempVideoNav animated:YES];
//                                
//                                [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
                                
                                
                                
//                                [self showViewController:tempVideoNav sender:self];
                                
                                
                                [[self navigationControllerWithView:self.view] pushViewController:videoDetailsVC animated:YES];
                                
                                
                            }
                            
                        }
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        [self hidenLoadingView];
//                        return ;
                    }
                    
                    else {
                        
                        if (tempFlag == 0 && tempCount == 2) {
                            
                            
                            [self showHubWithLabelText:@"视频坐飞船走了，可能是主人删除了" andHidAfterDelay:3.0];
                        }
                        
                    }
                    
                }
                
                
            }
            else {
                
                [self showHubWithLabelText:@"视频坐飞船走了，可能是主人删除了" andHidAfterDelay:3.0];
            }
            
            
            
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
    
    
    
    
    
    
    
    
    
//    //  导航条设置为不透明的（这样创建的视图（0，0）点，是在导航条左下角开始的。）
//    UINavigationController *tempVideoNav = [CYUtilities createDefaultNavCWithRootVC:videoDetailsVC BgColor:nil TintColor:[UIColor whiteColor] translucent:NO titleColor:[UIColor whiteColor] title:@"" bgImg:[UIImage imageNamed:@"Title1"]];
//    
//    
//    [self showViewController:tempVideoNav sender:self];
    
}


// connectBtn：分享
- (void)connectBtnClick{
    NSLog(@"视频connectBtn：分享:点击事件");
    
    // 分享：网页分享
    [self sharedToWeChatWithWebpageWithShareTitle:@"APP 下载地址" andDescription:@"男左女右 遇见你的TA" andImage:[UIImage imageNamed:@"logo.png"] andWebpageUrl:cDownLoadUrl andbText:NO andScene:0];
    
}

// 选中了collectionCell：点击事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"选中了第 %ld 个collectionCell",(long)indexPath.row);
    
    
    // 视频cell：模型
    CYOtherVideoCellModel *videoCellModel = self.videoListDataArr[indexPath.row];
    
    
    
    
     
}



// 设置cell 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(cVideoCollectionCellWidth, cVideoCollectionCellHeight);
    
}


- (NSMutableArray *)videoListDataArr{
    
    if (_videoListDataArr == nil) {
        
        _videoListDataArr = [[NSMutableArray alloc] init];
    }
    
    return _videoListDataArr;
}


@end
