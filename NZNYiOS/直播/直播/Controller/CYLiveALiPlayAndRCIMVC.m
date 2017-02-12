//
//  CYLiveALiPlayAndRCIMVC.m
//  nzny
//
//  Created by 男左女右 on 2016/12/29.
//  Copyright © 2016年 nznychina. All rights reserved.
//

#import "CYLiveALiPlayAndRCIMVC.h"
#import "RCDLiveMessageCell.h"
#import "RCDLiveTextMessageCell.h"
#import "RCDLiveGiftMessageCell.h"
#import "RCDLiveGiftMessage.h"
#import "RCDLiveTipMessageCell.h"
#import "RCDLiveMessageModel.h"
#import "RCDLive.h"
#import "RCDLiveCollectionViewHeader.h"
#import "RCDLiveKitUtility.h"
#import "RCDLiveKitCommonDefine.h"
#import <RongIMLib/RongIMLib.h>
#import <objc/runtime.h>
#import "RCDLiveTipMessageCell.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "RCDLivePortraitViewCell.h"
//#import "KSYLivePlaying.h"




// 测试融云聊天室和阿里直播推流用
//#import "RCDLiveChatRoomViewController.h"





// 阿里播放器：界面：VC
#import "AliVcMoiveViewController.h"

// 观众列表cell：模型
#import "CYAudienceListCellModel.h"


// 他人详情页：VC
#import "CYOthersInfoVC.h"
// 联系他
// 是否为好友:模型
#import "CYVideoIsFriendModel.h"
// 聊天界面：VC
#import "CYChatVC.h"
// 加好友弹窗：VC
#import "CYAddFriendVC.h"
// 送礼弹窗：VC
#import "CYGiveGiftTipVC.h"
// 送礼弹窗：View
#import "CYGiveGiftTipWithMoneyView.h"


// 点赞弹窗：VC
#import "CYLikeTipVC.h"
// 点赞弹窗：View
#import "CYLikeTipWithMoneyView.h"

// 余额不足弹窗：VC
#import "CYBalanceNotEnoughVC.h"
// 余额不足弹窗：View
#import "CYBalanceNotEnoughView.h"
// 充值界面：VC
#import "CYRechargeVC.h"


//输入框的高度
#define MinHeight_InputView 50.0f
#define kBounds [UIScreen mainScreen].bounds.size
@interface CYLiveALiPlayAndRCIMVC () <
//UICollectionViewDelegate,
//UICollectionViewDataSource,
//UICollectionViewDelegateFlowLayout,
//UIGestureRecognizerDelegate,
//UIScrollViewDelegate,
UINavigationControllerDelegate,

RCDLiveMessageCellDelegate,
RCTKInputBarControlDelegate,
//RCConnectionStatusChangeDelegate,

RCIMConnectionStatusDelegate,


UITextFieldDelegate
>


// 送礼弹窗：View
@property(nonatomic, strong) CYGiveGiftTipWithMoneyView *giveGiftTipView;
// 点赞弹窗：View
@property(nonatomic, strong) CYLikeTipWithMoneyView *likeTipWithMoneyView;
// 余额不足弹窗：View
@property(nonatomic, strong) CYBalanceNotEnoughView *balanceNotEnoughView;


//
@property(nonatomic, strong)RCDLiveCollectionViewHeader *collectionViewHeader;

/**
 *  存储长按返回的消息的model
 */
@property(nonatomic, strong) RCDLiveMessageModel *longPressSelectedModel;

/**
 *  是否需要滚动到底部
 */
@property(nonatomic, assign) BOOL isNeedScrollToButtom;

/**
 *  是否正在加载消息
 */
@property(nonatomic) BOOL isLoading;

/**
 *  会话名称
 */
@property(nonatomic,copy) NSString *navigationTitle;

/**
 *  点击空白区域事件
 */
@property(nonatomic, strong) UITapGestureRecognizer *resetBottomTapGesture;

/**
 *  金山视频播放器manager
 */
//@property(nonatomic, strong) KSYLivePlaying *livePlayingManager;

/**
 *  直播互动文字显示
 */
@property(nonatomic,strong) UIView *titleView ;

/**
 *  播放器view
 */
@property(nonatomic,strong) UIView *liveView;

/**
 *  底部显示未读消息view
 */
@property (nonatomic, strong) UIView *unreadButtonView;
@property(nonatomic, strong) UILabel *unReadNewMessageLabel;

/**
 *  滚动条不在底部的时候，接收到消息不滚动到底部，记录未读消息数
 */
@property (nonatomic, assign) NSInteger unreadNewMsgCount;

/**
 *  当前融云连接状态
 */
@property (nonatomic, assign) RCConnectionStatus currentConnectionStatus;

/**
 *  返回按钮
 */
@property (nonatomic, strong) UIButton *backBtn;

/**
 *  鲜花按钮
 */
@property(nonatomic,strong)UIButton *flowerBtn;

/**
 *  评论按钮
 */
@property(nonatomic,strong)UIButton *feedBackBtn;

/**
 *  掌声按钮
 */
@property(nonatomic,strong)UIButton *clapBtn;


// 进入直播间的用户列表：View
@property(nonatomic,strong)UICollectionView *portraitsCollectionView;


// 用户列表：array
@property(nonatomic,strong)NSMutableArray *userList;



@end

/**
 *  文本cell标示
 */
static NSString *const rctextCellIndentifier = @"rctextCellIndentifier";

/**
 *  小灰条提示cell标示
 */
static NSString *const RCDLiveTipMessageCellIndentifier = @"RCDLiveTipMessageCellIndentifier";

/**
 *  礼物cell标示
 */
static NSString *const RCDLiveGiftMessageCellIndentifier = @"RCDLiveGiftMessageCellIndentifier";

@implementation CYLiveALiPlayAndRCIMVC




- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self rcinit];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self rcinit];
    }
    return self;
}

- (void)rcinit {
    
    // 聊天内容的消息Cell数据模型的数据源
    self.conversationDataRepository = [[NSMutableArray alloc] init];
    
    // 用户列表
    self.userList = [[NSMutableArray alloc] init];
    
    // 聊天界面的CollectionView
    self.conversationMessageCollectionView = nil;
    
    // 目标会话ID
    self.targetId = nil;
    
    //  *  注册监听Notification
    [self registerNotification];
    
    // 设置进入聊天室需要获取的历史消息数量
    self.defaultHistoryMessageCountOfChatRoom = 10;
    
    // 设置IMLib的连接状态监听器
    //    [[RCIMClient sharedRCIMClient]setRCConnectionStatusChangeDelegate:self];
    [[RCIM sharedRCIM] setConnectionStatusDelegate:self];
}

/**
 *  注册监听Notification
 */
- (void)registerNotification {
    //注册接收消息
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(didReceiveMessageNotification:)
     name:RCDLiveKitDispatchMessageNotification
     object:nil];
}



// 聊天界面的CollectionView：注册cell
/**
 *  注册cell
 *
 *  @param cellClass  cell类型
 *  @param identifier cell标示
 */
- (void)registerClass:(Class)cellClass forCellWithReuseIdentifier:(NSString *)identifier {
    [self.conversationMessageCollectionView registerClass:cellClass
                               forCellWithReuseIdentifier:identifier];
}

/**
 *  页面加载
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // AppDelegate里面添加的假用户
    //    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    //    self.userList = delegate.userList;
    
    
    //初始化UI
    [self initializedSubViews];
    
    
    
    // 上部：头像、姓名、观看人数、观众：view
    [self initChatroomMemberInfo];
    
    
    // 观众：提前注册：collectionView
    [self.portraitsCollectionView registerClass:[RCDLivePortraitViewCell class] forCellWithReuseIdentifier:@"portraitcell"];
    
    
    
    
    
    // 初始化视频直播
    [self initializedLiveSubViews];
    
    
    
    // 当前会话类型为聊天室时，加入聊天室
    [self joinChatRoomWithChatRoomId:self.targetId];
    NSLog(@"CYLiveALiPlayAndRCIMVC:%@",self.targetId);
    
    
    //    __weak CYLiveALiPlayAndRCIMVC *weakSelf = self;
    //
    //
    //
    //    //聊天室类型进入时需要调用加入聊天室接口，退出时需要调用退出聊天室接口
    //    // 当前会话类型为聊天室时，加入聊天室
    //    if (ConversationType_CHATROOM == self.conversationType) {
    //        [[RCIMClient sharedRCIMClient]
    //         joinChatRoom:self.targetId
    //         messageCount:-1
    //         success:^{
    //             dispatch_async(dispatch_get_main_queue(), ^{
    //
    //
    //#warning 可以用自己的视频播放器
    //                 // 视频播放器：初始化，并带入视频地址
    //                 //                 self.livePlayingManager = [[KSYLivePlaying alloc] initPlaying:self.contentURL];
    //                 //                 self.livePlayingManager = [[LELivePlaying alloc] initPlaying:@"201604183000000z4"];
    //                 //                 self.livePlayingManager = [[QINIULivePlaying alloc] initPlaying:@"rtmp://live.hkstv.hk.lxdns.com/live/hks"];
    //                 //                 self.livePlayingManager = [[QCLOUDLivePlaying alloc] initPlaying:@"http://2527.vod.myqcloud.com/2527_117134a2343111e5b8f5bdca6cb9f38c.f20.mp4"];
    //
    //                 // 初始化视频直播
    //                 [self initializedLiveSubViews];
    //
    //                 // 开始播放
    //                 //                 [self.livePlayingManager startPlaying];
    //
    //
    //                 // 通知消息类：谁加入了聊天室
//                     RCInformationNotificationMessage *joinChatroomMessage = [[RCInformationNotificationMessage alloc]init];
    //                 joinChatroomMessage.message = [NSString stringWithFormat: @"%@加入了聊天室",[RCDLive sharedRCDLive].currentUserInfo.name];
    //                 [self sendMessage:joinChatroomMessage pushContent:nil];
    //             });
    //         }
    //         error:^(RCErrorCode status) {
    //             dispatch_async(dispatch_get_main_queue(), ^{
    //                 if (status == KICKED_FROM_CHATROOM) {
    //                     [weakSelf loadErrorAlert:NSLocalizedStringFromTable(@"JoinChatRoomRejected", @"RongCloudKit", nil)];
    //                 } else {
    //                     [weakSelf loadErrorAlert:NSLocalizedStringFromTable(@"JoinChatRoomFailed", @"RongCloudKit", nil)];
    //                 }
    //             });
    //         }];
    //    }
    
}

// 加载数据
- (void)loadData{
    
    // 网络请求：直播详情页
    
    // 新地址
    NSDictionary *params = @{
                             @"userId":self.onlyUser.userID,
                             @"id":self.liveID
                             };
    
    [self showLoadingView];
    
    // 网络请求：直播详情页
    [CYNetWorkManager getRequestWithUrl:cLiveDetaillUrl params:params progress:^(NSProgress *uploadProgress) {
        NSLog(@"获取直播详情页进度：%@",uploadProgress);
        
        
    } whenSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"直播详情页：请求成功！");
        
        // 1、
        NSString *code = responseObject[@"code"];
        
        // 1.2.1.1.2、和成功的code 匹配
        if ([code isEqualToString:@"0"]) {
            NSLog(@"直播详情页：获取成功！");
            NSLog(@"直播详情页：%@",responseObject);
            
            // 清空：每次刷新都需要
            [self.dataArray removeAllObjects];
            
            // 解析数据，模型存到数组
            //            [self.dataArray addObject:[[CYLivePlayDetailsViewModel alloc] initWithDictionary:responseObject[@"res"][@"data"][@"model"] error:nil]];
            
            // 模型
            CYLivePlayDetailsViewModel *tempLivePlayDetailsViewModel = [[CYLivePlayDetailsViewModel alloc] initWithDictionary:responseObject[@"res"][@"data"][@"model"] error:nil];
            
            tempLivePlayDetailsViewModel.isPlayView = YES;
            //            tempLivePlayDetailsViewModel.isTrailer = self.isTrailer;
            
            // 模型赋值
            _livePlayDetailsView.livePlayDetailsModel = tempLivePlayDetailsViewModel;
            
            self.oppUserId = tempLivePlayDetailsViewModel.LiveUserId;
            //
            //
            //            self.targetId = responseObject[@"res"][@"data"][@"model"][@"DiscussionId"];
            
            //
            //
            //            // 初始化视频直播
            //            [self initializedLiveSubViews];
            //
            //
            //
            //            // 当前会话类型为聊天室时，加入聊天室
            //            [self joinChatRoomWithChatRoomId:self.targetId];
            
            
            // 网络请求：直播间观众
            [self requestLiveAudienceWithLiveId:tempLivePlayDetailsViewModel.LiveId];
            
            // 请求数据结束，取消加载
            [self hidenLoadingView];
            
            
        }
        else{
            NSLog(@"直播详情页：获取失败:responseObject:%@",responseObject);
            NSLog(@"直播详情页：获取失败:responseObject:res:msg:%@",responseObject[@"res"][@"msg"]);
            // 1.2.1.1.2.2、获取失败：弹窗提示：获取失败的返回信息
            [self showHubWithLabelText:responseObject[@"res"][@"msg"] andHidAfterDelay:3.0];
            
        }
        
        
    } whenFailure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"直播详情页：请求失败！");
        NSLog(@"失败原因：error：%@",error);
        
        [self showHubWithLabelText:@"请检查网络，重新加载" andHidAfterDelay:3.0];
    } withToken:self.onlyUser.userToken];
    
}

// 当前会话类型为聊天室时，加入聊天室
- (void)joinChatRoomWithChatRoomId:(NSString *)chatRoomId{
    
    
    
    __weak CYLiveALiPlayAndRCIMVC *weakSelf = self;
    
    //聊天室类型进入时需要调用加入聊天室接口，退出时需要调用退出聊天室接口
    // 当前会话类型为聊天室时，加入聊天室
    if (ConversationType_CHATROOM == self.conversationType) {
        
        [[RCIMClient sharedRCIMClient]
         joinChatRoom:chatRoomId
         messageCount:-1
         success:^{
             dispatch_async(dispatch_get_main_queue(), ^{
                 
                 
                 // 只有聊天室
                 RCDLiveGiftMessage *giftMessage = [[RCDLiveGiftMessage alloc]init];
                 giftMessage.type = @"2";
                 giftMessage.tempMessageType = @"2";
                 giftMessage.tempMessageContentStr = @"进入直播间";
                 giftMessage.content = @"进入直播间";
                 [self sendMessage:giftMessage pushContent:@""];
                 
                 
                 
             });
         }
         error:^(RCErrorCode status) {
             dispatch_async(dispatch_get_main_queue(), ^{
                 if (status == KICKED_FROM_CHATROOM) {
                     [weakSelf loadErrorAlert:NSLocalizedStringFromTable(@"JoinChatRoomRejected", @"RongCloudKit", nil)];
                 } else {
                     [weakSelf loadErrorAlert:NSLocalizedStringFromTable(@"JoinChatRoomFailed", @"RongCloudKit", nil)];
                 }
             });
         }];
    }
}

// 网络请求：直播间观众
- (void)requestLiveAudienceWithLiveId:(NSString *)liveId{
    NSLog(@"网络请求：直播间观众");
    
    // 网络请求：直播间观众
    
    // 新地址
    NSDictionary *params = @{
                             @"liveRoomId":liveId
                             };
    
    [self showLoadingView];
    
    // 网络请求：直播间观众
    [CYNetWorkManager getRequestWithUrl:cLiveRoomPeopleUrl params:params progress:^(NSProgress *uploadProgress) {
        NSLog(@"获取直播间观众进度：%@",uploadProgress);
        
        
    } whenSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"直播间观众：请求成功！");
        
        // 1、
        NSString *code = responseObject[@"code"];
        
        // 1.2.1.1.2、和成功的code 匹配
        if ([code isEqualToString:@"0"]) {
            NSLog(@"直播间观众：获取成功！");
            NSLog(@"直播间观众：%@",responseObject);
            
            // 清空：每次刷新都需要
            [self.dataArray removeAllObjects];
            
            // 解析数据，模型存到数组
            
            [self.userList addObjectsFromArray:[CYAudienceListCellModel arrayOfModelsFromDictionaries:responseObject[@"res"][@"data"][@"list"]]];
            
            [self.portraitsCollectionView reloadData];
            
            
            // 请求数据结束，取消加载
            [self hidenLoadingView];
            
            
        }
        else{
            NSLog(@"直播间观众：获取失败:responseObject:%@",responseObject);
            NSLog(@"直播间观众：获取失败:responseObject:res:msg:%@",responseObject[@"res"][@"msg"]);
            // 1.2.1.1.2.2、获取失败：弹窗提示：获取失败的返回信息
            [self showHubWithLabelText:responseObject[@"res"][@"msg"] andHidAfterDelay:3.0];
            
        }
        
        
    } whenFailure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"直播间观众：请求失败！");
        NSLog(@"失败原因：error：%@",error);
        
        [self showHubWithLabelText:@"请检查网络，重新加载" andHidAfterDelay:3.0];
    } withToken:self.onlyUser.userToken];
    
}



/**
 *  加入聊天室失败的提示
 *
 *  @param title 提示内容
 */
- (void)loadErrorAlert:(NSString *)title {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [self.navigationController popViewControllerAnimated:YES];
        
    }];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
    [self.view addGestureRecognizer:_resetBottomTapGesture];
    [self.conversationMessageCollectionView reloadData];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    
    // 加载数据：上部头像数据
    [self loadData];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.navigationTitle = self.navigationItem.title;
    
}


/**
 *  移除监听
 *
 *  @param animated <#animated description#>
 */
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:@"kRCPlayVoiceFinishNotification"
     object:nil];
    
    [self.conversationMessageCollectionView removeGestureRecognizer:_resetBottomTapGesture];
    [self.conversationMessageCollectionView
     addGestureRecognizer:_resetBottomTapGesture];
    
}

/**
 *  回收的时候需要消耗播放器和退出聊天室
 */
- (void)dealloc {
    //    [self quitConversationViewAndClear];
}

/**
 *  点击返回的时候消耗播放器和退出聊天室
 *
 *  @param sender sender description
 */
- (void)leftBarButtonItemPressed:(id)sender {
    [self quitConversationViewAndClear];
}

// 清理环境（退出讨论组、移除监听等）
- (void)quitConversationViewAndClear {
    if (self.conversationType == ConversationType_CHATROOM) {
        
        
        // 销毁播放器
        //        if (self.livePlayingManager) {
        //            [self.livePlayingManager destroyPlaying];
        //        }
        
        //        [[RCIM sharedRCIM] quitDiscussion:<#(NSString *)#> success:<#^(RCDiscussion *discussion)successBlock#> error:<#^(RCErrorCode status)errorBlock#>];
        // 退出聊天室
        [[RCIMClient sharedRCIMClient] quitChatRoom:self.targetId
                                            success:^{
                                                self.conversationMessageCollectionView.dataSource = nil;
                                                self.conversationMessageCollectionView.delegate = nil;
                                                [[NSNotificationCenter defaultCenter] removeObserver:self];
                                                [[RCDLive sharedRCDLive]logoutRongCloud];
                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                    [self.navigationController popViewControllerAnimated:YES];
                                                });
                                                
                                            } error:^(RCErrorCode status) {
                                                
                                            }];
    }
}



#pragma mark--------------------------- 上部视图：开始 ---------------------------------------
// 上部：头像、姓名、观看人数、观众：view
- (void)initChatroomMemberInfo{
    
    // 头像、姓名、观看人数：View
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(45, 30, 85, 35)];
    view.backgroundColor = [UIColor whiteColor];
    view.layer.cornerRadius = 35/2;
    view.alpha = 0.5;
    //    [self.view addSubview:view];
    
    
    // 头像
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(1, 1, 34, 34)];
    imageView.image = [UIImage imageNamed:@"head"];
    imageView.layer.cornerRadius = 34/2;
    imageView.layer.masksToBounds = YES;
    //    [view addSubview:imageView];
    
    
    // 姓名、观看人数：label
    UILabel *chatroomlabel = [[UILabel alloc] initWithFrame:CGRectMake(37, 0, 45, 35)];
    chatroomlabel.numberOfLines = 2;
    chatroomlabel.font = [UIFont systemFontOfSize:12.f];
    chatroomlabel.text = [NSString stringWithFormat:@"小海豚\n2890人"];
    //    [view addSubview:chatroomlabel];
    
    
    
    // 观众：collectionView
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 16;
    layout.sectionInset = UIEdgeInsetsMake(0.0f, 20.0f, 0.0f, 20.0f);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    CGFloat memberHeadListViewX = view.frame.origin.x + view.frame.size.width;
    self.portraitsCollectionView  = [[UICollectionView alloc] initWithFrame:CGRectMake(memberHeadListViewX,30,self.view.frame.size.width - memberHeadListViewX,35) collectionViewLayout:layout];
    self.portraitsCollectionView.delegate = self;
    self.portraitsCollectionView.dataSource = self;
    self.portraitsCollectionView.backgroundColor = [UIColor clearColor];
    //    [self.view addSubview:self.portraitsCollectionView];
    
    
    [self.livePlayDetailsView.liveRoomPeopleListView addSubview:self.portraitsCollectionView];
    
    
    // 注册cell
    [self.portraitsCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
}

/**
 *  初始化页面控件
 */
- (void)initializedSubViews {
    
    
    // 上部用户信息界面：VC
    [self addTopUserInfoVC];
    
    
    
    
    //聊天区
    // 消息列表CollectionView和输入框都在这个view里
    if(self.contentView == nil){
        CGRect contentViewFrame = CGRectMake(0, self.view.bounds.size.height-237, self.view.bounds.size.width,237);
        //        self.contentView.backgroundColor = RCDLive_RGBCOLOR(235, 235, 235);
        self.contentView.backgroundColor = [UIColor redColor];
        self.contentView = [[UIView alloc]initWithFrame:contentViewFrame];
        [self.view addSubview:self.contentView];
        
        UIImageView *chatViewBg = [[UIImageView alloc] initWithFrame:contentViewFrame];
        chatViewBg.image = [UIImage imageNamed:@"直播详情底部"];
        //        [self.contentView insertSubview:chatViewBg atIndex:0];
        
    }
    
    
    
    //聊天消息区：cell
    if (nil == self.conversationMessageCollectionView) {
        UICollectionViewFlowLayout *customFlowLayout = [[UICollectionViewFlowLayout alloc] init];
        customFlowLayout.minimumLineSpacing = 0;
        customFlowLayout.sectionInset = UIEdgeInsetsMake(10.0f, 0.0f,5.0f, 0.0f);
        customFlowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        // frame
        CGRect _conversationViewFrame = self.contentView.bounds;
        _conversationViewFrame.origin.y = 0;
        
        // 设置frame小于聊天区50
        _conversationViewFrame.size.height = self.contentView.bounds.size.height - (_livePlayDetailsView.bottomAllBtnView.frame.size.height / 667.0 * cScreen_Height);
        
        NSLog(@"_livePlayDetailsView.bottomAllBtnView.frame.size.height:%f",_livePlayDetailsView.bottomAllBtnView.frame.size.height);
        
        _conversationViewFrame.size.width = 240;
        self.conversationMessageCollectionView =
        [[UICollectionView alloc] initWithFrame:_conversationViewFrame
                           collectionViewLayout:customFlowLayout];
        [self.conversationMessageCollectionView
         setBackgroundColor:[UIColor clearColor]];
        self.conversationMessageCollectionView.showsHorizontalScrollIndicator = NO;
        self.conversationMessageCollectionView.alwaysBounceVertical = YES;
        
        
        self.conversationMessageCollectionView.dataSource = self;
        self.conversationMessageCollectionView.delegate = self;
        
        // 加入到聊天区View
        [self.contentView addSubview:self.conversationMessageCollectionView];
    }
    
    
    
    
    //输入区：文本框
    if(self.inputBar == nil){
        
        // frame：y：在聊天消息区cell 的下面
        float inputBarOriginY = self.conversationMessageCollectionView.bounds.size.height +30;
        float inputBarOriginX = self.conversationMessageCollectionView.frame.origin.x;
        float inputBarSizeWidth = self.contentView.frame.size.width;
        float inputBarSizeHeight = MinHeight_InputView;
        self.inputBar = [[RCDLiveInputBar alloc]initWithFrame:CGRectMake(inputBarOriginX, inputBarOriginY,inputBarSizeWidth,inputBarSizeHeight)];
        self.inputBar.delegate = self;
        self.inputBar.backgroundColor = [UIColor clearColor];
        
        // 先隐藏
        self.inputBar.hidden = YES;
        
        // 加入到聊天区View
        [self.contentView addSubview:self.inputBar];
    }
    
    
    // 聊天界面出现之前，显示的加载界面
    self.collectionViewHeader = [[RCDLiveCollectionViewHeader alloc]
                                 initWithFrame:CGRectMake(0, -50, self.view.bounds.size.width, 40)];
    _collectionViewHeader.tag = 1999;
    self.collectionViewHeader.backgroundColor = [UIColor redColor];
    [self.conversationMessageCollectionView addSubview:_collectionViewHeader];
    
    
    
    
    // 提前注册
    [self registerClass:[RCDLiveTextMessageCell class]forCellWithReuseIdentifier:rctextCellIndentifier];
    [self registerClass:[RCDLiveTipMessageCell class]forCellWithReuseIdentifier:RCDLiveTipMessageCellIndentifier];
    [self registerClass:[RCDLiveGiftMessageCell class]forCellWithReuseIdentifier:RCDLiveGiftMessageCellIndentifier];
    
    
    
    
    // 全屏和半屏模式切换：一些控件的添加
    [self changeModel:YES];
    
    
    
    // 点击空白区域事件：输入工具栏为初始化状态
    _resetBottomTapGesture =[[UITapGestureRecognizer alloc]
                             initWithTarget:self
                             action:@selector(tap4ResetDefaultBottomBarStatus:)];
    [_resetBottomTapGesture setDelegate:self];
    
    
    
    // 返回按钮：button
    _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _backBtn.frame = CGRectMake(10, 35, 72, 25);
    UIImageView *backImg = [[UIImageView alloc]
                            initWithImage:[UIImage imageNamed:@"back.png"]];
    backImg.frame = CGRectMake(0, 0, 25, 25);
    [_backBtn addSubview:backImg];
    [_backBtn addTarget:self
                 action:@selector(leftBarButtonItemPressed:)
       forControlEvents:UIControlEventTouchUpInside];
    //    [self.view addSubview:_backBtn];
    
    
    
    
    // 评论按钮：button
    _feedBackBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
    _feedBackBtn.frame = CGRectMake(10, self.view.frame.size.height - 45, 35, 35);
    UIImageView *clapImg = [[UIImageView alloc]
                            initWithImage:[UIImage imageNamed:@"feedback"]];
    clapImg.frame = CGRectMake(0,0, 35, 35);
    [_feedBackBtn addSubview:clapImg];
    [_feedBackBtn addTarget:self
                     action:@selector(showInputBar:)
           forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_feedBackBtn];
    
    
    // 送礼按钮：button：点击事件
    // 鲜花按钮：button
    _flowerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _flowerBtn.frame = CGRectMake(self.view.frame.size.width-90, self.view.frame.size.height - 45, 35, 35);
    UIImageView *clapImg2 = [[UIImageView alloc]
                             initWithImage:[UIImage imageNamed:@"giftIcon"]];
    clapImg2.frame = CGRectMake(0,0, 35, 35);
    [_flowerBtn addSubview:clapImg2];
    
    
    [_flowerBtn addTarget:self
                   action:@selector(flowerButtonPressed:)
         forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_flowerBtn];
    
    
    
    // 掌声按钮：button
    _clapBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _clapBtn.frame = CGRectMake(self.view.frame.size.width-45, self.view.frame.size.height - 45, 35, 35);
    UIImageView *clapImg3 = [[UIImageView alloc]
                             initWithImage:[UIImage imageNamed:@"heartIcon"]];
    clapImg3.frame = CGRectMake(0,0, 35, 35);
    [_clapBtn addSubview:clapImg3];
    [_clapBtn addTarget:self
                 action:@selector(clapButtonPressed:)
       forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_clapBtn];
    
    
    
    
    
    // 阿里播放界面：
    //    NSString *newUrl = @"http://live.nznychina.com/n99fbb0d7954afc2e5aeb2c36bd192309/lfff48c7b49a5e3e4eb321065029fb605.m3u8";
    
    NSString *newPlayUrl = self.playUrl;
    [self pushALiPlayerViewControllerWithPlayUrl:newPlayUrl];
    
}

// 上部用户信息界面：VC
- (void)addTopUserInfoVC{
    
    _livePlayDetailsView = [[[NSBundle mainBundle] loadNibNamed:@"CYLivePlayDetailsView" owner:nil options:nil] lastObject];
    
    _livePlayDetailsView.frame = self.view.frame;
    _livePlayDetailsView.bgImgView.hidden = YES;
    _livePlayDetailsView.chatRoomView.hidden = YES;
    // 观众列表
    //    CYAudienceListVC *audienceListVC = [[CYAudienceListVC alloc] init];
    //    audienceListVC.view.frame = _livePlayDetailsView.liveRoomPeopleListView.frame;
    //    audienceListVC.baseCollectionView.frame = _livePlayDetailsView.liveRoomPeopleListView.frame;
    //    NSLog(@"audienceListVC.view.frame.size.height：%lf",audienceListVC.view.frame.size.height);
    //
    //    [_livePlayDetailsView.liveRoomPeopleListView addSubview:audienceListVC.view];
    //    [_livePlayDetailsView.liveRoomPeopleListView addSubview:audienceListVC.baseCollectionView];
    
    
    
    
    //    _livePlayDetailsView.frame = CGRectMake(0, 0, cScreen_Width, cScreen_Height);
    
    
    // 上部头部：手势
    _livePlayDetailsView.topHeadNameFIDFollorView.userInteractionEnabled = YES;
    [_livePlayDetailsView.topHeadNameFIDFollorView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(topHeadNameIDFollowViewClick)]];
    
    // 关注：button：点击事件
    [_livePlayDetailsView.followBtn addTarget:self action:@selector(topFollowBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    // 关闭btn：点击事件
    [_livePlayDetailsView.closeBtn addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    // 发消息btn：点击事件
    [_livePlayDetailsView.sendMessageBtn addTarget:self action:@selector(sendMessageBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    // 联系他btn：点击事件
    [_livePlayDetailsView.connectBtn addTarget:self action:@selector(connectBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    // 送礼btn：点击事件
    [_livePlayDetailsView.sendGiftBtn addTarget:self action:@selector(sendGiftBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    // 点赞btn：点击事件
    [_livePlayDetailsView.likeBtn addTarget:self action:@selector(likeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    // 分享btn：点击事件
    [_livePlayDetailsView.shareBtn addTarget:self action:@selector(shareBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    [self.view addSubview:_livePlayDetailsView];
    //        self.view = _livePlayDetailsView;
    
}


// 上部头部：手势
- (void)topHeadNameIDFollowViewClick{
    NSLog(@"上部头部：手势");
    
    // 他人详情页
    CYOthersInfoVC *othersInfoVC = [[CYOthersInfoVC alloc] init];
    
    othersInfoVC.oppUserId = self.oppUserId;
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController pushViewController:othersInfoVC animated:YES];
    
    //    [othersInfoVC.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
    
}

// 上部头像：关注：点击事件
- (void)topFollowBtnClick{
    NSLog(@"上部头像：关注：点击事件");
    
    [self addFollow];
}
// 网络请求：加关注
- (void)addFollow{
    
    // 网络请求：加关注
    // 参数
    NSString *newUrl = [NSString stringWithFormat:@"%@?userId=%@&oppUserId=%@",cAddFollowUrl,self.onlyUser.userID,self.oppUserId];
    
    [self showLoadingView];
    
    // 网络请求：加关注
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

// 关闭btn：点击事件
- (void)closeBtnClick{
    NSLog(@"关闭btn：点击事件");
    
    
    // 隐藏键盘
    [self.view endEditing:YES];
    
    
    // 网络请求：观众离开直播间
    [self requestAudienceLeaveLiveRoomWithLiveRoomId:self.liveRoomId];
    
    
    // 销毁播放器、退出聊天室
    [self destroyPlayerAndQuitChatRoom];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark--------------------------- 上部视图：结束 ---------------------------------------


// 网络请求：观众离开直播间
- (void)requestAudienceLeaveLiveRoomWithLiveRoomId:(NSString *)liveRoomId{
    NSLog(@"网络请求：观众离开直播间");
    
    
    // 网络请求：观众离开直播间
    // 新地址
    NSString *newUrl = [NSString stringWithFormat:@"%@?liveRoomId=%@",cLeaveLiveRoomUrl,liveRoomId];
    
    //    [self showLoadingView];
    
    // 网络请求：观众离开直播间
    [CYNetWorkManager postRequestWithUrl:newUrl params:nil progress:^(NSProgress *uploadProgress) {
        NSLog(@"获取观众离开直播间进度：%@",uploadProgress);
        
        
    } whenSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"观众离开直播间：请求成功！");
        
        // 1、
        NSString *code = responseObject[@"code"];
        
        // 1.2.1.1.2、和成功的code 匹配
        if ([code isEqualToString:@"0"]) {
            NSLog(@"观众离开直播间：获取成功！");
            NSLog(@"观众离开直播间：%@",responseObject);
            
            
            // 取消加载
            //            [self hidenLoadingView];
            
            
        }
        else{
            NSLog(@"观众离开直播间：获取失败:responseObject:%@",responseObject);
            NSLog(@"观众离开直播间：获取失败:responseObject:res:msg:%@",responseObject[@"res"][@"msg"]);
            // 1.2.1.1.2.2、获取失败：弹窗提示：获取失败的返回信息
            [self showHubWithLabelText:responseObject[@"res"][@"msg"] andHidAfterDelay:3.0];
            
        }
        
        
    } whenFailure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"观众离开直播间：请求失败！");
        NSLog(@"失败原因：error：%@",error);
        
        [self showHubWithLabelText:@"请检查网络，重新加载" andHidAfterDelay:3.0];
    } withToken:self.onlyUser.userToken];
    
    
}



// 销毁播放器、退出聊天室
- (void)destroyPlayerAndQuitChatRoom{
    NSLog(@"销毁播放器、退出聊天室");
    
    
    
    // 销毁播放器
    [self.aliPlayVC closeBtnClickForPlayView];
    
    
    // 退出聊天室
    if (self.conversationType == ConversationType_CHATROOM) {
        
        
        [[RCIMClient sharedRCIMClient] quitChatRoom:self.targetId success:^{
            NSLog(@"退出聊天室：成功！");
            
            self.conversationMessageCollectionView.dataSource = nil;
            self.conversationMessageCollectionView.delegate = nil;
            [[NSNotificationCenter defaultCenter] removeObserver:self];
            
        } error:^(RCErrorCode status) {
            NSLog(@"退出聊天室：失败！");
            
        }];
        
    }
    else {
        NSLog(@"融云：进入的不是聊天室");
    }
    
}


// 发消息btn：点击事件
- (void)sendMessageBtnClick{
    NSLog(@"发消息btn：点击事件");
    
    
}

// 联系他btn：点击事件
- (void)connectBtnClick{
    NSLog(@"联系他btn：点击事件");
    
    
    
    // 网络请求：联系他
    // 参数
    NSString *newUrlStr = [NSString stringWithFormat:@"api/Relationship/contact?userId=%@&oppUserId=%@",self.onlyUser.userID,self.oppUserId];
    
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
        
        
        
        CYVideoIsFriendModel *isFriendModel = [[CYVideoIsFriendModel alloc]initWithDictionary:responseObject[@"res"] error:nil];
        // 判断是否是朋友
        BOOL isFriend = isFriendModel.IsFriend;
        NSLog(@"isFriend:%d",isFriend);
        
        
        // 2.3.1.2、判断返回值
        if ([code isEqualToString:@"0"]) {
            NSLog(@"联系他：关注成功！");
            
            
            if (isFriend) {
                
                // 聊天界面
                [self chatViewWithOppUserId:self.onlyUser.userID andOppUserName:self.oppUserId];
            }
            else {
                
                // 加好友界面
                [self addFriendViewWithOppUserId:self.oppUserId];
                
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
    [self.navigationController pushViewController:chatVC animated:NO];
    
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
    
    
    [self presentViewController:addFriendVC animated:NO completion:nil];
}

// 送礼btn：点击事件
- (void)sendGiftBtnClick{
    NSLog(@"送礼btn：点击事件");
    
    
    // 送礼弹窗
    CYGiveGiftTipVC *giveGiftTipVC = [[CYGiveGiftTipVC alloc] init];
    
    giveGiftTipVC.oppUserId = self.oppUserId;
    
    
    [self presentViewController:giveGiftTipVC animated:NO completion:nil];
}

// 点赞btn：点击事件
- (void)likeBtnClick{
    NSLog(@"点赞btn：点击事件");
    
    
    // 点赞弹窗
    CYLikeTipVC *likeTipVC = [[CYLikeTipVC alloc] init];
    
    likeTipVC.oppUserId = self.oppUserId;
    
    [self presentViewController:likeTipVC animated:NO completion:nil];
    
}

// 分享btn：点击事件
- (void)shareBtnClick{
    NSLog(@"分享btn：点击事件");
    
    
    // 分享：网页分享
    [self sharedToWeChatWithWebpageWithShareTitle:@"APP 下载地址" andDescription:@"男左女右 遇见你的TA" andImage:[UIImage imageNamed:@"logo.png"] andWebpageUrl:cDownLoadUrl andbText:NO andScene:0];
    
}


// 阿里播放界面：VC
- (void)pushALiPlayerViewControllerWithPlayUrl:(NSString *)playUrl{
    
    
    //    playUrl = @"rtmp://live.nznychina.com/nzny/993a5e86-7e4d-4c12-921a-215e425c12f7?auth_key=1485009206-0-0-9e8abda1e86e293c80baafc08dd1f7f5";
    
    
    NSLog(@"newPlayUrl：%@",playUrl);
    
    _aliPlayVC = [[TBMoiveViewController alloc] init];
    
    // 屏幕亮度：因为原本里面的屏幕亮度设置是在viewWillAppear 里面设置的，现在直接把播放器VC的view添加到当前VC的view，不会调用播发器的viewWillAppear方法，所以在这里设置屏幕亮度；
    _aliPlayVC.systemBrightness = [UIScreen mainScreen].brightness;
    
    NSURL* url = [NSURL URLWithString:playUrl];
    
    
    if(url == nil) {
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"错误" message:@"输入地址无效" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alter show];
        return;
    }
    
    
    [_aliPlayVC SetMoiveSource:url];
    
    //    //    [self presentViewController:currentView animated:YES completion:nil ];
    //    UINavigationController *tempVideoNav = [CYUtilities createDefaultNavCWithRootVC:aLiPlayerVC BgColor:nil TintColor:[UIColor whiteColor] translucent:NO titleColor:[UIColor whiteColor] title:@"" bgImg:[UIImage imageNamed:@"Title1"]];
    //
    //    [aLiPlayerVC.navigationController setNavigationBarHidden:YES animated:YES];
    //
    //    [self showViewController:tempVideoNav sender:self];
    
    
    //    [self.view addSubview:aLiPlayerVC.view];
    //    [self.view insertSubview:_aliPlayVC.view atIndex:0];
    
    
}


// 评论按钮：button
-(void)showInputBar:(id)sender{
    NSLog(@"评论按钮：button：点击事件");
    
    // 直播和聊天室
    
    self.inputBar.hidden = NO;
    [self.inputBar setInputBarStatus:RCDLiveBottomBarKeyboardStatus];
}



#pragma mark------------------------ 送礼开始：弹窗 ---------------------------------------
/**
 *  发送鲜花
 *
 *  @param sender sender description
 */
-(void)flowerButtonPressed:(id)sender{
    
    
    
    _giveGiftTipView = [[[NSBundle mainBundle] loadNibNamed:@"CYGiveGiftTipWithMoneyView" owner:nil options:nil] lastObject];
    
    _giveGiftTipView.frame = CGRectMake(0, 0, cScreen_Width, cScreen_Height);
    
    
    
//    if (cScreen_Width == 320) {
//        
//        CGRect tempRect = _giveGiftTipView.oneRoseBtn.frame;
//        
//        _giveGiftTipView.oneRoseBtn.frame = CGRectMake(tempRect.origin.x, tempRect.origin.y - 10, tempRect.size.width, tempRect.size.height - 10);
//    }
    
//    _giveGiftTipView.backgroundColor = [UIColor colorWithRed:0.55 green:0.55 blue:0.55 alpha:0.70];
    _giveGiftTipView.backgroundColor = [UIColor clearColor];
//    _giveGiftTipView.giveGiftBgImgView.hidden = YES;
    
    // tipCloseBtn：关闭弹窗：点击事件
    [_giveGiftTipView.tipCloseBtn addTarget:self action:@selector(giveGiftTipCloseBtnClick) forControlEvents:UIControlEventTouchUpInside];
    // 一支玫瑰花：点击事件
    [_giveGiftTipView.oneRoseBtn addTarget:self action:@selector(oneRoseBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    // 三支玫瑰花：点击事件
    [_giveGiftTipView.threeRoseBtn addTarget:self action:@selector(threeRoseBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    // 九支玫瑰花：点击事件
    [_giveGiftTipView.nineRoseBtn addTarget:self action:@selector(nineRoseBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    // 九十九支玫瑰花：点击事件
    [_giveGiftTipView.ninetyNineRoseBtn addTarget:self action:@selector(ninetyNineRoseBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    // 送礼：textField：文本改变事件
    [_giveGiftTipView.giftCountTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    // 送礼：button：点击事件
    [_giveGiftTipView.giveGiftBtn addTarget:self action:@selector(giveGiftBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    _giveGiftTipView.giftCountTextField.delegate = self;
    
    [self.view addSubview:_giveGiftTipView];
    
    // 直播和聊天室
//    RCDLiveGiftMessage *giftMessage = [[RCDLiveGiftMessage alloc]init];
//    giftMessage.type = @"0";
//    giftMessage.tempMessageType = @"0";
//    giftMessage.tempMessageContentStr = @"为主播送了礼";
//    [self sendMessage:giftMessage pushContent:@""];
    
    
    
    
    // 送礼弹窗
//        CYGiveGiftTipVC *giveGiftTipVC = [[CYGiveGiftTipVC alloc] init];
    //
    //    giveGiftTipVC.oppUserId = self.oppUserId;
    //
    //    [self presentViewController:giveGiftTipVC animated:YES completion:nil];
    
    
}


// 一支玫瑰花：点击事件
- (void)oneRoseBtnClick{
    NSLog(@"一支玫瑰花：点击事件");
    
    // 送礼：玫瑰花数量
    NSInteger roseCount = 1;
    
    // 网络请求：送一支玫瑰花
    [self requestUserBalanceIfIsEnoughWithUserId:self.onlyUser.userID andOppUserId:self.oppUserId andGiftCount:roseCount andCost:(2.0 * roseCount)];
    
}



// 三支玫瑰花：点击事件
- (void)threeRoseBtnClick{
    NSLog(@"三支玫瑰花：点击事件");
    
    // 送礼：玫瑰花数量
    NSInteger roseCount = 3;
    
    // 网络请求：送三支玫瑰花
    [self requestUserBalanceIfIsEnoughWithUserId:self.onlyUser.userID andOppUserId:self.oppUserId andGiftCount:roseCount andCost:(2.0 * roseCount)];
    
}

// 九支玫瑰花：点击事件
- (void)nineRoseBtnClick{
    NSLog(@"九支玫瑰花：点击事件");
    
    // 送礼：玫瑰花数量
    NSInteger roseCount = 9;
    
    // 网络请求：送九支玫瑰花
    [self requestUserBalanceIfIsEnoughWithUserId:self.onlyUser.userID andOppUserId:self.oppUserId andGiftCount:roseCount andCost:(2.0 * roseCount)];
    
}

// 九十九支玫瑰花：点击事件
- (void)ninetyNineRoseBtnClick{
    NSLog(@"九十九支玫瑰花：点击事件");
    
    // 送礼：玫瑰花数量
    NSInteger roseCount = 99;
    
    // 网络请求：送九十九支玫瑰花
    [self requestUserBalanceIfIsEnoughWithUserId:self.onlyUser.userID andOppUserId:self.oppUserId andGiftCount:roseCount andCost:(2.0 * roseCount)];
}


// 送礼：button：点击事件
- (void)giveGiftBtnClick{
    NSLog(@"送礼：button：点击事件");
    
    NSScanner *scan = [NSScanner scannerWithString:self.giveGiftTipView.giftCountTextField.text];
    
    NSInteger flag;
    
    if ([scan scanInteger:&flag] && [scan isAtEnd]) {
        
        // 送礼：玫瑰花数量
        NSInteger roseCount = [self.giveGiftTipView.giftCountTextField.text integerValue];
        
        // 网络请求：送 n 支玫瑰花
        [self requestUserBalanceIfIsEnoughWithUserId:self.onlyUser.userID andOppUserId:self.oppUserId andGiftCount:roseCount andCost:(2.0 * roseCount)];
        
    }
    else {
        
        [self.view bringSubviewToFront:self.hud];
        [self showHubWithLabelText:@"请输入数字" andHidAfterDelay:3.0];
    }
    
    
}


// 网络请求：用户余额：余额够，则送礼请求，不够则充值弹窗
- (void)requestUserBalanceIfIsEnoughWithUserId:(NSString *)userId andOppUserId:(NSString *)oppUserId andGiftCount:(NSInteger)likeCount andCost:(float)cost{
    NSLog(@"用户余额：网络请求！");
    
    [self showLoadingView];
    
    // 新地址
    NSString *newUrl = [NSString stringWithFormat:@"%@?userId=%@",cUserMoneyUrl,userId];
    
    // 网络请求：用户余额
    [CYNetWorkManager getRequestWithUrl:newUrl params:nil progress:^(NSProgress *uploadProgress) {
        NSLog(@"用户余额：%@",uploadProgress);
        
        
    } whenSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"用户余额：请求成功！");
        
        // 1、
        NSString *code = responseObject[@"code"];
        
        // 1.2.1.1.2、和成功的code 匹配
        if ([code isEqualToString:@"0"]) {
            NSLog(@"用户余额：获取成功！");
            NSLog(@"用户余额：%@",responseObject);
            
            
            
            // 请求数据结束，取消加载
            //            [self hidenLoadingView];
            
            
            NSString * tempMoneyStr = responseObject[@"res"][@"data"][@"money"];
            float tempMoney = [tempMoneyStr floatValue];
            
            NSLog(@"tempMoneyStr:%@",tempMoneyStr);
            NSLog(@"tempMoney:%lf",tempMoney);
            NSLog(@"cost:%lf",cost);
            
            // 如果余额够支付，则赞、支付
            if (tempMoney >= cost) {
                
                self.isEnoughForPay = YES;
                
                // 网路请求：送礼
                [self requestGiveGiftWithUserId:self.onlyUser.userID andReceiveUserId:self.oppUserId andGiftCount:likeCount];
                
            }
            // 余额不足，则弹到充值界面
            else {
                
                // 请求数据结束，取消加载
                [self hidenLoadingView];
                
                
                // 余额不足弹窗：VC
//                CYBalanceNotEnoughVC *balanceNotEnoughVC = [[CYBalanceNotEnoughVC alloc] init];
//                
//                
//                //                UINavigationController *tempBalanceNotEnoughNav = [CYUtilities createDefaultNavCWithRootVC:balanceNotEnoughVC BgColor:nil TintColor:[UIColor whiteColor] translucent:NO titleColor:[UIColor whiteColor] title:@"" bgImg:[UIImage imageNamed:@"Title1"]];
//                //
//                //                [balanceNotEnoughVC.navigationController setNavigationBarHidden:YES animated:YES];
//                
//                //                [self showViewController:tempVideoNav sender:self];
//                //                [self presentViewController:tempBalanceNotEnoughNav animated:YES completion:nil];
//                [self presentViewController:balanceNotEnoughVC animated:YES completion:nil];
                
                
                
 #pragma mark------------------------ 余额不足弹窗：开始 --------------------------------------
                
                
                
                _balanceNotEnoughView = [[[NSBundle mainBundle] loadNibNamed:@"CYBalanceNotEnoughView" owner:nil options:nil] lastObject];
                
                _balanceNotEnoughView.frame = CGRectMake(0, 0, cScreen_Width, cScreen_Height);
                
                
                
                if (cScreen_Width == 320) {
                    
//                    CGRect tempRect = _balanceNotEnoughView.oneRoseBtn.frame;
                    
//                    _balanceNotEnoughView.oneRoseBtn.frame = CGRectMake(tempRect.origin.x, tempRect.origin.y - 10, tempRect.size.width, tempRect.size.height - 10);
                }
                
                
                _balanceNotEnoughView.backgroundColor = [UIColor clearColor];
                _balanceNotEnoughView.balanceNotEnoughBgImgView.hidden = YES;
                
                // 余额不足：弹窗关闭：button：点击事件
                [_balanceNotEnoughView.closeBtn addTarget:self action:@selector(balanceNotEnoughCloseBtnClick) forControlEvents:UIControlEventTouchUpInside];
                
                // 立即充值：button：点击事件
                [_balanceNotEnoughView.instantRechargeBtn addTarget:self action:@selector(balanceNotEnoughInstantRechargeBtnClick) forControlEvents:UIControlEventTouchUpInside];
                
                
                // 送礼弹窗：恢复位置
                [UIView animateWithDuration:0.5 animations:^{
                    self.giveGiftTipView.bounds = CGRectMake(0, 0, cScreen_Width, cScreen_Height);
                    
                }];
                // 隐藏键盘
                [self.view endEditing:YES];
                
                
                [self.view addSubview:_balanceNotEnoughView];
                
                
            }
        }
        else{
            NSLog(@"用户余额：获取失败:responseObject:%@",responseObject);
            NSLog(@"用户余额：获取失败:responseObject:res:msg:%@",responseObject[@"res"][@"msg"]);
            // 1.2.1.1.2.2、获取失败：弹窗提示：获取失败的返回信息
            [self showHubWithLabelText:responseObject[@"res"][@"msg"] andHidAfterDelay:3.0];
            
        }
        
        
    } whenFailure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"用户余额：请求失败！");
        NSLog(@"点一个赞：error：%@",error);
        
        [self showHubWithLabelText:@"请检查网络，重新加载" andHidAfterDelay:3.0];
    } withToken:self.onlyUser.userToken];
    
}


// 余额不足：弹窗关闭：button：点击事件
- (void)balanceNotEnoughCloseBtnClick{
    NSLog(@"余额不足：弹窗关闭：button：点击事件");
    
    [self.balanceNotEnoughView removeFromSuperview];
    
}

// 余额不足：立即充值：button：点击事件
- (void)balanceNotEnoughInstantRechargeBtnClick{
    NSLog(@"余额不足：立即充值：button：点击事件");
    
    
    // 充值界面
    CYRechargeVC *rechargeVC = [[CYRechargeVC alloc] init];
    
    [[self navigationControllerWithView:self.view] setNavigationBarHidden:NO animated:YES];
    
    // 导航VC：获取当前视图所在位置的导航控制器
    [[self navigationControllerWithView:self.view] pushViewController:rechargeVC animated:YES];
    
    [self.balanceNotEnoughView removeFromSuperview];
}

#pragma mark------------------------ 充值弹窗：结束 ---------------------------------------

// 送礼：网络请求
- (void)requestGiveGiftWithUserId:(NSString *)userId andReceiveUserId:(NSString *)receiveUserId andGiftCount:(NSInteger)giftCount{
    NSLog(@"送礼：网络请求！");
    
    [self showLoadingView];
    
    // 参数
    NSDictionary *params = @{
                             @"UserId":userId,
                             @"ReceiveUserId":receiveUserId,
                             @"Count":@(giftCount)
                             };
    
    // 网络请求：送 n 支玫瑰花
    [CYNetWorkManager postRequestWithUrl:cAddFlowersUrl params:params progress:^(NSProgress *uploadProgress) {
        NSLog(@"送 %ld 支玫瑰花进度：%@",(long)giftCount,uploadProgress);
        
        
    } whenSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"送 %ld 支玫瑰花：请求成功！",(long)giftCount);
        
        // 1、
        NSString *code = responseObject[@"code"];
        
        // 1.2.1.1.2、和成功的code 匹配
        if ([code isEqualToString:@"0"]) {
            NSLog(@"送 %ld 支玫瑰花：送礼成功！",(long)giftCount);
            NSLog(@"送 %ld 支玫瑰花：%@",(long)giftCount,responseObject);
            
            
            // 请求数据结束，取消加载
            //            [self hidenLoadingView];
            
            [self showHubWithLabelText:[NSString stringWithFormat:@"送%ld朵玫瑰成功！",(long)giftCount] andHidAfterDelay:3.0];
            
            
            
            // 直播和聊天室
            RCDLiveGiftMessage *giftMessage = [[RCDLiveGiftMessage alloc]init];
            giftMessage.type = @"0";
            giftMessage.tempMessageType = @"0";
            giftMessage.tempMessageContentStr = [NSString stringWithFormat:@"送给主播%ld朵玫瑰",(long)giftCount];
            giftMessage.content = [NSString stringWithFormat:@"送给主播%ld朵玫瑰",(long)giftCount];
            [self sendMessage:giftMessage pushContent:@""];
            
            
            [self.giveGiftTipView removeFromSuperview];
            
        }
        else{
            NSLog(@"送 %ld 支玫瑰花：送礼:responseObject:%@",(long)giftCount,responseObject);
            NSLog(@"送 %ld 支玫瑰花：送礼:responseObject:res:msg:%@",(long)giftCount,responseObject[@"res"][@"msg"]);
            // 1.2.1.1.2.2、获取失败：弹窗提示：获取失败的返回信息
            [self showHubWithLabelText:responseObject[@"res"][@"msg"] andHidAfterDelay:3.0];
            
        }
        
        
    } whenFailure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"送 %ld 支玫瑰花：请求失败！",(long)giftCount);
        NSLog(@"失败原因：error：%@",error);
        
        [self showHubWithLabelText:@"请检查网络，重新加载" andHidAfterDelay:3.0];
    } withToken:self.onlyUser.userToken];
    
}


// 重写touchsBegan，点击旁边空白时，让UIView 类的子类，失去第一响应者
#pragma mark --重写touchsBegan
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    
    // 送礼：恢复位置
    [UIView animateWithDuration:0.5 animations:^{
        self.giveGiftTipView.bounds = CGRectMake(0, 0, cScreen_Width, cScreen_Height);
        
    }];
    
    // 点赞：恢复位置
    [UIView animateWithDuration:0.5 animations:^{
        self.likeTipWithMoneyView.bounds = CGRectMake(0, 0, cScreen_Width, cScreen_Height);
        
    }];
    
    for (UIView *tempView in self.view.subviews) {
        if ([tempView isKindOfClass:[UIView class]]) {
            // 失去第一响应者
            [tempView resignFirstResponder];
        }
    }
    
}


// tipCloseBtn：弹窗关闭button：点击事件
- (void)giveGiftTipCloseBtnClick{
    NSLog(@"送礼弹窗：弹窗关闭button：点击事件");
    
    [_giveGiftTipView removeFromSuperview];
}
#pragma mark------------------------ 送礼弹窗：结束 ---------------------------------------



#pragma mark------------------------ 点赞弹窗：开始 ---------------------------------------
/**
 *  发送掌声
 *
 *  @param sender <#sender description#>
 */
-(void)clapButtonPressed:(id)sender{
    
    
    // 直播和聊天室
//    RCDLiveGiftMessage *giftMessage = [[RCDLiveGiftMessage alloc]init];
//    giftMessage.type = @"1";
//    giftMessage.tempMessageType = @"1";
//    giftMessage.tempMessageContentStr = @"为主播点了赞";
//    giftMessage.content = @"为安卓主播点了赞赞赞赞赞赞";
//    [self sendMessage:giftMessage pushContent:@""];
//    [self praiseHeart];
    
    
    
//    RCMessageContent *tempGiftMessage = [[RCMessageContent alloc] init];
    
    
    
    
    
    
    _likeTipWithMoneyView = [[[NSBundle mainBundle] loadNibNamed:@"CYLikeTipWithMoneyView" owner:nil options:nil] lastObject];
    
    _likeTipWithMoneyView.frame = CGRectMake(0, 0, cScreen_Width, cScreen_Height);
    
    _likeTipWithMoneyView.backgroundColor = [UIColor clearColor];
    
    
    // 弹窗关闭：点击事件
    [_likeTipWithMoneyView.tipCloseBtn addTarget:self action:@selector(likeTipViewTipCloseBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    // 1个赞：点击事件
    [_likeTipWithMoneyView.oneLikeBtn addTarget:self action:@selector(likeTipViewOneLikeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    // 10个赞：点击事件
    [_likeTipWithMoneyView.tenLikeBtn addTarget:self action:@selector(likeTipViewTenLikeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    // 32个赞：点击事件
    [_likeTipWithMoneyView.thirtyTwoLikeBtn addTarget:self action:@selector(likeTipViewThirtyTwoLikeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    // 300个赞：点击事件
    [_likeTipWithMoneyView.threeHundredLikeBtn addTarget:self action:@selector(likeTipViewThreeHundredLikeBtnBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    // 点赞：textField：文本改变事件
    [_likeTipWithMoneyView.likeCountTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    // 点赞：button：点击事件
    [_likeTipWithMoneyView.likeBtn addTarget:self action:@selector(likeTipViewlikeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    _likeTipWithMoneyView.likeCountTextField.delegate = self;
    
    [self.view addSubview:_likeTipWithMoneyView];
    
    
    
    
    
}
// 点赞弹窗：弹窗关闭：点击事件
- (void)likeTipViewTipCloseBtnClick{
    NSLog(@"");
    
    [self.likeTipWithMoneyView removeFromSuperview];
}
// 1个赞：点击事件
- (void)likeTipViewOneLikeBtnClick{
    NSLog(@"");
    
    
    NSInteger likeCount = 1;
    
    // 网络请求：用户余额：余额够，则点赞请求，不够则充值弹窗
    [self requestUserBalanceIfIsEnoughWithUserId:self.onlyUser.userID andOppUserId:self.oppUserId andLikeCount:likeCount andCost:(1.0 * likeCount)];
}
// 10个赞：点击事件
- (void)likeTipViewTenLikeBtnClick{
    NSLog(@"");
    
    NSInteger likeCount = 10;
    
    // 网络请求：用户余额：余额够，则点赞请求，不够则充值弹窗
    [self requestUserBalanceIfIsEnoughWithUserId:self.onlyUser.userID andOppUserId:self.oppUserId andLikeCount:likeCount andCost:(1.0 * likeCount)];
}
// 32个赞：点击事件
- (void)likeTipViewThirtyTwoLikeBtnClick{
    NSLog(@"");
    
    NSInteger likeCount = 32;
    
    // 网络请求：用户余额：余额够，则点赞请求，不够则充值弹窗
    [self requestUserBalanceIfIsEnoughWithUserId:self.onlyUser.userID andOppUserId:self.oppUserId andLikeCount:likeCount andCost:(1.0 * likeCount)];
}
// 300个赞：点击事件
- (void)likeTipViewThreeHundredLikeBtnBtnClick{
    NSLog(@"");
    
    NSInteger likeCount = 300;
    
    // 网络请求：用户余额：余额够，则点赞请求，不够则充值弹窗
    [self requestUserBalanceIfIsEnoughWithUserId:self.onlyUser.userID andOppUserId:self.oppUserId andLikeCount:likeCount andCost:(1.0 * likeCount)];
}
// 点赞：button：点击事件
- (void)likeTipViewlikeBtnClick{
    NSLog(@"点赞弹窗：点赞：button：点击事件");
    
    NSScanner *scan = [NSScanner scannerWithString:self.likeTipWithMoneyView.likeCountTextField.text];
    
    NSInteger flag;
    
    if ([scan scanInteger:&flag] && [scan isAtEnd]) {
        
        NSInteger likeCount = [self.likeTipWithMoneyView.likeCountTextField.text integerValue];
        
        // 网络请求：点 n 个赞
        // 网络请求：用户余额：余额够，则点赞请求，不够则充值弹窗
        [self requestUserBalanceIfIsEnoughWithUserId:self.onlyUser.userID andOppUserId:self.oppUserId andLikeCount:likeCount andCost:(1.0 * likeCount)];
        
    }
    else {
        
        [self.view bringSubviewToFront:self.hud];
        [self showHubWithLabelText:@"请输入数字" andHidAfterDelay:3.0];
    }
}

// 网络请求：用户余额：余额够，则点赞请求，不够则充值弹窗
- (void)requestUserBalanceIfIsEnoughWithUserId:(NSString *)userId andOppUserId:(NSString *)oppUserId andLikeCount:(NSInteger)likeCount andCost:(float)cost{
    NSLog(@"用户余额：网络请求！");
    
    [self showLoadingView];
    
    // 新地址
    NSString *newUrl = [NSString stringWithFormat:@"%@?userId=%@",cUserMoneyUrl,userId];
    
    // 网络请求：用户余额
    [CYNetWorkManager getRequestWithUrl:newUrl params:nil progress:^(NSProgress *uploadProgress) {
        NSLog(@"用户余额：%@",uploadProgress);
        
        
    } whenSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"用户余额：请求成功！");
        
        // 1、
        NSString *code = responseObject[@"code"];
        
        // 1.2.1.1.2、和成功的code 匹配
        if ([code isEqualToString:@"0"]) {
            NSLog(@"用户余额：获取成功！");
            NSLog(@"用户余额：%@",responseObject);
            
            
            
            // 请求数据结束，取消加载
            [self hidenLoadingView];
            
            
            NSString * tempMoneyStr = responseObject[@"res"][@"data"][@"money"];
            float tempMoney = [tempMoneyStr floatValue];
            
            // 如果余额够支付，则赞、支付
            if (tempMoney >= cost) {
                
                self.isEnoughForPay = YES;
                
                // 网路请求：点 n 个赞
                [self requestLikeWithUserId:self.onlyUser.userID andReceiveUserId:oppUserId andLikeCount:likeCount andAddLikeUrl:cAddLiveLikeUrl];
                
            }
            // 余额不足，则弹到充值界面
            else {
                
                // 请求数据结束，取消加载
                [self hidenLoadingView];
                
                
                // 余额不足弹窗：VC
//                CYBalanceNotEnoughVC *balanceNotEnoughVC = [[CYBalanceNotEnoughVC alloc] init];
//                
//                UINavigationController *tempBalanceNotEnoughNav = [CYUtilities createDefaultNavCWithRootVC:balanceNotEnoughVC BgColor:nil TintColor:[UIColor whiteColor] translucent:NO titleColor:[UIColor whiteColor] title:@"" bgImg:[UIImage imageNamed:@"Title1"]];
//                
//                [balanceNotEnoughVC.navigationController setNavigationBarHidden:YES animated:YES];
//                
//                //                [self showViewController:tempVideoNav sender:self];
//                [self presentViewController:tempBalanceNotEnoughNav animated:YES completion:nil];
                
                
                
                
                
                
                
                
                
#pragma mark------------------------ 余额不足弹窗：开始 ---------------------------------------
                
                _balanceNotEnoughView = [[[NSBundle mainBundle] loadNibNamed:@"CYBalanceNotEnoughView" owner:nil options:nil] lastObject];
                
                _balanceNotEnoughView.frame = CGRectMake(0, 0, cScreen_Width, cScreen_Height);
                
                
                
                if (cScreen_Width == 320) {
                    
                    //                    CGRect tempRect = _balanceNotEnoughView.oneRoseBtn.frame;
                    
                    //                    _balanceNotEnoughView.oneRoseBtn.frame = CGRectMake(tempRect.origin.x, tempRect.origin.y - 10, tempRect.size.width, tempRect.size.height - 10);
                }
                
                
                _balanceNotEnoughView.backgroundColor = [UIColor clearColor];
                _balanceNotEnoughView.balanceNotEnoughBgImgView.hidden = YES;
                
                // 余额不足：弹窗关闭：button：点击事件
                [_balanceNotEnoughView.closeBtn addTarget:self action:@selector(balanceNotEnoughCloseBtnClick) forControlEvents:UIControlEventTouchUpInside];
                
                // 立即充值：button：点击事件
                [_balanceNotEnoughView.instantRechargeBtn addTarget:self action:@selector(balanceNotEnoughInstantRechargeBtnClick) forControlEvents:UIControlEventTouchUpInside];
                
                
                // 送礼弹窗：恢复位置
                [UIView animateWithDuration:0.5 animations:^{
                    self.likeTipWithMoneyView.bounds = CGRectMake(0, 0, cScreen_Width, cScreen_Height);
                    
                }];
                // 隐藏键盘
                [self.view endEditing:YES];
                
                
                [self.view addSubview:_balanceNotEnoughView];
                
                
                
                
                
                
                
                
                
                
            }
        }
        else{
            NSLog(@"用户余额：获取失败:responseObject:%@",responseObject);
            NSLog(@"用户余额：获取失败:responseObject:res:msg:%@",responseObject[@"res"][@"msg"]);
            // 1.2.1.1.2.2、获取失败：弹窗提示：获取失败的返回信息
            [self showHubWithLabelText:responseObject[@"res"][@"msg"] andHidAfterDelay:3.0];
            
        }
        
        
    } whenFailure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"用户余额：请求失败！");
        NSLog(@"点一个赞：error：%@",error);
        
        [self showHubWithLabelText:@"请检查网络，重新加载" andHidAfterDelay:3.0];
    } withToken:self.onlyUser.userToken];
    
}

// 点赞：网络请求
- (void)requestLikeWithUserId:(NSString *)userId andReceiveUserId:(NSString *)receiveUserId andLikeCount:(NSInteger)likeCount andAddLikeUrl:(NSString *)addLikeUrl{
    NSLog(@"点赞：网络请求！");
    
    [self showLoadingView];
    
    // 参数
    NSDictionary *params = @{
                             @"UserId":userId,
                             @"ReceiveUserId":receiveUserId,
                             @"Count":@(likeCount)
                             };
    
    // 网络请求：点 n 个赞
    [CYNetWorkManager postRequestWithUrl:addLikeUrl params:params progress:^(NSProgress *uploadProgress) {
        NSLog(@"点 %ld 个赞：%@",(long)likeCount,uploadProgress);
        
        
    } whenSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"点 %ld 个赞：请求成功！",(long)likeCount);
        
        // 1、
        NSString *code = responseObject[@"code"];
        
        // 1.2.1.1.2、和成功的code 匹配
        if ([code isEqualToString:@"0"]) {
            NSLog(@"点 %ld 个赞：点赞成功！",(long)likeCount);
            NSLog(@"点 %ld 个赞：%@",(long)likeCount,responseObject);
            
            
            
            
            [self showHubWithLabelText:[NSString stringWithFormat:@"点 %ld 个赞成功！",(long)likeCount] andHidAfterDelay:3.0];
            
            
            // 直播和聊天室
            RCDLiveGiftMessage *giftMessage = [[RCDLiveGiftMessage alloc]init];
            giftMessage.type = @"1";
            giftMessage.tempMessageType = @"1";
            giftMessage.tempMessageContentStr = [NSString stringWithFormat:@"为主播点了 %ld 个赞",(long)likeCount];
            giftMessage.content = [NSString stringWithFormat:@"为主播点了 %ld 个赞",(long)likeCount];
            [self sendMessage:giftMessage pushContent:@""];
            
            
            [self.likeTipWithMoneyView removeFromSuperview];
            
            
        }
        else{
            NSLog(@"点 %ld 个赞：点赞:responseObject:%@",(long)likeCount,responseObject);
            NSLog(@"点 %ld 个赞：点赞:responseObject:res:msg:%@",(long)likeCount,responseObject[@"res"][@"msg"]);
            // 1.2.1.1.2.2、获取失败：弹窗提示：获取失败的返回信息
            [self showHubWithLabelText:responseObject[@"res"][@"msg"] andHidAfterDelay:3.0];
            
        }
        
        
    } whenFailure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"点 %ld 个赞：请求失败！",(long)likeCount);
        NSLog(@"点 %ld 个赞：error：%@",(long)likeCount,error);
        
        [self showHubWithLabelText:@"请检查网络，重新加载" andHidAfterDelay:3.0];
    } withToken:self.onlyUser.userToken];
    
}

#pragma mark------------------------ 点赞弹窗：结束 ---------------------------------------




#pragma mark ---------------------- 点赞、送礼：代理：UITextFieldDelegate：开始 ----------------
-(void)textFieldDidChange :(UITextField *)theTextField{
    NSLog( @"text changed: %@", theTextField.text);
    
    
    // 送礼
    NSScanner *giveGiftScan = [NSScanner scannerWithString:self.giveGiftTipView.giftCountTextField.text];
    
    
    float giveGiftCost = [self.giveGiftTipView.giftCountTextField.text floatValue] * 2.0;
    
    NSInteger giveGiftFlag;
    
    if ([giveGiftScan scanInteger:&giveGiftFlag] && [giveGiftScan isAtEnd]) {
        
        self.giveGiftTipView.tfRoseCountCostLab.text = [NSString stringWithFormat:@"￥%.1f",giveGiftCost];
        
    }
    else {
        
        self.giveGiftTipView.tfRoseCountCostLab.text = @"￥0.0";
    }
    
    
    
    
    
    
    // 点赞
    NSScanner *likeScan = [NSScanner scannerWithString:self.likeTipWithMoneyView.likeCountTextField.text];
    
    
    float likeCost = [self.likeTipWithMoneyView.likeCountTextField.text floatValue] * 1.0;
    
    NSInteger likeFlag;
    
    if ([likeScan scanInteger:&likeFlag] && [likeScan isAtEnd]) {
        
        self.likeTipWithMoneyView.tfLikeCountCostLab.text = [NSString stringWithFormat:@"￥%.1f",likeCost];
        
    }
    else {
        
        self.likeTipWithMoneyView.tfLikeCountCostLab.text = @"￥0.0";
    }
    
    
    
    
}
// 结束打字时恢复原位
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    
    // 送礼：恢复位置
    [UIView animateWithDuration:0.5 animations:^{
        self.giveGiftTipView.bounds = CGRectMake(0, 128, cScreen_Width, cScreen_Height);
    }];
    
    
    // 点赞：恢复位置
    [UIView animateWithDuration:0.5 animations:^{
        self.likeTipWithMoneyView.bounds = CGRectMake(0, 128, cScreen_Width, cScreen_Height);
    }];
    
}

#pragma mark ---------------------- 点赞、送礼：代理：UITextFieldDelegate：结束 ----------------





/**
 *  未读消息View
 *
 *  @return <#return value description#>
 */
- (UIView *)unreadButtonView {
    if (!_unreadButtonView) {
        _unreadButtonView = [[UIView alloc]initWithFrame:CGRectMake((self.view.frame.size.width - 80)/2, self.view.frame.size.height - MinHeight_InputView - 30, 80, 30)];
        _unreadButtonView.userInteractionEnabled = YES;
        _unreadButtonView.backgroundColor = RCDLive_HEXCOLOR(0xffffff);
        _unreadButtonView.alpha = 0.7;
        
        // 点击未读提醒，滚动到底部
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tabUnreadMsgCountIcon:)];
        [_unreadButtonView addGestureRecognizer:tap];
        
        
        _unreadButtonView.hidden = YES;
        
        // 添加底部未读消息View
        [self.view addSubview:_unreadButtonView];
        _unreadButtonView.layer.cornerRadius = 4;
    }
    return _unreadButtonView;
}

/**
 *  底部新消息文字
 *
 *  @return return value description
 */
- (UILabel *)unReadNewMessageLabel {
    if (!_unReadNewMessageLabel) {
        _unReadNewMessageLabel = [[UILabel alloc]initWithFrame:_unreadButtonView.bounds];
        _unReadNewMessageLabel.backgroundColor = [UIColor clearColor];
        _unReadNewMessageLabel.font = [UIFont systemFontOfSize:12.0f];
        _unReadNewMessageLabel.textAlignment = NSTextAlignmentCenter;
        _unReadNewMessageLabel.textColor = RCDLive_HEXCOLOR(0xff4e00);
        [self.unreadButtonView addSubview:_unReadNewMessageLabel];
    }
    return _unReadNewMessageLabel;
    
}

/**
 *  更新底部新消息提示显示状态
 */
- (void)updateUnreadMsgCountLabel{
    if (self.unreadNewMsgCount == 0) {
        self.unreadButtonView.hidden = YES;
    }
    else{
        self.unreadButtonView.hidden = NO;
        self.unReadNewMessageLabel.text = @"底部有新消息";
    }
}

/**
 *  检查是否更新新消息提醒
 */
- (void) checkVisiableCell{
    NSIndexPath *lastPath = [self getLastIndexPathForVisibleItems];
    if (lastPath.row >= self.conversationDataRepository.count - self.unreadNewMsgCount || lastPath == nil || [self isAtTheBottomOfTableView] ) {
        self.unreadNewMsgCount = 0;
        [self updateUnreadMsgCountLabel];
    }
}

/**
 *  获取显示的最后一条消息的indexPath
 *
 *  @return indexPath
 */
- (NSIndexPath *)getLastIndexPathForVisibleItems
{
    NSArray *visiblePaths = [self.conversationMessageCollectionView indexPathsForVisibleItems];
    if (visiblePaths.count == 0) {
        return nil;
    }else if(visiblePaths.count == 1) {
        return (NSIndexPath *)[visiblePaths firstObject];
    }
    NSArray *sortedIndexPaths = [visiblePaths sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSIndexPath *path1 = (NSIndexPath *)obj1;
        NSIndexPath *path2 = (NSIndexPath *)obj2;
        return [path1 compare:path2];
    }];
    return (NSIndexPath *)[sortedIndexPaths lastObject];
}

/**
 *  点击未读提醒滚动到底部
 *
 *  @param gesture gesture description
 */
- (void)tabUnreadMsgCountIcon:(UIGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateEnded) {
        [self scrollToBottomAnimated:YES];
    }
}

/**
 *  初始化视频直播
 */
- (void)initializedLiveSubViews {
    //        _liveView = self.livePlayingManager.currentLiveView;
    
    
    
    _liveView = _aliPlayVC.view;
    
    
    
    _liveView.frame = self.view.frame;
    [self.view addSubview:_liveView];
    [self.view sendSubviewToBack:_liveView];
    
}


/**
 *  全屏和半屏模式切换
 *
 *  @param isFullScreen 全屏或者半屏
 */
- (void)changeModel:(BOOL)isFullScreen {
    
    
    
    // 直播互动文字
    _titleView.hidden = YES;
    
    // 聊天界面的CollectionView
    self.conversationMessageCollectionView.backgroundColor = [UIColor clearColor];
    
    // 消息列表CollectionView和输入框都在这个view里
    CGRect contentViewFrame = CGRectMake(0, self.view.bounds.size.height-237, self.view.bounds.size.width,237);
    // 重新设置frame
    self.contentView.frame = contentViewFrame;
    
    
    
    // 评论按钮
    _feedBackBtn.frame = CGRectMake(10, self.view.frame.size.height - 45, 35, 35);
    _flowerBtn.frame = CGRectMake(self.view.frame.size.width-90, self.view.frame.size.height - 45, 35, 35);
    
    
    // 掌声按钮
    _clapBtn.frame = CGRectMake(self.view.frame.size.width-45, self.view.frame.size.height - 45, 35, 35);
    
    
    
    // 添加播放器View：放到最后面
    [self.view sendSubviewToBack:_liveView];
    
    
    
    // 输入工具栏：frame（输入框）
    float inputBarOriginY = self.conversationMessageCollectionView.bounds.size.height + 30;
    float inputBarOriginX = self.conversationMessageCollectionView.frame.origin.x;
    float inputBarSizeWidth = self.contentView.frame.size.width;
    float inputBarSizeHeight = MinHeight_InputView;
    
    
    //添加输入框：
    [self.inputBar changeInputBarFrame:CGRectMake(inputBarOriginX, inputBarOriginY,inputBarSizeWidth,inputBarSizeHeight)];
    
    
    // 聊天界面的CollectionView：重新加载数据
    [self.conversationMessageCollectionView reloadData];
    
    
    
    // 未读消息：View
    [self.unreadButtonView setFrame:CGRectMake((self.view.frame.size.width - 80)/2, self.view.frame.size.height - MinHeight_InputView - 30, 80, 30)];
}

/**
 *  顶部插入历史消息
 *
 *  @param model 消息Model
 */
- (void)pushOldMessageModel:(RCDLiveMessageModel *)model {
    if (!(!model.content && model.messageId > 0)
        && !([[model.content class] persistentFlag] & MessagePersistent_ISPERSISTED)) {
        return;
    }
    long ne_wId = model.messageId;
    for (RCDLiveMessageModel *__item in self.conversationDataRepository) {
        if (ne_wId == __item.messageId) {
            return;
        }
    }
    [self.conversationDataRepository insertObject:model atIndex:0];
}

/**
 *  加载历史消息(暂时没有保存聊天室消息)
 */
- (void)loadMoreHistoryMessage {
    long lastMessageId = -1;
    if (self.conversationDataRepository.count > 0) {
        RCDLiveMessageModel *model = [self.conversationDataRepository objectAtIndex:0];
        lastMessageId = model.messageId;
    }
    
    NSArray *__messageArray =
    [[RCIMClient sharedRCIMClient] getHistoryMessages:_conversationType
                                             targetId:_targetId
                                      oldestMessageId:lastMessageId
                                                count:10];
    for (int i = 0; i < __messageArray.count; i++) {
        RCMessage *rcMsg = [__messageArray objectAtIndex:i];
        RCDLiveMessageModel *model = [[RCDLiveMessageModel alloc] initWithMessage:rcMsg];
        [self pushOldMessageModel:model];
    }
    [self.conversationMessageCollectionView reloadData];
    if (_conversationDataRepository != nil &&
        _conversationDataRepository.count > 0 &&
        [self.conversationMessageCollectionView numberOfItemsInSection:0] >=
        __messageArray.count - 1) {
        NSIndexPath *indexPath =
        [NSIndexPath indexPathForRow:__messageArray.count - 1 inSection:0];
        [self.conversationMessageCollectionView scrollToItemAtIndexPath:indexPath
                                                       atScrollPosition:UICollectionViewScrollPositionTop
                                                               animated:NO];
    }
}


#pragma mark <UIScrollViewDelegate>
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
}

/**
 *  滚动条滚动时显示正在加载loading
 *
 *  @param scrollView
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // 是否显示右下未读icon
    if (self.unreadNewMsgCount != 0) {
        [self checkVisiableCell];
    }
    
    if (scrollView.contentOffset.y < -5.0f) {
        [self.collectionViewHeader startAnimating];
    } else {
        [self.collectionViewHeader stopAnimating];
        _isLoading = NO;
    }
}

/**
 *  滚动结束加载消息 （聊天室消息还没存储，所以暂时还没有此功能）
 *
 *  @param scrollView scrollView description
 *  @param decelerate decelerate description
 */
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView
                  willDecelerate:(BOOL)decelerate {
    if (scrollView.contentOffset.y < -15.0f && !_isLoading) {
        _isLoading = YES;
    }
}

/**
 *  消息滚动到底部
 *
 *  @param animated 是否开启动画效果
 */
- (void)scrollToBottomAnimated:(BOOL)animated {
    if ([self.conversationMessageCollectionView numberOfSections] == 0) {
        return;
    }
    NSUInteger finalRow = MAX(0, [self.conversationMessageCollectionView numberOfItemsInSection:0] - 1);
    if (0 == finalRow) {
        return;
    }
    NSIndexPath *finalIndexPath =
    [NSIndexPath indexPathForItem:finalRow inSection:0];
    [self.conversationMessageCollectionView scrollToItemAtIndexPath:finalIndexPath
                                                   atScrollPosition:UICollectionViewScrollPositionTop
                                                           animated:animated];
}

#pragma mark <UICollectionViewDataSource>
/**
 *  定义展示的UICollectionViewCell的个数
 *
 *  @return
 */
- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    if ([collectionView isEqual:self.portraitsCollectionView]) {
        return self.userList.count;
    }
    return self.conversationDataRepository.count;
}

/**
 *  每个UICollectionView展示的内容
 *
 *  @return
 */
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if ([collectionView isEqual:self.portraitsCollectionView]) {
        
        
        RCDLivePortraitViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"portraitcell" forIndexPath:indexPath];
        
        CYAudienceListCellModel *tempAudienceListModel = self.userList[indexPath.row];
        
        
        //        RCUserInfo *user = self.userList[indexPath.row];
        //        NSString *str = user.portraitUri;
        
        
        
        //        cell.portaitView.image = [UIImage imageNamed:str];
        cell.portaitView.image = [UIImage imageNamed:tempAudienceListModel.Portrait];
        
        
        
        return cell;
    }
    //NSLog(@"path row is %d", indexPath.row);
    RCDLiveMessageModel *model =
    [self.conversationDataRepository objectAtIndex:indexPath.row];
    RCMessageContent *messageContent = model.content;
    RCDLiveMessageBaseCell *cell = nil;
    if ([messageContent isMemberOfClass:[RCInformationNotificationMessage class]] || [messageContent isMemberOfClass:[RCTextMessage class]] || [messageContent isMemberOfClass:[RCDLiveGiftMessage class]]){
        
        
        RCDLiveTipMessageCell *__cell = [collectionView dequeueReusableCellWithReuseIdentifier:RCDLiveTipMessageCellIndentifier forIndexPath:indexPath];
        
        
        __cell.isFullScreenMode = YES;
        
        
        [__cell setDataModel:model];
        
        
        [__cell setDelegate:self];
        
        
        cell = __cell;
    }
    
    return cell;
}

#pragma mark <UICollectionViewDelegateFlowLayout>

/**
 *  cell的大小
 *
 *  @return
 */
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([collectionView isEqual:self.portraitsCollectionView]) {
        return CGSizeMake(35,35);
    }
    RCDLiveMessageModel *model =
    [self.conversationDataRepository objectAtIndex:indexPath.row];
    if (model.cellSize.height > 0) {
        return model.cellSize;
    }
    RCMessageContent *messageContent = model.content;
    if ([messageContent isMemberOfClass:[RCTextMessage class]] || [messageContent isMemberOfClass:[RCInformationNotificationMessage class]] || [messageContent isMemberOfClass:[RCDLiveGiftMessage class]]) {
        model.cellSize = [self sizeForItem:collectionView atIndexPath:indexPath];
    } else {
        return CGSizeZero;
    }
    return model.cellSize;
}

/**
 *  计算不同消息的具体尺寸
 *
 *  @return
 */
- (CGSize)sizeForItem:(UICollectionView *)collectionView
          atIndexPath:(NSIndexPath *)indexPath {
    
    
    CGFloat __width = CGRectGetWidth(collectionView.frame);
    
    
    RCDLiveMessageModel *model =
    [self.conversationDataRepository objectAtIndex:indexPath.row];
    
    
    RCMessageContent *messageContent = model.content;
    
    CGFloat __height = 0.0f;
    
    NSString *localizedMessage;
    
    if ([messageContent isMemberOfClass:[RCInformationNotificationMessage class]]) {
        
        RCInformationNotificationMessage *notification = (RCInformationNotificationMessage *)messageContent;
        
        localizedMessage = [RCDLiveKitUtility formatMessage:notification];
        
    }else if ([messageContent isMemberOfClass:[RCTextMessage class]]){
        
        
        RCTextMessage *notification = (RCTextMessage *)messageContent;
        
        localizedMessage = [RCDLiveKitUtility formatMessage:notification];
        
        NSString *name;
        
        if (messageContent.senderUserInfo) {
            name = messageContent.senderUserInfo.name;
        }
        localizedMessage = [NSString stringWithFormat:@"%@ %@",name,localizedMessage];
        
        
        
    }else if ([messageContent isMemberOfClass:[RCDLiveGiftMessage class]]){
        
        
        RCDLiveGiftMessage *notification = (RCDLiveGiftMessage *)messageContent;
        
        
        localizedMessage = notification.tempMessageContentStr;
        
        
        
        NSString *name;
        
        
        if (messageContent.senderUserInfo) {
            name = messageContent.senderUserInfo.name;
        }
        
        
        
        localizedMessage = [NSString stringWithFormat:@"%@ %@",name,localizedMessage];
        
        
    }
    
    
    CGSize __labelSize = [RCDLiveTipMessageCell getTipMessageCellSize:localizedMessage];
    
    
    __height = __height + __labelSize.height;
    
    
    return CGSizeMake(__width, __height);
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeZero;
}

#pragma mark <UICollectionViewDelegate>

/**
 *   UICollectionView被选中时调用的方法
 *
 *  @return
 */
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
}


/**
 *  将消息加入本地数组
 *
 *  @return
 */
- (void)appendAndDisplayMessage:(RCMessage *)rcMessage {
    if (!rcMessage) {
        return;
    }
    RCDLiveMessageModel *model = [[RCDLiveMessageModel alloc] initWithMessage:rcMessage];
    if([rcMessage.content isMemberOfClass:[RCDLiveGiftMessage class]]){
        model.messageId = -1;
    }
    if ([self appendMessageModel:model]) {
        NSIndexPath *indexPath =
        [NSIndexPath indexPathForItem:self.conversationDataRepository.count - 1
                            inSection:0];
        if ([self.conversationMessageCollectionView numberOfItemsInSection:0] !=
            self.conversationDataRepository.count - 1) {
            return;
        }
        [self.conversationMessageCollectionView
         insertItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]];
        if ([self isAtTheBottomOfTableView] || self.isNeedScrollToButtom) {
            [self scrollToBottomAnimated:YES];
            self.isNeedScrollToButtom=NO;
        }
    }
}

/**
 *  如果当前会话没有这个消息id，把消息加入本地数组
 *
 *  @return
 */
- (BOOL)appendMessageModel:(RCDLiveMessageModel *)model {
    long newId = model.messageId;
    for (RCDLiveMessageModel *__item in self.conversationDataRepository) {
        /*
         * 当id为－1时，不检查是否重复，直接插入
         * 该场景用于插入临时提示。
         */
        if (newId == -1) {
            break;
        }
        if (newId == __item.messageId) {
            return NO;
        }
    }
    if (!model.content) {
        return NO;
    }
    //这里可以根据消息类型来决定是否显示，如果不希望显示直接return NO
    
    //数量不可能无限制的大，这里限制收到消息过多时，就对显示消息数量进行限制。
    //用户可以手动下拉更多消息，查看更多历史消息。
    if (self.conversationDataRepository.count>100) {
        //                NSRange range = NSMakeRange(0, 1);
        RCDLiveMessageModel *message = self.conversationDataRepository[0];
        [[RCIMClient sharedRCIMClient]deleteMessages:@[@(message.messageId)]];
        
        [self.conversationDataRepository removeObjectAtIndex:0];
        [self.conversationMessageCollectionView reloadData];
    }
    
    [self.conversationDataRepository addObject:model];
    return YES;
}

/**
 *  UIResponder
 *
 *  @return
 */
- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    return [super canPerformAction:action withSender:sender];
}

/**
 *  找出消息的位置
 *
 *  @return
 */
- (NSInteger)findDataIndexFromMessageList:(RCDLiveMessageModel *)model {
    NSInteger index = 0;
    for (int i = 0; i < self.conversationDataRepository.count; i++) {
        RCDLiveMessageModel *msg = (self.conversationDataRepository)[i];
        if (msg.messageId == model.messageId) {
            index = i;
            break;
        }
    }
    return index;
}


/**
 *  打开大图。开发者可以重写，自己下载并且展示图片。默认使用内置controller
 *
 *  @param imageMessageContent 图片消息内容
 */
- (void)presentImagePreviewController:(RCDLiveMessageModel *)model {
}

/**
 *  打开地理位置。开发者可以重写，自己根据经纬度打开地图显示位置。默认使用内置地图
 *
 *  @param locationMessageCotent 位置消息
 */
- (void)presentLocationViewController:
(RCLocationMessage *)locationMessageContent {
    
}

/**
 *  关闭提示框
 *
 *  @param theTimer theTimer description
 */
- (void)timerForHideHUD:(NSTimer*)theTimer//弹出框
{
    __weak __typeof(&*self)weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
    });
    [theTimer invalidate];
    theTimer = nil;
}


/*!
 发送消息(除图片消息外的所有消息)
 
 @param messageContent 消息的内容
 @param pushContent    接收方离线时需要显示的远程推送内容
 
 @discussion 当接收方离线并允许远程推送时，会收到远程推送。
 远程推送中包含两部分内容，一是pushContent，用于显示；二是pushData，用于携带不显示的数据。
 
 SDK内置的消息类型，如果您将pushContent置为nil，会使用默认的推送格式进行远程推送。
 自定义类型的消息，需要您自己设置pushContent来定义推送内容，否则将不会进行远程推送。
 
 如果您需要设置发送的pushData，可以使用RCIM的发送消息接口。
 */
- (void)sendMessage:(RCMessageContent *)messageContent
        pushContent:(NSString *)pushContent {
    NSLog(@"CYLiveALiPlayAndRCIMVC:sendMessage:pushContent:");
    
    
    // 直播和聊天室
    if (_targetId == nil) {
        return;
    }
    
    
    messageContent.senderUserInfo = [RCDLive sharedRCDLive].currentUserInfo;
    
    
    if (messageContent == nil) {
        return;
    }
    
    [[RCDLive sharedRCDLive] sendMessage:self.conversationType
                                targetId:self.targetId
                                 content:messageContent
                             pushContent:pushContent
                                pushData:nil
                                 success:^(long messageId) {
                                     
                                     
                                     
                                     __weak typeof(&*self) __weakself = self;
                                     
                                     
                                     
                                     dispatch_async(dispatch_get_main_queue(), ^{
                                         RCMessage *message = [[RCMessage alloc] initWithType:__weakself.conversationType
                                                                                     targetId:__weakself.targetId
                                                                                    direction:MessageDirection_SEND
                                                                                    messageId:messageId
                                                                                      content:messageContent];
                                         if ([message.content isMemberOfClass:[RCDLiveGiftMessage class]] ) {
                                             message.messageId = -1;//插入消息时如果id是-1不判断是否存在
                                         }
                                         [__weakself appendAndDisplayMessage:message];
                                         [__weakself.inputBar clearInputView];
                                     });
                                     
                                     
                                     
                                 } error:^(RCErrorCode nErrorCode, long messageId) {
                                     [[RCIMClient sharedRCIMClient]deleteMessages:@[ @(messageId) ]];
                                 }];
}

/**
 *  接收到消息的回调
 *
 *  @param notification
 */
- (void)didReceiveMessageNotification:(NSNotification *)notification {
    
    
    __block RCMessage *rcMessage = notification.object;
    RCDLiveMessageModel *model = [[RCDLiveMessageModel alloc] initWithMessage:rcMessage];
    NSDictionary *leftDic = notification.userInfo;
    if (leftDic && [leftDic[@"left"] isEqual:@(0)]) {
        self.isNeedScrollToButtom = YES;
    }
    if (model.conversationType == self.conversationType &&
        [model.targetId isEqual:self.targetId]) {
        __weak typeof(&*self) __blockSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (rcMessage) {
                [__blockSelf appendAndDisplayMessage:rcMessage];
                UIMenuController *menu = [UIMenuController sharedMenuController];
                menu.menuVisible=NO;
                //如果消息不在最底部，收到消息之后不滚动到底部，加到列表中只记录未读数
                if (![self isAtTheBottomOfTableView]) {
                    self.unreadNewMsgCount ++ ;
                    [self updateUnreadMsgCountLabel];
                }
            }
        });
    }
}




/**
 *  定义展示的UICollectionViewCell的个数
 *
 *  @return
 */
- (void)tap4ResetDefaultBottomBarStatus:
(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        //        CGRect collectionViewRect = self.conversationMessageCollectionView.frame;
        //        collectionViewRect.size.height = self.contentView.bounds.size.height - 0;
        //        [self.conversationMessageCollectionView setFrame:collectionViewRect];
        
        // 输入工具栏为初始化状态
        [self.inputBar setInputBarStatus:RCDLiveBottomBarDefaultStatus];
        
        //
        self.inputBar.hidden = YES;
    }
}

/**
 *  判断消息是否在collectionView的底部
 *
 *  @return 是否在底部
 */
- (BOOL)isAtTheBottomOfTableView {
    if (self.conversationMessageCollectionView.contentSize.height <= self.conversationMessageCollectionView.frame.size.height) {
        return YES;
    }
    if(self.conversationMessageCollectionView.contentOffset.y +200 >= (self.conversationMessageCollectionView.contentSize.height - self.conversationMessageCollectionView.frame.size.height)) {
        return YES;
    }else{
        return NO;
    }
}

#pragma mark - 输入框事件
/**
 *  点击键盘回车或者emoji表情面板的发送按钮执行的方法
 *
 *  @param text  输入框的内容
 */
- (void)onTouchSendButton:(NSString *)text{
    
    
    // 发送消息：用GiftMessage代替
    RCDLiveGiftMessage *giftMessage = [[RCDLiveGiftMessage alloc]init];
    giftMessage.type = @"2";
    giftMessage.tempMessageType = @"2";
    giftMessage.tempMessageContentStr = text;
    giftMessage.content = text;
    [self sendMessage:giftMessage pushContent:@""];
    
    
}

//修复ios7下不断下拉加载历史消息偶尔崩溃的bug
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

#pragma mark RCInputBarControlDelegate

/**
 *  根据inputBar 回调来修改页面布局，inputBar frame 变化会触发这个方法
 *
 *  @param frame    输入框即将占用的大小
 *  @param duration 时间
 *  @param curve
 */
- (void)onInputBarControlContentSizeChanged:(CGRect)frame withAnimationDuration:(CGFloat)duration andAnimationCurve:(UIViewAnimationCurve)curve{
    CGRect collectionViewRect = self.contentView.frame;
    self.contentView.backgroundColor = [UIColor clearColor];
    collectionViewRect.origin.y = self.view.bounds.size.height - frame.size.height - 237 +50;
    
    collectionViewRect.size.height = 237;
    [UIView animateWithDuration:duration animations:^{
        [UIView setAnimationCurve:curve];
        [self.contentView setFrame:collectionViewRect];
        [UIView commitAnimations];
    }];
    CGRect inputbarRect = self.inputBar.frame;
    
    inputbarRect.origin.y = self.contentView.frame.size.height -50;
    [self.inputBar setFrame:inputbarRect];
    [self.view bringSubviewToFront:self.inputBar];
    [self scrollToBottomAnimated:NO];
}

/**
 *  屏幕翻转
 *
 *  @param newCollection <#newCollection description#>
 *  @param coordinator   <#coordinator description#>
 */
- (void)willTransitionToTraitCollection:(UITraitCollection *)newCollection withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator{
    [super willTransitionToTraitCollection:newCollection
                 withTransitionCoordinator:coordinator];
    [coordinator animateAlongsideTransition:^(id <UIViewControllerTransitionCoordinatorContext> context)
     {
         if (newCollection.verticalSizeClass == UIUserInterfaceSizeClassCompact) {
             //To Do: modify something for compact vertical size
             [self changeCrossOrVerticalscreen:NO];
         } else {
             [self changeCrossOrVerticalscreen:YES];
             //To Do: modify something for other vertical size
         }
         [self.view setNeedsLayout];
     } completion:nil];
}

/**
 *  横竖屏切换
 *
 *  @param isVertical isVertical description
 */
-(void)changeCrossOrVerticalscreen:(BOOL)isVertical{
    _isScreenVertical = isVertical;
    //    if (!isVertical) {
    //        self.livePlayingManager.currentLiveView.frame = self.view.frame;
    //    } else {
    //        self.livePlayingManager.currentLiveView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - self.contentView.frame.size.height);
    //    }
    float inputBarOriginY = self.conversationMessageCollectionView.bounds.size.height + 30;
    float inputBarOriginX = self.conversationMessageCollectionView.frame.origin.x;
    float inputBarSizeWidth = self.contentView.frame.size.width;
    float inputBarSizeHeight = MinHeight_InputView;
    //添加输入框
    [self.inputBar changeInputBarFrame:CGRectMake(inputBarOriginX, inputBarOriginY,inputBarSizeWidth,inputBarSizeHeight)];
    for (RCDLiveMessageModel *__item in self.conversationDataRepository) {
        __item.cellSize = CGSizeZero;
    }
    [self changeModel:YES];
    [self.view bringSubviewToFront:self.backBtn];
    [self.inputBar setHidden:YES];
}

/**
 *  连接状态改变的回调
 *
 *  @param status <#status description#>
 */
//- (void)onConnectionStatusChanged:(RCConnectionStatus)status {
//    self.currentConnectionStatus = status;
//}
- (void)onRCIMConnectionStatusChanged:(RCConnectionStatus)status{
    
    self.currentConnectionStatus = status;
    
}


- (void)praiseHeart{
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(_clapBtn.frame.origin.x , _clapBtn.frame.origin.y - 49, 35, 35);
    imageView.image = [UIImage imageNamed:@"heart"];
    imageView.backgroundColor = [UIColor clearColor];
    imageView.clipsToBounds = YES;
    [self.view addSubview:imageView];
    
    
    CGFloat startX = round(random() % 200);
    CGFloat scale = round(random() % 2) + 1.0;
    CGFloat speed = 1 / round(random() % 900) + 0.6;
    int imageName = round(random() % 7);
    NSLog(@"%.2f - %.2f -- %d",startX,scale,imageName);
    
    [UIView beginAnimations:nil context:(__bridge void *_Nullable)(imageView)];
    [UIView setAnimationDuration:7 * speed];
    
    imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"heart%d.png",imageName]];
    imageView.frame = CGRectMake(kBounds.width - startX, -100, 35 * scale, 35 * scale);
    
    [UIView setAnimationDidStopSelector:@selector(onAnimationComplete:finished:context:)];
    [UIView setAnimationDelegate:self];
    [UIView commitAnimations];
}


- (void)praiseGift{
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(_flowerBtn.frame.origin.x , _flowerBtn.frame.origin.y - 49, 35, 35);
    imageView.image = [UIImage imageNamed:@"gift"];
    imageView.backgroundColor = [UIColor clearColor];
    imageView.clipsToBounds = YES;
    [self.view addSubview:imageView];
    
    
    CGFloat startX = round(random() % 200);
    CGFloat scale = round(random() % 2) + 1.0;
    CGFloat speed = 1 / round(random() % 900) + 0.6;
    int imageName = round(random() % 2);
    NSLog(@"%.2f - %.2f -- %d",startX,scale,imageName);
    
    [UIView beginAnimations:nil context:(__bridge void *_Nullable)(imageView)];
    [UIView setAnimationDuration:7 * speed];
    
    imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"gift%d.png",imageName]];
    imageView.frame = CGRectMake(kBounds.width - startX, -100, 35 * scale, 35 * scale);
    
    [UIView setAnimationDidStopSelector:@selector(onAnimationComplete:finished:context:)];
    [UIView setAnimationDelegate:self];
    [UIView commitAnimations];
}


- (void)onAnimationComplete:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context{
    
    UIImageView *imageView = (__bridge UIImageView *)(context);
    [imageView removeFromSuperview];
}


@end
