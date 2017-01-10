//
//  CYSearchVC.m
//  nzny
//
//  Created by 男左女右 on 2016/11/20.
//  Copyright © 2016年 nznychina. All rights reserved.
//

#import "CYSearchVC.h"


// 搜索cell
#import "CYSearchViewCell.h"

// 搜索cell：model
#import "CYSearchViewCellModel.h"


// 他人详情页
#import "CYOthersInfoVC.h"


@interface CYSearchVC ()

@end

@implementation CYSearchVC

{
    NSInteger flag;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.view.frame = CGRectMake(0, 0, cScreen_Width, (1108 / 1334) * cScreen_Height);
    
    // 提前注册
    [self.baseTableView registerNib:[UINib nibWithNibName:@"CYSearchViewCell" bundle:nil] forCellReuseIdentifier:@"CYSearchViewCell"];
    
    // 设置navigation 上面的搜索框
    [self setNavigationBarItem];
    
    // 设置搜索结果label
    [self setTipSearchResultLabel];
    
}

//
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    // 将要显示的时候，加载数据，用于刷新
    [self loadData];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self.navigationController.view endEditing:YES];
    
}

// 设置搜索结果label
- (void)setTipSearchResultLabel{
    
    
    // tabbar：隐藏
    self.hidesBottomBarWhenPushed = YES;
    
    
    self.searchResultLab.frame = CGRectMake((12.0 / 750.0) * self.view.frame.size.width, (80.0 / 1334.0) * self.view.frame.size.height, (726.0 / 750.0) * self.view.frame.size.width, (30.0 / 1334.0) * self.view.frame.size.height);
    
    self.searchResultLab.text = @"刚进入时，请输入姓名或ID号，搜索好友";
    
    self.searchResultLab.textAlignment = NSTextAlignmentCenter;
    self.searchResultLab.font = [UIFont systemFontOfSize:15];
    
    self.searchResultLab.textColor = [UIColor colorWithRed:0.50 green:0.50 blue:0.50 alpha:1.00];
    
    [self.view addSubview:self.searchResultLab];
}

// 设置navigationBarItem
- (void)setNavigationBarItem{
    
    // 设置navigation 上面的搜索框
    [self searchTextFieldViewNavigationBarItem];
    
    // 搜索：好友：右侧navigationBarItem
    [self searchButtonNavigationBarItem];
}


// 设置navigation 上面的搜索框
- (void)searchTextFieldViewNavigationBarItem{
    
    UIView *searView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, (580.0 / 750.0) * self.view.frame.size.width, (68.0 / 1334.0) * self.view.frame.size.height)];
    searView.backgroundColor = [UIColor whiteColor];
    
    
    self.searchTextField.placeholder = @"请输入姓名或ID号";
    
    self.searchTextField.frame = CGRectMake(searView.frame.origin.x + 10, searView.frame.origin.y, searView.frame.size.width - 40, searView.frame.size.height);
    
    // 光标的颜色
    self.searchTextField.tintColor = [UIColor colorWithRed:0.26 green:0.42 blue:0.95 alpha:1.00];
    
    
    [searView addSubview:self.searchTextField];
    
    
    self.navigationItem.titleView = searView;
    
}

// 搜索：好友：右侧navigationBarItem
- (void)searchButtonNavigationBarItem{
    
    
    // 搜索：好友：右侧navigationBarItem
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"搜索" style:UIBarButtonItemStylePlain target:self action:@selector(requestSearchFriendsRightBarBtnItemClick)];
}


// 搜索：好友：右侧navigationBarItem：点击事件
- (void)requestSearchFriendsRightBarBtnItemClick{
    NSLog(@"搜索：好友：右侧navigationBarItem：点击事件");
    
    // 隐藏键盘
    [self.navigationController.view endEditing:YES];
    
    // 加载数据
    [self loadData];
}


// 加载数据
- (void)loadData{
    
    
    // 网路请求：搜索人
    // 参数
    NSDictionary *params = @{
                             @"userId":self.onlyUser.userID,
                             @"searchString":self.searchTextField.text
                             };
    
    [self showLoadingView];
    
    // 网络请求：搜索人
    [CYNetWorkManager getRequestWithUrl:cSearchPeopleUrl params:params progress:^(NSProgress *uploadProgress) {
        NSLog(@"搜索人请求：进度：%@",uploadProgress);
        
    } whenSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"搜索人请求：请求成功！");
        // 1、
        NSString *code = responseObject[@"code"];
        
        // 1.2.1.1.2、和成功的code 匹配
        if ([code isEqualToString:@"0"]) {
            NSLog(@"搜索人：搜索成功！");
            NSLog(@"搜索人：responseObject：%@",responseObject);
            
            // 清空：每次刷新都需要
            [self.dataArray removeAllObjects];
            
            // 解析数据，模型存到数组
            [self.dataArray addObjectsFromArray:[CYSearchViewCellModel arrayOfModelsFromDictionaries:responseObject[@"res"][@"data"][@"list"]]];
            
            // 刷新数据
            [self.baseTableView reloadData];
            
            // 判断是否显示搜索结果Label
            [self showSearchLabel];
            
            // 请求数据结束，取消加载
            [self hidenLoadingView];
            
        }
        else{
            NSLog(@"搜索人：搜索失败:responseObject:%@",responseObject);
            NSLog(@"搜索人：搜索失败:responseObject:res:msg:%@",responseObject[@"res"][@"msg"]);
            // 1.2.1.1.2.2、搜索人失败：弹窗提示：获取失败的返回信息
            [self showHubWithLabelText:responseObject[@"res"][@"msg"] andHidAfterDelay:3.0];
            
        }
        
    } whenFailure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"搜索人请求：请求失败！");
        
        [self showHubWithLabelText:@"请检查网络" andHidAfterDelay:3.0];
        
    } withToken:self.onlyUser.userToken];
    
}


// 是否显示搜索结果label
- (void)showSearchLabel{
    
    
    // 显示搜索框：没有搜索到人
    if (self.dataArray.count == 0) {
        
        // 搜索框显示
        self.searchResultLab.hidden = NO;
        
        // 搜索结构框显示内容
        self.searchResultLab.text = @"没有搜索到您要搜索的内容";
    }
    
    // 不显示搜索框：搜索到人
    else{
        
        // 搜索框隐藏
        self.searchResultLab.hidden = YES;
    }
    
}



// tableView有多少组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

// 每组多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}



// cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CYSearchViewCell *searchViewCell = [tableView dequeueReusableCellWithIdentifier:@"CYSearchViewCell" forIndexPath:indexPath];
    
    // 加关注：点击事件
    [searchViewCell.followBtn addTarget:self action:@selector(followBtnClickWithBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    searchViewCell.searchModel = self.dataArray[indexPath.row];
    
    
    
    return searchViewCell;
    
}

// 加关注：点击事件
- (void)followBtnClickWithBtn:(UIButton *)followBtn{
    NSLog(@"加关注：点击事件");
    
    // tableViewCell上面button的父类的父类：为tableViewCell
    UITableViewCell *tempView = (UITableViewCell *)[[followBtn superview] superview];
    
    // tableView类 调用方法，获取cell的indexPath
    NSIndexPath *indexPath = [self.baseTableView indexPathForCell:tempView];
    
    CYSearchViewCellModel *searchViewCellModel = self.dataArray[indexPath.row];
    
    // 如果已关注，则取消关注
    if (searchViewCellModel.Follow == YES) {
        // 网络请求：取消关注
        [self delFollowWithSearchViewCellModel:searchViewCellModel];
    }
    // 如果没关注，则加关注
    else {
        
        // 网络请求：加关注
        [self addFollowWithSearchViewCellModel:searchViewCellModel];
    }
    
    
    
    
}

// 网络请求：取消关注
- (void)delFollowWithSearchViewCellModel:(CYSearchViewCellModel *)searchViewCellModel{
    
    // 网络请求：取消关注
    // 参数
    NSString *newUrl = [NSString stringWithFormat:@"%@?userId=%@&oppUserId=%@",cDelFollowUrl,self.onlyUser.userID,searchViewCellModel.Id];
    
    [self showLoadingView];
    
    // 取消关注
    [CYNetWorkManager postRequestWithUrl:newUrl params:nil progress:^(NSProgress *uploadProgress) {
        NSLog(@"取消关注：progress:%@",uploadProgress);
        
        
    } whenSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"取消关注：请求成功！");
        
        
        // 2.3.1.1、获取code 值
        NSString *code = responseObject[@"code"];
        
        // 2.3.1.2、判断返回值
        if ([code isEqualToString:@"0"]) {
            NSLog(@"取消关注：取消成功！");
            
            // 隐藏菊花
//            [self hidenLoadingView];
            
            // 刷新数据
            [self loadData];
            
        }
        else{
            NSLog(@"取消关注：取消失败！");
            NSLog(@"msg:%@",responseObject[@"res"][@"msg"]);
            
            
            // 2.3.1.2.2、取消关注失败，弹窗
            [self showHubWithLabelText:responseObject[@"res"][@"msg"] andHidAfterDelay:3.0];
        }
        
    } whenFailure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"取消关注：请求失败！");
        NSLog(@"error:%@",error);
        
        // 取消关注：请求：失败，加载菊花消失
        [self hidenLoadingView];
        
        // 2.3.1.2.2、取消取消失败，弹窗
        [self showHubWithLabelText:@"网络错误，请重新上传！" andHidAfterDelay:3.0];
        
        
    } withToken:self.onlyUser.userToken];
}

// 网络请求：加关注
- (void)addFollowWithSearchViewCellModel:(CYSearchViewCellModel *)searchViewCellModel{
    
    // 网络请求：加关注
    // 参数
    NSString *newUrl = [NSString stringWithFormat:@"%@?userId=%@&oppUserId=%@",cAddFollowUrl,self.onlyUser.userID,searchViewCellModel.Id];
    
    [self showLoadingView];
    
    // 加关注
    [CYNetWorkManager postRequestWithUrl:newUrl params:nil progress:^(NSProgress *uploadProgress) {
        NSLog(@"加关注：progress:%@",uploadProgress);
        
        
    } whenSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"加关注：请求成功！");
        
        
        // 2.3.1.1、获取code 值
        NSString *code = responseObject[@"code"];
        
        // 2.3.1.2、判断返回值
        if ([code isEqualToString:@"0"]) {
            NSLog(@"加关注：关注成功！");
            
            // 隐藏菊花
//            [self hidenLoadingView];
            
            // 刷新数据
            [self loadData];
            
        }
        else{
            NSLog(@"加关注：关注失败！");
            NSLog(@"msg:%@",responseObject[@"res"][@"msg"]);
            
            
            // 2.3.1.2.2、加关注失败，弹窗
            [self showHubWithLabelText:responseObject[@"res"][@"msg"] andHidAfterDelay:3.0];
        }
        
    } whenFailure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"加关注：请求失败！");
        NSLog(@"error:%@",error);
        
        // 加关注：请求：失败，加载菊花消失
        [self hidenLoadingView];
        
        // 2.3.1.2.2、加关注请求失败，弹窗
        [self showHubWithLabelText:@"网络错误，请重新上传！" andHidAfterDelay:3.0];
        
        
    } withToken:self.onlyUser.userToken];
}

// cell：点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"点击了第 %ld 行 cell",(long)indexPath.row);
    
    //当离开某行时，让某行的选中状态消失
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CYSearchViewCellModel *currentCellModel = self.dataArray[indexPath.row];
    
    
    // 他人详情页
    CYOthersInfoVC *othersInfoVC = [[CYOthersInfoVC alloc] init];
    
//    othersInfoVC.view.frame = CGRectMake(0, 0, 400, 400);
    
    othersInfoVC.oppUserId = currentCellModel.Id;
    
    othersInfoVC.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:othersInfoVC animated:YES];
    
}

// cell 的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return (190.0 / 1108) * self.view.frame.size.height;
}

// 为了设置第一行距顶部navigation 的距离
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.1;
}

// 最后一行距底部的距离
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 1;
}

- (UITextField *)searchTextField{
    
    if (_searchTextField == nil) {
        
        _searchTextField = [[UITextField alloc] init];
    }
    
    return _searchTextField;
}

- (UILabel *)searchResultLab{
    
    if (_searchResultLab == nil) {
        _searchResultLab = [[UILabel alloc] init];
    }
    
    return _searchResultLab;
    
}


@end
