//
//  CYServiceAskFeedBackVC.m
//  nzny
//
//  Created by 男左女右 on 2017/2/18.
//  Copyright © 2017年 nznychina. All rights reserved.
//

#import "CYServiceAskFeedBackVC.h"

@interface CYServiceAskFeedBackVC ()<UITextViewDelegate>

@property (nonatomic,assign) BOOL ifShowTip;

@end

#define MAX_LIMIT_NUMS (50)

@implementation CYServiceAskFeedBackVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"反馈";
    
    
    // textView代理
    self.feedBackInfoTV.delegate = self;
    
    // 设置视图
    [self setFeedBackView];
    
}
// 设置视图
- (void)setFeedBackView{
    
    _ifShowTip = YES;
    
    if (_ifShowTip) {
        
        
        self.feedBackInfoTV.text = @"请输入您要提交的问题...";
    }
    
    self.feedBackInfoTV.textColor = [UIColor colorWithRed:0.80 green:0.80 blue:0.80 alpha:1.00];
    [self.feedBackInfoTV setFont:[UIFont systemFontOfSize:14]];
    
    // 提交：点击事件
    [self.submitBtn addTarget:self action:@selector(submitBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
}


// 提交：点击事件
- (void)submitBtnClick{
    NSLog(@"提交：点击事件");
    
    if (_ifShowTip || [self.feedBackInfoTV.text isEqualToString:@""]) {
        
        [self showHubWithLabelText:@"请输入问题" andHidAfterDelay:3.0];
    }
    else {
        
        // 请求数据：修改爱情宣言
        NSString *newUrl = [NSString stringWithFormat:@"%@?userId=%@&content=%@",cFeedBackAddUrl,self.onlyUser.userID,self.feedBackInfoTV.text];
        
        // 编码：url里面有中文
        NSString *tempUrl = [newUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSLog(@"newUrl:%@",tempUrl);
        // 显示加载
        [self showLoadingView];
        
        // 请求数据：修改爱情宣言
        [CYNetWorkManager postRequestWithUrl:tempUrl params:nil progress:^(NSProgress *uploadProgress) {
            NSLog(@"提交反馈进度：%@",uploadProgress);
            
        } whenSuccess:^(NSURLSessionDataTask *task, id responseObject) {
            NSLog(@"提交反馈：请求成功！");
            
            //        [self hidenLoadingView];
            
            // 1、
            NSString *code = responseObject[@"code"];
            
            // 1.2.1.1.2、和成功的code 匹配
            if ([code isEqualToString:@"0"]) {
                NSLog(@"提交反馈：获取成功！");
                NSLog(@"提交反馈：%@",responseObject);
                
                
                // 提交反馈
                
                // 返回上一个界面
                //            [self.navigationController popViewControllerAnimated:YES];
                [self showHubWithLabelText:@"提交成功" andHidAfterDelay:3.0];
                
            }
            else{
                NSLog(@"提交反馈：获取失败:responseObject:%@",responseObject);
                NSLog(@"提交反馈：获取失败:responseObject:res:msg:%@",responseObject[@"res"][@"msg"]);
                // 1.2.1.1.2.2、获取失败：弹窗提示：获取失败的返回信息
                [self showHubWithLabelText:responseObject[@"res"][@"msg"] andHidAfterDelay:3.0];
                
            }
            
            
        } whenFailure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"提交反馈：请求失败！:error:%@",error);
            
            [self showHubWithLabelText:@"请检查网络，重新加载" andHidAfterDelay:3.0];
            
        } withToken:self.onlyUser.userToken];
        
    }
    
}



#pragma ------------------------------- textView代理：开始 -------------------------------
- (void)textViewDidBeginEditing:(UITextView *)textView{
    
    if (_ifShowTip) {
        
        self.feedBackInfoTV.text = @"";
        
        _ifShowTip = NO;
    }
    
    
    self.surplusCountLab.hidden = NO;
    self.maxCountLab.hidden = NO;
    
    
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    
    
    self.feedBackInfoTV.textColor = [UIColor blackColor];
    
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
            self.surplusCountLab.text = [NSString stringWithFormat:@"%d ",0];
            self.maxCountLab.text = [NSString stringWithFormat:@"/ %ld",(long)MAX_LIMIT_NUMS];
        }
        return NO;
    }
}
- (void)textViewDidChange:(UITextView *)textView{
    
//    self.surplusCountLab.hidden = NO;
//    self.maxCountLab.hidden = NO;
    
    
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
    self.surplusCountLab.text = [NSString stringWithFormat:@"%ld ",MAX(0,MAX_LIMIT_NUMS - existTextNum)];
    self.maxCountLab.text = [NSString stringWithFormat:@"/ %d",MAX_LIMIT_NUMS];
}

#pragma ------------------------------- textView代理：结束 -------------------------------




@end
