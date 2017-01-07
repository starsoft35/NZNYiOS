//
//  CYMineViewController.m
//  NZNYiOS
//
//  Created by 男左女右 on 16/8/17.
//  Copyright © 2016年 NZNY. All rights reserved.
//

#import "CYMineViewController.h"

// 我的:头部header视图
#import "CYMineHeaderView.h"

// 我的:主cell视图
#import "CYMineMainTableViewCell.h"

// 我的：模型
#import "CYMineVCModel.h"


// cell 的模型
#import "CYMineMainCellModel.h"

// 个人信息VC
#import "CYMinePersonalInfoVC.h"

// 我的:视频VC
#import "CYMineVideoVC.h"
// 我的：直播VC
#import "CYMyLiveVC.h"
#import "CYMyLiveRecordVC.h"
#import "CYMyLiveTrailerVC.h"
#import "CYBaseSwipeViewController.h"
// 我的：粉丝VC
#import "CYMyFansVC.h"
// 我的：关注VC
#import "CYMyFollowVC.h"

// 账户余额
#import "CYMyAccountBalanceVC.h"
// 我的赞
#import "CYMyLikeVC.h"
#import "CYWhoPraiseMeVC.h"


// 诚信认证VC
#import "CYHonestyVC.h"
// 我的礼物
#import "CYMyGiftVC.h"

// 我的标签
#import "CYMyTagVC.h"


// 我的好友VC
#import "CYMyFriendVC.h"


#define mineTableCellID @"mineTableCellID"


@interface CYMineViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *mineTableView;

@property (nonatomic,strong) NSMutableArray *headerInfoArr;

@property (nonatomic,strong) NSMutableArray *allInfoArr;


@end

@implementation CYMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置我的视图
//    [self setMineMainView];
    
    
    
    // 加载数据
//    [self loadData];
    
    self.baseTableView.frame = CGRectMake(0, -1, cScreen_Width, cScreen_Height);
    
    // 设置navigationBarButtonItem
    [self setNavBarBtnItem];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
    // tabbar：显示
//    self.hidesBottomBarWhenPushed = NO;
    
    
    // 刷新界面
    [self loadData];
    
}

// 加载数据
- (void)loadData{
    
    
    // 请求数据：我的信息
    // URL参数：
    NSDictionary *params = @{
                             @"userId":self.onlyUser.userID
                             };
    
    
    // 网络请求：
    [CYNetWorkManager getRequestWithUrl:cMyBaseInfoUrl params:params progress:^(NSProgress *uploadProgress) {
        NSLog(@"我的一级页面信息请求：进度：%@",uploadProgress);
        
    } whenSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"我的一级页面信息请求：请求成功！");
        // 1、
        NSString *code = responseObject[@"code"];
        
        // 1.2.1.1.2、和成功的code 匹配
        if ([code isEqualToString:@"0"]) {
            NSLog(@"获取用户个人信息：获取成功！");
            NSLog(@"获取用户个人信息：%@",responseObject);
            
            // 清空：每次刷新都需要
//            if (self.dataArray.count != 0) {
//                
//                [self.dataArray removeAllObjects];
//            }
            
            // 解析数据，模型存到数组
            NSDictionary *tempDic = responseObject[@"res"][@"data"][@"model"];
            
            CYMineVCModel *tempModel = [[CYMineVCModel alloc] initWithDictionary:tempDic error:nil];
            
            // 清空：每次刷新都需要
            [self.allInfoArr removeAllObjects];
            
            // 添加数据
            [self.allInfoArr addObject:tempModel];
            
            // 处理数据
            [self loadNewData];
            
            
            [self.baseTableView reloadData];
            
        }
        else{
            NSLog(@"获取用户个人信息：获取失败:responseObject:%@",responseObject);
            NSLog(@"获取用户个人信息：获取失败:responseObject:res:msg:%@",responseObject[@"res"][@"msg"]);
            // 1.2.1.1.2.2、获取失败：弹窗提示：获取失败的返回信息
            [self showHubWithLabelText:responseObject[@"res"][@"msg"] andHidAfterDelay:3.0];
            
        }
        
    } whenFailure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"我的一级页面信息请求：请求失败！");
        
        [self showHubWithLabelText:@"请检查网络" andHidAfterDelay:3.0];
        
    } withToken:self.onlyUser.userToken];
    
}

- (void)loadNewData{
    
    // 假数据
    CYMineVCModel *mineVCModel = self.allInfoArr[0];
    
    NSString *fID = [NSString stringWithFormat:@"%ld",mineVCModel.FId];
    NSString *money = [NSString stringWithFormat:@"¥ %.2f",mineVCModel.Money];
    NSString *certificateLevel = [NSString stringWithFormat:@"%.1f",mineVCModel.CertificateLevel];
    NSString *like = [NSString stringWithFormat:@"%ld",mineVCModel.LikeCount];
    
    
    // headerInfoModel
    CYMineHeaderViewModel *headerModel = [[CYMineHeaderViewModel alloc] init];
    headerModel.portrait = mineVCModel.Portrait;
    headerModel.userName = mineVCModel.RealName;
    headerModel.userActiveDays = @"";
    headerModel.fId = [NSString stringWithFormat:@"ID：%@",fID];
    headerModel.userAddress = @"所在地";
    headerModel.userGender = mineVCModel.Gender;
    headerModel.VideoCount = mineVCModel.VideoCount;
    headerModel.LiveCount = mineVCModel.LiveCount;
    headerModel.FansCount = mineVCModel.FansCount;
    headerModel.FollowsCount = mineVCModel.FollowsCount;
    
    [self.headerInfoArr removeAllObjects];
    [self.headerInfoArr addObject:headerModel];
    
    
    NSArray *newArr = @[
                        
                        @[
                            @{
                                @"cellTitle" : @"账户余额",
                                @"cellDetailTitle" : money
                                },
                            @{
                                @"cellTitle" : @"我的赞",
                                @"cellDetailTitle" : like
                                },
                            @{
                                @"cellTitle" : @"诚信认证",
                                @"cellDetailTitle" : certificateLevel
                                },
                            @{
                                @"cellTitle" : @"我的礼物",
                                @"cellDetailTitle" : @""
                                },
                            @{
                                @"cellTitle" : @"我的标签",
                                @"cellDetailTitle" : @""
                                },
                            @{
                                @"cellTitle" : @"我的好友",
                                @"cellDetailTitle" : @""
                                },
                            
                            
                            ]
                        ];
    
    // 创建好的最新dataArray
    self.dataArray = (NSMutableArray *)newArr;
    
}

// 设置我的视图
- (void)setMineMainView{
    
    
//    CYMineHeaderView *headerView = [[[NSBundle mainBundle] loadNibNamed:@"CYMineHeaderView" owner:nil options:nil] lastObject];
//    
//    headerView.frame = CGRectMake(0, 0, cScreen_Width, cScreen_Height * 400 / 1334);
//    
//    // view的背景图片
//        headerView.layer.contents = (id)[UIImage imageNamed:@"Title1"].CGImage;
//    
//    [self.view addSubview:headerView];
    
    
//    _mineTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, cScreen_Height * 400 / 1334, cScreen_Width, cScreen_Height - cScreen_Height * 400 / 1334) style:UITableViewStyleGrouped];
    
    _mineTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, cScreen_Width, cScreen_Height) style:UITableViewStyleGrouped];
    
    
    _mineTableView.dataSource = self;
    _mineTableView.delegate = self;
    
    [self.view addSubview:_mineTableView];
    
}


// 设置navigationBarButtonItem
- (void)setNavBarBtnItem{
    
    // 左边BarButtonItem：搜索
    [self setSearchLeftBarButtonItem];
    
    // 右边BarButtonItem：附近的人、消息
    [self setNearAndNewsRightBarButtonItem];
}

// 左边BarButtonItem：设置
- (void)setSearchLeftBarButtonItem{
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Setting"] style:UIBarButtonItemStylePlain target:self action:@selector(setLeftBarBtnItemClick)];
    
    
}


// 右边BarButtonItem：附近的人、消息
- (void)setNearAndNewsRightBarButtonItem{
    
    // 右边BarButtonItem：附近的人
    UIBarButtonItem *nearBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"附近" style:2 target:self action:@selector(nearRightBarBtnItemClick)];
    
    // 右边BarButtonItem：消息
    UIBarButtonItem *newsBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"bubble"] style:UIBarButtonItemStylePlain target:self action:@selector(newsRightBarBtnItemClick)];
    
    NSArray *arr = [NSArray arrayWithObjects:newsBarButtonItem,nearBarButtonItem, nil];
    
    [self.navigationItem setRightBarButtonItems:arr];
    
#warning rightBarButtonItem的字体大小，设置了，为什么不起作用？？？
    // rightBarButtonItem的字体大小，设置了，为什么不起作用？？？？？
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:8],NSFontAttributeName, nil] forState:UIControlStateNormal];
    
}

#pragma mark --UITableViewDataSource代理
// header
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    CYMineHeaderView *headerView = [[[NSBundle mainBundle] loadNibNamed:@"CYMineHeaderView" owner:nil options:nil] lastObject];
    
    headerView.frame = CGRectMake(0, 0, cScreen_Width, cScreen_Height * 400 / 1334);
    // view的背景图片
    //    headerView.layer.contents = (id)[UIImage imageNamed:@"Title1"].CGImage;
    
    
    // 视图赋值
    headerView.mineMainHeaderViewModel = _headerInfoArr[0];
    
    
    // 编辑信息button：点击事件
    [headerView.editInfoBtn addTarget:self action:@selector(editInfoBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    // 视频view：点击事件
    headerView.videoView.userInteractionEnabled = YES;
    [headerView.videoView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(videoViewClick)]];
    
    // 直播view：点击事件
    headerView.liveView.userInteractionEnabled = YES;
    [headerView.liveView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(liveViewClick)]];
    
    // 粉丝view：点击事件
    headerView.fansView.userInteractionEnabled = YES;
    [headerView.fansView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fansViewClick)]];
    
    // 关注view：点击事件
    headerView.followView.userInteractionEnabled = YES;
    [headerView.followView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(followViewClick)]];
    
    
    return headerView;
}


// headerView：编辑信息button：点击事件
- (void)editInfoBtnClick{
    NSLog(@"编辑信息button：点击事件");
    
    // 创建个人信息VC
    CYMinePersonalInfoVC *personInfoVC = [[CYMinePersonalInfoVC alloc] init];
    
    // 隐藏tabbar
    personInfoVC.hidesBottomBarWhenPushed = YES;
    
    // 跳转到下个页面
    [self.navigationController pushViewController:personInfoVC animated:YES];
    
    
}


// 视频view：点击事件
- (void)videoViewClick{
    NSLog(@"视频view：点击事件");
    
    
    // 创建我的视频VC
    CYMineVideoVC *mineVideoVC = [[CYMineVideoVC alloc] init];
    
    // 隐藏tabbar
    mineVideoVC.hidesBottomBarWhenPushed = YES;
    
    
    // 跳转到下个界面
    [self.navigationController pushViewController:mineVideoVC animated:YES];
    
}

// 直播view：点击事件
- (void)liveViewClick{
    NSLog(@"直播view：点击事件");
    
    //
    CYMyLiveVC *myLiveVC = [[CYMyLiveVC alloc] init];
    
    // 隐藏tabbar
    myLiveVC.hidesBottomBarWhenPushed = YES;
    
    
    // 跳转到下个界面
    [self.navigationController pushViewController:myLiveVC animated:YES];
    
    
//    CYMyLiveTrailerVC *myLiveTrailerVC = [[CYMyLiveTrailerVC alloc] init];
////    myLiveTrailerVC.view.frame = CGRectMake(0, 0, cScreen_Width, 500);
////    myLiveTrailerVC.baseCollectionView.frame = CGRectMake(0, 0, cScreen_Width, 500);
//    
//    // 记录：VC
//    CYMyLiveRecordVC *myLiveRecordVC = [[CYMyLiveRecordVC alloc] init];
//    //    myLiveRecordVC.view.frame = CGRectMake(0, 0, cScreen_Width, 500);
//    //    myLiveRecordVC.baseTableView.frame = CGRectMake(0, 0, cScreen_Width, 500);
//    
//    // 中部滑动视图
//    CYBaseSwipeViewController *trailerRecordVC = [[CYBaseSwipeViewController alloc] initWithSubVC:@[myLiveTrailerVC,myLiveRecordVC] andTitles:@[@"预告",@"记录"]];
//    
//    [self.navigationController pushViewController:trailerRecordVC animated:YES];
}

// 粉丝view：点击事件
- (void)fansViewClick{
    NSLog(@"粉丝view：点击事件");
    
    CYMyFansVC *myFansVC = [[CYMyFansVC alloc] init];
    
    
    // 隐藏tabbar
    myFansVC.hidesBottomBarWhenPushed = YES;
    
    
    // 跳转到下个界面
    [self.navigationController pushViewController:myFansVC animated:YES];
}

// 关注view：点击事件
- (void)followViewClick{
    NSLog(@"关注view：点击事件");
    
    CYMyFollowVC *myFollowVC = [[CYMyFollowVC alloc] init];
    
    
    // 隐藏tabbar
    myFollowVC.hidesBottomBarWhenPushed = YES;
    
    
    // 跳转到下个界面
    [self.navigationController pushViewController:myFollowVC animated:YES];
}



// header 的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return cScreen_Height * 400 / 1334;
}

// 有多少组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.dataArray.count;
}

// 每组多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.dataArray[section] count];
//    return [self.dataArray[0] count];
}

// 创建tableView（即tableView要展示的内容）
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    // 注册
    [self.baseTableView registerNib:[UINib nibWithNibName:@"CYMineMainTableViewCell" bundle:nil] forCellReuseIdentifier:@"CYMineMainTableViewCell"];
    
    // 从缓冲池查找ID对象，
    CYMineMainTableViewCell *mineMainCell = [tableView dequeueReusableCellWithIdentifier:@"CYMineMainTableViewCell" forIndexPath:indexPath];
    
    CYMineMainCellModel *model = [[CYMineMainCellModel alloc] init];
    model.mineCellTitle = self.dataArray[indexPath.section][indexPath.row][@"cellTitle"];
    model.mineCellInfo = self.dataArray[indexPath.section][indexPath.row][@"cellDetailTitle"];
    
    if ([model.mineCellTitle isEqualToString:@"诚信认证"]) {
        
        model.isStarLevelCell = YES;
        
        // 星级
        model.mineStarLevel = [self.dataArray[indexPath.section][indexPath.row][@"cellDetailTitle"] floatValue];
        //        model.mineStarLevel = 4;
        model.mineCellInfo = @"";
    }
    else if ([model.mineCellTitle isEqualToString:@"我的赞"]) {
        
        model.mineCellInfo = @"";
    }
    else {
        
        model.isStarLevelCell = NO;
    }
    
    // 给cell赋值
    mineMainCell.mineMainCellModel = model;
    
    mineMainCell.nextImgView.image = [UIImage imageNamed:@"Right-"];
    
    
    return mineMainCell;
    
}


// cell 点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"点击了cell：%ld",(long)indexPath.row);
    
    //当离开某行时，让某行的选中状态消失
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        
        // 我的账户余额
        CYMyAccountBalanceVC *myAccountBalanceVC = [[CYMyAccountBalanceVC alloc] init];
        
        // 隐藏tabbar
        myAccountBalanceVC.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:myAccountBalanceVC animated:YES];
        
        
    }
    else if (indexPath.section == 0 && indexPath.row == 1) {
        
        // 我的赞
        CYMyLikeVC *myLikeVC = [[CYMyLikeVC alloc] init];
        
        // 隐藏tabbar
        myLikeVC.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:myLikeVC animated:YES];
        
        // 谁赞过我
//        CYWhoPraiseMeVC *whoPraiseMeVC = [[CYWhoPraiseMeVC alloc] init];
//        
//        // 隐藏tabbar
//        whoPraiseMeVC.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:whoPraiseMeVC animated:YES];
        
    }
    else if (indexPath.section == 0 && indexPath.row == 2) {
        
        
        // 诚信认证
        CYHonestyVC *honestyVC = [[CYHonestyVC alloc] init];
        
        // 隐藏tabbar
        honestyVC.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:honestyVC animated:YES];
        
    }
    else if (indexPath.section == 0 && indexPath.row == 3) {
        
        
        // 我的礼物
        CYMyGiftVC *myGiftVC = [[CYMyGiftVC alloc] init];
        
        // 隐藏tabbar
        myGiftVC.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:myGiftVC animated:YES];
        
    }
    else if (indexPath.section == 0 && indexPath.row == 4) {
        
        // 我的标签
        CYMyTagVC *myTagVC = [[CYMyTagVC alloc] init];
        
        // 隐藏tabbar
        myTagVC.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:myTagVC animated:YES];
        
    }
    else if (indexPath.section == 0 && indexPath.row == 5) {
        
        // 我的好友
        CYMyFriendVC *myFriendVC = [[CYMyFriendVC alloc] init];
        
        // 隐藏tabbar
        myFriendVC.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:myFriendVC animated:YES];
        
    }
    
    
    
}

// 头部信息数组
- (NSMutableArray *)headerInfoArr{
    
    if (!_headerInfoArr) {
        
        _headerInfoArr = [[NSMutableArray alloc] init];
        
    }
    
    return _headerInfoArr;
}

// 所有的信息数组：用来中间赋值
- (NSMutableArray *)allInfoArr{
    
    
    if (!_allInfoArr) {
        _allInfoArr = [[NSMutableArray alloc] init];
    }
    
    return _allInfoArr;
}

@end
