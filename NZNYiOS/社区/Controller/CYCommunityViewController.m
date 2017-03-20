//
//  CYCommunityViewController.m
//  NZNYiOS
//
//  Created by 男左女右 on 16/8/17.
//  Copyright © 2016年 NZNY. All rights reserved.
//

#import "CYCommunityViewController.h"


// 活动轮播图：View
#import "SDCycleScrollView.h"

// 广告轮播：模型
#import "CYActiveDetailsVCModel.h"

// 社区活动详情:VC
#import "CYActiveDetailsVC.h"

// 社区首页：活动：VC
#import "CYCommunityHomePageCellVC.h"

// 线下活动
#import "CYOfflineActivityVC.h"

// 往期回顾
#import "CYPastReviewVC.h"

// 客服问答
#import "CYCustomerServerAskVC.h"



@interface CYCommunityViewController () <SDCycleScrollViewDelegate>

@end

@implementation CYCommunityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    // 设置navigationBarButtonItem
    [self setNavBarBtnItem];
    
    
    // 添加视图
    [self addView];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
    // tabbar：显示
    self.hidesBottomBarWhenPushed = NO;
    
}

// 设置navigationBarButtonItem
- (void)setNavBarBtnItem{
    
    // 左边BarButtonItem：搜索
    [self setSearchLeftBarButtonItem];
    
    // 右边BarButtonItem：附近的人、消息
    [self setNearAndNewsRightBarButtonItem];
}

// 左边BarButtonItem：搜索
- (void)setSearchLeftBarButtonItem{
    
    // 搜索
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchLeftBarBtnItemClick)];
    
}

// 右边BarButtonItem：附近的人、消息
- (void)setNearAndNewsRightBarButtonItem{
    
    // 右边BarButtonItem：附近的人
    UIBarButtonItem *nearBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"附近" style:2 target:self action:@selector(nearRightBarBtnItemClick)];
    //    UIBarButtonItem *newsBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(newsRightBarBtnItemSearchClick)];
    
    
    // 右边BarButtonItem：消息
    UIBarButtonItem *newsBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"bubble"] style:UIBarButtonItemStylePlain target:self action:@selector(newsRightBarBtnItemClick)];
    
    NSArray *arr = [NSArray arrayWithObjects:newsBarButtonItem,nearBarButtonItem, nil];
    
    [self.navigationItem setRightBarButtonItems:arr];
    
#warning rightBarButtonItem的字体大小，设置了，为什么不起作用？？？
    // rightBarButtonItem的字体大小，设置了，为什么不起作用？？？？？
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:8],NSFontAttributeName, nil] forState:UIControlStateNormal];
    
}


// 添加视图
- (void)addView{
    
    [self.topView setNeedsLayout];
    [self.topView layoutIfNeeded];
    // 上部
    _topView = [[[NSBundle mainBundle] loadNibNamed:@"CYCommunityHeaderView" owner:nil options:nil] lastObject];
    
    
    _topView.frame = CGRectMake(0, 0, cScreen_Width, 294.0 / 1334.0 * cScreen_Height);
    NSLog(@"cScreen_Height:%f",cScreen_Height);
    NSLog(@"_topView.frame.size.height:%f",_topView.frame.size.height);
    NSLog(@"_topView.activeNotiveView.frame.size.height:%f",_topView.activeNotiveView.frame.size.height);
    NSLog(@"_topView.activeNoticeCarouselView.frame.size.height:%f",_topView.activeNoticeCarouselView.frame.size.height);
    
    // 广告轮播
    // 网络请求：广告轮播
    [self requestGetActiveNoticeCarousel];
    
    _topView.activeNotiveView.frame = CGRectMake(0, 0, cScreen_Width, 34.0 / 147.0 * _topView.frame.size.height);
    _topView.activeNoticeCarouselView.frame = CGRectMake(0, 0, cScreen_Width, 15.0 / 34.0 * _topView.activeNotiveView.frame.size.height);
    
    
    // 线下活动：imageView：点击事件
    _topView.offlineActiveImgView.userInteractionEnabled = YES;
    [_topView.offlineActiveImgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(offlineActiveImgViewClick)]];
    // 往期回顾：imageView：点击事件
    _topView.pastReViewImgView.userInteractionEnabled = YES;
    [_topView.pastReViewImgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pastReViewImgViewClick)]];
    // 客服问答：imageView：点击事件
    _topView.customQuestionImgView.userInteractionEnabled = YES;
    [_topView.customQuestionImgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(customQuestionImgViewClick)]];
    // 活动公告：View：点击事件
//    _topView.activeNotiveView.userInteractionEnabled = YES;
//    [_topView.activeNotiveView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(activeNotiveViewClick)]];
    
    [self.view addSubview:_topView];
    
    
    
    
    
    // 社区：首页：活动：cell
    CYCommunityHomePageCellVC *communityActiveCellVC = [[CYCommunityHomePageCellVC alloc] init];
    
    communityActiveCellVC.view.frame = CGRectMake(0, 294.0 / 1334.0 * cScreen_Height, cScreen_Width, cScreen_Height - 294.0 / 1334.0 * cScreen_Height - 49);
//    tempChatListVC.view.frame = CGRectMake(0, 294.0 / 1334.0 * cScreen_Height, cScreen_Width, 407);
    communityActiveCellVC.baseTableView.frame = CGRectMake(0, 0, cScreen_Width, cScreen_Height - 294.0 / 1334.0 * cScreen_Height - 64 - 49);
    [self.view addSubview:communityActiveCellVC.view];
    
    
}


// 网络请求：广告轮播
- (void)requestGetActiveNoticeCarousel{
    NSLog(@"网络请求：广告轮播");
    
    
    
    // 网络请求：广告轮播
    [CYNetWorkManager getRequestWithUrl:cActivityIndexNoticeListUrl params:nil progress:^(NSProgress *uploadProgress) {
        NSLog(@"获取广告轮播进度：%@",uploadProgress);
        
        
    } whenSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"广告轮播：请求成功！");
        
        
        // 1、
        NSString *code = responseObject[@"code"];
        
        // 1.2.1.1.2、和成功的code 匹配
        if ([code isEqualToString:@"0"]) {
            NSLog(@"广告轮播：获取成功！");
            NSLog(@"广告轮播：%@",responseObject);
            
            
            
            // 清空：每次刷新都需要：但是上拉加载、下拉刷新的不需要；
            [self.activeCarouselArray removeAllObjects];
            
            
            // 解析数据，模型存到数组
            [self.activeCarouselArray addObjectsFromArray:[CYActiveDetailsVCModel arrayOfModelsFromDictionaries:responseObject[@"res"][@"data"][@"list"]]];
            
            
            // 添加Title到轮播图
            [self addTitleToActiveCarouselView];
            
            
            
        }
        else{
            NSLog(@"广告轮播：获取失败:responseObject:%@",responseObject);
            NSLog(@"广告轮播：获取失败:responseObject:res:msg:%@",responseObject[@"res"][@"msg"]);
            // 1.2.1.1.2.2、获取失败：弹窗提示：获取失败的返回信息
            [self showHubWithLabelText:responseObject[@"res"][@"msg"] andHidAfterDelay:3.0];
            
        }
        
        
    } whenFailure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"广告轮播：请求失败！");
        NSLog(@"失败原因：error：%@",error);
        
        
        
        [self showHubWithLabelText:@"请检查网络，重新加载" andHidAfterDelay:3.0];
    } withToken:self.onlyUser.userToken];
    
    
}
// 添加Title到轮播图
- (void)addTitleToActiveCarouselView{
    
    SDCycleScrollView *cycleScrollView4 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, _topView.activeNoticeCarouselView.frame.size.width, _topView.activeNoticeCarouselView.frame.size.height) delegate:self placeholderImage:nil];
    
    cycleScrollView4.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    cycleScrollView4.onlyDisplayText = YES;
    
    NSMutableArray *titlesArray = [NSMutableArray new];
    for (CYActiveDetailsVCModel *tempModel in self.activeCarouselArray) {
        
        [titlesArray addObject:tempModel.Title];
        
    }
    
    cycleScrollView4.titlesGroup = [titlesArray copy];
    
    
    
//    cycleScrollView4
    
    
    
    [_topView.activeNoticeCarouselView addSubview:cycleScrollView4];
    

}





- (NSMutableArray *)activeCarouselArray{
    
    if (_activeCarouselArray == nil) {
        
        _activeCarouselArray = [[NSMutableArray alloc] init];
    }
    
    return _activeCarouselArray;
}


#pragma mark - SDCycleScrollViewDelegate：开始

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"---点击了第%ld张图片", (long)index);
    
    CYActiveDetailsVCModel *activeDetailsVCModel = self.activeCarouselArray[index];
    
    CYActiveDetailsVC *activeDetailsVC = [[CYActiveDetailsVC alloc] init];
    
    activeDetailsVC.activeId = activeDetailsVCModel.ActivityContentId;
    NSLog(@"activeId:%@",activeDetailsVC.activeId);
    
    
    activeDetailsVC.hidesBottomBarWhenPushed = YES;
    
    
    //    [self.navigationController pushViewController:activeDetailsVC animated:YES];
    [[self navigationControllerWithView:self.view] pushViewController:activeDetailsVC animated:YES];
    
}
#pragma mark - SDCycleScrollViewDelegate：结束



// 线下活动：imageView：点击事件
- (void)offlineActiveImgViewClick{
    NSLog(@"线下活动：imageView：点击事件");
    
    CYOfflineActivityVC *offlineActivityVC = [[CYOfflineActivityVC alloc] init];
    
    offlineActivityVC.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:offlineActivityVC animated:YES];
    
}
// 往期回顾：imageView：点击事件
- (void)pastReViewImgViewClick{
    NSLog(@"往期回顾：imageView：点击事件");
    
    CYPastReviewVC *pastReviewVC = [[CYPastReviewVC alloc] init];
    
    pastReviewVC.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:pastReviewVC animated:YES];
}

// 客服问答：imageView：点击事件
- (void)customQuestionImgViewClick{
    NSLog(@"客服问答：imageView：点击事件");
    
    CYCustomerServerAskVC *customerServerAskVC = [[CYCustomerServerAskVC alloc] init];
    
    customerServerAskVC.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:customerServerAskVC animated:YES];
}

// 活动公告：View：点击事件
- (void)activeNotiveViewClick{
    NSLog(@"活动公告：View：点击事件");
    
    
}



@end
