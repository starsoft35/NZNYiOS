//
//  CYMyFriendApplyListCell.h
//  nzny
//
//  Created by 男左女右 on 2017/1/14.
//  Copyright © 2017年 nznychina. All rights reserved.
//

#import <UIKit/UIKit.h>

// 模型
#import "CYMyFriendApplyListCellModel.h"

@interface CYMyFriendApplyListCell : UITableViewCell


// 模型
@property (nonatomic, strong) CYMyFriendApplyListCellModel *friendApplyListCellModel;


// 头像：imageView
@property (weak, nonatomic) IBOutlet UIImageView *headImgView;


// 姓名：label
@property (weak, nonatomic) IBOutlet UILabel *nameLab;

// 请求添加好友：label
@property (weak, nonatomic) IBOutlet UILabel *applyAddFriendLab;

// 添加好友原因：label
@property (weak, nonatomic) IBOutlet UILabel *descriptionLab;


// 是否同意：button
@property (weak, nonatomic) IBOutlet UIButton *agreeBtn;

@end
