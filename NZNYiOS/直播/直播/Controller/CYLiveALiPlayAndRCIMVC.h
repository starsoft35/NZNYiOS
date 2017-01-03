//
//  CYLiveALiPlayAndRCIMVC.h
//  nzny
//
//  Created by 男左女右 on 2016/12/29.
//  Copyright © 2016年 nznychina. All rights reserved.
//

#import "CYBaseViewController.h"

//#import <UIKit/UIKit.h>
#import "RCDLiveMessageBaseCell.h"
#import "RCDLiveMessageModel.h"
#import "RCDLiveInputBar.h"


// 阿里播放SDK：视图
#import "AliVcMoiveViewController.h"

// 直播拉流详情页
#import "CYLivePlayDetailsView.h"



///输入栏扩展输入的唯一标示
#define PLUGIN_BOARD_ITEM_ALBUM_TAG    1001
#define PLUGIN_BOARD_ITEM_CAMERA_TAG   1002
#define PLUGIN_BOARD_ITEM_LOCATION_TAG 1003
#if RC_VOIP_ENABLE
#define PLUGIN_BOARD_ITEM_VOIP_TAG     1004
#endif

/*!
 聊天界面类
 */
@interface CYLiveALiPlayAndRCIMVC: CYBaseViewController
<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate, UIScrollViewDelegate>


// 阿里播放SDK：视图
@property (nonatomic, strong) TBMoiveViewController *aliPlayVC;

// 直播拉流详情页：View
@property (nonatomic, strong) CYLivePlayDetailsView *livePlayDetailsView;


// 视频拉流地址：
@property (nonatomic, copy) NSString *playUrl;
// 所查看的用户Id
@property (nonatomic, copy) NSString *oppUserId;

// 直播ID
@property (nonatomic, copy) NSString *liveID;

// 直播间Id
@property (nonatomic, copy) NSString *liveRoomId;


#pragma mark - 会话属性

/*!
 当前会话的会话类型
 */
@property(nonatomic) RCConversationType conversationType;

/*!
 目标会话ID
 */
@property(nonatomic, strong) NSString *targetId;

/*!
 屏幕方向
 */
@property(nonatomic, assign) BOOL isScreenVertical;

/*!
 播放内容地址
 */
@property(nonatomic, strong) NSString *contentURL;

#pragma mark - 聊天界面属性

/*!
 聊天内容的消息Cell数据模型的数据源
 
 @discussion 数据源中存放的元素为消息Cell的数据模型，即RCDLiveMessageModel对象。
 */
@property(nonatomic, strong) NSMutableArray<RCDLiveMessageModel *> *conversationDataRepository;

/*!
 消息列表CollectionView和输入框都在这个view里
 */
@property(nonatomic, strong) UIView *contentView;

/*!
 聊天界面的CollectionView
 */
@property(nonatomic, strong) UICollectionView *conversationMessageCollectionView;

#pragma mark - 输入工具栏

@property(nonatomic,strong) RCDLiveInputBar *inputBar;

#pragma mark - 显示设置
/*!
 设置进入聊天室需要获取的历史消息数量（仅在当前会话为聊天室时生效）
 
 @discussion 此属性需要在viewDidLoad之前进行设置。
 -1表示不获取任何历史消息，0表示不特殊设置而使用SDK默认的设置（默认为获取10条），0<messageCount<=50为具体获取的消息数量,最大值为50。
 */
@property(nonatomic, assign) int defaultHistoryMessageCountOfChatRoom;

@end
