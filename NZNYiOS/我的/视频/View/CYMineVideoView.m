//
//  CYMineVideoView.m
//  nzny
//
//  Created by 男左女右 on 2016/10/30.
//  Copyright © 2016年 nznychina. All rights reserved.
//

#import "CYMineVideoView.h"

@implementation CYMineVideoView

-(void)setListArr:(NSMutableArray *)listArr{
    
    _listArr = listArr;
    
    _leftVideoDeleteBtn.hidden = YES;
    _rightVideoDeleteBtn.hidden = YES;
    
    
//    for (CYMineVideoViewModel *tempModel in listArr) {
//        
//        switch (tempModel.AuditStatus) {
//            case 0:
//                
//                break;
//                
//            default:
//                break;
//        }
//    }
    
    
    if (listArr.count == 0) {
        
        // 没有上传视频：设置默认界面
        //  左侧显示内容默认
        [self setLeftVideoShowInfoDefault];
        
        // 左侧use、share隐藏
        [self setLeftVideoHiddenUseAndShareBtn];
        
        //  右侧显示内容默认
        [self setRightVideoShowInfoDefault];
        
        // 右侧use、share隐藏
        [self setRightVideoHiddenUseAndShareBtn];
        
    }
    else if (listArr.count == 1) {
        
        
        
        CYMineVideoViewModel *leftModel = _listArr[0];
        
        switch (leftModel.AuditStatus) {
                
            case 0:
                // 正在审核
                // 左侧黑色
                [self setLeftVideoShowBlackInfoNowAudit];
                // 左侧：use、share隐藏
                [self setLeftVideoHiddenUseAndShareBtn];
                
                
                
                break;
            case 1:
                // 审核通过
                // 左侧信息
                [self setLeftVideoShowInfoWithModel:leftModel];
                
                // 左侧：use、share 显示
                [self setLeftVideoShowUseAndShareBtn];
                
                
                if (leftModel.Default) {
                
                    // 左侧默认使用
                    
                    // 左侧正在使用
                    [self setLeftVideoIsUse];
                }
                else {
                    
                    
                    // 左侧：使用
                    [self setLeftVideoNoUse];
                }
                
                
                break;
            case 2:
                // 审核未通过
                // 左侧黑色
                [self setLeftVideoShowBlackInfoNowAudit];
                
                // 左侧：uer、share 隐藏
                [self setLeftVideoHiddenUseAndShareBtn];
                
                break;
                
            default:
                break;
        }
        
        
        // 右侧默认
        [self setRightVideoShowInfoDefault];
        
        // 右侧：use、share 隐藏
        [self setRightVideoHiddenUseAndShareBtn];
        
        
        
    }
    else {
        
        // 上传两个视频
        CYMineVideoViewModel *leftModel = _listArr[0];
        
        switch (leftModel.AuditStatus) {
                
            case 0:
                // 正在审核
                // 左侧黑色
                [self setLeftVideoShowBlackInfoNowAudit];
                // 左侧：use、share隐藏
                [self setLeftVideoHiddenUseAndShareBtn];
                
                break;
            case 1:
                // 审核通过
                // 左侧信息
                [self setLeftVideoShowInfoWithModel:leftModel];
                
                // 左侧：use、share 显示
                [self setLeftVideoShowUseAndShareBtn];
                
                // 如果左侧是默认
                if (leftModel.Default) {
                    
                    
                    // 左侧：正在使用
                    [self setLeftVideoIsUse];
                    
                    // 右侧：使用
                    [self setRightVideoNoUse];
                }
                else {
                    
                    // 左侧：使用
                    [self setLeftVideoNoUse];
                    
                    // 右侧：正在使用
                    [self setRightVideoIsUse];
                    
                }
                
                break;
            case 2:
                // 审核未通过
                // 左侧黑色
                [self setLeftVideoShowBlackInfoNowAudit];
                
                // 左侧：uer、share 隐藏
                [self setLeftVideoHiddenUseAndShareBtn];
                
                break;
                
            default:
                break;
        }
        
        
        
        CYMineVideoViewModel *rightModel = _listArr[1];
        
        switch (rightModel.AuditStatus) {
                
            case 0:
                // 正在审核
                // 右侧黑色
                [self setRightVideoShowBlackInfoNowAudit];
                // 右侧：use、share隐藏
                [self setRightVideoHiddenUseAndShareBtn];
                
                break;
            case 1:
                // 审核通过
                // 右侧信息
                [self setRightVideoShowInfoWithModel:rightModel];
                
                // 右侧：use、share 显示
                [self setRightVideoShowUseAndShareBtn];
                
                
                // 如果右侧是默认
                if (rightModel.Default) {
                    
                    // 左侧：使用
                    [self setLeftVideoNoUse];
                    
                    // 右侧：正在使用
                    [self setRightVideoIsUse];
                }
                else {
                    
                    // 左侧：正在使用
                    [self setLeftVideoIsUse];
                    
                    // 右侧：使用
                    [self setRightVideoNoUse];
                    
                }
                
                break;
            case 2:
                // 审核未通过
                // 右侧黑色
                [self setRightVideoShowBlackInfoNowAudit];
                
                // 右侧：uer、share 隐藏
                [self setRightVideoHiddenUseAndShareBtn];
                
                break;
                
            default:
                break;
        }
        
        
    }
    
    
    // 前期没有拍摄功能
//    _uploadPlayVideoBtn.hidden = YES;
    
    
}

#pragma --左侧视频状态
// 设置左侧视频显示内容：默认
- (void)setLeftVideoShowInfoDefault{
    
    _leftVideoBlackImgView.hidden = YES;
    _leftVideoPlayImgView.hidden = YES;
    
    _leftVideoBackImgView.image = [UIImage imageNamed:@"默认视频"];
    
    _leftVideoAuditStatusLab.text = @"";
    
    _leftVideoTimeLab.text = @"";
    
    _leftVideoSizeLab.text = @"";

    
}


// 设置左侧视频显示内容
- (void)setLeftVideoShowInfoWithModel:(CYMineVideoViewModel *)model{
    
    _leftVideoBlackImgView.hidden = YES;
    _leftVideoPlayImgView.hidden = NO;
    
//    CYMineVideoViewModel *leftModel = _listArr[0];
    
    
    
//    _leftVideoBackImgView.image = [UIImage imageNamed:@"默认头像"];
//    [_leftVideoBackImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",cHostUrl,model.headImgName]] placeholderImage:[UIImage imageNamed:@"默认头像"]];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 处理耗时操作的代码块...
        
        _leftVideoBackImgView.image = [CYUtilities thumbnailImageForVideo:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",cHostUrl,model.Video]] atTime:0.1];

        
    });
    
//    [_leftVideoBackImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",cHostUrl,model.Video]] placeholderImage:[UIImage imageNamed:@"默认头像"]];
    
    _leftVideoAuditStatusLab.text = @"";
    
    _leftVideoTimeLab.text = [model.CreateDate substringToIndex:10];
    
    _leftVideoSizeLab.text = [NSString stringWithFormat:@"%.2fM",model.Size];
    
    
}

// 设置左侧视频：正在审核、未通过，黑色覆盖
- (void)setLeftVideoShowBlackInfoNowAudit{
    
    _leftVideoBlackImgView.hidden = NO;
    _leftVideoBlackImgView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
    
    _leftVideoPlayImgView.hidden = YES;
    
    _leftVideoBackImgView.image = [UIImage imageNamed:@"默认头像"];
    
    CYMineVideoViewModel *leftModel = _listArr[0];
    
    if (leftModel.AuditStatus == 0) {
        
        _leftVideoAuditStatusLab.text = @"正在审核";
        
        _leftVideoTimeLab.text = @"请耐心等待";
        
    }
    else if (leftModel.AuditStatus == 2) {
        
        _leftVideoAuditStatusLab.text = @"不通过";
        
        _leftVideoTimeLab.text = @"请重新上传";
    }
    
    
    _leftVideoSizeLab.text = @"";
    
}

// 设置左侧未上传、正在审核、审核失败，隐藏useBtn、shareBtn
- (void)setLeftVideoHiddenUseAndShareBtn{
    
    _leftVideoUseBtn.hidden = YES;
    
    _leftVideoShareBtn.hidden = YES;
    
}

// 设置左侧审核通过，显示useBtn、shareBtn
- (void)setLeftVideoShowUseAndShareBtn{
    
    _leftVideoUseBtn.hidden = NO;
    
    _leftVideoShareBtn.hidden = NO;
    
}
// 设置左侧视频使用：正在使用
- (void)setLeftVideoIsUse{
    [_leftVideoUseBtn setTitle:@"正在使用" forState:UIControlStateNormal];
    [_leftVideoUseBtn setTitleColor:[UIColor redColor] forState:UIControlStateDisabled];
    [_leftVideoUseBtn setBackgroundImage:[UIImage imageNamed:@"登录完成未激活"] forState:UIControlStateNormal];
    _leftVideoUseBtn.enabled = NO;
}
// 设置左侧视频使用：使用
- (void)setLeftVideoNoUse{
    
    [_leftVideoUseBtn setTitle:@"使用" forState:UIControlStateNormal];
    [_leftVideoUseBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [_leftVideoUseBtn setBackgroundImage:[UIImage imageNamed:@"注册底"] forState:UIControlStateNormal];
    _leftVideoUseBtn.enabled = YES;
}


#pragma --右侧视频状态
// 设置右侧视频显示内容：默认
- (void)setRightVideoShowInfoDefault{
    
    _rightVideoBlackImgView.hidden = YES;
    _rightVideoPlayImgView.hidden = YES;
    
    _rightVideoBackImgView.image = [UIImage imageNamed:@"默认视频"];
    
    _rightVideoAuditStatusLab.text = @"";
    
    _rightVideoTimeLab.text = @"";
    
    _rightVideoSizeLab.text = @"";
}

// 设置右侧视频显示内容
- (void)setRightVideoShowInfoWithModel:(CYMineVideoViewModel *)model{
    _rightVideoBlackImgView.hidden = YES;
    _rightVideoPlayImgView.hidden = NO;
    
//    CYMineVideoViewModel *rightModel = _listArr[1];
    
    
    
//    _rightVideoBackImgView.image = [UIImage imageNamed:@"默认头像"];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 处理耗时操作的代码块...
        
        _rightVideoBackImgView.image = [CYUtilities thumbnailImageForVideo:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",cHostUrl,model.Video]] atTime:0.1];

        
    });
    
    _rightVideoAuditStatusLab.text = @"";
    
    _rightVideoTimeLab.text = [model.CreateDate substringToIndex:10];
    
    _rightVideoSizeLab.text = [NSString stringWithFormat:@"%.2fM",model.Size];
}

// 设置右侧视频：正在审核、未通过，黑色覆盖
- (void)setRightVideoShowBlackInfoNowAudit{
    
    _rightVideoBlackImgView.hidden = NO;
    _rightVideoBlackImgView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
    
    _rightVideoPlayImgView.hidden = YES;
    
    _rightVideoBackImgView.image = [UIImage imageNamed:@"默认头像"];
    
    CYMineVideoViewModel *rightModel = _listArr[1];
    
    if (rightModel.AuditStatus == 0) {
        
        _rightVideoAuditStatusLab.text = @"正在审核";
        
        _rightVideoTimeLab.text = @"请耐心等待";
        
    }
    else if (rightModel.AuditStatus == 2) {
        
        _rightVideoAuditStatusLab.text = @"不通过";
        
        _rightVideoTimeLab.text = @"请重新上传";
    }
    
    
    _rightVideoSizeLab.text = @"";
    
}

// 设置右侧未上传、正在审核、审核失败，隐藏useBtn、shareBtn
- (void)setRightVideoHiddenUseAndShareBtn{
    
    _rightVideoUseBtn.hidden = YES;
    
    _rightVideoShareBtn.hidden = YES;
    
}

// 设置右侧审核通过，显示useBtn、shareBtn
- (void)setRightVideoShowUseAndShareBtn{
    
    _rightVideoUseBtn.hidden = NO;
    
    _rightVideoShareBtn.hidden = NO;
    
}

// 设置右侧视频使用：正在使用
- (void)setRightVideoIsUse{
    
    [_rightVideoUseBtn setTitle:@"正在使用" forState:UIControlStateNormal];
    [_rightVideoUseBtn setTitleColor:[UIColor redColor] forState:UIControlStateDisabled];
    [_rightVideoUseBtn setBackgroundImage:[UIImage imageNamed:@"登录完成未激活"] forState:UIControlStateNormal];
    _rightVideoUseBtn.enabled = NO;
}

// 设置右侧视频使用：使用
- (void)setRightVideoNoUse{
    
    [_rightVideoUseBtn setTitle:@"使用" forState:UIControlStateNormal];
    [_rightVideoUseBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [_rightVideoUseBtn setBackgroundImage:[UIImage imageNamed:@"注册底"] forState:UIControlStateNormal];
    _rightVideoUseBtn.enabled = YES;
}



@end
