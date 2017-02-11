//
//  WebViewURLViewController.m
//  tableview嵌套webview
//
//  Created by WOSHIPM on 16/7/2.
//  Copyright © 2016年 WOSHIPM. All rights reserved.
//

#import "WebViewURLViewController.h"

@interface WebViewURLViewController ()<UIWebViewDelegate>
@property(nonatomic, strong)UIWebView *webView;
@end

@implementation WebViewURLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64)];
    _webView.scrollView.bounces = NO;
    _webView.delegate = self;
    [self.view addSubview:_webView];
    NSURL *url = [NSURL URLWithString:_URLString];
    
    [_webView loadRequest:[NSURLRequest requestWithURL:url]];
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    self.navigationItem.title =  [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}



@end
