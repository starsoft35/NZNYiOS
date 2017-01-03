//
//  CYMineVideoVC.m
//  nzny
//
//  Created by 男左女右 on 2016/10/31.
//  Copyright © 2016年 nznychina. All rights reserved.
//

#import "CYMineVideoVC.h"


#import <AssetsLibrary/AssetsLibrary.h>



// 我的视频View
#import "CYMineVideoView.h"


// 我的视频模型
#import "CYMineVideoViewModel.h"

//



@interface CYMineVideoVC ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate>

// 我的视频视图View
@property (nonatomic,strong) CYMineVideoView *mineVideoView;


// 删除barButtonItem
@property (nonatomic,strong) UIBarButtonItem *deleteBarBtnItem;

// 左侧视频删除button 是否选择
@property (nonatomic,assign) BOOL leftVideoDelBtnIsSelected;


// 右侧视频删除button 是否选择
@property (nonatomic,assign) BOOL rightVideoDelBtnIsSelected;


@end

@implementation CYMineVideoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // title
    self.title = @"视频";
    
    
    // 加载数据
    [self loadData];
    
    // 创建视图
    [self setMineVideoView];
    
    // 加载菊花
    [self showLoadingView];
    
}

// 加载数据
- (void)loadData{
    
    // 加载菊花
//    [self showLoadingView];
    // 参数
    NSDictionary *params = @{
                             @"userId":self.onlyUser.userID
                             };
    
    
    
    // 请求数据
    [CYNetWorkManager getRequestWithUrl:cMineVideoListUrl params:params progress:^(NSProgress *uploadProgress) {
        NSLog(@"获取我的视频列表进度：%@",uploadProgress);
        
    } whenSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"获取我的视频列表：请求成功！");
        
        // 1、
        NSString *code = responseObject[@"code"];
        
        // 1.2.1.1.2、和成功的code 匹配
        if ([code isEqualToString:@"0"]) {
            NSLog(@"获取我的视频列表：获取成功！");
            
            
            // 清空：每次刷新都需要
            [self.dataArray removeAllObjects];
            
            // 解析数据，模型存到数组
            [self.dataArray addObjectsFromArray:[CYMineVideoViewModel arrayOfModelsFromDictionaries:responseObject[@"res"][@"data"][@"list"]]];
            
            
            _mineVideoView.listArr = self.dataArray;
            
            // 请求数据结束，取消加载
            [self hidenLoadingView];
            
        }
        else{
            NSLog(@"获取我的视频列表：获取失败！");
            
            // 1.2.1.1.2.2、获取失败：弹窗提示：获取失败的返回信息
            [self showHubWithLabelText:responseObject[@"res"][@"msg"] andHidAfterDelay:3.0];
            
        }
        
        
    } whenFailure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"获取我的视频列表：请求失败！");
        
        [self showHubWithLabelText:@"请求失败！" andHidAfterDelay:3.0];
        
    } withToken:self.onlyUser.userToken];
    
    
}


// 创建视图
- (void)setMineVideoView{
    
    // 我的视频View
    _mineVideoView = [[[NSBundle mainBundle] loadNibNamed:@"CYMineVideoView" owner:nil options:nil] lastObject];
    
    
    
    
    // 左侧视频删除button
    [_mineVideoView.leftVideoDeleteBtn addTarget:self action:@selector(leftDelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    // 右侧视频删除button
    [_mineVideoView.rightVideoDeleteBtn addTarget:self action:@selector(rightDelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    // 1、左侧视频播放ImgView：手势
    _mineVideoView.leftVideoPlayImgView.userInteractionEnabled = YES;
    [_mineVideoView.leftVideoPlayImgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(leftVideoPlayImgViewClick)]];
    
    // 2、左侧视频使用Button：点击事件
    [_mineVideoView.leftVideoUseBtn addTarget:self action:@selector(leftVideoUseBtnClicK) forControlEvents:UIControlEventTouchUpInside];
    // 3、左侧视频分享Button：点击事件
    [_mineVideoView.leftVideoShareBtn addTarget:self action:@selector(leftVideoShareBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    // 4、右侧视频播放ImgView：手势
    _mineVideoView.rightVideoPlayImgView.userInteractionEnabled = YES;
    [_mineVideoView.rightVideoPlayImgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rightVideoPlayImgViewClick)]];
    
    // 5、右侧左侧视频使用Button：点击事件
    [_mineVideoView.rightVideoUseBtn addTarget:self action:@selector(rightVideoUseBtnClicK) forControlEvents:UIControlEventTouchUpInside];
    // 6、右侧视频分享Button：点击事件
    [_mineVideoView.rightVideoShareBtn addTarget:self action:@selector(rightVideoShareBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    // 7、上传视频：手机视频button：点击事件
    [_mineVideoView.uploadPhoneVideoBtn addTarget:self action:@selector(uploadPhoneVideoBtnClick) forControlEvents:UIControlEventTouchUpInside];
    // 8、上传视频：拍视频button：点击事件
//    _mineVideoView.hidden = YES;  // hidden 整个视图都不见了，是为什么？？？？
//    [_mineVideoView.uploadPlayVideoBtn addTarget:self action:@selector(uploadPlayVideoBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    // 删除button
    _deleteBarBtnItem = [[UIBarButtonItem alloc] initWithTitle:@"删除" style:2 target:self action:@selector(deleteBarBtnItemClick)];
    
    self.navigationItem.rightBarButtonItem = _deleteBarBtnItem;
    
    self.view = _mineVideoView;
    
}
// 删除视频barButtonItem
- (void)deleteBarBtnItemClick{
    NSLog(@"删除视频barButtonItem：点击事件！");
    
    // 删除状态时，点击进入选择
    if ([_deleteBarBtnItem.title isEqualToString:@"删除"]) {
        
        // 两个删除选择框的状态都是没有选中的
        _leftVideoDelBtnIsSelected = NO;
        _rightVideoDelBtnIsSelected = NO;
        // 改变两个选择按钮的背景 为没选中
        [_mineVideoView.leftVideoDeleteBtn setBackgroundImage:[UIImage imageNamed:@"视频未选中"] forState:UIControlStateNormal];
        [_mineVideoView.rightVideoDeleteBtn setBackgroundImage:[UIImage imageNamed:@"视频未选中"] forState:UIControlStateNormal];
        
        // 还没上传视频
        if (self.dataArray.count == 0) {
            
            // 提示用户还没有上传视频
            [self showHubWithLabelText:@"还没有上传视频" andHidAfterDelay:3.0];
        }
        // 如果只上传了一个视频
        else if (self.dataArray.count == 1) {
            
            // 左侧删除button 出现，左侧删除的选择框显示
            _mineVideoView.leftVideoDeleteBtn.hidden = NO;
            
            // 隐藏所有没用的button，并设置为@“确定”
            [self hidenAllNoUseBtn];
            
            
            // tabBarButtonItem
            _deleteBarBtnItem.title = @"确定";
            
        }
        // 如果上传了两个视频
        else if (self.dataArray.count == 2) {
            
            // 左、右上传视频button 都出现，两个删除的选择框都显示
            _mineVideoView.leftVideoDeleteBtn.hidden = NO;
            _mineVideoView.rightVideoDeleteBtn.hidden = NO;
            
            // 隐藏所有没用的button
            [self hidenAllNoUseBtn];
            
            
            // tabBarButtonItem
            _deleteBarBtnItem.title = @"确定";
            
        }
        
        
    }
    
    // 选择状态时，点击确定，网络请求，删除视频
    else if ([_deleteBarBtnItem.title isEqualToString:@"确定"]) {
        
        
        _mineVideoView.leftVideoDeleteBtn.hidden = YES;
        _mineVideoView.rightVideoDeleteBtn.hidden = YES;
        
        // 显示所有没有的button，并设置为@“删除”
        [self showAllNoUseBtn];
        
        // 网络请求：删除视频
        [self deleteVideo];
        
        
        // tabBarButtonItem
        _deleteBarBtnItem.title = @"删除";
        
    }
    
}


// 隐藏所有按钮，并把title设置为：“确定”
- (void)hidenAllNoUseBtn{
    
    // 左侧
    _mineVideoView.leftVideoUseBtn.hidden = YES;
    _mineVideoView.leftVideoShareBtn.hidden = YES;
    _mineVideoView.leftVideoPlayImgView.hidden = YES;
    
    // 右侧
    _mineVideoView.rightVideoUseBtn.hidden = YES;
    _mineVideoView.rightVideoShareBtn.hidden = YES;
    _mineVideoView.rightVideoPlayImgView.hidden = YES;
    
    // 上传视频button
    _mineVideoView.uploadPhoneVideoBtn.hidden = YES;
    
}

// 显示所有按钮，并把title设置为：“删除”
- (void)showAllNoUseBtn{
    
    // 只有审核通过的，才显示use、share、play
    if (self.dataArray.count == 0) {
        
        
    }
    else if (self.dataArray.count == 1) {
        
        // 只有一个视频时
        CYMineVideoViewModel *leftModel = self.dataArray[0];
        
        if (leftModel.AuditStatus == 1) {
            
            // 审核通过，显示use、share、play
            // 左侧
            _mineVideoView.leftVideoUseBtn.hidden = NO;
            _mineVideoView.leftVideoShareBtn.hidden = NO;
            _mineVideoView.leftVideoPlayImgView.hidden = NO;
            
        }
        else {
            
            // 左侧
            _mineVideoView.leftVideoUseBtn.hidden = YES;
            _mineVideoView.leftVideoShareBtn.hidden = YES;
            _mineVideoView.leftVideoPlayImgView.hidden = YES;
        }
    }
    else if (self.dataArray.count == 2) {
        
        // 有两个视频时
        // 左侧
        CYMineVideoViewModel *leftModel = self.dataArray[0];
        
        if (leftModel.AuditStatus == 1) {
            
            // 审核通过，显示use、share、play
            // 左侧
            _mineVideoView.leftVideoUseBtn.hidden = NO;
            _mineVideoView.leftVideoShareBtn.hidden = NO;
            _mineVideoView.leftVideoPlayImgView.hidden = NO;
            
        }
        else {
            
            // 左侧
            _mineVideoView.leftVideoUseBtn.hidden = YES;
            _mineVideoView.leftVideoShareBtn.hidden = YES;
            _mineVideoView.leftVideoPlayImgView.hidden = YES;
        }
        
        
        // 右侧
        CYMineVideoViewModel *rightModel = self.dataArray[1];
        
        if (rightModel.AuditStatus == 1) {
            
            // 审核通过，显示use、share、play
            // 右侧
            _mineVideoView.rightVideoUseBtn.hidden = NO;
            _mineVideoView.rightVideoShareBtn.hidden = NO;
            _mineVideoView.rightVideoPlayImgView.hidden = NO;
            
        }
        else {
            
            // 右侧
            _mineVideoView.rightVideoUseBtn.hidden = YES;
            _mineVideoView.rightVideoShareBtn.hidden = YES;
            _mineVideoView.rightVideoPlayImgView.hidden = YES;
        }
        
    }
    
    // 上传视频button
    _mineVideoView.uploadPhoneVideoBtn.hidden = NO;
    
    
}

// 删除视频
- (void)deleteVideo{
    
    // 如果左侧视频删除  为选中状态，则删除视频
    if (_leftVideoDelBtnIsSelected) {
        
        CYMineVideoViewModel *leftVideoModel = self.dataArray[0];
        
        // 参数
        NSDictionary *leftParams = @{
                              @"id":leftVideoModel.Id
                              };
        
        [self requestDeleteVideoWithParams:leftParams];
    }
    
    // 如果右侧视频删除 为选中状态，则删除视频
    if (_rightVideoDelBtnIsSelected) {
        
        // 网络请求：删除右侧视频
        CYMineVideoViewModel *rightVideoModel = self.dataArray[1];
        
        // 参数
        NSDictionary *params = @{
                                 @"id":rightVideoModel.Id
                                 };
        
        [self requestDeleteVideoWithParams:params];
    }
    
}

// 网络请求：删除视频
- (void)requestDeleteVideoWithParams:(NSDictionary *)params{
    
    
    // 加载数据前，加载菊花
    [self showLoadingView];
    
    // 网络请求：删除左侧视频
    [CYNetWorkManager getRequestWithUrl:cMineVideoDeleteUrl params:params progress:^(NSProgress *uploadProgress) {
        NSLog(@"删除视频：%@",uploadProgress);
        
    } whenSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"删除视频：请求成功！");
        
        // 1、
        NSString *code = responseObject[@"code"];
        
        // 1.2.1.1.2、和成功的code 匹配
        if ([code isEqualToString:@"0"]) {
            NSLog(@"删除视频：删除成功！");
            
            [self loadData];
            
//            [self showHubWithLabelText:@"删除视频成功!" andHidAfterDelay:3.0];
            
            // 请求数据结束，取消加载
            [self hidenLoadingView];
            
        }
        else{
            NSLog(@"删除视频：删除失败！");
            
            // 1.2.1.1.2.2、获取失败：弹窗提示：获取失败的返回信息
            [self showHubWithLabelText:responseObject[@"res"][@"msg"] andHidAfterDelay:3.0];
            
        }
        
        
    } whenFailure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"删除视频：请求失败！");
        
        
    } withToken:self.onlyUser.userToken];
    
}

// 左侧视频删除button：点击事件
- (void)leftDelBtnClick{
    NSLog(@"左侧视频删除button：点击事件");
    
    // 左侧删除 如果选中
    if (_leftVideoDelBtnIsSelected) {
        
        // 改变背景 为没选中
        [_mineVideoView.leftVideoDeleteBtn setBackgroundImage:[UIImage imageNamed:@"视频未选中"] forState:UIControlStateNormal];
        
        // 左侧删除 设置为没选中
        _leftVideoDelBtnIsSelected = NO;
        
        
    }
    // 左侧删除 如果没选中
    else {
        
        // 改变背景 为选中
        [_mineVideoView.leftVideoDeleteBtn setBackgroundImage:[UIImage imageNamed:@"视频选中"] forState:UIControlStateNormal];
        
        // 左侧删除 设置为选中
        _leftVideoDelBtnIsSelected = YES;
    }
    
    
}

// 右侧视频删除button：点击事件
- (void)rightDelBtnClick{
    NSLog(@"右侧视频删除button：点击事件");
    
    // 右侧删除 如果选中
    if (_rightVideoDelBtnIsSelected) {
        
        // 改变背景 为没选中
        [_mineVideoView.rightVideoDeleteBtn setBackgroundImage:[UIImage imageNamed:@"视频未选中"] forState:UIControlStateNormal];
        
        // 右侧删除 设置为没选中
        _rightVideoDelBtnIsSelected = NO;
    }
    // 右侧删除 如果没选中
    else {
        
        // 改变背景 为没选中
        [_mineVideoView.rightVideoDeleteBtn setBackgroundImage:[UIImage imageNamed:@"视频选中"] forState:UIControlStateNormal];
        
        // 右侧删除 设置为选中
        _rightVideoDelBtnIsSelected = YES;
    }
    
}


// 1、左侧视频播放ImgView：手势
- (void)leftVideoPlayImgViewClick{
    NSLog(@"左侧视频播放ImgView：手势：点击事件");
    
    
}


// 2、左侧视频使用Button：点击事件
- (void)leftVideoUseBtnClicK{
    NSLog(@"左侧视频使用Button：点击事件");
    
    //
    if (self.dataArray.count == 0 && self.dataArray.count == 1) {
        
//        [self showHubWithLabelText:@"请先上传视频" andHidAfterDelay:3.0];
        // 没有视频时，不显示use、share、play：button
    }
    // 只有有两个视频时，左侧的视频使用按钮才有效 && 只有左侧视频使用按钮：可以使用时，才能点击，修改默认
    else if (self.dataArray.count == 2 && [_mineVideoView.leftVideoUseBtn.titleLabel.text isEqualToString:@"使用"]) {
        
        
        // 参数：
        // 左侧视频模型
        CYMineVideoViewModel *leftVideoModel = self.dataArray[0];
        
        // 右侧视频模型
        CYMineVideoViewModel *rightVideoModel = self.dataArray[1];
        
        // 拼接地址
        NSString *newUrlStr = [NSString stringWithFormat:@"%@?id=%@&otherId=%@",cMineVideoSetDefault,leftVideoModel.Id,rightVideoModel.Id];
        
        
        // 网络请求之前，显示加载菊花
        [self showLoadingView];
        
        
        // 网络请求：改变视频默认使用情况
        [CYNetWorkManager postRequestWithUrl:newUrlStr params:nil progress:^(NSProgress *uploadProgress) {
            NSLog(@"左侧：改变视频默认使用：progress:%@",uploadProgress);
        } whenSuccess:^(NSURLSessionDataTask *task, id responseObject) {
            NSLog(@"左侧：改变视频默认使用：请求成功！");
            
            
            // 2.3.1.1、获取code 值
            NSString *code = responseObject[@"code"];
            
            // 2.3.1.2、判断返回值
            if ([code isEqualToString:@"0"]) {
                NSLog(@"左侧：改变视频默认使用：改变成功！");
                
                
                // 刷新界面
                [self loadData];
                
                // 改变视频默认使用成功，提示用户：保存成功
//                [self showHubWithLabelText:@"修改成功！" andHidAfterDelay:3.0];
                
                
                // 改变视频默认使用成功，加载菊花消失
                [self hidenLoadingView];
                
            }
            else{
                NSLog(@"左侧：改变视频默认使用：改变失败！");
                NSLog(@"msg:%@",responseObject[@"res"][@"msg"]);
                
                // 改变视频默认使用失败，加载菊花消失
                [self hidenLoadingView];
                
                // 2.3.1.2.2、改变视频默认使用失败，弹窗
                [self showHubWithLabelText:responseObject[@"res"][@"msg"] andHidAfterDelay:3.0];
            }
            
        } whenFailure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"左侧：改变视频默认使用：请求失败！");
            NSLog(@"error:%@",error);
            
            // 改变视频默认使用：请求：失败，加载菊花消失
            [self hidenLoadingView];
            
            // 2.3.1.2.2、改变视频默认使用失败，弹窗
            [self showHubWithLabelText:@"网络错误，请重新上传！" andHidAfterDelay:3.0];
            
        } withToken:self.onlyUser.userToken];
        
    }
    
    
}

// 3、左侧视频分享Button：点击事件
- (void)leftVideoShareBtnClick{
    NSLog(@"左侧视频分享Button：点击事件");
    
}

// 4、右侧视频播放ImgView：手势
- (void)rightVideoPlayImgViewClick{
    NSLog(@"右侧视频播放ImgView：手势：点击事件");
    
    
}


// 5、右侧视频使用Button：点击事件
- (void)rightVideoUseBtnClicK{
    NSLog(@"右侧视频使用Button：点击事件");
    
    if (self.dataArray.count == 0 && self.dataArray.count == 1) {
        
//        [self showHubWithLabelText:@"请先上传视频" andHidAfterDelay:3.0];
        // 右侧：没有视频时，不显示use、share、play：button
        
    }
    // 只有有两个视频时，右侧的视频使用按钮才有效 && 只有右侧视频使用按钮：可以使用时，才能点击，修改默认
    else if (self.dataArray.count == 2 && [_mineVideoView.rightVideoUseBtn.titleLabel.text isEqualToString:@"使用"]) {
        
        
        // 参数：
        // 左侧视频模型
        CYMineVideoViewModel *leftVideoModel = self.dataArray[0];
        
        // 右侧视频模型
        CYMineVideoViewModel *rightVideoModel = self.dataArray[1];
        
        // 拼接地址
        NSString *newUrlStr = [NSString stringWithFormat:@"%@?id=%@&otherId=%@",cMineVideoSetDefault,rightVideoModel.Id,leftVideoModel.Id];
        
        
        // 网络请求之前，显示加载菊花
        [self showLoadingView];
        
        
        // 网络请求：改变视频默认使用情况
        [CYNetWorkManager postRequestWithUrl:newUrlStr params:nil progress:^(NSProgress *uploadProgress) {
            NSLog(@"右侧：改变视频默认使用：progress:%@",uploadProgress);
        } whenSuccess:^(NSURLSessionDataTask *task, id responseObject) {
            NSLog(@"右侧：改变视频默认使用：请求成功！");
            
            
            // 2.3.1.1、获取code 值
            NSString *code = responseObject[@"code"];
            
            // 2.3.1.2、判断返回值
            if ([code isEqualToString:@"0"]) {
                NSLog(@"右侧：改变视频默认使用：改变成功！");
                
                
                // 刷新界面
                [self loadData];
                
                
                // 改变视频默认使用成功，提示用户：保存成功
//                [self showHubWithLabelText:@"修改成功！" andHidAfterDelay:3.0];
                
                
//                // 改变视频默认使用成功，加载菊花消失
                [self hidenLoadingView];
                
            }
            else{
                NSLog(@"右侧：改变视频默认使用：改变失败！");
                NSLog(@"msg:%@",responseObject[@"res"][@"msg"]);
                
                // 改变视频默认使用失败，加载菊花消失
                [self hidenLoadingView];
                
                // 2.3.1.2.2、改变视频默认使用失败，弹窗
                [self showHubWithLabelText:responseObject[@"res"][@"msg"] andHidAfterDelay:3.0];
            }
            
        } whenFailure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"右侧：改变视频默认使用：请求失败！");
            NSLog(@"error:%@",error);
            
            // 改变视频默认使用：请求：失败，加载菊花消失
            [self hidenLoadingView];
            
            // 2.3.1.2.2、改变视频默认使用失败，弹窗
            [self showHubWithLabelText:@"网络错误，请重新上传！" andHidAfterDelay:3.0];
            
        } withToken:self.onlyUser.userToken];
        
    }
    
    
}
// 6、右侧视频分享Button：点击事件
- (void)rightVideoShareBtnClick{
    NSLog(@"右侧视频分享Button：点击事件");
    
}

// 7、上传视频：手机视频button：点击事件
- (void)uploadPhoneVideoBtnClick{
    NSLog(@"上传视频：手机视频button：点击事件");
    
    
    if (self.dataArray.count != 2) {
        
        // 选择相册还是拍摄
        [self chooseAlbumOrPlay];
        
    }
    else {
        
        [self showHubWithLabelText:@"最多上传两个视频，请先删除再上传！" andHidAfterDelay:3.0];
    }
    
    
    
//    ALAssetsLibrary *library1 = [[ALAssetsLibrary alloc] init];
//    
//    [library1 enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
//        NSLog(@"ALAssetsLibrary：获取视频：成功！");
//        
//        if (group) {
//            
//            [group setAssetsFilter:[ALAssetsFilter allVideos]];
//            [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
//                NSLog(@"");
//                
//                if (result) {
//                    
//                    // 设置缩略图：用的好像是本身的类
//                    CYMineVideoVC *videoInfo = [[CYMineVideoVC alloc] init];
//                    videoInfo.thumbnail = [UIImage imageWithCGImage:result.thumbnail];
//                    videoInfo.videoURL = [result valueForProperty:ALAssetPropertyAssetURL];
//                    videoInfo.videoURL = result.defaultRepresentation.url;
//                    
//                    videoInfo.duration = [result valueForProperty:ALAssetPropertyDuration];
//                    videoInfo.name = [self getFormatedDateStringOfDate:[result valueForProperty:ALAssetPropertyDate]];
//                    videoInfo.size = result.defaultRepresentation.size;
//                    
//                    videoInfo.format = [result.defaultRepresentation.filename pathExtension];
//                    
////                    [];
//                    
//                }
//                
//            }];
//        }
//        
//        
//    } failureBlock:^(NSError *error) {
//        NSLog(@"ALAssetsLibrary：获取视频：失败！");
//        
//        
//    }];
    
    
}

////将创建日期作为文件名
//-(NSString*)getFormatedDateStringOfDate:(NSDate*)date{
//    
//    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
//    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"]; //注意时间的格式：MM表示月份，mm表示分钟，HH用24小时制，小hh是12小时制。
//    NSString* dateString = [dateFormatter stringFromDate:date];
//    return dateString;
//}



// 选择相册还是拍摄
- (void)chooseAlbumOrPlay{
    
    
    // 选择框：相机、相册
    UIActionSheet *sheet;
    
    // 判断是否支持相机
//    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
//        
//        sheet = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"拍照",@"相册", nil];
//    }
//    else {
//        
        sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"相册", nil];
//    }
    
    //
    sheet.tag = 255;
    [sheet showInView:self.view];
    
}


// 选择框：相机、相册，选择的是哪一个：代理事件
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (actionSheet.tag == 255) {
        
        NSUInteger sourceType = 0;
        
        // 判断是否支持相机
//        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
//            
//            switch (buttonIndex) {
//                case 0:
//                    // 取消
//                    return;
//                case 1:
//                    // 相机
//                    sourceType = UIImagePickerControllerSourceTypeCamera;
//                    
//                    break;
//                case 2:
//                    // 相册
//                    sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//                    
//                    break;
//                    
//                default:
//                    break;
//            }
//        }
//        else {
//            
            if (buttonIndex == 0) {
                
                return;
            }
            else {
                sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            }
//        }
        
        // 跳转到相机或相册页面。
        UIImagePickerController *imgPickerController = [[UIImagePickerController alloc] init];
        
        imgPickerController.delegate = self;
        imgPickerController.allowsEditing = YES;
        imgPickerController.sourceType = sourceType;
        imgPickerController.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:sourceType];
        
        [self presentViewController:imgPickerController animated:YES completion:nil];

    }
}



// ImagePicker delegate 事件
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
//    if ([mediaType isEqualToString:@"public.movie"]) {
//        
//    }
    
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        NSLog(@"选择的是照片~~");
        [self showHubWithLabelText:@"请选择视频上传" andHidAfterDelay:3.0];
    }
    else {
        NSLog(@"选择的不是照片：视频或其他");
        
        // 如果是视频：获取视频的地址（在本地的）
        NSURL *videoUrl = info[UIImagePickerControllerMediaURL];
        NSLog(@"videoUrl：%@",videoUrl);
        NSLog(@"视频文件的大小：FileSize：%@",[NSString stringWithFormat:@"%.2f",[self getFileSize:[videoUrl path]]]);
        
        
        // 获取视频总时长
        CGFloat lengthTime = [self getVideoLength:videoUrl];
        NSLog(@"获取的视频总时长：%f",lengthTime);
        
        // 压缩视频
//        NSData *videoData = [NSData dataWithContentsOfURL:[self condenseVideoNewUrl:videoUrl]];
        
        // 视频上传
        [self uploadVideoWithVideoUrl:videoUrl];
        
        
    }
    
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}



// 网络请求：上传视频
- (void)uploadVideoWithVideoUrl:(NSURL *)videoUrl{
    
    NSDictionary *uploadImgParams = @{
                                      @"UserId":self.onlyUser.userID,
                                      @"FileType":@"video"
                                      };
    
    
    
    // 上传之前，加载菊花
    [self showLoadingView];
    
    // 网络请求：上传视频
    [CYNetWorkManager uploadImgRequestWithUrl:cUploadImgUrl params:uploadImgParams constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSLog(@"上传视频：处理视频！");
        
        NSData *videoData = [NSData dataWithContentsOfURL:videoUrl];
        
        NSLog(@"videoData:%@",videoData);
        
        // 文件名
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.mp4",str];
        
        NSLog(@"fileName:%@",fileName);
        
        [formData appendPartWithFileData:videoData name:@"FileData" fileName:fileName mimeType:@"video"];
        
    } progress:^(NSProgress *uploadProgress) {
        NSLog(@"上传进度：%@",uploadProgress);
        
    } whenSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"上传视频请求：请求成功！");
        NSLog(@"responseObject:%@",responseObject);
        
        
        // 2.3.1.1、获取code 值
        NSString *code = responseObject[@"code"];
        
        
        // 2.3.1.2、判断返回值
        if ([code isEqualToString:@"0"]) {
            NSLog(@"上传视频：成功！");
            NSLog(@"msg:%@",responseObject[@"res"][@"msg"]);
            
            
            // 上传视频成功：添加视频到用户的信息
            [self saveVideoInfoWithVideoPath:responseObject[@"res"][@"data"][@"path"] andVideoSize:responseObject[@"res"][@"data"][@"size"]];
            
            
            
        }
        else{
            NSLog(@"上传视频：失败！");
            NSLog(@"msg:%@",responseObject[@"res"][@"msg"]);
            
            
            // 请求失败，加载菊花取消
            [self hidenLoadingView];
            
            // 2.3.1.2.2、上传视频失败，弹窗
            [self showHubWithLabelText:responseObject[@"res"][@"msg"] andHidAfterDelay:3.0];
        }
        
        
    } whenFailure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"上传视频：请求失败！");
        NSLog(@"error:%@",error);
        
        // 请求失败，加载菊花取消
        [self hidenLoadingView];
        
        // 上传视频：请求：失败，弹窗
        [self showHubWithLabelText:@"网络请求出错，请检查网络重新上传！" andHidAfterDelay:3.0];
        
    } withToken:self.onlyUser.userToken];
    
}


// 上传视频成功：添加视频到用户的信息
- (void)saveVideoInfoWithVideoPath:(NSString *)videoPath andVideoSize:(NSString *)videoSize{
    
    
    // 参数
    NSDictionary *params = @{
                             @"UserId":self.onlyUser.userID,
                             @"Introduction":@"用户展示视频，暂时没有设置输入信息的地方",
                             @"Video":videoPath,
                             @"Size":videoSize
                             };
    
    
    // 网络请求：添加用户视频信息
    [CYNetWorkManager postRequestWithUrl:cMineVideoAddUrl params:params progress:^(NSProgress *uploadProgress) {
        NSLog(@"添加用户视频：progress:%@",uploadProgress);
    } whenSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"添加用户视频：请求成功！");
        
        
        // 2.3.1.1、获取code 值
        NSString *code = responseObject[@"code"];
        
        // 2.3.1.2、判断返回值
        if ([code isEqualToString:@"0"]) {
            NSLog(@"添加用户视频：添加成功！");
            
            // 刷新界面
            [self loadData];
            
            // 添加用户视频成功，提示用户：保存成功
            //            [self showHubWithLabelText:@"添加视频成功！" andHidAfterDelay:3.0];
            
            
            //            // 添加用户视频成功，加载菊花消失
            [self hidenLoadingView];
            
        }
        else{
            NSLog(@"添加用户视频：添加失败！");
            NSLog(@"msg:%@",responseObject[@"res"][@"msg"]);
            
            // 添加用户视频失败，加载菊花消失
            [self hidenLoadingView];
            
            // 2.3.1.2.2、添加用户视频失败，弹窗
            [self showHubWithLabelText:responseObject[@"res"][@"msg"] andHidAfterDelay:3.0];
        }
        
    } whenFailure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"添加用户视频：请求失败！");
        NSLog(@"error:%@",error);
        
        // 添加用户视频：请求：失败，加载菊花消失
        [self hidenLoadingView];
        
        // 2.3.1.2.2、添加用户视频失败，弹窗
        [self showHubWithLabelText:@"网络错误，请重新上传！" andHidAfterDelay:3.0];
        
    } withToken:self.onlyUser.userToken];
}




// 压缩视频
//- (NSURL *)condenseVideoNewUrl: (NSURL *)url{
//    // 沙盒目录
//    NSString *docuPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
//    NSString *destFilePath = [docuPath stringByAppendingPathComponent:[NSString stringWithFormat:@"lyh%@.MOV",[self getCurrentTime]]];
//    NSURL *destUrl = [NSURL fileURLWithPath:destFilePath];
//    //将视频文件copy到沙盒目录中
//    NSFileManager *manager = [NSFileManager defaultManager];
//    NSError *error = nil;
//    [manager copyItemAtURL:url toURL:destUrl error:&error];
//    NSLog(@"压缩前--%.2fk",[self getFileSize:destFilePath]);
//    // 播放视频
//    /*
//     NSURL *videoURL = [NSURL fileURLWithPath:destFilePath];
//     AVPlayer *player = [AVPlayer playerWithURL:videoURL];
//     AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
//     playerLayer.frame = self.view.bounds;
//     [self.view.layer addSublayer:playerLayer];
//     [player play];
//     */
//    // 进行压缩
//    AVAsset *asset = [AVAsset assetWithURL:destUrl];
//    //创建视频资源导出会话
//    /**
//     NSString *const AVAssetExportPresetLowQuality; // 低质量
//     NSString *const AVAssetExportPresetMediumQuality;
//     NSString *const AVAssetExportPresetHighestQuality; //高质量
//     */
//    
//    AVAssetExportSession *session = [[AVAssetExportSession alloc] initWithAsset:asset presetName:AVAssetExportPresetLowQuality];
//    // 创建导出的url
//    NSString *resultPath = [docuPath stringByAppendingPathComponent:[NSString stringWithFormat:@"lyhg%@.MOV",[self getCurrentTime]]];
//    session.outputURL = [NSURL fileURLWithPath:resultPath];
//    // 必须配置输出属性
//    session.outputFileType = @"com.apple.quicktime-movie";
//    // 导出视频
//    [session exportAsynchronouslyWithCompletionHandler:^{
//        NSLog(@"压缩后---%.2fk",[self getFileSize:resultPath]);
//        NSLog(@"视频导出完成");
//        
//    }];
//    
//    return session.outputURL;
//}

// 获取当前时间
- (NSString *)getCurrentTime{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateTime = [formatter stringFromDate:[NSDate date]];
    //    NSString *str = [NSString stringWithFormat:@"%@mdxx",dateTime];
    //    NSString *tokenStr = [str stringToMD5:str];
    return dateTime;
    
}


//此方法可以获取文件的大小，返回的是单位是KB。
- (CGFloat) getFileSize:(NSString *)path
{
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


//此方法可以获取视频文件的时长。
- (CGFloat) getVideoLength:(NSURL *)URL
{
    
//    AVURLAsset *avUrl = [AVURLAsset assetWithURL:URL];
//    
//    CMTime time = [avUrl duration];
//    int second = ceil(time.value/time.timescale);
//    return second;
    
    
    return 000.0;
}


// 8、上传视频：拍视频button：点击事件
- (void)uploadPlayVideoBtnClick{
    NSLog(@"上传视频：拍视频button：点击事件");
    
}
@end
