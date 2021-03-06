//
//  CYLiveViewController.m
//  NZNYiOS
//
//  Created by 男左女右 on 16/8/17.
//  Copyright © 2016年 NZNY. All rights reserved.
//

#import "CYLiveViewController.h"

// 是否为好友模型
#import "CYVideoIsFriendModel.h"

// 加好友界面：VC
//#import "CYAddFriendVC.h"
// 加好友弹窗：view
#import "CYAddFriendView.h"


// 聊天界面:VC
#import "CYChatVC.h"

// 直播拉流模型:model
#import "CYLiveCollectionViewCellModel.h"

// 直播详情页:VC
#import "CYLivePlayDetailsVC.h"

#define cCollectionCellWidth ((340.0 / 750.0) * cScreen_Width)
#define cCollectionCellHeight (195)
//#define cCollectionCellHeight ((390.0 / 1334.0) * cScreen_Height)
#define cCellMinLine ((20.0 / 750.0) * cScreen_Width)
#define cCellMinInteritem ((20.0 / 1334.0) * cScreen_Height)
#define cCellEdgeTop ((10.0 / 1334.0) * cScreen_Height)
#define cCellEdgeLeft ((25.0 / 750.0) * cScreen_Width)
#define cCellEdgeDown ((10.0 / 1334.0) * cScreen_Height)
#define cCellEdgeRight ((25.0 / 750.0) * cScreen_Width)


#define MAX_LIMIT_NUMS (30)



@interface CYLiveViewController ()<UITextViewDelegate>


// 加好友弹窗：View
@property(nonatomic, strong) CYAddFriendView *addFriendView;



@end

@implementation CYLiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // 添加下拉刷新
    self.baseCollectionView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self refresh];
        
    }];
    
    // 添加上拉加载
    self.baseCollectionView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        [self loadMore];
        
    }];
    
    // View的背景颜色
//    self.view.backgroundColor = [UIColor cyanColor];
    
    // 加载数据
    [self loadData];
    
    
    
    
    // 提前注册
    [self.baseCollectionView registerNib:[UINib nibWithNibName:@"CYLiveCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"CYLiveCollectionViewCell"];
    
    
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
    // tabbar：显示
    self.hidesBottomBarWhenPushed = NO;
    
}


//// 选中了collectionCell：点击事件
//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//    NSLog(@"选中了第 %ld 个collectionCell",indexPath.row);
//    
//    
////    // 融云SDK
////    // 新建一个聊天会话viewController 对象
////    CYChatVC *chatVC = [[CYChatVC alloc] init];
////    
////    
////    
////    // 设置会话的类型，如单聊、讨论组、群聊、聊天室、客服、公众服务会话等
////    
////    // 聊天室
////    chatVC.conversationType = ConversationType_CHATROOM;
////    
////    // 模型
//////    CYMyFriendViewCellModel *tempMyFriendModel = self.dataArray[indexPath.row];
////    
////    // 设置会话的目标会话ID。（单聊、客服、公众服务号会话为对方的ID，讨论组、群聊、聊天室为会话的ID）
////    chatVC.targetId = @"聊天室1";
////    
////    // 设置聊天会话界面要显示的标题
////    chatVC.title = @"聊天室1~~";
////    
////    chatVC.hidesBottomBarWhenPushed = YES;
////    
////    // 显示聊天会话界面
////    [self.navigationController pushViewController:chatVC animated:YES];
////    
////    self.hidesBottomBarWhenPushed = NO;
//    
//    
//    // 模型
//    CYLiveCollectionViewCellModel *liveCellModel = self.dataArray[indexPath.row];
//    
//    // 直播详情页
//    CYLivePlayDetailsVC *livePlayDetailsVC = [[CYLivePlayDetailsVC alloc] init];
//    
//    livePlayDetailsVC.liveID = liveCellModel.LiveId;
//    
//    //  导航条设置为不透明的（这样创建的视图（0，0）点，是在导航条左下角开始的。）
//    UINavigationController *tempVideoNav = [CYUtilities createDefaultNavCWithRootVC:livePlayDetailsVC BgColor:nil TintColor:[UIColor whiteColor] translucent:NO titleColor:[UIColor whiteColor] title:@"" bgImg:[UIImage imageNamed:@"Title1"]];
//    
//    [self showViewController:tempVideoNav sender:self];
//    
//}


// connectBtn：联系他
- (void)connectBtnClickWithConnectBtn:(UIButton *)connectBtn{
    NSLog(@"直播connectBtn:点击事件");
    
    
    // collectionViewCell上面button的父类 的父类 为collectionViewCell：因为connectBtn上多一个View，所以要多一个superView
    UICollectionViewCell *tempView = (UICollectionViewCell *)[[connectBtn superview] superview];
    
    // collectionView类 调用方法，获取cell的indexPath
    NSIndexPath *indexPath = [self.baseCollectionView indexPathForCell:tempView];
    
    NSLog(@"当前的cell：%ld",(long)indexPath.row);
    
    // 模型：当前选中的cell
    CYLiveCollectionViewCellModel *liveCellModel = self.dataArray[indexPath.row];
    
    // 网络请求：联系他
    // 参数
    NSString *newUrlStr = [NSString stringWithFormat:@"%@?userId=%@&oppUserId=%@",cContactUrl,self.onlyUser.userID,liveCellModel.LiveUserId];
    
    // 网络请求：联系他
    [CYNetWorkManager postRequestWithUrl:newUrlStr params:nil progress:^(NSProgress *uploadProgress) {
        NSLog(@"联系他：progress:%@",uploadProgress);
        
        
    } whenSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"联系他：请求成功！");
        NSLog(@"responseObject：%@",responseObject);
        NSLog(@"responseObject:res:IsFriend:%@",responseObject[@"res"][@"IsFriend"]);
        
        //        NSString *isFriend = responseObject[@"res"][@"IsFriend"];
        //        NSLog(@"isFriend：%@",isFriend);
        
        // 2.3.1.1、获取code 值
        NSString *code = responseObject[@"code"];
        
        
        
        // 2.3.1.2、判断返回值
        if ([code isEqualToString:@"0"]) {
            NSLog(@"联系他：关注成功！");
            
            
            if ([responseObject[@"res"][@"IsFriend"] boolValue]) {
                
                // 聊天界面
                [self chatViewWithOppUserId:liveCellModel.LiveUserId andOppUserName:liveCellModel.LiveUserName];
            }
            else {
                
                
                self.oppUserId = liveCellModel.LiveUserId;
                
                
                // 加好友界面
                [self addFriendViewWithOppUserId:liveCellModel.LiveUserId];
                
            }
            
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

// 聊天界面
- (void)chatViewWithOppUserId:(NSString *)oppUserId andOppUserName:(NSString *)oppUserName{
    NSLog(@"聊天界面");
    
    // 融云SDK
    // 新建一个聊天会话viewController 对象
    CYChatVC *chatVC = [[CYChatVC alloc] init];
    
    
    
    // 设置会话的类型，如单聊、讨论组、群聊、聊天室、客服、公众服务会话等
    chatVC.conversationType = ConversationType_PRIVATE;
    
    
    // 设置会话的目标会话ID。（单聊、客服、公众服务号会话为对方的ID，讨论组、群聊、聊天室为会话的ID）
    chatVC.targetId = oppUserId;
    
    // 设置聊天会话界面要显示的标题
    chatVC.title = oppUserName;
    
    self.parentViewController.hidesBottomBarWhenPushed = YES;
    //    self.hidesBottomBarWhenPushed = YES;
    
    // 显示聊天会话界面
    [self.navigationController pushViewController:chatVC animated:YES];
    
    // tabbar：显示
    self.parentViewController.hidesBottomBarWhenPushed = NO;
}

// 加好友界面
- (void)addFriendViewWithOppUserId:(NSString *)oppUserId{
    NSLog(@"加好友界面");
    
//    CYAddFriendVC *addFriendVC = [[CYAddFriendVC alloc] init];
//    
//    addFriendVC.OppUserId = oppUserId;
//    
//    
//    [self presentViewController:addFriendVC animated:YES completion:nil];
    
    
    
    
    
    
    
    
    
    
    _addFriendView = [[[NSBundle mainBundle] loadNibNamed:@"CYAddFriendView" owner:nil options:nil] lastObject];
    
    _addFriendView.frame = CGRectMake(0, -128, cScreen_Width, cScreen_Height);
    
    
    
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
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    
    //
    [UIView animateWithDuration:0.5 animations:^{
        self.addFriendView.frame = CGRectMake(0, -128, cScreen_Width, cScreen_Height);
        
    }];
    
    for (UIView *tempView in self.view.subviews) {
        if ([tempView isKindOfClass:[UIView class]]) {
            // 失去第一响应者
            [tempView resignFirstResponder];
        }
    }
    
    
}

#pragma mark --UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView{
    
    
    // 键盘弹出：上拉弹窗
    [UIView animateWithDuration:0.5 animations:^{
        self.addFriendView.bounds = CGRectMake(0, 64, cScreen_Width, cScreen_Height);
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



// 设置cell 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(cCollectionCellWidth, cCollectionCellHeight);
    
}

// 设置cell 的 边界距离
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    // 上、左、下、右
    return UIEdgeInsetsMake(cCellEdgeTop, cCellEdgeLeft, cCellEdgeDown, cCellEdgeRight);
}


@end
