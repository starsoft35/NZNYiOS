//
//  CYAddFriendVC.m
//  nzny
//
//  Created by 男左女右 on 2016/11/23.
//  Copyright © 2016年 nznychina. All rights reserved.
//

#import "CYAddFriendVC.h"



@interface CYAddFriendVC ()<UITextViewDelegate>

@end

#define MAX_LIMIT_NUMS (30)

@implementation CYAddFriendVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    // 添加视图
    [self addView];
    
    
}


// 添加视图
- (void)addView{
    
    
    _addFriendView = [[[NSBundle mainBundle] loadNibNamed:@"CYAddFriendView" owner:nil options:nil] lastObject];
    
    
    // 弹窗关闭：点击事件
    [_addFriendView.tipCloseBtn addTarget:self action:@selector(tipCloseBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    // 添加好友：点击事件
    [_addFriendView.addFriendBtn addTarget:self action:@selector(addFriendBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    _addFriendView.sayToYouTextView.delegate = self;
    
    self.view = _addFriendView;
    
}


// 弹窗关闭：点击事件
- (void)tipCloseBtnClick{
    NSLog(@"弹窗关闭：点击事件");
    
    // 隐藏键盘
    [self.view endEditing:YES];
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


// 添加好友：点击事件
- (void)addFriendBtnClick{
    NSLog(@"添加好友：点击事件");
    

    // 网络请求：添加好友
    // 参数
    NSDictionary *params = @{
                             @"UserId":self.onlyUser.userID,
                             @"OppUserId":self.OppUserId,
                             @"Description":self.addFriendView.sayToYouTextView.text
                             };
    NSLog(@"Description:%@",self.addFriendView.sayToYouTextView.text);
    // 网络请求：添加好友
    [CYNetWorkManager postRequestWithUrl:cApplyFriendUrl params:params progress:^(NSProgress *uploadProgress) {
        NSLog(@"progress:%@",uploadProgress);
        
    } whenSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"添加好友：请求成功！");
        
        
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
        self.view.bounds = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        
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
        self.view.bounds = CGRectMake(0, 128, self.view.frame.size.width, self.view.frame.size.height);
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

@end
