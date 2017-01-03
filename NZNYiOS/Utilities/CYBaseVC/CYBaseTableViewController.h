//
//  CYBaseTableViewController.h
//  nzny
//
//  Created by 男左女右 on 2016/10/19.
//  Copyright © 2016年 nznychina. All rights reserved.
//

#import "CYBaseViewController.h"

// 下拉刷新下拉加载
#import "MJRefresh.h"

@interface CYBaseTableViewController : CYBaseViewController<UITableViewDataSource,UITableViewDelegate>


//@property (nonatomic, strong) NSMutableArray *dataArray;

// tableView
@property (nonatomic, strong) UITableView *baseTableView;

// 创建视图
- (void)creatView;

// 加载数据
- (void)loadData;




// 页码
@property (nonatomic,assign)NSInteger curPage;


// 下拉刷新
- (void)refresh;

// 上拉加载
- (void)loadMore;

@end
