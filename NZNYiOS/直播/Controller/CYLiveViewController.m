//
//  CYLiveViewController.m
//  NZNYiOS
//
//  Created by 男左女右 on 16/8/17.
//  Copyright © 2016年 NZNY. All rights reserved.
//

#import "CYLiveViewController.h"

// 是否为好友模型
#import "CYVideoIsFriendModel.h"
// 加好友界面：VC
#import "CYAddFriendVC.h"
// 聊天界面:VC
#import "CYChatVC.h"

// 直播拉流模型:model
#import "CYLiveCollectionViewCellModel.h"

// 直播详情页:VC
#import "CYLivePlayDetailsVC.h"

#define cCollectionCellWidth ((340.0 / 750.0) * self.view.frame.size.width)
#define cCollectionCellHeight (195)
//#define cCollectionCellHeight ((390.0 / 1334.0) * self.view.frame.size.height)
#define cCellMinLine ((20.0 / 750.0) * self.view.frame.size.width)
#define cCellMinInteritem ((20.0 / 1334.0) * self.view.frame.size.height)
#define cCellEdgeTop ((10.0 / 1334.0) * self.view.frame.size.height)
#define cCellEdgeLeft ((25.0 / 750.0) * self.view.frame.size.width)
#define cCellEdgeDown ((10.0 / 1334.0) * self.view.frame.size.height)
#define cCellEdgeRight ((25.0 / 750.0) * self.view.frame.size.width)

@interface CYLiveViewController ()

@end

@implementation CYLiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // 添加下拉刷新
    self.baseCollectionView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self refresh];
        
    }];
    
    // 添加上拉加载
    self.baseCollectionView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        [self loadMore];
        
    }];
    
    // View的背景颜色
//    self.view.backgroundColor = [UIColor cyanColor];
    
    // 加载数据
    [self loadData];
    
    
    
    
    // 提前注册
    [self.baseCollectionView registerNib:[UINib nibWithNibName:@"CYLiveCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"CYLiveCollectionViewCell"];
    
    
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
    // tabbar：显示
    self.hidesBottomBarWhenPushed = NO;
    
}


//// 选中了collectionCell：点击事件
//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//    NSLog(@"选中了第 %ld 个collectionCell",indexPath.row);
//    
//    
////    // 融云SDK
////    // 新建一个聊天会话viewController 对象
////    CYChatVC *chatVC = [[CYChatVC alloc] init];
////    
////    
////    
////    // 设置会话的类型，如单聊、讨论组、群聊、聊天室、客服、公众服务会话等
////    
////    // 聊天室
////    chatVC.conversationType = ConversationType_CHATROOM;
////    
////    // 模型
//////    CYMyFriendViewCellModel *tempMyFriendModel = self.dataArray[indexPath.row];
////    
////    // 设置会话的目标会话ID。（单聊、客服、公众服务号会话为对方的ID，讨论组、群聊、聊天室为会话的ID）
////    chatVC.targetId = @"聊天室1";
////    
////    // 设置聊天会话界面要显示的标题
////    chatVC.title = @"聊天室1~~";
////    
////    chatVC.hidesBottomBarWhenPushed = YES;
////    
////    // 显示聊天会话界面
////    [self.navigationController pushViewController:chatVC animated:YES];
////    
////    self.hidesBottomBarWhenPushed = NO;
//    
//    
//    // 模型
//    CYLiveCollectionViewCellModel *liveCellModel = self.dataArray[indexPath.row];
//    
//    // 直播详情页
//    CYLivePlayDetailsVC *livePlayDetailsVC = [[CYLivePlayDetailsVC alloc] init];
//    
//    livePlayDetailsVC.liveID = liveCellModel.LiveId;
//    
//    //  导航条设置为不透明的（这样创建的视图（0，0）点，是在导航条左下角开始的。）
//    UINavigationController *tempVideoNav = [CYUtilities createDefaultNavCWithRootVC:livePlayDetailsVC BgColor:nil TintColor:[UIColor whiteColor] translucent:NO titleColor:[UIColor whiteColor] title:@"" bgImg:[UIImage imageNamed:@"Title1"]];
//    
//    [self showViewController:tempVideoNav sender:self];
//    
//}


// connectBtn：联系他
- (void)connectBtnClickWithConnectBtn:(UIButton *)connectBtn{
    NSLog(@"直播connectBtn:点击事件");
    
    
    // collectionViewCell上面button的父类 的父类 为collectionViewCell：因为connectBtn上多一个View，所以要多一个superView
    UICollectionViewCell *tempView = (UICollectionViewCell *)[[connectBtn superview] superview];
    
    // collectionView类 调用方法，获取cell的indexPath
    NSIndexPath *indexPath = [self.baseCollectionView indexPathForCell:tempView];
    
    NSLog(@"当前的cell：%ld",indexPath.row);
    
    // 模型：当前选中的cell
    CYLiveCollectionViewCellModel *liveCellModel = self.dataArray[indexPath.row];
    
    // 网络请求：联系他
    // 参数
    NSString *newUrlStr = [NSString stringWithFormat:@"api/Relationship/contact?userId=%@&oppUserId=%@",self.onlyUser.userID,liveCellModel.LiveUserId];
    
    // 网络请求：联系他
    [CYNetWorkManager postRequestWithUrl:newUrlStr params:nil progress:^(NSProgress *uploadProgress) {
        NSLog(@"联系他：progress:%@",uploadProgress);
        
        
    } whenSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"联系他：请求成功！");
        NSLog(@"responseObject：%@",responseObject);
        NSLog(@"responseObject:res:IsFriend:%@",responseObject[@"res"][@"IsFriend"]);
        
        //        NSString *isFriend = responseObject[@"res"][@"IsFriend"];
        //        NSLog(@"isFriend：%@",isFriend);
        
        // 2.3.1.1、获取code 值
        NSString *code = responseObject[@"code"];
        
        
#warning 为什么 IsFriend 打印中有值，但是赋值时是没有值的？？？？？？？
        CYVideoIsFriendModel *isFriendModel = [[CYVideoIsFriendModel alloc]initWithDictionary:responseObject[@"res"] error:nil];
        // 判断是否是朋友
        BOOL isFriend = isFriendModel.IsFriend;
        
        // 2.3.1.2、判断返回值
        if ([code isEqualToString:@"0"]) {
            NSLog(@"联系他：关注成功！");
            
            
            if (isFriend) {
                
                // 聊天界面
                [self chatViewWithOppUserId:liveCellModel.LiveUserId andOppUserName:liveCellModel.LiveUserName];
            }
            else {
                
                // 加好友界面
                [self addFriendViewWithOppUserId:liveCellModel.LiveUserId];
                
            }
            
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

// 聊天界面
- (void)chatViewWithOppUserId:(NSString *)oppUserId andOppUserName:(NSString *)oppUserName{
    NSLog(@"聊天界面");
    
    // 融云SDK
    // 新建一个聊天会话viewController 对象
    CYChatVC *chatVC = [[CYChatVC alloc] init];
    
    
    
    // 设置会话的类型，如单聊、讨论组、群聊、聊天室、客服、公众服务会话等
    chatVC.conversationType = ConversationType_PRIVATE;
    
    
    // 设置会话的目标会话ID。（单聊、客服、公众服务号会话为对方的ID，讨论组、群聊、聊天室为会话的ID）
    chatVC.targetId = oppUserId;
    
    // 设置聊天会话界面要显示的标题
    chatVC.title = oppUserName;
    
    self.parentViewController.hidesBottomBarWhenPushed = YES;
    //    self.hidesBottomBarWhenPushed = YES;
    
    // 显示聊天会话界面
    [self.navigationController pushViewController:chatVC animated:YES];
    
    // tabbar：显示
    self.parentViewController.hidesBottomBarWhenPushed = NO;
}
// 加好友界面
- (void)addFriendViewWithOppUserId:(NSString *)oppUserId{
    NSLog(@"加好友界面");
    
    //        CYNotFriendTipVC *notFriendVC = [[CYNotFriendTipVC alloc] init];
    //
    //        notFriendVC.OppUserId = othersInfoViewModel.Id;
    //
    //        [self presentViewController:notFriendVC animated:YES completion:nil];
    CYAddFriendVC *addFriendVC = [[CYAddFriendVC alloc] init];
    
    addFriendVC.OppUserId = oppUserId;
    
    
    [self presentViewController:addFriendVC animated:YES completion:nil];
}


// 设置cell 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(cCollectionCellWidth, cCollectionCellHeight);
    
}

// 设置cell 的 边界距离
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    // 上、左、下、右
    return UIEdgeInsetsMake(cCellEdgeTop, cCellEdgeLeft, cCellEdgeDown, cCellEdgeRight);
}


@end
