//
//  CYBaseTableViewController.m
//  nzny
//
//  Created by 男左女右 on 2016/10/19.
//  Copyright © 2016年 nznychina. All rights reserved.
//

#import "CYBaseTableViewController.h"




@interface CYBaseTableViewController ()

@end

@implementation CYBaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
//    _dataArray = [[NSMutableArray alloc] init];
    
    
    
    
    // 创建视图
    [self creatView];
    
    
    
    // 提前注册
    [_baseTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellID"];
    
//    [_tableView registerNib:[UINib nibWithNibName:@"CYInfoHeaderCell" bundle:nil] forCellReuseIdentifier:@"CYInfoHeaderCell"];
    
//    [self loadData];
    
}
// 下拉刷新
- (void)refresh{
    
    _curPage = 1;
    
    [self loadData];
    
}

// 上拉加载
- (void)loadMore{
    
    _curPage++;
    
    [self loadData];
    
}

- (void)loadData{
    NSLog(@"tableView 子类需要重写loadData 这个方法，如果没有重写，就会打印这句话");
    
    // 假数据
    
    
    self.dataArray = (NSMutableArray *)@[
                        @[
                            @{
                                @"cellTitle" : @"头像",
                                @"cellIcon" : @"默认头像"
                                },
                            @{
                                @"cellTitle" : @"姓名",
                                @"cellDetailTitle" : @"张大大"
                                },
                            @{
                                @"cellTitle" : @"用户ID",
                                @"cellDetailTitle" : @"18"
                                },
                            @{
                                @"cellTitle" : @"性别",
                                @"cellDetailTitle" : @"男"
                                },
                            @{
                                @"cellTitle" : @"年龄",
                                @"cellDetailTitle" : @"18"
                                },
                            @{
                                @"cellTitle" : @"婚姻状况",
                                @"cellDetailTitle" : @"未知"
                                },
                            @{
                                @"cellTitle" : @"所在地区",
                                @"cellDetailTitle" : @"未知"
                                },
                            
                            
                            ],
                        @[
                            @{
                                @"cellTitle" : @"爱情宣言",
                                @"cellDetailTitle" : @"守护一颗心"
                                }
                            ]
                        ];
    
    
}


// 创建视图
- (void)creatView{
    
    // 创建tableView
    _baseTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    
    // 代理
    _baseTableView.delegate = self;
    _baseTableView.dataSource = self;
    
//    self.view = _baseTableView;
    
    // 添加到控制器
    [self.view addSubview:_baseTableView];
    
}



#pragma mark --UITableViewDataSource代理
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
    
    //标示符
    static NSString *cellId = @"cellID";
    
    // 从缓冲池查找ID对象，
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    
    // 没有就创建
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    //设置箭头
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    NSDictionary *tempCellDict = self.dataArray[indexPath.section][indexPath.row];
    
    cell.textLabel.text = tempCellDict[@"cellTitle"];
    cell.imageView.image = [UIImage imageNamed:tempCellDict[@"cellIcon"]];
    cell.detailTextLabel.text = tempCellDict[@"cellDetailTitle"];
    
    
    
    
    
    return cell;
    
}

@end
