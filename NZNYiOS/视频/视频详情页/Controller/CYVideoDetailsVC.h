//
//  CYVideoDetailsVC.h
//  nzny
//
//  Created by 男左女右 on 2016/11/27.
//  Copyright © 2016年 nznychina. All rights reserved.
//

#import "CYBaseViewController.h"

// 视频详情页View
#import "CYVideoDetailsView.h"

// 音频播放器
#import <AVFoundation/AVFoundation.h>
// 视频播放器
#import <MediaPlayer/MediaPlayer.h>


// 阿里云播放器：SDK
//#import <AliyunPlayerSDK/AliyunPlayerSDK.h>

@interface CYVideoDetailsVC : CYBaseViewController<AVAudioPlayerDelegate>

// 视频详情页View
@property (nonatomic, strong) CYVideoDetailsView *videoDetailsView;




// 所查看的用户Id
@property (nonatomic, copy) NSString *oppUserId;


// 选中的第几个cell
@property (nonatomic, copy) NSIndexPath *indexPath;


// 音频播放器
@property (nonatomic,strong)AVAudioPlayer *audioPlayer;
// 视频播放器
@property (nonatomic, strong) MPMoviePlayerViewController *moviePlayerVC;


// 阿里：视频播放器
//@property (nonatomic, strong) AliVcMediaPlayer *aliMediaPlayer;


@end
