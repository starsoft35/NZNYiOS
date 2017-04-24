//
//  CYOthersInfoVC.m
//  nzny
//
//  Created by 男左女右 on 2016/11/22.
//  Copyright © 2016年 nznychina. All rights reserved.
//

#import "CYOthersInfoVC.h"


// 他人详情页：view
#import "CYOthersInfoView.h"
// 他人详情页模型：model
#import "CYOthersInfoViewModel.h"


// 视频详情页：VC
#import "CYVideoDetailsVC.h"

//中部scrollView：VC
#import "CYOthersInfoVideoLiveVC.h"
// 资料：VC
#import "CYOtherDetailsVC.h"
// 视频：VC
#import "CYOtherVideoVC.h"
// 直播：VC
#import "CYOtherLiveVC.h"

// 聊天界面
#import "CYChatVC.h"


// 不是好友：VC
//#import "CYNotFriendTipVC.h"
// 加好友弹窗
//#import "CYAddFriendVC.h"
// 加好友弹窗：view
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



@interface CYOthersInfoVC ()<UITextFieldDelegate,UITextViewDelegate>

// 送礼弹窗：View
@property(nonatomic, strong) CYGiveGiftTipWithMoneyView *giveGiftTipView;
// 点赞弹窗：View
@property(nonatomic, strong) CYLikeTipWithMoneyView *likeTipWithMoneyView;
// 余额不足弹窗：View
@property(nonatomic, strong) CYBalanceNotEnoughView *balanceNotEnoughView;


// 加好友弹窗：View
@property(nonatomic, strong) CYAddFriendView *addFriendView;





@end

@implementation CYOthersInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // 添加视图
    [self addView];
    
    
//    // 加载数据
//    [self loadData];
    
//    [self.navigationItem.backBarButtonItem setAction:@selector(tempNavBackBarItemClick)];
//    [self.navigationController.navigationItem.backBarButtonItem setAction:@selector(tempNavBackBarItemClick)];
    
//    UIBarButtonItem *tempBackBarBtnItem = [[UIBarButtonItem alloc] initWithTitle:@"temp" style:2 target:self action:@selector(tempNavBackBarItemClick)];
//    [self.navigationController.navigationBar.backItem setBackBarButtonItem:tempBackBarBtnItem];
//    self.navigationItem.backBarButtonItem = tempBackBarBtnItem;
//    self.navigationController.navigationItem.backBarButtonItem = tempBackBarBtnItem;
//    self.navigationController.navigationItem.rightBarButtonItem = tempBackBarBtnItem;
    
    
    
    
    
    
    
//    self.navigationItem.rightBarButtonItem = tempBackBarBtnItem;
//    self.navigationItem.backBarButtonItem = tempBackBarBtnItem;
    
    
    
    
    
    
    
    
//    UINavigationItem *tempBackItem = [[UINavigationItem alloc] initWithTitle:@"temp2"];
//    [self.navigationController.navigationBar.backItem setitem];
    
//    [self.navigationController.barHideOnSwipeGestureRecognizer addTarget:self action:@selector(tempNavBackBarItemClick)];
    
}
//
- (void)tempNavBackBarItemClick{
    NSLog(@"tempNavBackBarItemClick");
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    
    if (![[self.navigationController viewControllers] containsObject:self])
    {
        NSLog(@"用户点击了返回按钮");
        
        
        
//        for (UIViewController *controller in self.navigationController.viewControllers) {
//            
//            
//            
//            if ([controller isKindOfClass:[CYVideoDetailsVC class]]) {
//                
//                [self.navigationController popToViewController:controller animated:YES];
//                
//            }
//            
//        }
        
        
    }
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound){
        
        NSLog(@"用户点击了返回按钮2");
    }
    
}


//
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    // 显示导航栏
    self.navigationController.navigationBarHidden = NO;
    
    // 将要显示的时候，加载数据，用于刷新
    [self loadData];
}

// 加载数据
- (void)loadData{
    
    // 网络请求：他人详情页
    
    // 新地址
    NSDictionary *params = @{
                             @"userId":self.onlyUser.userID,
                             @"oppUserId":self.oppUserId,
                             };
    NSLog(@"params:oppUserId:%@",self.oppUserId);
    
//    [self showLoadingView];
    
    // 网络请求：他人详情页
    [CYNetWorkManager getRequestWithUrl:cOppUserInfoUrl params:params progress:^(NSProgress *uploadProgress) {
        NSLog(@"获取他人详情页进度：%@",uploadProgress);
        
        
    } whenSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"他人详情页：请求成功！");
        
        // 1、
        NSString *code = responseObject[@"code"];
        
        // 1.2.1.1.2、和成功的code 匹配
        if ([code isEqualToString:@"0"]) {
            NSLog(@"他人详情页：获取成功！");
            NSLog(@"他人详情页：%@",responseObject);
            
            // 清空：每次刷新都需要
            [self.dataArray removeAllObjects];
            
            // 解析数据，模型存到数组
            [self.dataArray addObject:[[CYOthersInfoViewModel alloc] initWithDictionary:responseObject[@"res"][@"data"][@"model"] error:nil]];
            
            
            
            // 模型赋值
            if (self.dataArray.count != 0) {
                
                _othersInfoView.othersInfoViewModel = self.dataArray[0];
                
                
            }
            
            // 请求数据结束，取消加载
            [self hidenLoadingView];
            
        }
        else{
            NSLog(@"他人详情页：获取失败:responseObject:%@",responseObject);
            NSLog(@"他人详情页：获取失败:responseObject:res:msg:%@",responseObject[@"res"][@"msg"]);
            // 1.2.1.1.2.2、获取失败：弹窗提示：获取失败的返回信息
            [self showHubWithLabelText:responseObject[@"res"][@"msg"] andHidAfterDelay:3.0];
            
        }
        
        
    } whenFailure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"他人详情页：请求失败！");
        NSLog(@"失败原因：error：%@",error);
        
        [self showHubWithLabelText:@"请检查网络，重新加载" andHidAfterDelay:3.0];
    } withToken:self.onlyUser.userToken];
    
}

// 添加视图
- (void)addView{
    
    _othersInfoView = [[[NSBundle mainBundle] loadNibNamed:@"CYOthersInfoView" owner:nil options:nil] lastObject];
    
//    NSLog(@"self.dataArray.count:%ld",(unsigned long)self.dataArray.count);
    
    
    // 头像：圆角
    _othersInfoView.headImgView.layer.cornerRadius = (60.0 / 1334.0) * (cScreen_Height - 64);
    
    
//    CGRect tempRect = CGRectMake(0, 0, cScreen_Width, _othersInfoView.infoOrVideoOrLiveView.frame.size.height - 76);
//    NSLog(@"_othersInfoView.infoOrVideoOrLiveView.frame.size.height:%lf",_othersInfoView.infoOrVideoOrLiveView.frame.size.height);
    
    CGRect tempRect = CGRectMake(0, 0, cScreen_Width, 388.0 / 667.0 * (cScreen_Height - 64) - 35);
//        CGRect tempRec = CGRectMake(0, 0, cScreen_Width, 388 - 30);
    
//    NSLog(@"tempRec.size.height:%lf",tempRect.size.height);
//    NSLog(@"_othersInfoView.infoOrVideoOrLiveView:%@",_othersInfoView.infoOrVideoOrLiveView);
    
    // 资料
    // 导航VC
    _otherInfoVC = [[CYOtherDetailsVC alloc] init];
//    CYOtherDetailsVC *o = [[CYOtherDetailsVC alloc] init];
    _otherInfoVC.oppUserId = self.oppUserId;
//    UINavigationController *otherInfoNav = [CYUtilities createDefaultNavCWithRootVC:_otherInfoVC BgColor:nil TintColor:[UIColor whiteColor] translucent:NO titleColor:[UIColor whiteColor] title:@"登录" bgImg:[UIImage imageNamed:@"Title1"]];
    
    _otherInfoVC.view.frame = tempRect;
    _otherInfoVC.baseTableView.frame = tempRect;
    
    // 视频
    _otherVideoVC = [[CYOtherVideoVC alloc] init];
    _otherVideoVC.oppUserId = self.oppUserId;
    _otherVideoVC.view.frame = tempRect;
    _otherVideoVC.baseCollectionView.frame = tempRect;
    
//    CYOtherVideoVC *v = [[CYOtherVideoVC alloc] init];
//    UINavigationController *videoNav = [[UINavigationController alloc] initWithRootViewController:_otherVideoVC];
    
    // 直播
    _otherLiveVC = [[CYOtherLiveVC alloc] init];
    _otherLiveVC.oppUserId = self.oppUserId;
//    CYOtherLiveVC *l = [[CYOtherLiveVC alloc] init];
    _otherLiveVC.view.frame = tempRect;
    _otherLiveVC.baseTableView.frame = tempRect;
    
    // 中部视图页面
    CYOthersInfoVideoLiveVC *middleVC = [[CYOthersInfoVideoLiveVC alloc] initWithSubVC:@[_otherInfoVC,_otherVideoVC,_otherLiveVC] andTitles:@[@"资料",@"视频",@"直播"]];
//    CYOthersInfoVideoLiveVC *videoVC = [[CYOthersInfoVideoLiveVC alloc] initWithSubVC:@[_otherInfoVC,videoNav,l] andTitles:@[@"资料",@"视频",@"直播"]];
    
//    float middleVCHeight = _othersInfoView.infoOrVideoOrLiveView.frame.size.height / 1334.0 * cScreen_Height;
//    float middleVCHeight = 388.0 / 667.0 * (cScreen_Height - 0);
//    NSLog(@"_othersInfoView.infoOrVideoOrLiveView.frame.size.height:%f",_othersInfoView.infoOrVideoOrLiveView.frame.size.height);
//    NSLog(@"middleVCHeight:%f",middleVCHeight);
//    NSLog(@"cScreen_Height:%f",cScreen_Height);
//    
    
//    CGRect middleVCRect = CGRectMake(0, 0, cScreen_Width, middleVCHeight);
    
    middleVC.view.frame = CGRectMake(0, 0, cScreen_Width, 388.0 / 667.0 * cScreen_Height);
    middleVC.bgScrollView.frame = CGRectMake(0, 35, cScreen_Width, 388.0 / 667.0 * (cScreen_Height - 64) - 35);
    
//    [videoVC setScrollViewFrame];
    // 中部视图：赋值
    [_othersInfoView.infoOrVideoOrLiveView addSubview:middleVC.view];
    
    
    
    
    
    
    
    
    
    // 联系他：button：点击事件
    [_othersInfoView.contactBtn addTarget:self action:@selector(contactBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    // 加关注：button：点击事件
    [_othersInfoView.followBtn addTarget:self action:@selector(followBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    // 点赞：button：点击事件
    [_othersInfoView.likeBtn addTarget:self action:@selector(likeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    // 送礼：button：点击事件
    [_othersInfoView.giveGiftBtn addTarget:self action:@selector(giveGiftBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
//    _othersInfoView.frame = self.view.frame;
    
//    [self.view addSubview:_othersInfoView];
    self.view = _othersInfoView;
    
}


// 联系他：button：点击事件
- (void)contactBtnClick{
    NSLog(@"联系他：button：点击事件");
    
    // 模型
    CYOthersInfoViewModel *othersInfoViewModel = [[CYOthersInfoViewModel alloc] init];
    
    if (self.dataArray.count) {
        
        othersInfoViewModel = self.dataArray[0];
        
    }
    
    // 如果是好友，聊天界面
    if (othersInfoViewModel.IsFriend) {
        
        // 融云SDK
        // 新建一个聊天会话viewController 对象
        CYChatVC *chatVC = [[CYChatVC alloc] init];
        
        
        
        // 设置会话的类型，如单聊、讨论组、群聊、聊天室、客服、公众服务会话等
        chatVC.conversationType = ConversationType_PRIVATE;
        
        
        // 设置会话的目标会话ID。（单聊、客服、公众服务号会话为对方的ID，讨论组、群聊、聊天室为会话的ID）
        chatVC.targetId = othersInfoViewModel.Id;
        
        // 设置聊天会话界面要显示的标题
        chatVC.title = othersInfoViewModel.RealName;
        
        // 显示聊天会话界面
        [self.navigationController pushViewController:chatVC animated:YES];
    }
    else{
        
        // 加好友界面
        [self addFriendViewWithOppUserId:othersInfoViewModel.Id];
        
        
        
    }
    
    
}

// 加好友界面
- (void)addFriendViewWithOppUserId:(NSString *)oppUserId{
    
    
//    CYAddFriendVC *addFriendVC = [[CYAddFriendVC alloc] init];
//    
//    addFriendVC.OppUserId = oppUserId;
//    
//    [self presentViewController:addFriendVC animated:YES completion:nil];
    
    
    
    
    
    
    
    
    
    
    _addFriendView = [[[NSBundle mainBundle] loadNibNamed:@"CYAddFriendView" owner:nil options:nil] lastObject];
    
    _addFriendView.frame = CGRectMake(0, -64, cScreen_Width, cScreen_Height);
    
    
    
    _addFriendView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
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

// 重写touchsBegan，点击旁边空白时，让UIView 类的子类，失去第一响应者
#pragma mark --重写touchsBegan
//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
//    [super touchesBegan:touches withEvent:event];
//    
//    //
//    [UIView animateWithDuration:0.5 animations:^{
//        self.addFriendView.frame = CGRectMake(0, -128, cScreen_Width, cScreen_Height);
//        
//    }];
//    
//    for (UIView *tempView in self.view.subviews) {
//        if ([tempView isKindOfClass:[UIView class]]) {
//            // 失去第一响应者
//            [tempView resignFirstResponder];
//        }
//    }
//    
//    
//}

#pragma mark --UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView{
    
    
    // 键盘弹出：上拉弹窗
    [UIView animateWithDuration:0.5 animations:^{
        self.addFriendView.bounds = CGRectMake(0, 128, cScreen_Width, cScreen_Height);
    }];
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    
    // 加好友：恢复位置
    [UIView animateWithDuration:0.5 animations:^{
        self.addFriendView.bounds = CGRectMake(0, 0, cScreen_Width, cScreen_Height);
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




// 加关注：button：点击事件
- (void)followBtnClick{
    NSLog(@"加关注：button：点击事件");
    
    // 如果已关注，则取消关注
    if (_othersInfoView.othersInfoViewModel.IsFollow == YES) {
        // 网络请求：取消关注
        [self delFollow];
    }
    // 如果没关注，则加关注
    else {
        
        // 网络请求：加关注
        [self addFollow];
    }
    
}

// 网络请求：取消关注
- (void)delFollow{
    
    // 网络请求：取消关注
    // 参数
    NSString *newUrl = [NSString stringWithFormat:@"%@?userId=%@&oppUserId=%@",cDelFollowUrl,self.onlyUser.userID,_othersInfoView.othersInfoViewModel.Id];
    
    [self showLoadingView];
    
    // 取消关注
    [CYNetWorkManager postRequestWithUrl:newUrl params:nil progress:^(NSProgress *uploadProgress) {
        NSLog(@"取消关注：progress:%@",uploadProgress);
        
        
    } whenSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"取消关注：请求成功！");
        
        
        // 2.3.1.1、获取code 值
        NSString *code = responseObject[@"code"];
        
        // 2.3.1.2、判断返回值
        if ([code isEqualToString:@"0"]) {
            NSLog(@"取消关注：取消成功！");
            
            // 隐藏菊花
            //            [self hidenLoadingView];
            
            // 刷新数据
            [self loadData];
            
        }
        else{
            NSLog(@"取消关注：取消失败！");
            NSLog(@"msg:%@",responseObject[@"res"][@"msg"]);
            
            
            // 2.3.1.2.2、取消关注失败，弹窗
            [self showHubWithLabelText:responseObject[@"res"][@"msg"] andHidAfterDelay:3.0];
        }
        
    } whenFailure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"取消关注：请求失败！");
        NSLog(@"error:%@",error);
        
        // 取消关注：请求：失败，加载菊花消失
        [self hidenLoadingView];
        
        // 2.3.1.2.2、取消取消失败，弹窗
        [self showHubWithLabelText:@"网络错误，请重新上传！" andHidAfterDelay:3.0];
        
        
    } withToken:self.onlyUser.userToken];
}

// 网络请求：加关注
- (void)addFollow{
    
    // 网络请求：加关注
    // 参数
    NSString *newUrl = [NSString stringWithFormat:@"%@?userId=%@&oppUserId=%@",cAddFollowUrl,self.onlyUser.userID,_othersInfoView.othersInfoViewModel.Id];
    
    [self showLoadingView];
    
    // 加关注
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


//// 点赞：button：点击事件
//- (void)likeBtnClick{
//    NSLog(@"点赞：button：点击事件");
//    
//    // 点赞弹窗
//    CYLikeTipVC *likeTipVC = [[CYLikeTipVC alloc] init];
//    
//    likeTipVC.oppUserId = self.oppUserId;
//    likeTipVC.addLikeUrl = cAddUserLikeUrl;
//    
//    [self presentViewController:likeTipVC animated:YES completion:nil];
//    
////    [self showViewController:likeTipVC sender:self];
////    [self.navigationController pushViewController:likeTipVC animated:YES];
//    
////    [self.view addSubview :likeTipVC.view];
//    
//}
//
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







#pragma mark------------------------ 点赞弹窗：开始 ---------------------------------------

// 点赞：button：点击事件
- (void)likeBtnClick{
    NSLog(@"点赞：button：点击事件");
    
    // 点赞弹窗
    _likeTipWithMoneyView = [[[NSBundle mainBundle] loadNibNamed:@"CYLikeTipWithMoneyView" owner:nil options:nil] lastObject];
    
    _likeTipWithMoneyView.frame = CGRectMake(0, -64, cScreen_Width, cScreen_Height);
    NSLog(@"_likeTipWithMoneyView:cScreen_Height:%f",cScreen_Height);
    
    _likeTipWithMoneyView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    
    
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
                
                // 请求数据结束，取消加载
                [self hidenLoadingView];
                
                
                // 余额不足弹窗：
                
                
#pragma mark------------------------ 余额不足弹窗：开始 ---------------------------------------
                
                _balanceNotEnoughView = [[[NSBundle mainBundle] loadNibNamed:@"CYBalanceNotEnoughView" owner:nil options:nil] lastObject];
                
                _balanceNotEnoughView.frame = CGRectMake(0, -64, cScreen_Width, cScreen_Height);
                
                
                
                _balanceNotEnoughView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
                _balanceNotEnoughView.balanceNotEnoughBgImgView.hidden = YES;
                
                // 余额不足：弹窗关闭：button：点击事件
                [_balanceNotEnoughView.closeBtn addTarget:self action:@selector(balanceNotEnoughCloseBtnClick) forControlEvents:UIControlEventTouchUpInside];
                
                // 立即充值：button：点击事件
                [_balanceNotEnoughView.instantRechargeBtn addTarget:self action:@selector(balanceNotEnoughInstantRechargeBtnClick) forControlEvents:UIControlEventTouchUpInside];
                
                
                // 送礼弹窗：恢复位置
                [UIView animateWithDuration:0.5 animations:^{
//                    self.likeTipWithMoneyView.bounds = CGRectMake(0, 0, cScreen_Width, cScreen_Height);
                    self.likeTipWithMoneyView.frame = CGRectMake(0, -64, cScreen_Width, cScreen_Height);
                    
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



#pragma mark------------------------ 送礼开始：弹窗 ---------------------------------------

// 送礼：button：点击事件
- (void)giveGiftBtnClick{
    NSLog(@"送礼：button：点击事件");
    
    _giveGiftTipView = [[[NSBundle mainBundle] loadNibNamed:@"CYGiveGiftTipWithMoneyView" owner:nil options:nil] lastObject];
    
    _giveGiftTipView.frame = CGRectMake(0, -64, cScreen_Width, cScreen_Height);
    
    
    
    //    if (cScreen_Width == 320) {
    //
    //        CGRect tempRect = _giveGiftTipView.oneRoseBtn.frame;
    //
    //        _giveGiftTipView.oneRoseBtn.frame = CGRectMake(tempRect.origin.x, tempRect.origin.y - 10, tempRect.size.width, tempRect.size.height - 10);
    //    }
    
    
    _giveGiftTipView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
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
                
                
                // 余额不足弹窗：VC
                //                CYBalanceNotEnoughVC *balanceNotEnoughVC = [[CYBalanceNotEnoughVC alloc] init];
                //
                //
                //                //                UINavigationController *tempBalanceNotEnoughNav = [CYUtilities createDefaultNavCWithRootVC:balanceNotEnoughVC BgColor:nil TintColor:[UIColor whiteColor] translucent:NO titleColor:[UIColor whiteColor] title:@"" bgImg:[UIImage imageNamed:@"Title1"]];
                //                //
                //                //                [balanceNotEnoughVC.navigationController setNavigationBarHidden:YES animated:YES];
                //
                //                //                [self showViewController:tempVideoNav sender:self];
                //                //                [self presentViewController:tempBalanceNotEnoughNav animated:YES completion:nil];
                //                [self presentViewController:balanceNotEnoughVC animated:YES completion:nil];
                
                
                
#pragma mark------------------------ 余额不足弹窗：开始 --------------------------------------
                
                
                
                _balanceNotEnoughView = [[[NSBundle mainBundle] loadNibNamed:@"CYBalanceNotEnoughView" owner:nil options:nil] lastObject];
                
                _balanceNotEnoughView.frame = CGRectMake(0, -64, cScreen_Width, cScreen_Height);
                
                
                
                if (cScreen_Width == 320) {
                    
                    //                    CGRect tempRect = _balanceNotEnoughView.oneRoseBtn.frame;
                    
                    //                    _balanceNotEnoughView.oneRoseBtn.frame = CGRectMake(tempRect.origin.x, tempRect.origin.y - 10, tempRect.size.width, tempRect.size.height - 10);
                }
                
                
                _balanceNotEnoughView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
                _balanceNotEnoughView.balanceNotEnoughBgImgView.hidden = YES;
                
                // 余额不足：弹窗关闭：button：点击事件
                [_balanceNotEnoughView.closeBtn addTarget:self action:@selector(balanceNotEnoughCloseBtnClick) forControlEvents:UIControlEventTouchUpInside];
                
                // 立即充值：button：点击事件
                [_balanceNotEnoughView.instantRechargeBtn addTarget:self action:@selector(balanceNotEnoughInstantRechargeBtnClick) forControlEvents:UIControlEventTouchUpInside];
                
                
                // 送礼弹窗：恢复位置
                [UIView animateWithDuration:0.5 animations:^{
//                    self.giveGiftTipView.bounds = CGRectMake(0, 0, cScreen_Width, cScreen_Height);
                    self.giveGiftTipView.frame = CGRectMake(0, -64, cScreen_Width, cScreen_Height);
                    
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
//        self.giveGiftTipView.bounds = CGRectMake(0, 0, cScreen_Width, cScreen_Height);
        self.giveGiftTipView.frame = CGRectMake(0, -64, cScreen_Width, cScreen_Height);
        
    }];
    
    // 点赞：恢复位置
    [UIView animateWithDuration:0.5 animations:^{
//        self.likeTipWithMoneyView.bounds = CGRectMake(0, 0, cScreen_Width, cScreen_Height);
        self.likeTipWithMoneyView.frame = CGRectMake(0, -64, cScreen_Width, cScreen_Height);
    }];
    
    
    // 加好友：回复位置
    [UIView animateWithDuration:0.5 animations:^{
        self.addFriendView.frame = CGRectMake(0, -64, cScreen_Width, cScreen_Height);
        
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

// 开始输入时，弹窗位置上移
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    
    // 送礼：弹窗位置上移
    [UIView animateWithDuration:0.5 animations:^{
//        self.giveGiftTipView.bounds = CGRectMake(0, 128, cScreen_Width, cScreen_Height);
        self.giveGiftTipView.frame = CGRectMake(0, -64 - 128, cScreen_Width, cScreen_Height);
    }];
    
    
    // 点赞：弹窗位置上移
    [UIView animateWithDuration:0.5 animations:^{
//        self.likeTipWithMoneyView.bounds = CGRectMake(0, -64 + 128, cScreen_Width, cScreen_Height);
        self.likeTipWithMoneyView.frame = CGRectMake(0, -64 - 128, cScreen_Width, cScreen_Height);
    }];
    
}

#pragma mark ---------------------- 点赞、送礼：代理：UITextFieldDelegate：结束 ----------------







@end
