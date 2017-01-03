//
//  ZCYSwipeViewController.m
//  ZCYWangYi
//
//  Created by dgp on 16/6/14.
//  Copyright © 2016年 ZCY. All rights reserved.
//

#import "ZCYSwipeViewController.h"
#import "ZCYSegment.h"


@interface ZCYSwipeViewController ()<UIScrollViewDelegate>


{
    
    
    
    
    // 上部导航条button
    ZCYSegment *_seg;
    
    // 上部滚动条button 下面的线
    UIView *_line;
    
}


// 子视图控制器数组
@property (nonatomic,copy)NSArray *subVCArr;

// 标题数组 上部button
@property (nonatomic,copy)NSArray *titlesArr;



@end

@implementation ZCYSwipeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // 初始化_bgScrollView
    [self setupBgScrollView];
    
    
    // 初始化segment
    [self setupSegment];
    
}

// 初始化segment
- (void)setupSegment{
    
//    __block NSInteger page = 0;
    _seg = [[ZCYSegment alloc] initWithFrame:CGRectMake((25.0 / 750.0) * self.view.frame.size.width, (10.0 / 1334.0) * self.view.frame.size.height, (700.0 / 750.0) * self.view.frame.size.width, (66.0 / 1334.0) * self.view.frame.size.height) withTitles:_titlesArr action:^(NSInteger index){
        
        // 修改contentOfSet
        //   1.
        //        _bgScroll.contentOffset = CGPointMake(index * SCREEN_WIDTH, 0);
        //   2.
        [_bgScrollView setContentOffset:CGPointMake(index * cScreen_Width, 0) animated:YES];
        
        // 添加视图（也可以用代理，在滑动结束的时候添加）
        [self addSubViewToBgScrollViewWithIndex:index];
        
//        page = index;
    }];
    
    // 添加到上部导航栏
//    if (page == 0 || page == 2) {
//        
//        self.navigationItem.titleView = _seg;
//    }
//    else{
//        
//       [self.view addSubview:_seg];
//    }
    [self.view addSubview:_seg];
    
    
    // 找到对应的line
    _line = [_seg valueForKey:@"line"];
    
}

// 初始化_bgScrollView
- (void)setupBgScrollView{
    
    // 自动填充上面的64
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // 初始化scrollView
    _bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, (76.0 / 1334) * self.view.frame.size.height, cScreen_Width, cScreen_Height)];
    
    // 设置scrollView 的 frame
    [self setScrollViewFrame];
    
    // 代理
    _bgScrollView.delegate = self;
    
    // 翻页
    _bgScrollView.pagingEnabled = YES;
    
    // 横向滚动条
    _bgScrollView.showsHorizontalScrollIndicator = NO;
    
    
    
    // 添加到视图
    [self.view addSubview:_bgScrollView];
    
    
    // 添加第0个视图：默认第0个视图显示出来
    [self addSubViewToBgScrollViewWithIndex:0];
    
    
    // 设置_bgScrollView 的范围大小
    _bgScrollView.contentSize = CGSizeMake(cScreen_Width * _subVCArr.count, 0);
    
}

// 设置scrollView 的 frame
- (void)setScrollViewFrame{
    
    _bgScrollView.frame = CGRectMake(0, (76.0 / 1334) * self.view.frame.size.height, cScreen_Width, cScreen_Height);
}


// 添加视图到对应的scrollView
- (void)addSubViewToBgScrollViewWithIndex:(NSInteger)index{
    
    // 判断
    if (index > _subVCArr.count - 1) {
        
        // 超出范围，直接返回
        return;
    }
    
    // 将你所选择的视图控制器的view 添加到底部scrollView 上
    //  先获取对应的视图控制器
    UIViewController *tempVC = _subVCArr[index];
    
    // 如果已经有父视图（即已经添加过此视图），则不再添加
    if (!tempVC.view.superview) {
    
        // 指定位置
        tempVC.view.frame = CGRectMake(index * cScreen_Width, 0, cScreen_Width, _bgScrollView.bounds.size.height);
        
        // 背景颜色
//        tempVC.view.backgroundColor = [UIColor colorWithRed:arc4random() % 256 / 256.0 green:arc4random() % 256 / 256.0 blue:arc4random() % 256 / 256.0 alpha:1.0];
        
        
        // 添加到_bgScrollView
        [_bgScrollView addSubview:tempVC.view];
    }

}

#pragma mark --ScrollViewDelegate 代理
// 停止减速
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    // 获取当前的页数
    NSInteger index = scrollView.contentOffset.x / cScreen_Width;
    
    // 添加当前的页 到视图
    [self addSubViewToBgScrollViewWithIndex:index];
    
    
    // 选中当前的button
    [_seg selectWithIndex:index];
    
    
}

// 停止拖拽
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    
}


// 视图滚动的时候：实时联动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    // 计算button 占一个界面的比例
    CGFloat ratio = (_seg.frame.size.width / _titlesArr.count) / cScreen_Width;
    
    // 获取line 的frame
    CGRect frame = _line.frame;
    
    // 改变line的frame：按比例缩放
    frame.origin.x = scrollView.contentOffset.x * ratio;
    
    // 赋值
    _line.frame = frame;
}


// 懒加载：初始化subVC
//  保存子视图控制器以及标题
- (instancetype)initWithSubVC:(NSArray *)subVCArr andTitles:(NSArray *)titlesArr{
    
    if (self = [super init]) {
        
        // 初始化视图数组
        self.subVCArr = subVCArr;
        
        // 创建子视图控制器
        for (UIViewController *vc in self.subVCArr) {
            
            [self addChildViewController:vc];
        }
        
        // 初始化标题数组
        self.titlesArr = titlesArr;
    }
    
    return self;
}


@end
