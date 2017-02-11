//
//  CYSetUpAboutUsVC.m
//  nzny
//
//  Created by 男左女右 on 2017/1/7.
//  Copyright © 2017年 nznychina. All rights reserved.
//

#import "CYSetUpAboutUsVC.h"

@interface CYSetUpAboutUsVC ()

@end

@implementation CYSetUpAboutUsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"用户须知";
    
    
    // 加载数据
    [self loadData];
    
    
    
    
    // 设置行间距
//    _aboutUsLab.frame = CGRectMake(0, 20, 320, 200);
//    [_aboutUsLab setFont:[UIFont systemFontOfSize:15]];
//    
//    [_aboutUsLab setNumberOfLines:0];
//    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:_aboutUsLab.text];
//    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//    [paragraphStyle setLineSpacing:5.0];//调整行间距
//    
//    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [_aboutUsLab.text length])];
//    _aboutUsLab.attributedText = attributedString;
//    _aboutUsLab.contentMode = UIViewContentModeTop;
//    [_aboutUsLab sizeToFit];
}

// 加载数据
- (void)loadData{
    
    // 网络请求：关于我们
    [CYNetWorkManager getRequestWithUrl:cAboutUsUrl params:nil progress:^(NSProgress *uploadProgress) {
        NSLog(@"获取关于我们进度：%@",uploadProgress);
        
        
    } whenSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"关于我们：请求成功！");
        
        
        
        // 1、
        NSString *code = responseObject[@"code"];
        
        // 1.2.1.1.2、和成功的code 匹配
        if ([code isEqualToString:@"0"]) {
            NSLog(@"关于我们：获取成功！：%@",responseObject);
            
            
            // 解析数据，模型存到数组
//            [self.dataArray addObject:[[CYSetUpAboutUsVCModel alloc] initWithDictionary:responseObject[@"res"][@"data"][@"model"] error:nil]];
            
            self.setUpAboutUsVCModel = [[CYSetUpAboutUsVCModel alloc] initWithDictionary:responseObject[@"res"][@"data"][@"model"] error:nil];
            
        }
        else{
            NSLog(@"关于我们：获取失败:responseObject:%@",responseObject);
            NSLog(@"关于我们：获取失败:responseObject:res:msg:%@",responseObject[@"res"][@"msg"]);
            
            
            // 1.2.1.1.2.2、获取失败：弹窗提示：获取失败的返回信息
            [self showHubWithLabelText:responseObject[@"res"][@"msg"] andHidAfterDelay:3.0];
            
        }
        
        
    } whenFailure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"关于我们：请求失败！失败原因：error：%@",error);
        
        [self showHubWithLabelText:@"请检查网络，重新加载" andHidAfterDelay:3.0];
    } withToken:self.onlyUser.userToken];
    
}


// 模型赋值
- (void)setSetUpAboutUsVCModel:(CYSetUpAboutUsVCModel *)setUpAboutUsVCModel{
    
    _setUpAboutUsVCModel = setUpAboutUsVCModel;
    
//    self.title = setUpAboutUsVCModel.Title;
    
    _subTitleLab.text = setUpAboutUsVCModel.SubTitle;
    
//    _aboutUsLab.text = setUpAboutUsVCModel.Content;
    
    
    
    // 一、使用label加载html：方法一
//    NSString *str1 = setUpAboutUsVCModel.Content;
//    //1.将字符串转化为标准HTML字符串
//    str1 = [self htmlEntityDecode:str1];
//    //2.将HTML字符串转换为attributeString
//    NSAttributedString * attributeStr = [self attributedStringWithHTMLString:str1];
//    
//    //3.使用label加载html字符串
//    _aboutUsLab.attributedText = attributeStr;
    
    
    
    
    // 一、使用label加载html：方法二
    NSMutableAttributedString * attrString =[[NSMutableAttributedString alloc] initWithData:[setUpAboutUsVCModel.Content dataUsingEncoding:NSUnicodeStringEncoding]options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType}documentAttributes:nil error:nil];
    
    [attrString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} range:NSMakeRange(0, attrString.length)];
    
    
    
    
    // 算高度
    NSMutableAttributedString *htmlString =[[NSMutableAttributedString alloc] initWithData:[setUpAboutUsVCModel.Content dataUsingEncoding:NSUTF8StringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,NSCharacterEncodingDocumentAttribute:[NSNumber numberWithInt:NSUTF8StringEncoding]}documentAttributes:NULL error:nil];
    
    [htmlString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} range:NSMakeRange(0, htmlString.length)];
    
    
    CGSize textSize = [htmlString boundingRectWithSize:(CGSize){cScreen_Width - 20, CGFLOAT_MAX} options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    
    _aboutUsLab.frame = CGRectMake(_aboutUsLab.frame.origin.x, _aboutUsLab.frame.origin.y, _aboutUsLab.frame.size.width, textSize.height);
    
    
    _aboutUsLab.attributedText = attrString;
    
    
    // 二、使用webView加载html
//    UIWebView * webView = [[UIWebView alloc]initWithFrame:CGRectMake(20, 300, self.view.frame.size.width - 40, 400)];
//    [webView loadHTMLString:setUpAboutUsVCModel.Content baseURL:nil];
//    [self.view addSubview:webView];
    
    
    
}

//将 &lt 等类似的字符转化为HTML中的“<”等
- (NSString *)htmlEntityDecode:(NSString *)string
{
    string = [string stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    string = [string stringByReplacingOccurrencesOfString:@"&apos;" withString:@"'"];
    string = [string stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    string = [string stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    string = [string stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"]; // Do this last so that, e.g. @"&amp;lt;" goes to @"&lt;" not @"<"
    
    return string;
}

//将HTML字符串转化为NSAttributedString富文本字符串
- (NSAttributedString *)attributedStringWithHTMLString:(NSString *)htmlString
{
    NSDictionary *options = @{ NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType,
                               NSCharacterEncodingDocumentAttribute :@(NSUTF8StringEncoding) };
    
    NSData *data = [htmlString dataUsingEncoding:NSUTF8StringEncoding];
    
    return [[NSAttributedString alloc] initWithData:data options:options documentAttributes:nil error:nil];
}


@end
