//
//  CYLivePlayDetailsView.h
//  nzny
//
//  Created by 男左女右 on 2016/12/10.
//  Copyright © 2016年 nznychina. All rights reserved.
//

#import <UIKit/UIKit.h>

// 模型
#import "CYLivePlayDetailsViewModel.h"

@interface CYLivePlayDetailsView : UIView

// 模型
@property (nonatomic, strong) CYLivePlayDetailsViewModel *livePlayDetailsModel;



// 背景：imageView
@property (weak, nonatomic) IBOutlet UIImageView *bgImgView;


// 观众列表：View
@property (weak, nonatomic) IBOutlet UIView *liveRoomPeopleListView;

// 头像、姓名、FID、观众：view
@property (weak, nonatomic) IBOutlet UIView *topHeadNameFIDFollorView;

// 上部关注：背景
@property (weak, nonatomic) IBOutlet UIImageView *topHeadNameIDFollowBgImgView;

// 上部已关注：背景
@property (weak, nonatomic) IBOutlet UIImageView *topAllreadyFollowBgImgView;


// 关注：button
@property (weak, nonatomic) IBOutlet UIButton *followBtn;



// 头像：imageView
@property (weak, nonatomic) IBOutlet UIImageView *headImgView;

// 姓名：label
@property (weak, nonatomic) IBOutlet UILabel *nameLab;

// ID:label
@property (weak, nonatomic) IBOutlet UILabel *idLab;

// 人气：label
@property (weak, nonatomic) IBOutlet UILabel *popularityLab;


// 开始时间：label
@property (weak, nonatomic) IBOutlet UILabel *startTimeLab;

// 开始时间提示：label
@property (weak, nonatomic) IBOutlet UILabel *startTimeTipLab;



// 聊天室：view
@property (weak, nonatomic) IBOutlet UIImageView *chatRoomView;

// 发消息：button
@property (weak, nonatomic) IBOutlet UIButton *sendMessageBtn;


// 底部：联系、发消息、送礼、点赞、分享：view
@property (weak, nonatomic) IBOutlet UIView *bottomAllBtnView;


// 联系他：button
@property (weak, nonatomic) IBOutlet UIButton *connectBtn;


// 送礼：button
@property (weak, nonatomic) IBOutlet UIButton *sendGiftBtn;


// 点赞：button
@property (weak, nonatomic) IBOutlet UIButton *likeBtn;

// 切换镜头：button
@property (weak, nonatomic) IBOutlet UIButton *changeCameraBtn;


// 分享：button
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;


// 关闭：button
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;


// 标题、爱情宣言：视图：View
@property (nonatomic, strong) UIView *tagAndDeclarationView;

// 标签：label
@property (nonatomic, copy) UILabel *tagLab;

// 爱情宣言：label
@property (nonatomic, copy) UILabel *declarationLab;


@end
