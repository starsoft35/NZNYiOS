//
//  CYMyLiveView.h
//  nzny
//
//  Created by 男左女右 on 2016/12/11.
//  Copyright © 2016年 nznychina. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CYMyLiveView : UIView


// 直播详情：View：预告cell、记录cell
@property (weak, nonatomic) IBOutlet UIView *liveTrailerRecordView;


// 我要上直播：button
@property (weak, nonatomic) IBOutlet UIButton *gotoLiveBtn;



@end
