//
//  CYUtilities.m
//  NZNYiOS
//
//  Created by 男左女右 on 16/9/6.
//  Copyright © 2016年 NZNY. All rights reserved.
//

#import "CYUtilities.h"


// 获取视频第一帧图片：使用
#import <AVFoundation/AVFoundation.h>



@implementation CYUtilities


// 创建button
+ (UIButton *)createBtnFrame:(CGRect)frame title:(NSString *)title imgName:(NSString *)imgName bgImgName:(NSString*)bgImgName selectedBgImgName:(NSString *)selectedBgImgName target:(id)target action:(SEL)action{
    
    //
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btn.frame = frame;
    
    [btn setTitle:title forState:UIControlStateNormal];
    
    // 字体颜色修改为黑色
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    // button图标
    if (imgName) {
        
        [btn setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
    }
    
    // 正常状态下背景图片
    if (bgImgName) {
        
        [btn setBackgroundImage:[UIImage imageNamed:bgImgName] forState:UIControlStateNormal];
    }
    
    // 选中状态下背景图片
    if (selectedBgImgName) {
        
        [btn setBackgroundImage:[UIImage imageNamed:selectedBgImgName] forState:UIControlStateSelected];
    }
    
    // 点击事件
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}

// 加载带主机地址的网络图片
+ (UIImage *)setUrlImgWithHostUrl:(NSString *)hostUrl andUrl:(NSString *)url{
    
    UIImage *image = [[UIImage alloc] init];
    // 头像
    if (url.length > 18) {
        
        NSString *portaitUrl = [url substringToIndex:18];
        if ([portaitUrl isEqualToString:@"/Uploads/AppImage/"]) {
            
            
            image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",hostUrl,url]]]];
            
        }
        else {
            
            image = [UIImage imageNamed:@"默认头像"];
        }
    }
    else {
        image = [UIImage imageNamed:@"默认头像"];
    }
    
    
    
    return image;
    
}

// 检查手机号是否正确
+ (BOOL)checkTel:(NSString *)tel{
    
    
    NSString *regex = @"^1[3|4|5|7|8][0-9]{9}$";
//    NSString *regex = @"^1[3|4|5|7|8][0-9]\\d{8}]$";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",regex];
    
    return [pred evaluateWithObject:tel];
    
}

// 检查密码格式是否正确
+ (BOOL)checkPassword:(NSString *)password{
    
    NSString *regex = @"^[A-Za-z0-9]{8,16}$";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",regex];
    
    return [pred evaluateWithObject:password];
}

// 检查验证码格式是否正确
+ (BOOL)checkVerificationCode:(NSString *)verificationCode{
    
    NSString *regex = @"[0-9]{4}$";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",regex];
    
    return [pred evaluateWithObject:verificationCode];
}

// 检查用户名格式是否正确
+ (BOOL)checkUserName:(NSString *)userName{
    
    NSString *regex = @"[\u4e00-\u9fa5]{2,4}$";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",regex];
    
    return [pred evaluateWithObject:userName];
}

// 设置默认navigationBar样式
+ (UINavigationController *)createDefaultNavCWithRootVC:(UIViewController *)rootVC BgColor:(UIColor *)bgColor TintColor:(UIColor *)tintColor translucent:(BOOL)translucent titleColor:(UIColor *)titleColor title:(NSString *)title bgImg:(UIImage *)bgImg{
    
    // navigationController
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:rootVC];
    // 设置导航条的样式
    nav.navigationBar.barStyle = UIBarStyleBlack;
    // bgColor
    nav.navigationBar.backgroundColor = bgColor;
    
    // tintColor
    nav.navigationBar.tintColor = tintColor;
    
    // translucent：是否透明（不透明，Y轴在navigation下面开始）
    nav.navigationBar.translucent = translucent;
    
    // titleColor
//    nav.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:titleColor};
    
    // title
    nav.navigationItem.title = title;
    
    // bgImg
    [nav.navigationBar setBackgroundImage:bgImg forBarMetrics:UIBarMetricsDefault];
    
    return nav;
}

// 设置时间：精确到分
+ (NSString *)setYearMouthDayHourMinuteWithYearMouthDayHourMinuteSecond:(NSString *)time{
    
    NSString *year = [time substringToIndex:4];
    NSString *month = [time substringWithRange:NSMakeRange(5, 2)];
    NSString *day = [time substringWithRange:NSMakeRange(8, 2)];
    NSString *hour = [time substringWithRange:NSMakeRange(11, 2)];
    NSString *minute = [time substringWithRange:NSMakeRange(14, 2)];
    return [NSString stringWithFormat:@"%@/%@/%@ %@:%@",year,month,day,hour,minute];
}
// 设置时间：精确到分：用xxxx年xx月xx日 xx时xx分表示
+ (NSString *)setYearMouthDayHourMinuteWithChineseYearMouthDayHourMinuteSecond:(NSString *)time{
    
    NSString *year = [time substringToIndex:4];
    NSString *month = [time substringWithRange:NSMakeRange(5, 2)];
    NSString *day = [time substringWithRange:NSMakeRange(8, 2)];
    NSString *hour = [time substringWithRange:NSMakeRange(11, 2)];
    NSString *minute = [time substringWithRange:NSMakeRange(14, 2)];
    return [NSString stringWithFormat:@"%@年%@月%@日 %@:%@",year,month,day,hour,minute];
}
// 设置时间：xx月xx日
+ (NSString *)setYearMouthDayHourMinuteWithChineseMouthDay:(NSString *)time{
    
    
    NSString *month = [time substringWithRange:NSMakeRange(5, 2)];
    NSString *day = [time substringWithRange:NSMakeRange(8, 2)];
    
    return [NSString stringWithFormat:@"%@月%@日",month,day];
}

// 提示框
//+ (void)showHubWithLabelText:(NSString *)text andHidAfterDelay:(double)afterDelay{
//    
//    _hud.labelText = text;
//    
//    
//    [self->hud show:YES];
//    [self.hud hide:YES afterDelay:afterDelay];
//}


//
//- (UIImage*) getVideoPreViewImage
//{
//
//    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:[NSURL URLWithString:@""] options:nil];
//    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
//    [asset release];
//    gen.appliesPreferredTrackTransform = YES;
//    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
//    NSError *error = nil;
//    CMTime actualTime;
//    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
//    UIImage *img = [[[UIImage alloc] initWithCGImage:image] autorelease];
//    CGImageRelease(image);
//    [gen release];
//    return img;
//}
+ (UIImage*) thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time {
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    NSParameterAssert(asset);
    AVAssetImageGenerator *assetImageGenerator =[[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetImageGenerator.appliesPreferredTrackTransform = YES;
    assetImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    
    CGImageRef thumbnailImageRef = NULL;
    CFTimeInterval thumbnailImageTime = time;
    NSError *thumbnailImageGenerationError = nil;
    thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(thumbnailImageTime, 60)actualTime:NULL error:&thumbnailImageGenerationError];
    
    if(!thumbnailImageRef)
        NSLog(@"thumbnailImageGenerationError %@",thumbnailImageGenerationError);
    
    UIImage*thumbnailImage = thumbnailImageRef ? [[UIImage alloc]initWithCGImage: thumbnailImageRef] : nil;
    
    return thumbnailImage;
}

//+ (UIImage *)firstFrameWithVideoURL:(NSURL *)url size:(CGSize)size
//{
//    // 获取视频第一帧
//    NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
//    AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:url options:opts];
//    AVAssetImageGenerator *generator = [AVAssetImageGenerator assetImageGeneratorWithAsset:urlAsset];
//    generator.appliesPreferredTrackTransform = YES;
//    generator.maximumSize = CGSizeMake(size.width, size.height);
//    NSError *error = nil;
//    CGImageRef img = [generator copyCGImageAtTime:CMTimeMake(0, 10) actualTime:NULL error:&error];
//    if (error == nil)
//    {
//        return [UIImage imageWithCGImage:img];
//    }
//    return nil;
//}


// 获取视频文件的时长：单位是秒
+ (CGFloat)getVideoLengthWithVideoUrl:(NSURL *)URL{
    
    AVURLAsset *avUrl = [AVURLAsset assetWithURL:URL];
    
    CMTime time = [avUrl duration];
    
    NSLog(@"CMTime.time.value:%lld",time.value);
    NSLog(@"CMTime.time.timescale:%d",time.timescale);
    
    float second = ceil(time.value/time.timescale);
    
    
    return second;
    
}
// 获取视频文件的大小，返回的是单位是KB。
+ (CGFloat)getFileSizeWithPath:(NSString *)path{
    NSLog(@"filePath：%@",path);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    float filesize = -1.0;
    if ([fileManager fileExistsAtPath:path]) {
        NSDictionary *fileDic = [fileManager attributesOfItemAtPath:path error:nil];//获取文件的属性
        unsigned long long size = [[fileDic objectForKey:NSFileSize] longLongValue];
        filesize = 1.0*size/1024;
    }else{
        NSLog(@"找不到文件");
    }
    return filesize;
}




// 压缩视频：返回压缩后视频的地址，该地址在沙盒目录中
+ (NSURL *)condenseVideoWithUrl:(NSURL *)url{
    // 沙盒目录
    NSString *docuPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *destFilePath = [docuPath stringByAppendingPathComponent:[NSString stringWithFormat:@"lyh%@.MOV",[self getCurrentTime]]];
    NSURL *destUrl = [NSURL fileURLWithPath:destFilePath];
    //将视频文件copy到沙盒目录中
    NSFileManager *manager = [NSFileManager defaultManager];
    NSError *error = nil;
    [manager copyItemAtURL:url toURL:destUrl error:&error];
    NSLog(@"压缩前--%.2fk",[CYUtilities getFileSizeWithPath:destFilePath]);
    
    // 播放视频
    /*
     NSURL *videoURL = [NSURL fileURLWithPath:destFilePath];
     AVPlayer *player = [AVPlayer playerWithURL:videoURL];
     AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
     playerLayer.frame = self.view.bounds;
     [self.view.layer addSublayer:playerLayer];
     [player play];
     */
    // 进行压缩
    AVAsset *asset = [AVAsset assetWithURL:destUrl];
    //创建视频资源导出会话
    /**
     NSString *const AVAssetExportPresetLowQuality; // 低质量
     NSString *const AVAssetExportPresetMediumQuality;
     NSString *const AVAssetExportPresetHighestQuality; //高质量
     */
    
    AVAssetExportSession *session = [[AVAssetExportSession alloc] initWithAsset:asset presetName:AVAssetExportPresetLowQuality];
    // 创建导出的url
    NSString *resultPath = [docuPath stringByAppendingPathComponent:[NSString stringWithFormat:@"lyhg%@.MOV",[self getCurrentTime]]];
    session.outputURL = [NSURL fileURLWithPath:resultPath];
    // 必须配置输出属性
    session.outputFileType = @"com.apple.quicktime-movie";
    // 导出视频
    [session exportAsynchronouslyWithCompletionHandler:^{
        NSLog(@"压缩后---%.2fk",[CYUtilities getFileSizeWithPath:resultPath]);
        NSLog(@"视频导出完成");
        
    }];
    
    return session.outputURL;
}



// 获取当前时间
+ (NSString *)getCurrentTime{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateTime = [formatter stringFromDate:[NSDate date]];
    //    NSString *str = [NSString stringWithFormat:@"%@mdxx",dateTime];
    //    NSString *tokenStr = [str stringToMD5:str];
    return dateTime;
    
}


@end
