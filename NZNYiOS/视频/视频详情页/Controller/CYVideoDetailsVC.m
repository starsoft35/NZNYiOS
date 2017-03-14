//
//  CYVideoDetailsVC.m
//  nzny
//
//  Created by 男左女右 on 2016/11/27.
//  Copyright © 2016年 nznychina. All rights reserved.
//

#import "CYVideoDetailsVC.h"

// 视频详情页：view
#import "CYVideoDetailsView.h"

// 他人详情页：VC
#import "CYOthersInfoVC.h"


// 联系他
// 聊天界面：VC
#import "CYChatVC.h"
// 加好友弹窗：VC
//#import "CYAddFriendVC.h"
// 加好友弹窗：View
#import "CYAddFriendView.h"


// 送礼弹窗：VC
#import "CYGiveGiftTipVC.h"
// 送礼弹窗：View
#import "CYGiveGiftTipWithMoneyView.h"


// 点赞弹窗：VC
#import "CYLikeTipVC.h"
// 点赞弹窗：View
#import "CYLikeTipWithMoneyView.h"

// 余额不足弹窗：VC
#import "CYBalanceNotEnoughVC.h"
// 余额不足弹窗：View
#import "CYBalanceNotEnoughView.h"


// 充值界面：VC
#import "CYRechargeVC.h"


#define MAX_LIMIT_NUMS (30)



@interface CYVideoDetailsVC ()<UITextFieldDelegate,UITextViewDelegate>


// 送礼弹窗：View
@property(nonatomic, strong) CYGiveGiftTipWithMoneyView *giveGiftTipView;
// 点赞弹窗：View
@property(nonatomic, strong) CYLikeTipWithMoneyView *likeTipWithMoneyView;
// 余额不足弹窗：View
@property(nonatomic, strong) CYBalanceNotEnoughView *balanceNotEnoughView;

// 加好友弹窗：View
@property(nonatomic, strong) CYAddFriendView *addFriendView;


// 模型：视频详情页
@property (nonatomic, strong) CYVideoDetailsViewModel *videoDetailsViewModel;


// 临时arr
//@property(nonatomic, strong) NSMutableArray *tempArr;


@end

@implementation CYVideoDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    // 添加视图
    [self addView];
    
    
    
    // 阿里云播放器：代理
//    [AliVcMediaPlayer setAccessKeyDelegate:self];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    // 隐藏导航栏
    self.navigationController.navigationBarHidden = YES;
    
    
//    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    // 加载数据
    [self loadData];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    // 显示导航栏
    self.navigationController.navigationBarHidden = NO;
}


// 加载数据
- (void)loadData{
    
//    // 网络请求：他人详情页
//    // URL参数
//    NSDictionary *params = @{
//                             @"userId":self.onlyUser.userID,
//                             @"oppUserId":self.oppUserId,
//                             };
//    
//    //    [self showLoadingView];
//    
//    // 网络请求：他人详情页
//    [CYNetWorkManager getRequestWithUrl:cOppUserInfoUrl params:params progress:^(NSProgress *uploadProgress) {
//        NSLog(@"获取他人详情页进度：%@",uploadProgress);
//        
//        
//    } whenSuccess:^(NSURLSessionDataTask *task, id responseObject) {
//        NSLog(@"他人详情页：请求成功！");
//        
//        // 1、
//        NSString *code = responseObject[@"code"];
//        
//        // 1.2.1.1.2、和成功的code 匹配
//        if ([code isEqualToString:@"0"]) {
//            NSLog(@"他人详情页：获取成功！");
//            NSLog(@"他人详情页：%@",responseObject);
//            
//            // 清空：每次刷新都需要
//            [self.dataArray removeAllObjects];
//            
//            // 解析数据，模型存到数组
//            [self.dataArray addObject:[[CYOthersInfoViewModel alloc] initWithDictionary:responseObject[@"res"][@"data"][@"model"] error:nil]];
//            
//            // 模型赋值
//            if (self.dataArray.count != 0) {
//                
//                _videoDetailsView.othersInfoVM = self.dataArray[0];
//                
//                
//            }
//            
//            // 请求数据结束，取消加载
//            [self hidenLoadingView];
//            
//            
//        }
//        else{
//            NSLog(@"他人详情页：获取失败:responseObject:%@",responseObject);
//            NSLog(@"他人详情页：获取失败:responseObject:res:msg:%@",responseObject[@"res"][@"msg"]);
//            // 1.2.1.1.2.2、获取失败：弹窗提示：获取失败的返回信息
//            [self showHubWithLabelText:responseObject[@"res"][@"msg"] andHidAfterDelay:3.0];
//            
//        }
//        
//        
//    } whenFailure:^(NSURLSessionDataTask *task, NSError *error) {
//        NSLog(@"他人详情页：请求失败！");
//        NSLog(@"失败原因：error：%@",error);
//        
//        [self showHubWithLabelText:@"请检查网络，重新加载" andHidAfterDelay:3.0];
//    } withToken:self.onlyUser.userToken];
    
    
    
    
    
    [self showLoadingView];
    
    
    
    
    
    
    
    
    // 网络请求：视频视图详情
    // URL参数
    NSDictionary *videoDetailParams = @{
                                        @"id":self.videoId
                                        };
    
    [CYNetWorkManager getRequestWithUrl:cVideoViewDetailUrl params:videoDetailParams progress:^(NSProgress *uploadProgress) {
        NSLog(@"获取视频视图详情进度：%@",uploadProgress);
        
        
    } whenSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"视频视图详情：请求成功！");
        
        [self hidenLoadingView];
        
        // 1、
        NSString *code = responseObject[@"code"];
        
        // 1.2.1.1.2、和成功的code 匹配
        if ([code isEqualToString:@"0"]) {
            NSLog(@"视频视图详情：获取成功！");
            NSLog(@"视频视图详情：%@",responseObject);
            
            // 清空：每次刷新都需要
//            [self.tempArr removeAllObjects];
            
            
            // 解析数据，模型存到数组
            _videoDetailsViewModel = [[CYVideoDetailsViewModel alloc] initWithDictionary:responseObject[@"res"][@"data"][@"model"] error:nil];
            
            
            
            // 网络请求：判断是否已关注
            [self requestIfIsFollow];
            
            
            self.oppUserId = _videoDetailsViewModel.VideoUserId;
            self.videoId = _videoDetailsViewModel.VideoId;
            self.videoPlayUrl = _videoDetailsViewModel.VideoUrl;
            
            
            
            
        }
        else{
            NSLog(@"视频视图详情：获取失败:responseObject:%@",responseObject);
            NSLog(@"视频视图详情：获取失败:responseObject:res:msg:%@",responseObject[@"res"][@"msg"]);
            // 1.2.1.1.2.2、获取失败：弹窗提示：获取失败的返回信息
            [self showHubWithLabelText:responseObject[@"res"][@"msg"] andHidAfterDelay:3.0];
            
        }
        
        
    } whenFailure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"视频视图详情：请求失败！");
        NSLog(@"失败原因：error：%@",error);
        
        [self showHubWithLabelText:@"请检查网络，重新加载" andHidAfterDelay:3.0];
    } withToken:self.onlyUser.userToken];
    
    
    
    
    
}

// 网络请求：判断是否已关注
- (void)requestIfIsFollow{
    
    
    // 网络请求：判断是否已关注
    // 参数
    NSString *newUrl = [NSString stringWithFormat:@"%@?userId=%@&oppUserId=%@",cIfIsFriendUrl,self.onlyUser.userID,self.oppUserId];
    
    [self showLoadingView];
    
    [CYNetWorkManager postRequestWithUrl:newUrl params:nil progress:^(NSProgress *uploadProgress) {
        NSLog(@"判断是否已关注：progress:%@",uploadProgress);
        
        
    } whenSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"判断是否已关注：请求成功！");
        
        
        // 2.3.1.1、获取code 值
        NSString *code = responseObject[@"code"];
        
        // 2.3.1.2、判断返回值
        if ([code isEqualToString:@"0"]) {
            NSLog(@"判断是否已关注：结果成功！");
            
            _videoDetailsViewModel.IsFollow = [responseObject[@"res"][@"IsFriend"] boolValue];
            
            
            
            _videoDetailsView.videoDetailsViewModel = _videoDetailsViewModel;
            
            
            [self hidenLoadingView];
            
        }
        else{
            NSLog(@"判断是否已关注：结果失败！");
            NSLog(@"msg:%@",responseObject[@"res"][@"msg"]);
            
            
            // 2.3.1.2.2、加关注失败，弹窗
            [self showHubWithLabelText:responseObject[@"res"][@"msg"] andHidAfterDelay:3.0];
        }
        
    } whenFailure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"判断是否已关注：请求失败！");
        NSLog(@"error:%@",error);
        
        
        // 2.3.1.2.2、加关注请求失败，弹窗
        [self showHubWithLabelText:@"网络错误，请重新上传！" andHidAfterDelay:3.0];
        
        
    } withToken:self.onlyUser.userToken];
    
    

}


// 添加视图
- (void)addView{
    
    _videoDetailsView = [[[NSBundle mainBundle] loadNibNamed:@"CYVideoDetailsView" owner:nil options:nil] lastObject];
    
    
    
    _videoDetailsView.frame = CGRectMake(0, 0, cScreen_Width, cScreen_Height);
    
    // 关闭：button：点击事件
    [_videoDetailsView.closeBtn addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    // 上部头部：手势
    _videoDetailsView.topHeadNameIDFollowView.userInteractionEnabled = YES;
    [_videoDetailsView.topHeadNameIDFollowView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(topHeadNameIDFollowViewClick)]];
    
    // 关注：button：点击事件
    [_videoDetailsView.followBtn addTarget:self action:@selector(followBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    // 联系他：button：点击事件
    [_videoDetailsView.connectBtn addTarget:self action:@selector(connectBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    // 送礼：button：点击事件
    [_videoDetailsView.giveGiftBtn addTarget:self action:@selector(giveGiftBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    // 点赞：button：点击事件
    [_videoDetailsView.likeBtn addTarget:self action:@selector(likeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    // 分享：button：点击事件
    [_videoDetailsView.shareBtn addTarget:self action:@selector(shareBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    // 播放：button：点击事件
    [_videoDetailsView.playBtn addTarget:self action:@selector(playBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_videoDetailsView];
//    self.view = videoDetailsView;
    
}


// 上部头部：手势
- (void)topHeadNameIDFollowViewClick{
    NSLog(@"上部头部：手势");
    
    
    // 他人详情页
    CYOthersInfoVC *othersInfoVC = [[CYOthersInfoVC alloc] init];
    
    othersInfoVC.oppUserId = self.oppUserId;
    
    
    [self.navigationController pushViewController:othersInfoVC animated:YES];
    
    [othersInfoVC.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
    
    
    
}

// 关闭：button：点击事件
- (void)closeBtnClick{
    NSLog(@"关闭：button：点击事件");
    
//    [self.moviePlayerVC.view removeFromSuperview];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


// 关注：button：点击事件
- (void)followBtnClick{
    NSLog(@"关注：button：点击事件");
    
    
    // 如果已关注，则取消关注
//    if (_othersInfoView.othersInfoViewModel.IsFollow == YES) {
//        // 网络请求：取消关注
//        [self delFollow];
//    }
//    // 如果没关注，则加关注
//    else {
//        
//        // 网络请求：加关注
        [self addFollow];
//    }
    
    
}

// 网络请求：加关注
- (void)addFollow{
    
    // 网络请求：加关注
    // 参数
    NSString *newUrl = [NSString stringWithFormat:@"%@?userId=%@&oppUserId=%@",cAddFollowUrl,self.onlyUser.userID,self.oppUserId];
    
    [self showLoadingView];
    
    // 网络请求：加关注
    [CYNetWorkManager postRequestWithUrl:newUrl params:nil progress:^(NSProgress *uploadProgress) {
        NSLog(@"加关注：progress:%@",uploadProgress);
        
        
    } whenSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"加关注：请求成功！");
        
        
        // 2.3.1.1、获取code 值
        NSString *code = responseObject[@"code"];
        
        // 2.3.1.2、判断返回值
        if ([code isEqualToString:@"0"]) {
            NSLog(@"加关注：关注成功！");
            
            // 隐藏菊花
            //            [self hidenLoadingView];
            
            // 刷新数据
            [self loadData];
            
        }
        else{
            NSLog(@"加关注：关注失败！");
            NSLog(@"msg:%@",responseObject[@"res"][@"msg"]);
            
            
            // 2.3.1.2.2、加关注失败，弹窗
            [self showHubWithLabelText:responseObject[@"res"][@"msg"] andHidAfterDelay:3.0];
        }
        
    } whenFailure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"加关注：请求失败！");
        NSLog(@"error:%@",error);
        
        // 加关注：请求：失败，加载菊花消失
        [self hidenLoadingView];
        
        // 2.3.1.2.2、加关注请求失败，弹窗
        [self showHubWithLabelText:@"网络错误，请重新上传！" andHidAfterDelay:3.0];
        
        
    } withToken:self.onlyUser.userToken];
}


// 联系他：button：点击事件
- (void)connectBtnClick{
    NSLog(@"联系他：button：点击事件");
    
    
    // 网络请求：判断是否为好友
    // 参数
    NSString *newUrl = [NSString stringWithFormat:@"%@?userId=%@&oppUserId=%@",cIfIsFriendUrl,self.onlyUser.userID,self.oppUserId];
    
    [self showLoadingView];
    
    [CYNetWorkManager postRequestWithUrl:newUrl params:nil progress:^(NSProgress *uploadProgress) {
        NSLog(@"判断是否为好友：progress:%@",uploadProgress);
        
        
    } whenSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"判断是否为好友：请求成功！");
        
        
        // 2.3.1.1、获取code 值
        NSString *code = responseObject[@"code"];
        
        // 2.3.1.2、判断返回值
        if ([code isEqualToString:@"0"]) {
            NSLog(@"判断是否为好友：结果成功！");
            
            // 如果是好友，聊天界面
            if ([responseObject[@"res"][@"IsFriend"] boolValue]) {
                
                
                // 聊天界面
                [self chatToElsePeopleVC];
                
                
            }
            else{
                
                
                // 加好友界面
                [self addFriendViewWithOppUserId:self.oppUserId];
            }
            
            [self hidenLoadingView];
            
        }
        else{
            NSLog(@"判断是否为好友：结果失败！");
            NSLog(@"msg:%@",responseObject[@"res"][@"msg"]);
            
            
            // 2.3.1.2.2、加关注失败，弹窗
            [self showHubWithLabelText:responseObject[@"res"][@"msg"] andHidAfterDelay:3.0];
        }
        
    } whenFailure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"判断是否为好友：请求失败！");
        NSLog(@"error:%@",error);
        
        
        // 2.3.1.2.2、加关注请求失败，弹窗
        [self showHubWithLabelText:@"网络错误，请重新上传！" andHidAfterDelay:3.0];
        
        
    } withToken:self.onlyUser.userToken];
    
    
    
}

// 聊天界面
- (void)chatToElsePeopleVC{
    
    
    // 模型
    
    
    
    // 融云SDK
    // 新建一个聊天会话viewController 对象
    CYChatVC *chatVC = [[CYChatVC alloc] init];
    
    
    
    // 设置会话的类型，如单聊、讨论组、群聊、聊天室、客服、公众服务会话等
    chatVC.conversationType = ConversationType_PRIVATE;
    
    
    // 设置会话的目标会话ID。（单聊、客服、公众服务号会话为对方的ID，讨论组、群聊、聊天室为会话的ID）
    chatVC.targetId = _videoDetailsViewModel.VideoUserId;
    
    // 设置聊天会话界面要显示的标题
    chatVC.title = _videoDetailsViewModel.VideoUserName;
    
    // 显示聊天会话界面
    [self.navigationController pushViewController:chatVC animated:YES];
    
}


// 加好友界面
- (void)addFriendViewWithOppUserId:(NSString *)oppUserId{
    
    
    
//    CYAddFriendVC *addFriendVC = [[CYAddFriendVC alloc] init];
//    
//    addFriendVC.OppUserId = oppUserId;
//    
//    
//    [self presentViewController:addFriendVC animated:YES completion:nil];
    
    
    
    
    
    _addFriendView = [[[NSBundle mainBundle] loadNibNamed:@"CYAddFriendView" owner:nil options:nil] lastObject];
    
    _addFriendView.frame = CGRectMake(0, 0, cScreen_Width, cScreen_Height);
    
    
    //    _addFriendView.backgroundColor = [UIColor colorWithRed:0.55 green:0.55 blue:0.55 alpha:0.50];
    _addFriendView.backgroundColor = [UIColor clearColor];
    //    _giveGiftTipView.giveGiftBgImgView.hidden = YES;
    
    // tipCloseBtn：关闭弹窗：点击事件
    [_addFriendView.tipCloseBtn addTarget:self action:@selector(addFriendViewCloseBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    // 添加好友：button：点击事件
    [_addFriendView.addFriendBtn addTarget:self action:@selector(addFriendViewAddFriendBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    _addFriendView.sayToYouTextView.delegate = self;
    
    
    [self.view addSubview:_addFriendView];
    
    
    
}


// tipCloseBtn：关闭弹窗：点击事件
- (void)addFriendViewCloseBtnClick{
    NSLog(@"tipCloseBtn：关闭弹窗：点击事件");
    
    [self.addFriendView removeFromSuperview];
    
}

// 添加好友：button：点击事件
- (void)addFriendViewAddFriendBtnClick{
    NSLog(@"添加好友：button：点击事件");
    
    // 网络请求：添加好友
    // 参数
    NSDictionary *params = @{
                             @"UserId":self.onlyUser.userID,
                             @"OppUserId":self.oppUserId,
                             @"Description":self.addFriendView.sayToYouTextView.text
                             };
    NSLog(@"Description:%@",self.addFriendView.sayToYouTextView.text);
    // 网络请求：添加好友
    [CYNetWorkManager postRequestWithUrl:cApplyFriendUrl params:params progress:^(NSProgress *uploadProgress) {
        NSLog(@"progress:%@",uploadProgress);
        
    } whenSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"添加好友：请求成功！");
        
        
        // 去掉添加好友弹窗
        [self.addFriendView removeFromSuperview];
        
        
        // 2.3.1.1、获取code 值
        NSString *code = responseObject[@"code"];
        
        // 2.3.1.2、判断返回值
        if ([code isEqualToString:@"0"]) {
            NSLog(@"添加好友：添加成功！");
            
            
            //            [self dismissViewControllerAnimated:YES completion:nil];
            
            // 添加好友成功，提示用户：保存成功
            [self showHubWithLabelText:@"申请成功！" andHidAfterDelay:3.0];
            
            
            
        }
        else{
            NSLog(@"添加好友：添加失败！");
            NSLog(@"msg:%@",responseObject[@"res"][@"msg"]);
            
            // 2.3.1.2.2、添加好友失败，弹窗
            [self showHubWithLabelText:responseObject[@"res"][@"msg"] andHidAfterDelay:3.0];
        }
        
    } whenFailure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"添加好友：请求失败！");
        NSLog(@"error:%@",error);
        [self showHubWithLabelText:@"添加好友失败，请检查网络" andHidAfterDelay:3.0];
        
    } withToken:self.onlyUser.userToken];
    
}


#pragma mark --UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView{
    
    
    // 键盘弹出：上拉弹窗
    [UIView animateWithDuration:0.5 animations:^{
        self.addFriendView.frame = CGRectMake(0, -128, cScreen_Width, cScreen_Height);
    }];
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    
    self.addFriendView.surplusCountLab.hidden = NO;
    self.addFriendView.maxCountLab.hidden = NO;
    self.addFriendView.guideHerToSayLab.hidden = YES;
    
    UITextRange *selectedRange = [textView markedTextRange];
    //获取高亮部分
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
    //获取高亮部分内容
    //NSString * selectedtext = [textView textInRange:selectedRange];
    
    //如果有高亮且当前字数开始位置小于最大限制时允许输入
    if (selectedRange && pos) {
        NSInteger startOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.start];
        NSInteger endOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.end];
        NSRange offsetRange = NSMakeRange(startOffset, endOffset - startOffset);
        
        if (offsetRange.location < MAX_LIMIT_NUMS) {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    
    
    NSString *comcatstr = [textView.text stringByReplacingCharactersInRange:range withString:text];
    
    NSInteger caninputlen = MAX_LIMIT_NUMS - comcatstr.length;
    
    if (caninputlen >= 0)
    {
        return YES;
    }
    else
    {
        NSInteger len = text.length + caninputlen;
        //防止当text.length + caninputlen < 0时，使得rg.length为一个非法最大正数出错
        NSRange rg = {0,MAX(len,0)};
        
        if (rg.length > 0)
        {
            NSString *s = @"";
            //判断是否只普通的字符或asc码(对于中文和表情返回NO)
            BOOL asc = [text canBeConvertedToEncoding:NSASCIIStringEncoding];
            if (asc) {
                s = [text substringWithRange:rg];//因为是ascii码直接取就可以了不会错
            }
            else
            {
                __block NSInteger idx = 0;
                __block NSString  *trimString = @"";//截取出的字串
                //使用字符串遍历，这个方法能准确知道每个emoji是占一个unicode还是两个
                [text enumerateSubstringsInRange:NSMakeRange(0, [text length])
                                         options:NSStringEnumerationByComposedCharacterSequences
                                      usingBlock: ^(NSString* substring, NSRange substringRange, NSRange enclosingRange, BOOL* stop) {
                                          
                                          if (idx >= rg.length) {
                                              *stop = YES; //取出所需要就break，提高效率
                                              return ;
                                          }
                                          
                                          trimString = [trimString stringByAppendingString:substring];
                                          
                                          idx++;
                                      }];
                
                s = trimString;
            }
            //rang是指从当前光标处进行替换处理(注意如果执行此句后面返回的是YES会触发didchange事件)
            [textView setText:[textView.text stringByReplacingCharactersInRange:range withString:s]];
            //既然是超出部分截取了，哪一定是最大限制了。
            //            self.declarationTF.text = [NSString stringWithFormat:@"%d/%ld",0,(long)MAX_LIMIT_NUMS];
            self.addFriendView.surplusCountLab.text = [NSString stringWithFormat:@"%d ",0];
            self.addFriendView.maxCountLab.text = [NSString stringWithFormat:@"/ %ld",(long)MAX_LIMIT_NUMS];
        }
        return NO;
    }
}
- (void)textViewDidChange:(UITextView *)textView{
    
    self.addFriendView.surplusCountLab.hidden = NO;
    self.addFriendView.maxCountLab.hidden = NO;
    
    
    UITextRange *selectedRange = [textView markedTextRange];
    //获取高亮部分
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
    
    //如果在变化中是高亮部分在变，就不要计算字符了
    if (selectedRange && pos) {
        return;
    }
    
    NSString  *nsTextContent = textView.text;
    NSInteger existTextNum = nsTextContent.length;
    
    if (existTextNum > MAX_LIMIT_NUMS)
    {
        //截取到最大位置的字符(由于超出截部分在should时被处理了所在这里这了提高效率不再判断)
        NSString *s = [nsTextContent substringToIndex:MAX_LIMIT_NUMS];
        
        [textView setText:s];
    }
    
    //不让显示负数 口口日
    //    self.declarationTF.text = [NSString stringWithFormat:@"%ld/%d",MAX(0,MAX_LIMIT_NUMS - existTextNum),MAX_LIMIT_NUMS];
    self.addFriendView.surplusCountLab.text = [NSString stringWithFormat:@"%ld ",MAX(0,MAX_LIMIT_NUMS - existTextNum)];
    self.addFriendView.maxCountLab.text = [NSString stringWithFormat:@"/ %d",MAX_LIMIT_NUMS];
}



//// 送礼：button：点击事件
//- (void)giveGiftBtnClick{
//    NSLog(@"送礼：button：点击事件");
//    
//    // 送礼弹窗
//    CYGiveGiftTipVC *giveGiftTipVC = [[CYGiveGiftTipVC alloc] init];
//    
//    giveGiftTipVC.oppUserId = self.oppUserId;
//    
//    [self presentViewController:giveGiftTipVC animated:YES completion:nil];
//    
//}
//// 点赞：button：点击事件
//- (void)likeBtnClick{
//    NSLog(@"点赞：button：点击事件");
//    
//    // 点赞弹窗
//    CYLikeTipVC *likeTipVC = [[CYLikeTipVC alloc] init];
//    
//    likeTipVC.oppUserId = self.oppUserId;
//    likeTipVC.addLikeUrl = cAddUserVideoLikeUrl;
//    
//    [self presentViewController:likeTipVC animated:YES completion:nil];
//    
//}

#pragma mark------------------------ 送礼开始：弹窗 ---------------------------------------

// 送礼：button：点击事件
- (void)giveGiftBtnClick{
    NSLog(@"送礼：button：点击事件");
    
    _giveGiftTipView = [[[NSBundle mainBundle] loadNibNamed:@"CYGiveGiftTipWithMoneyView" owner:nil options:nil] lastObject];
    
    _giveGiftTipView.frame = CGRectMake(0, 0, cScreen_Width, cScreen_Height);
    
    
    //    _giveGiftTipView.backgroundColor = [UIColor colorWithRed:0.55 green:0.55 blue:0.55 alpha:0.70];
    _giveGiftTipView.backgroundColor = [UIColor clearColor];
    //    _giveGiftTipView.giveGiftBgImgView.hidden = YES;
    
    // tipCloseBtn：关闭弹窗：点击事件
    [_giveGiftTipView.tipCloseBtn addTarget:self action:@selector(giveGiftTipCloseBtnClick) forControlEvents:UIControlEventTouchUpInside];
    // 一支玫瑰花：点击事件
    [_giveGiftTipView.oneRoseBtn addTarget:self action:@selector(oneRoseBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    // 三支玫瑰花：点击事件
    [_giveGiftTipView.threeRoseBtn addTarget:self action:@selector(threeRoseBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    // 九支玫瑰花：点击事件
    [_giveGiftTipView.nineRoseBtn addTarget:self action:@selector(nineRoseBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    // 九十九支玫瑰花：点击事件
    [_giveGiftTipView.ninetyNineRoseBtn addTarget:self action:@selector(ninetyNineRoseBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    // 送礼：textField：文本改变事件
    [_giveGiftTipView.giftCountTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    // 送礼：button：点击事件
    [_giveGiftTipView.giveGiftBtn addTarget:self action:@selector(giveGiftTipGiveGiftBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    _giveGiftTipView.giftCountTextField.delegate = self;
    
    [self.view addSubview:_giveGiftTipView];
    
}

// 一支玫瑰花：点击事件
- (void)oneRoseBtnClick{
    NSLog(@"一支玫瑰花：点击事件");
    
    // 送礼：玫瑰花数量
    NSInteger roseCount = 1;
    
    // 网络请求：送一支玫瑰花
    [self requestUserBalanceIfIsEnoughWithUserId:self.onlyUser.userID andOppUserId:self.oppUserId andGiftCount:roseCount andCost:(2.0 * roseCount)];
    
}



// 三支玫瑰花：点击事件
- (void)threeRoseBtnClick{
    NSLog(@"三支玫瑰花：点击事件");
    
    // 送礼：玫瑰花数量
    NSInteger roseCount = 3;
    
    // 网络请求：送三支玫瑰花
    [self requestUserBalanceIfIsEnoughWithUserId:self.onlyUser.userID andOppUserId:self.oppUserId andGiftCount:roseCount andCost:(2.0 * roseCount)];
    
}

// 九支玫瑰花：点击事件
- (void)nineRoseBtnClick{
    NSLog(@"九支玫瑰花：点击事件");
    
    // 送礼：玫瑰花数量
    NSInteger roseCount = 9;
    
    // 网络请求：送九支玫瑰花
    [self requestUserBalanceIfIsEnoughWithUserId:self.onlyUser.userID andOppUserId:self.oppUserId andGiftCount:roseCount andCost:(2.0 * roseCount)];
    
}

// 九十九支玫瑰花：点击事件
- (void)ninetyNineRoseBtnClick{
    NSLog(@"九十九支玫瑰花：点击事件");
    
    // 送礼：玫瑰花数量
    NSInteger roseCount = 99;
    
    // 网络请求：送九十九支玫瑰花
    [self requestUserBalanceIfIsEnoughWithUserId:self.onlyUser.userID andOppUserId:self.oppUserId andGiftCount:roseCount andCost:(2.0 * roseCount)];
}


// 送礼：button：点击事件
- (void)giveGiftTipGiveGiftBtnClick{
    NSLog(@"送礼：button：点击事件");
    
    NSScanner *scan = [NSScanner scannerWithString:self.giveGiftTipView.giftCountTextField.text];
    
    NSInteger flag;
    
    if ([scan scanInteger:&flag] && [scan isAtEnd]) {
        
        // 送礼：玫瑰花数量
        NSInteger roseCount = [self.giveGiftTipView.giftCountTextField.text integerValue];
        
        // 网络请求：送 n 支玫瑰花
        [self requestUserBalanceIfIsEnoughWithUserId:self.onlyUser.userID andOppUserId:self.oppUserId andGiftCount:roseCount andCost:(2.0 * roseCount)];
        
    }
    else {
        
        [self.view bringSubviewToFront:self.hud];
        [self showHubWithLabelText:@"请输入数字" andHidAfterDelay:3.0];
    }
    
    
}


// 网络请求：用户余额：余额够，则送礼请求，不够则充值弹窗
- (void)requestUserBalanceIfIsEnoughWithUserId:(NSString *)userId andOppUserId:(NSString *)oppUserId andGiftCount:(NSInteger)likeCount andCost:(float)cost{
    NSLog(@"用户余额：网络请求！");
    
    [self showLoadingView];
    
    // 新地址
    NSString *newUrl = [NSString stringWithFormat:@"%@?userId=%@",cUserMoneyUrl,userId];
    
    // 网络请求：用户余额
    [CYNetWorkManager getRequestWithUrl:newUrl params:nil progress:^(NSProgress *uploadProgress) {
        NSLog(@"用户余额：%@",uploadProgress);
        
        
    } whenSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"用户余额：请求成功！");
        
        // 1、
        NSString *code = responseObject[@"code"];
        
        // 1.2.1.1.2、和成功的code 匹配
        if ([code isEqualToString:@"0"]) {
            NSLog(@"用户余额：获取成功！");
            NSLog(@"用户余额：%@",responseObject);
            
            
            
            // 请求数据结束，取消加载
//            [self hidenLoadingView];
            
            
            NSString * tempMoneyStr = responseObject[@"res"][@"data"][@"money"];
            float tempMoney = [tempMoneyStr floatValue];
            
            NSLog(@"tempMoneyStr:%@",tempMoneyStr);
            NSLog(@"tempMoney:%lf",tempMoney);
            NSLog(@"cost:%lf",cost);
            
            // 如果余额够支付，则赞、支付
            if (tempMoney >= cost) {
                
                self.isEnoughForPay = YES;
                
                // 网路请求：送礼
                [self requestGiveGiftWithUserId:self.onlyUser.userID andReceiveUserId:self.oppUserId andGiftCount:likeCount];
                
            }
            // 余额不足，则弹到充值界面
            else {
                
                // 请求数据结束，取消加载
                [self hidenLoadingView];
                
                
                
                
#pragma mark------------------------ 余额不足弹窗：开始 --------------------------------------
                
                
                
                _balanceNotEnoughView = [[[NSBundle mainBundle] loadNibNamed:@"CYBalanceNotEnoughView" owner:nil options:nil] lastObject];
                
                _balanceNotEnoughView.frame = CGRectMake(0, 0, cScreen_Width, cScreen_Height);
                
                
                
                
                _balanceNotEnoughView.backgroundColor = [UIColor clearColor];
                _balanceNotEnoughView.balanceNotEnoughBgImgView.hidden = YES;
                
                // 余额不足：弹窗关闭：button：点击事件
                [_balanceNotEnoughView.closeBtn addTarget:self action:@selector(balanceNotEnoughCloseBtnClick) forControlEvents:UIControlEventTouchUpInside];
                
                // 立即充值：button：点击事件
                [_balanceNotEnoughView.instantRechargeBtn addTarget:self action:@selector(balanceNotEnoughInstantRechargeBtnClick) forControlEvents:UIControlEventTouchUpInside];
                
                
                // 送礼弹窗：恢复位置
                [UIView animateWithDuration:0.5 animations:^{
                    self.giveGiftTipView.bounds = CGRectMake(0, 0, cScreen_Width, cScreen_Height);
                    
                }];
                // 隐藏键盘
                [self.view endEditing:YES];
                
                
                [self.view addSubview:_balanceNotEnoughView];
                
                
            }
        }
        else{
            NSLog(@"用户余额：获取失败:responseObject:%@",responseObject);
            NSLog(@"用户余额：获取失败:responseObject:res:msg:%@",responseObject[@"res"][@"msg"]);
            // 1.2.1.1.2.2、获取失败：弹窗提示：获取失败的返回信息
            [self showHubWithLabelText:responseObject[@"res"][@"msg"] andHidAfterDelay:3.0];
            
        }
        
        
    } whenFailure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"用户余额：请求失败！");
        NSLog(@"点一个赞：error：%@",error);
        
        [self showHubWithLabelText:@"请检查网络，重新加载" andHidAfterDelay:3.0];
    } withToken:self.onlyUser.userToken];
    
}


// 余额不足：弹窗关闭：button：点击事件
- (void)balanceNotEnoughCloseBtnClick{
    NSLog(@"余额不足：弹窗关闭：button：点击事件");
    
    [self.balanceNotEnoughView removeFromSuperview];
    
}

// 余额不足：立即充值：button：点击事件
- (void)balanceNotEnoughInstantRechargeBtnClick{
    NSLog(@"余额不足：立即充值：button：点击事件");
    
    
    // 充值界面
    CYRechargeVC *rechargeVC = [[CYRechargeVC alloc] init];
    
    [[self navigationControllerWithView:self.view] setNavigationBarHidden:NO animated:YES];
    
    // 导航VC：获取当前视图所在位置的导航控制器
    [[self navigationControllerWithView:self.view] pushViewController:rechargeVC animated:YES];
    
    [self.balanceNotEnoughView removeFromSuperview];
}

#pragma mark------------------------ 充值弹窗：结束 ---------------------------------------

// 送礼：网络请求
- (void)requestGiveGiftWithUserId:(NSString *)userId andReceiveUserId:(NSString *)receiveUserId andGiftCount:(NSInteger)giftCount{
    NSLog(@"送礼：网络请求！");
    
    [self showLoadingView];
    
    // 参数
    NSDictionary *params = @{
                             @"UserId":userId,
                             @"ReceiveUserId":receiveUserId,
                             @"Count":@(giftCount)
                             };
    
    // 网络请求：送 n 支玫瑰花
    [CYNetWorkManager postRequestWithUrl:cAddFlowersUrl params:params progress:^(NSProgress *uploadProgress) {
        NSLog(@"送 %ld 支玫瑰花进度：%@",(long)giftCount,uploadProgress);
        
        
    } whenSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"送 %ld 支玫瑰花：请求成功！",(long)giftCount);
        
        // 1、
        NSString *code = responseObject[@"code"];
        
        // 1.2.1.1.2、和成功的code 匹配
        if ([code isEqualToString:@"0"]) {
            NSLog(@"送 %ld 支玫瑰花：送礼成功！",(long)giftCount);
            NSLog(@"送 %ld 支玫瑰花：%@",(long)giftCount,responseObject);
            
            
            // 请求数据结束，取消加载
//            [self hidenLoadingView];
            
            [self showHubWithLabelText:[NSString stringWithFormat:@"送%ld朵玫瑰成功！",(long)giftCount] andHidAfterDelay:3.0];
            
            
            [self.giveGiftTipView removeFromSuperview];
            
        }
        else{
            NSLog(@"送 %ld 支玫瑰花：送礼:responseObject:%@",(long)giftCount,responseObject);
            NSLog(@"送 %ld 支玫瑰花：送礼:responseObject:res:msg:%@",(long)giftCount,responseObject[@"res"][@"msg"]);
            // 1.2.1.1.2.2、获取失败：弹窗提示：获取失败的返回信息
            [self showHubWithLabelText:responseObject[@"res"][@"msg"] andHidAfterDelay:3.0];
            
        }
        
        
    } whenFailure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"送 %ld 支玫瑰花：请求失败！",(long)giftCount);
        NSLog(@"失败原因：error：%@",error);
        
        [self showHubWithLabelText:@"请检查网络，重新加载" andHidAfterDelay:3.0];
    } withToken:self.onlyUser.userToken];
    
}




// 重写touchsBegan，点击旁边空白时，让UIView 类的子类，失去第一响应者
#pragma mark --重写touchsBegan
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    
    // 送礼：恢复位置
    [UIView animateWithDuration:0.5 animations:^{
        self.giveGiftTipView.bounds = CGRectMake(0, 0, cScreen_Width, cScreen_Height);
        
    }];
    
    // 点赞：恢复位置
    [UIView animateWithDuration:0.5 animations:^{
        self.likeTipWithMoneyView.bounds = CGRectMake(0, 0, cScreen_Width, cScreen_Height);
        
    }];
    
    
    // 加好友：恢复位置
    [UIView animateWithDuration:0.5 animations:^{
        self.addFriendView.frame = CGRectMake(0, 0, cScreen_Width, cScreen_Height);
        
    }];
    
    
    
    for (UIView *tempView in self.view.subviews) {
        if ([tempView isKindOfClass:[UIView class]]) {
            // 失去第一响应者
            [tempView resignFirstResponder];
        }
    }
    
}


// tipCloseBtn：弹窗关闭button：点击事件
- (void)giveGiftTipCloseBtnClick{
    NSLog(@"送礼弹窗：弹窗关闭button：点击事件");
    
    [_giveGiftTipView removeFromSuperview];
}
#pragma mark------------------------ 送礼弹窗：结束 ---------------------------------------


#pragma mark------------------------ 点赞弹窗：开始 ---------------------------------------

// 点赞：button：点击事件
- (void)likeBtnClick{
    NSLog(@"点赞：button：点击事件");
    
    _likeTipWithMoneyView = [[[NSBundle mainBundle] loadNibNamed:@"CYLikeTipWithMoneyView" owner:nil options:nil] lastObject];
    
    _likeTipWithMoneyView.frame = CGRectMake(0, 0, cScreen_Width, cScreen_Height);
    
    _likeTipWithMoneyView.backgroundColor = [UIColor clearColor];
    
    
    // 弹窗关闭：点击事件
    [_likeTipWithMoneyView.tipCloseBtn addTarget:self action:@selector(likeTipViewTipCloseBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    // 1个赞：点击事件
    [_likeTipWithMoneyView.oneLikeBtn addTarget:self action:@selector(likeTipViewOneLikeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    // 10个赞：点击事件
    [_likeTipWithMoneyView.tenLikeBtn addTarget:self action:@selector(likeTipViewTenLikeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    // 32个赞：点击事件
    [_likeTipWithMoneyView.thirtyTwoLikeBtn addTarget:self action:@selector(likeTipViewThirtyTwoLikeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    // 300个赞：点击事件
    [_likeTipWithMoneyView.threeHundredLikeBtn addTarget:self action:@selector(likeTipViewThreeHundredLikeBtnBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    // 点赞：textField：文本改变事件
    [_likeTipWithMoneyView.likeCountTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    // 点赞：button：点击事件
    [_likeTipWithMoneyView.likeBtn addTarget:self action:@selector(likeTipViewlikeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    _likeTipWithMoneyView.likeCountTextField.delegate = self;
    
    [self.view addSubview:_likeTipWithMoneyView];
    
}
// 点赞弹窗：弹窗关闭：点击事件
- (void)likeTipViewTipCloseBtnClick{
    NSLog(@"");
    
    [self.likeTipWithMoneyView removeFromSuperview];
}
// 1个赞：点击事件
- (void)likeTipViewOneLikeBtnClick{
    NSLog(@"");
    
    
    NSInteger likeCount = 1;
    
    // 网络请求：用户余额：余额够，则点赞请求，不够则充值弹窗
    [self requestUserBalanceIfIsEnoughWithUserId:self.onlyUser.userID andOppUserId:self.oppUserId andLikeCount:likeCount andCost:(1.0 * likeCount)];
}
// 10个赞：点击事件
- (void)likeTipViewTenLikeBtnClick{
    NSLog(@"");
    
    NSInteger likeCount = 10;
    
    // 网络请求：用户余额：余额够，则点赞请求，不够则充值弹窗
    [self requestUserBalanceIfIsEnoughWithUserId:self.onlyUser.userID andOppUserId:self.oppUserId andLikeCount:likeCount andCost:(1.0 * likeCount)];
}
// 32个赞：点击事件
- (void)likeTipViewThirtyTwoLikeBtnClick{
    NSLog(@"");
    
    NSInteger likeCount = 32;
    
    // 网络请求：用户余额：余额够，则点赞请求，不够则充值弹窗
    [self requestUserBalanceIfIsEnoughWithUserId:self.onlyUser.userID andOppUserId:self.oppUserId andLikeCount:likeCount andCost:(1.0 * likeCount)];
}
// 300个赞：点击事件
- (void)likeTipViewThreeHundredLikeBtnBtnClick{
    NSLog(@"");
    
    NSInteger likeCount = 300;
    
    // 网络请求：用户余额：余额够，则点赞请求，不够则充值弹窗
    [self requestUserBalanceIfIsEnoughWithUserId:self.onlyUser.userID andOppUserId:self.oppUserId andLikeCount:likeCount andCost:(1.0 * likeCount)];
}
// 点赞：button：点击事件
- (void)likeTipViewlikeBtnClick{
    NSLog(@"点赞弹窗：点赞：button：点击事件");
    
    NSScanner *scan = [NSScanner scannerWithString:self.likeTipWithMoneyView.likeCountTextField.text];
    
    NSInteger flag;
    
    if ([scan scanInteger:&flag] && [scan isAtEnd]) {
        
        NSInteger likeCount = [self.likeTipWithMoneyView.likeCountTextField.text integerValue];
        
        // 网络请求：点 n 个赞
        // 网络请求：用户余额：余额够，则点赞请求，不够则充值弹窗
        [self requestUserBalanceIfIsEnoughWithUserId:self.onlyUser.userID andOppUserId:self.oppUserId andLikeCount:likeCount andCost:(1.0 * likeCount)];
        
    }
    else {
        
        [self.view bringSubviewToFront:self.hud];
        [self showHubWithLabelText:@"请输入数字" andHidAfterDelay:3.0];
    }
}

// 网络请求：用户余额：余额够，则点赞请求，不够则充值弹窗
- (void)requestUserBalanceIfIsEnoughWithUserId:(NSString *)userId andOppUserId:(NSString *)oppUserId andLikeCount:(NSInteger)likeCount andCost:(float)cost{
    NSLog(@"用户余额：网络请求！");
    
    [self showLoadingView];
    
    // 新地址
    NSString *newUrl = [NSString stringWithFormat:@"%@?userId=%@",cUserMoneyUrl,userId];
    
    // 网络请求：用户余额
    [CYNetWorkManager getRequestWithUrl:newUrl params:nil progress:^(NSProgress *uploadProgress) {
        NSLog(@"用户余额：%@",uploadProgress);
        
        
    } whenSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"用户余额：请求成功！");
        
        // 1、
        NSString *code = responseObject[@"code"];
        
        // 1.2.1.1.2、和成功的code 匹配
        if ([code isEqualToString:@"0"]) {
            NSLog(@"用户余额：获取成功！");
            NSLog(@"用户余额：%@",responseObject);
            
            
            
            // 请求数据结束，取消加载
            [self hidenLoadingView];
            
            
            NSString * tempMoneyStr = responseObject[@"res"][@"data"][@"money"];
            float tempMoney = [tempMoneyStr floatValue];
            
            // 如果余额够支付，则赞、支付
            if (tempMoney >= cost) {
                
                self.isEnoughForPay = YES;
                
                // 网路请求：点 n 个赞
                [self requestLikeWithUserId:self.onlyUser.userID andReceiveUserId:oppUserId andLikeCount:likeCount andAddLikeUrl:cAddUserVideoLikeUrl];
                
            }
            // 余额不足，则弹到充值界面
            else {
                
                
                // 余额不足弹窗：
#pragma mark------------------------ 余额不足弹窗：开始 ---------------------------------------
                _balanceNotEnoughView = [[[NSBundle mainBundle] loadNibNamed:@"CYBalanceNotEnoughView" owner:nil options:nil] lastObject];
                
                _balanceNotEnoughView.frame = CGRectMake(0, 0, cScreen_Width, cScreen_Height);
                
                
                
                _balanceNotEnoughView.backgroundColor = [UIColor clearColor];
                _balanceNotEnoughView.balanceNotEnoughBgImgView.hidden = YES;
                
                // 余额不足：弹窗关闭：button：点击事件
                [_balanceNotEnoughView.closeBtn addTarget:self action:@selector(balanceNotEnoughCloseBtnClick) forControlEvents:UIControlEventTouchUpInside];
                
                // 立即充值：button：点击事件
                [_balanceNotEnoughView.instantRechargeBtn addTarget:self action:@selector(balanceNotEnoughInstantRechargeBtnClick) forControlEvents:UIControlEventTouchUpInside];
                
                
                // 送礼弹窗：恢复位置
                [UIView animateWithDuration:0.5 animations:^{
                    self.likeTipWithMoneyView.bounds = CGRectMake(0, 0, cScreen_Width, cScreen_Height);
                    
                }];
                // 隐藏键盘
                [self.view endEditing:YES];
                
                
                [self.view addSubview:_balanceNotEnoughView];
                
                
                
                
                
                
                
                
                
                
            }
        }
        else{
            NSLog(@"用户余额：获取失败:responseObject:%@",responseObject);
            NSLog(@"用户余额：获取失败:responseObject:res:msg:%@",responseObject[@"res"][@"msg"]);
            // 1.2.1.1.2.2、获取失败：弹窗提示：获取失败的返回信息
            [self showHubWithLabelText:responseObject[@"res"][@"msg"] andHidAfterDelay:3.0];
            
        }
        
        
    } whenFailure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"用户余额：请求失败！");
        NSLog(@"点一个赞：error：%@",error);
        
        [self showHubWithLabelText:@"请检查网络，重新加载" andHidAfterDelay:3.0];
    } withToken:self.onlyUser.userToken];
    
}

// 点赞：网络请求
- (void)requestLikeWithUserId:(NSString *)userId andReceiveUserId:(NSString *)receiveUserId andLikeCount:(NSInteger)likeCount andAddLikeUrl:(NSString *)addLikeUrl{
    NSLog(@"点赞：网络请求！");
    
    [self showLoadingView];
    
    // 参数
    NSDictionary *params = @{
                             @"UserId":userId,
                             @"ReceiveUserId":receiveUserId,
                             @"Count":@(likeCount)
                             };
    
    // 网络请求：点 n 个赞
    [CYNetWorkManager postRequestWithUrl:addLikeUrl params:params progress:^(NSProgress *uploadProgress) {
        NSLog(@"点 %ld 个赞：%@",(long)likeCount,uploadProgress);
        
        
    } whenSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"点 %ld 个赞：请求成功！",(long)likeCount);
        
        // 1、
        NSString *code = responseObject[@"code"];
        
        // 1.2.1.1.2、和成功的code 匹配
        if ([code isEqualToString:@"0"]) {
            NSLog(@"点 %ld 个赞：点赞成功！",(long)likeCount);
            NSLog(@"点 %ld 个赞：%@",(long)likeCount,responseObject);
            
            
            
            
            [self showHubWithLabelText:[NSString stringWithFormat:@"点 %ld 个赞成功！",(long)likeCount] andHidAfterDelay:3.0];
            
            
            
            [self.likeTipWithMoneyView removeFromSuperview];
            
            
        }
        else{
            NSLog(@"点 %ld 个赞：点赞:responseObject:%@",(long)likeCount,responseObject);
            NSLog(@"点 %ld 个赞：点赞:responseObject:res:msg:%@",(long)likeCount,responseObject[@"res"][@"msg"]);
            // 1.2.1.1.2.2、获取失败：弹窗提示：获取失败的返回信息
            [self showHubWithLabelText:responseObject[@"res"][@"msg"] andHidAfterDelay:3.0];
            
        }
        
        
    } whenFailure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"点 %ld 个赞：请求失败！",(long)likeCount);
        NSLog(@"点 %ld 个赞：error：%@",(long)likeCount,error);
        
        [self showHubWithLabelText:@"请检查网络，重新加载" andHidAfterDelay:3.0];
    } withToken:self.onlyUser.userToken];
    
}

#pragma mark------------------------ 点赞弹窗：结束 ---------------------------------------




#pragma mark ---------------------- 点赞、送礼：代理：UITextFieldDelegate：开始 ----------------
-(void)textFieldDidChange :(UITextField *)theTextField{
    NSLog( @"text changed: %@", theTextField.text);
    
    
    // 送礼
    NSScanner *giveGiftScan = [NSScanner scannerWithString:self.giveGiftTipView.giftCountTextField.text];
    
    
    float giveGiftCost = [self.giveGiftTipView.giftCountTextField.text floatValue] * 2.0;
    
    NSInteger giveGiftFlag;
    
    if ([giveGiftScan scanInteger:&giveGiftFlag] && [giveGiftScan isAtEnd]) {
        
        self.giveGiftTipView.tfRoseCountCostLab.text = [NSString stringWithFormat:@"￥%.1f",giveGiftCost];
        
    }
    else {
        
        self.giveGiftTipView.tfRoseCountCostLab.text = @"￥0.0";
    }
    
    
    
    
    
    
    // 点赞
    NSScanner *likeScan = [NSScanner scannerWithString:self.likeTipWithMoneyView.likeCountTextField.text];
    
    
    float likeCost = [self.likeTipWithMoneyView.likeCountTextField.text floatValue] * 1.0;
    
    NSInteger likeFlag;
    
    if ([likeScan scanInteger:&likeFlag] && [likeScan isAtEnd]) {
        
        self.likeTipWithMoneyView.tfLikeCountCostLab.text = [NSString stringWithFormat:@"￥%.1f",likeCost];
        
    }
    else {
        
        self.likeTipWithMoneyView.tfLikeCountCostLab.text = @"￥0.0";
    }
    
    
    
    
}
// 结束打字时恢复原位
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    
    // 送礼：恢复位置
    [UIView animateWithDuration:0.5 animations:^{
        self.giveGiftTipView.bounds = CGRectMake(0, 128, cScreen_Width, cScreen_Height);
    }];
    
    
    // 点赞：恢复位置
    [UIView animateWithDuration:0.5 animations:^{
        self.likeTipWithMoneyView.bounds = CGRectMake(0, 128, cScreen_Width, cScreen_Height);
    }];
    
}

#pragma mark ---------------------- 点赞、送礼：代理：UITextFieldDelegate：结束 ----------------





// 分享：button：点击事件
- (void)shareBtnClick{
    NSLog(@"分享：button：点击事件");
    
    
    NSString *downloadUrl = [[NSString alloc] init];
    downloadUrl = cDownLoadUrl;
//    downloadUrl = @"https://www.baidu.com/";
    
    
    
    UIImage *thumbImage = [CYUtilities setUrlImgWithHostUrl:cHostUrl andUrl:self.onlyUser.Portrait];
    NSData *thumbImageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",cHostUrl,self.onlyUser.Portrait]]];
    
    // 分享：文本分享
//    [self sharedToWeChatWithText:@"分享随便些" bText:YES andScene:0];
    
    // 分享：图片分享
//    [self shareToWechatWithThumbImage:thumbImage andImageData:thumbImageData andbText:NO andScene:0];
    
    // 分享：网页分享
    [self sharedToWeChatWithWebpageWithShareTitle:@"APP 下载地址" andDescription:@"男左女右 遇见你的TA" andImage:[UIImage imageNamed:@"logo.png"] andWebpageUrl:cDownLoadUrl andbText:NO andScene:0];
    
}

// 播放：button：点击事件（系统播放器）
- (void)playBtnClick{
    NSLog(@"播放：button：点击事件");
    
    
//    
//    // 视频地址的赋值
//    // 模型：当前用户的信息模型
//    CYOthersInfoViewModel *tempOthersInfoViewModel = self.dataArray[0];
//    
//    // 当前用户的视频数组
//    NSArray *videosArr = tempOthersInfoViewModel.UserVideoList;
//    
//    // 视频模型
//    CYOtherVideoCellModel *videoCellModel = [[CYOtherVideoCellModel alloc] init];
//    
//    // 当前视频的地址
//    NSString *tempVideoUrl = [[NSString alloc] init];
//    
//    
//    // 如果没有indexPath，即主界面的视频
//    if (self.indexPath == nil) {
//        
//        // 判断视频数量
//        if (videosArr.count == 1) {
//            
//            // 如果是一个，默认为播放
//            videoCellModel = videosArr[0];
//            // 第一个为默认，则视频的地址为第一个的视频地址
//            tempVideoUrl = videoCellModel.Video;
//            
//        }
//        else if (videosArr.count == 2) {
//            
//            videoCellModel = videosArr[0];
//            NSLog(@"videoCellModel.Default:%d",videoCellModel.Default);
//            // 如果是两个，看是否默认
//            if (videoCellModel.Default == YES) {
//                
//                // 第一个为默认，则视频的地址为第一个的视频地址
//                tempVideoUrl = videoCellModel.Video;
//            }
//            else {
//                
//                // 第一个视频不是默认，则把打第二个视频模型赋值，第二个的视频地址为视频的地址。
//                videoCellModel = videosArr[1];
//                tempVideoUrl = videoCellModel.Video;
//            }
//        }
//        
//    }
//    else {
//        
//        // 如果有indexPath，即是从他人详情页的视频界面跳过来，用indexPath去判断播放哪个视频
//        CYOtherVideoCellModel *tempVideoCellModel = self.videoDetailsView.othersInfoVM.UserVideoList[self.indexPath.row];
//        
//        tempVideoUrl = tempVideoCellModel.Video;
//        
//    }
//    
//    // 构建播放地址
//    NSString *urlStr = [NSString stringWithFormat:@"%@%@",cHostUrl,tempVideoUrl];
    
    
    
    
    
    
    
    
    
    
    
    
    [self showLoadingView];
    
//    CYVideoDetailsViewModel *tempModel = self.tempArr[0];
    NSString *newUrlStr = [NSString stringWithFormat:@"%@%@",cHostUrl,_videoDetailsViewModel.VideoUrl];
    
    
    
    
    
    
    
    
    
    
    
    
    
    // 获取成功，播放视频
//    [self playVideoWithUrl:urlStr];
    [self playVideoWithUrl:newUrlStr];
    
}



// 获取成功，播放视频
- (void)playVideoWithUrl:(NSString *)newVideoUrl{
    NSLog(@"获取成功，播放视频");
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    [audioSession setActive:YES error:nil];
    self.audioPlayer.delegate = self;
    
    
    // MPMoviePlayerController 只是一个容器，里面有一个能够播放视频的视图
    // 可以是本地视频、也可以是网络视频
    self.moviePlayerVC = [[MPMoviePlayerViewController alloc]initWithContentURL:[NSURL URLWithString:newVideoUrl]];
    
    // 控制面板风格：嵌入视频风格
    self.moviePlayerVC.moviePlayer.controlStyle = MPMovieControlStyleEmbedded;
    
    // 设置播放器的frame
    self.moviePlayerVC.view.frame = CGRectMake(0, 70, cScreen_Width, self.videoDetailsView.frame.size.height - 70 - self.videoDetailsView.bottomTipDecConView.frame.size.height);
    
    
    [self.view addSubview:self.moviePlayerVC.view];
    
    [self hidenLoadingView];
    
//    self.videoDetailsView.bgImgView.hidden = YES;
//    self.videoDetailsView.playBtn.hidden = YES;
//    self.videoDetailsView.backgroundColor = [UIColor clearColor];
    
}

// 播放：button：点击事件：（阿里云播放器）
//- (void)playBtnClick{
//    NSLog(@"播放：button：点击事件~~：2");
//    
//    //新建播放器
//    _aliMediaPlayer = [[AliVcMediaPlayer alloc] init];
//    //创建播放器，传入显示窗口
//    [_aliMediaPlayer create:mShowView];
//    //注册准备完成通知
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(OnVideoPrepared:) name:AliVcMediaPlayerLoadDidPreparedNotification object:_aliMediaPlayer];
//    //注册错误通知
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(OnVideoError:) name:AliVcMediaPlayerPlaybackErrorNotification object:_aliMediaPlayer];
//    //传入播放地址，初始化视频，准备播放
//    [_aliMediaPlayer prepareToPlay:mUrl];
//    //开始播放
//    [_aliMediaPlayer play];
//    
//    
//}




@end
