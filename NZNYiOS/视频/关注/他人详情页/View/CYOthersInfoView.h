//
//  CYOthersInfoView.h
//  nzny
//
//  Created by 男左女右 on 2016/11/22.
//  Copyright © 2016年 nznychina. All rights reserved.
//

#import <UIKit/UIKit.h>

// 模型
#import "CYOthersInfoViewModel.h"



@interface CYOthersInfoView : UIView



// 模型
@property (nonatomic, strong) CYOthersInfoViewModel *othersInfoViewModel;

// 头像：imageView
@property (weak, nonatomic) IBOutlet UIImageView *headImgView;

// 职业：label
@property (weak, nonatomic) IBOutlet UILabel *workLab;

// 房车：label
@property (weak, nonatomic) IBOutlet UILabel *houseAndCarLab;


// 宠物控：label
@property (weak, nonatomic) IBOutlet UILabel *hobbyLab;


// 身高：label
@property (weak, nonatomic) IBOutlet UILabel *heightLab;

// 星座：label
@property (weak, nonatomic) IBOutlet UILabel *starSignLab;

// 姓名：label
@property (weak, nonatomic) IBOutlet UILabel *nameLab;

// 年龄：label
@property (weak, nonatomic) IBOutlet UILabel *ageLab;


// 性别：imageView
@property (weak, nonatomic) IBOutlet UIImageView *genderImgView;


// 关注人数：label
@property (weak, nonatomic) IBOutlet UILabel *followCountLab;


// 粉丝人数：label
@property (weak, nonatomic) IBOutlet UILabel *fansCountLab;


// 礼物数量：label
@property (weak, nonatomic) IBOutlet UILabel *giftCountLab;

// 中间视图：view
@property (weak, nonatomic) IBOutlet UIView *infoOrVideoOrLiveView;



// 联系他：button
@property (weak, nonatomic) IBOutlet UIButton *contactBtn;


// 关注：button
@property (weak, nonatomic) IBOutlet UIButton *followBtn;


// 点赞：button
@property (weak, nonatomic) IBOutlet UIButton *likeBtn;

// 送礼：button
@property (weak, nonatomic) IBOutlet UIButton *giveGiftBtn;




@end
