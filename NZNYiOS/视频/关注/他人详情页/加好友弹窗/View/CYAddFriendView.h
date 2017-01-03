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


// 对他说的话：textField
@property (weak, nonatomic) IBOutlet UITextField *sayToYouTextField;


// 添加ta 为好友：button
@property (weak, nonatomic) IBOutlet UIButton *addFriendBtn;



@end
