//
//  CYVideoVC.m
//  nzny
//
//  Created by 男左女右 on 2016/11/22.
//  Copyright © 2016年 nznychina. All rights reserved.
//

#import "CYVideoVC.h"

// 视频cell：View
#import "CYVideoCollectionViewCell.h"


// 视频cell模型
#import "CYVideoCollectionViewCellModel.h"



// 消息列表
#import "CYChatListVC.h"

// 是否为好友模型
#import "CYVideoIsFriendModel.h"

// 加好友界面：VC
#import "CYAddFriendVC.h"
// 聊天界面：VC
#import "CYChatVC.h"

// 他人详情页
//#import "CYOthersInfoVC.h"

// 视频详情页
#import "CYVideoDetailsVC.h"

#define cVideoCollectionCellWidth ((340.0 / 750.0) * cScreen_Width)
#define cVideoCollectionCellHeight ((340.0 / 1334.0) * cScreen_Height)

@interface CYVideoVC ()

@end

@implementation CYVideoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
//    self.baseCollectionView.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.96 alpha:1.00];
//    self.baseCollectionView.backgroundColor = [UIColor redColor];
    
    // 添加下拉刷新
    self.baseCollectionView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self refresh];
        
    }];
    
    // 添加上拉加载
    self.baseCollectionView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        [self loadMore];
        
    }];
    
    
    // 设置navigationBarButtonItem
//    [self setNavBarBtnItem];
    
    // 加载数据
//    [self loadData];
    
//    // cell Header重新加载
//    [self.baseCollectionView.header beginRefreshing];
    
    // 提前注册
    [self.baseCollectionView registerNib:[UINib nibWithNibName:@"CYVideoCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"CYVideoCollectionViewCell"];
    
    self.baseCollectionView.frame = CGRectMake(0, 0, cScreen_Width, cScreen_Height - 64 - 49 - (76.0 / 1334) * cScreen_Height);
    
}



//- (void)viewWillAppear:(BOOL)animated{
////    [super viewWillAppear:animated];
//    
////    [self loadData];
//    // tabbar：显示
//    self.parentViewController.hidesBottomBarWhenPushed = NO;
//    
//}



// collection代理
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    CYVideoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CYVideoCollectionViewCell" forIndexPath:indexPath];
    
    //    cell.backgroundView.userInteractionEnabled = NO;
    //    cell.playBtn.userInteractionEnabled = YES;
    
    //    [cell bringSubviewToFront:cell.playBtn];
    //    [cell.playBtn becomeFirstResponder];
    
    
    // 播放按钮：点击事件
//    [cell.playBtn addTarget:self action:@selector(playBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    // 联系他按钮：点击事件
    [cell.connectBtn addTarget:self action:@selector(connectBtnClickWithConnectBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    // 联系他：button：添加到最上层
    [cell bringSubviewToFront:cell.connectBtn];
    
    CYVideoCollectionViewCellModel *tempCollectionCellModel = self.dataArray[indexPath.row];
    
    tempCollectionCellModel.connectTitle = [NSString stringWithFormat:@"联系 TA"];
    
    // 模型赋值
    cell.videoCellModel = tempCollectionCellModel;
    
    
    return cell;
}



// 设置cell 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(cVideoCollectionCellWidth, cVideoCollectionCellHeight);
    
}


// playBtn
- (void)playBtnClick{
    NSLog(@"视频playBtn:点击事件");
    
}

// connectBtn：联系他
- (void)connectBtnClickWithConnectBtn:(UIButton *)connectBtn{
    NSLog(@"视频connectBtn:点击事件");
    
    
    // collectionViewCell上面button的父类为collectionViewCell
    UICollectionViewCell *tempView = (UICollectionViewCell *)[connectBtn superview];
    
    // collectionView类 调用方法，获取cell的indexPath
    NSIndexPath *indexPath = [self.baseCollectionView indexPathForCell:tempView];
    
    NSLog(@"当前的cell：%ld",indexPath.row);
    
    // 模型：当前选中的cell
    CYVideoCollectionViewCellModel *videoCellModel = self.dataArray[indexPath.row];
    
    // 网络请求：联系他
    // 参数
    NSString *newUrlStr = [NSString stringWithFormat:@"api/Relationship/contact?userId=%@&oppUserId=%@",self.onlyUser.userID,videoCellModel.VideoUserId];
    
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
                [self chatViewWithOppUserId:videoCellModel.VideoUserId andOppUserName:videoCellModel.VideoUserName];
            }
            else {
                
                // 加好友界面
                [self addFriendViewWithOppUserId:videoCellModel.VideoUserId];
                
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

// 选中了collectionCell：点击事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
        NSLog(@"选中了第 %ld 个collectionCell",indexPath.row);
    
    // 他人详情页
//    CYOthersInfoVC *othersInfoVC = [[CYOthersInfoVC alloc] init];
//    
//    othersInfoVC.view.frame = CGRectMake(0, 0, 400, 400);
//    
//    othersInfoVC.hidesBottomBarWhenPushed = YES;
//    
//    [self.navigationController pushViewController:othersInfoVC animated:YES];
    
    
    
    // 模型
    CYVideoCollectionViewCellModel *videoCellModel = self.dataArray[indexPath.row];
    
    // 视频详情页
    CYVideoDetailsVC *videoDetailsVC = [[CYVideoDetailsVC alloc] init];
    
    videoDetailsVC.oppUserId = videoCellModel.VideoUserId;
    videoDetailsVC.indexPath = nil;
    
    //  导航条设置为不透明的（这样创建的视图（0，0）点，是在导航条左下角开始的。）
    UINavigationController *tempVideoNav = [CYUtilities createDefaultNavCWithRootVC:videoDetailsVC BgColor:nil TintColor:[UIColor whiteColor] translucent:NO titleColor:[UIColor whiteColor] title:@"" bgImg:[UIImage imageNamed:@"Title1"]];
    
    [self showViewController:tempVideoNav sender:self];
    
}

@end
