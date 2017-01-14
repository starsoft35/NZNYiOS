//
//  CYFriendApplyView.h
//  nzny
//
//  Created by 男左女右 on 2017/1/14.
//  Copyright © 2017年 nznychina. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CYFriendApplyView : UIView



// 未读条数：label
@property (weak, nonatomic) IBOutlet UILabel *unReadCountLab;

// 未读条数：imageView
@property (weak, nonatomic) IBOutlet UIImageView *unReadCountImgView;


// 好友申请：View
@property (weak, nonatomic) IBOutlet UIView *applyFriendView;


@end
