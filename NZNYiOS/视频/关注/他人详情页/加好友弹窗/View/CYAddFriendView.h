//
//  CYAddFriendView.h
//  nzny
//
//  Created by 男左女右 on 2016/11/23.
//  Copyright © 2016年 nznychina. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CYAddFriendView : UIView


// 弹窗关闭：button
@property (weak, nonatomic) IBOutlet UIButton *tipCloseBtn;



// 对她说的话：textVIew
@property (weak, nonatomic) IBOutlet UITextView *sayToYouTextView;

// 引导他说的话：label
@property (weak, nonatomic) IBOutlet UILabel *guideHerToSayLab;



// 剩余输入字数：label
@property (weak, nonatomic) IBOutlet UILabel *surplusCountLab;


// 最大输入字数：label
@property (weak, nonatomic) IBOutlet UILabel *maxCountLab;


// 添加ta 为好友：button
@property (weak, nonatomic) IBOutlet UIButton *addFriendBtn;



@end
