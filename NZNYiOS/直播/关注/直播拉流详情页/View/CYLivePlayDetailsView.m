//
//  CYLivePlayDetailsView.m
//  nzny
//
//  Created by 男左女右 on 2016/12/10.
//  Copyright © 2016年 nznychina. All rights reserved.
//

#import "CYLivePlayDetailsView.h"

@implementation CYLivePlayDetailsView

// 模型赋值
- (void)setLivePlayDetailsModel:(CYLivePlayDetailsViewModel *)livePlayDetailsModel{
    
    
    _livePlayDetailsModel = livePlayDetailsModel;
    
    // 头像
    _headImgView.image = [CYUtilities setUrlImgWithHostUrl:cHostUrl andUrl:livePlayDetailsModel.LiveUserPortrait];
    
    // 姓名
    _nameLab.text = livePlayDetailsModel.LiveUserName;
    
    // FID
    _idLab.text = [NSString stringWithFormat:@"%ld",(long)livePlayDetailsModel.LiveUserFId];
    
    // 人气
//    _popularityLab.text = [NSString stringWithFormat:@"人气：%@",livePlayDetailsModel];
    
    // 关注
    
    // 观看列表
    
    // 开始时间
    _startTimeLab.text = [CYUtilities setYearMouthDayHourMinuteWithYearMouthDayHourMinuteSecond:livePlayDetailsModel.PlanStartTime];
    
    // 开始时间提示窗
    if (livePlayDetailsModel.isTrailer) {
        
        // 开始时间提示窗：显示
        _startTimeTipLab.superview.hidden = NO;
        _startTimeTipLab.hidden = NO;
        
        // 如果是预告
        NSString *month = [livePlayDetailsModel.PlanStartTime substringWithRange:NSMakeRange(5, 2)];
        NSString *day = [livePlayDetailsModel.PlanStartTime substringWithRange:NSMakeRange(8, 2)];
        NSString *hour = [livePlayDetailsModel.PlanStartTime substringWithRange:NSMakeRange(11, 2)];
        NSString *minute = [livePlayDetailsModel.PlanStartTime substringWithRange:NSMakeRange(14, 2)];
        _startTimeTipLab.text = [NSString stringWithFormat:@"开播时间：%@/%@ %@:%@",month,day,hour,minute];
        
        
        // 设置标签和爱情宣言
        [self setTagLabAndDeclarationValureWithLivePlayDetailsViewModel:livePlayDetailsModel];
        
        
        // 设置联系他位置
        [self setConnectBtnFrame];
        
        
        // 删除发送信息button
//        [_sendMessageBtn removeFromSuperview];
        
    }
    else {
        
        // 开始时间提示窗：隐藏
        _startTimeTipLab.superview.hidden = YES;
        _startTimeTipLab.hidden = YES;
    }
    
//    // 发消息、联系他、送礼、点赞、分享
//    if (livePlayDetailsModel.isPlayView) {
//        
//        // 是拉流界面
//        // 发消息：显示
//        _sendMessageBtn.hidden = NO;
//        
//        // 联系他：显示
//        _connectBtn.hidden = NO;
//        
//        // 送礼：显示
//        _sendGiftBtn.hidden = NO;
//        
//        // 点赞：显示
//        _likeBtn.hidden = NO;
//        
//        // 切换镜头：隐藏
//        _changeCameraBtn.hidden = YES;
//        
//        // 分享：显示
//        _shareBtn.hidden = NO;
//    }
//    else {
//        
//        // 不是拉流界面，则为推流界面
//        // 发消息：隐藏
//        _sendMessageBtn.hidden = YES;
//        
//        // 联系他：隐藏
//        _connectBtn.hidden = YES;
//        
//        // 送礼：隐藏
//        _sendGiftBtn.hidden = YES;
//        
//        // 点赞：隐藏
//        _likeBtn.hidden = YES;
//        
//        // 切换镜头：显示
//        _changeCameraBtn.hidden = NO;
//        
//        // 分享：显示
//        _shareBtn.hidden = NO;
//        
//    }
    
}

// 设置标签和爱情宣言
- (void)setTagLabAndDeclarationValureWithLivePlayDetailsViewModel:(CYLivePlayDetailsViewModel *)livePlayDetailsViewModel{
    
    _tagAndDeclarationView = [[UIView alloc] initWithFrame:CGRectMake(0, _bottomAllBtnView.frame.origin.y - (100.0 / 1334.0) * self.frame.size.height, cScreen_Width, (100.0 / 1334.0) * self.frame.size.height)];
    
//    _tagAndDeclarationView.backgroundColor = [UIColor redColor];
    
    [self addSubview:_tagAndDeclarationView];
    
    
    // 标签、爱情宣言：背景
    UIImageView *tAdBgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _tagAndDeclarationView.frame.size.width, _tagAndDeclarationView.frame.size.height)];
    
    tAdBgImgView.image = [UIImage imageNamed:@"直播详情底部"];
    
    [_tagAndDeclarationView addSubview:tAdBgImgView];
    
    
    
    //  标签、爱情宣言：x大小
    float tagAndDeclarationX = (26.0 / 750.0) * self.frame.size.width;
    
    // 标签Label：赋值
    [self setTagValureWithLivePlayDetailsViewModel:livePlayDetailsViewModel andTagFrameX:tagAndDeclarationX];
    
    // 爱情宣言：label：赋值
    [self setDeclarationValureWithLivePlayDetailsViewModel:livePlayDetailsViewModel andDeclarationFrameX:tagAndDeclarationX];
    
}

// 标签Label：赋值
- (void)setTagValureWithLivePlayDetailsViewModel:(CYLivePlayDetailsViewModel *)livePlayDetailsViewModel andTagFrameX:(float)tagFrameX{
    
    _tagLab = [[UILabel alloc] initWithFrame:CGRectMake(tagFrameX, (26.0 / 1334.0) * self.frame.size.height, cScreen_Width - 2 * tagFrameX, (24.0 / 1334.0) * self.frame.size.height)];
    
    
    int tempCount = 1;
    NSString *tagStr = [[NSString alloc] init];
    for (CYOtherTagModel * tempTagModel in livePlayDetailsViewModel.LiveUserTagList) {
        
        if (livePlayDetailsViewModel.LiveUserTagList.count >= 1) {
            
            if (tempCount == 1) {
                
                tagStr = [tagStr stringByAppendingString:[NSString stringWithFormat:@"%@ ",tempTagModel.Name]];
            }
            else {
                
                tagStr = [tagStr stringByAppendingString:[NSString stringWithFormat:@"/ %@ ",tempTagModel.Name]];
            }
            
            tempCount += 1;
        }
    }
    // 标签
    _tagLab.text = [NSString stringWithFormat:@"标签：%@",tagStr];
    
    _tagLab.textColor = [UIColor colorWithRed:0.91 green:0.51 blue:0.23 alpha:1.00];
    _tagLab.font = [UIFont systemFontOfSize:12];
    _tagLab.textAlignment = NSTextAlignmentLeft;
    
    
    [_tagAndDeclarationView addSubview:_tagLab];
    
}


// 爱情宣言：label：赋值
- (void)setDeclarationValureWithLivePlayDetailsViewModel:(CYLivePlayDetailsViewModel *)livePlayDetailsViewModel andDeclarationFrameX:(float)tagFrameX{
    
    _declarationLab = [[UILabel alloc] initWithFrame:CGRectMake(tagFrameX, (70.0 / 1334.0) * self.frame.size.height, cScreen_Width - 2 * tagFrameX, (30.0 / 1334.0) * self.frame.size.height)];
    
    _declarationLab.text = [NSString stringWithFormat:@"爱情宣言：%@",livePlayDetailsViewModel.LiveUserDeclaration];
    _declarationLab.textColor = [UIColor whiteColor];
    _declarationLab.font = [UIFont systemFontOfSize:15];
    _declarationLab.textAlignment = NSTextAlignmentLeft;
    
    
    [_tagAndDeclarationView addSubview:_declarationLab];
    
}

// 设置联系他位置
- (void)setConnectBtnFrame{
    
    float tempWidth = _connectBtn.frame.size.width;
    float tempHeight = _connectBtn.frame.size.height;
    
    
    _connectBtn.frame = CGRectMake((26.0 / 1334.0) * self.frame.size.width, (10.0 / 1334.0) * self.frame.size.height, tempWidth, tempHeight);
    
}

@end
