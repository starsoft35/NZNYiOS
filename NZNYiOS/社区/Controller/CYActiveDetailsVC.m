//
//  CYActiveDetailsVC.m
//  nzny
//
//  Created by 男左女右 on 2017/2/4.
//  Copyright © 2017年 nznychina. All rights reserved.
//

#import "CYActiveDetailsVC.h"

#import "HZPhotoBrowser.h"
#import "WebViewURLViewController.h"
#import "IMYWebView.h"



@interface CYActiveDetailsVC ()
<
UITableViewDataSource,
UITableViewDelegate,
IMYWebViewDelegate,
HZPhotoBrowserDelegate
>


@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, assign)CGFloat webviewHight;//记录webview的高度
@property(nonatomic, copy)NSString *HTMLData;//需要加载的HTML数据
@property(nonatomic, strong)NSMutableArray *imageArray;//HTML中的图片个数
@property(nonatomic, strong)IMYWebView *htmlWebView;

@property(nonatomic, strong)UILabel *titleLabel;





@end

NSInteger tagCount;//全局变量




@implementation CYActiveDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // 背景颜色
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 设置活动报名navigationBar
    [self setActiveEnrollRightNavigationBar];
    
    
    
    // 加载数据
    [self loadData];
    
//
//    // 设置webView
//    [self setWebView];
    
}

// 设置活动报名navigationBar
- (void)setActiveEnrollRightNavigationBar{
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"报名" style:2 target:self action:@selector(activeEnrollRightBarBtnItemClick)];
}

// 活动报名：navigationBarClick
- (void)activeEnrollRightBarBtnItemClick{
    NSLog(@"活动报名：navigationBarClick");
    
    // 网络请求：活动报名    
    NSString *newUrl = [NSString stringWithFormat:@"%@?userId=%@&activityContentId=%@",cActivityApplyUrl,self.onlyUser.userID,self.activeId];

    
    // 网络请求：活动报名
    [CYNetWorkManager postRequestWithUrl:newUrl params:nil progress:^(NSProgress *uploadProgress) {
        NSLog(@"活动报名进度：%@",uploadProgress);
        
        
    } whenSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"活动报名：请求成功！");
        
        
        // 1、
        NSString *code = responseObject[@"code"];
        
        // 1.2.1.1.2、和成功的code 匹配
        if ([code isEqualToString:@"0"]) {
            NSLog(@"活动报名：获取成功！");
            NSLog(@"活动报名：%@",responseObject);
            
            [self showHubWithLabelText:@"报名成功" andHidAfterDelay:3.0];
        }
        else{
            NSLog(@"活动报名：获取失败:responseObject:%@",responseObject);
            NSLog(@"活动报名：获取失败:responseObject:res:msg:%@",responseObject[@"res"][@"msg"]);
            // 1.2.1.1.2.2、获取失败：弹窗提示：获取失败的返回信息
            [self showHubWithLabelText:responseObject[@"res"][@"msg"] andHidAfterDelay:3.0];
            
        }
        
        
    } whenFailure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"活动报名：请求失败！");
        NSLog(@"失败原因：error：%@",error);
        
        
        [self showHubWithLabelText:@"请检查网络，重新加载" andHidAfterDelay:3.0];
    } withToken:self.onlyUser.userToken];
    
}


// 加载数据：社区活动详情
- (void)loadData{
    
    NSDictionary *params = @{
                             @"activityId":self.activeId
                             };
    
    [self showLoadingView];
    
    // 网络请求：社区活动详情
    [CYNetWorkManager getRequestWithUrl:cActivityDetailsUrl params:params progress:^(NSProgress *uploadProgress) {
        NSLog(@"获取社区活动详情进度：%@",uploadProgress);
        
        
    } whenSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"社区活动详情：请求成功！");
        
        
        // 1、
        NSString *code = responseObject[@"code"];
        
        // 1.2.1.1.2、和成功的code 匹配
        if ([code isEqualToString:@"0"]) {
            NSLog(@"社区活动详情：获取成功！：%@",responseObject);
            
            
            // 解析数据，模型存到数组
            //            [self.dataArray addObject:[[CYSetUpAboutUsVCModel alloc] initWithDictionary:responseObject[@"res"][@"data"][@"model"] error:nil]];
            
            self.activeDetailsVCModel = [[CYActiveDetailsVCModel alloc] initWithDictionary:responseObject[@"res"][@"data"][@"model"] error:nil];
            
            
            
            // 获取HTML数据
            // html文本格式：添加属性：图片自适应：宽固定，高等比例缩放，（!important：表示根据图片原本大小，宽度小于所给的固定宽带的不缩放，大于的缩小到所给的固定宽度）（使用css进行图片的自适应）
//            _HTMLData = [NSString stringWithFormat:@"%@%@",@" <style>img{max-width: 355px !important;height: auto;}</style>",self.activeDetailsVCModel.Content];
            
            float imageWidthMax = 300;
            if (cScreen_Width == 320) {
                
                imageWidthMax = 300;
            }
            else if (cScreen_Width == 375) {
                
                imageWidthMax = 355;
            }
            else if (cScreen_Width == 414) {
                
                imageWidthMax = 394;
            }
            
            _HTMLData = [NSString stringWithFormat:@" <style>img{max-width: %fpx !important;height: auto;}; video{max-width: %fpx !important;height: auto;}</style>%@",imageWidthMax,imageWidthMax,self.activeDetailsVCModel.Content];
            
            
            // 设置webView
//            [self setWebView];
            
            
            
            UIWebView * webView = [[UIWebView alloc]initWithFrame:CGRectMake(25.0 / 750.0 * cScreen_Width, 18.0 / 1334.0 * cScreen_Height, cScreen_Width - 2 * 25.0 / 750.0 * cScreen_Width, cScreen_Height - 64 - 18.0 / 1334.0 * cScreen_Height)];
            
            webView.frame = CGRectMake(0, 0, cScreen_Width, cScreen_Height - 64 - 18.0 / 1334.0 * cScreen_Height);
            
            webView.backgroundColor = [UIColor whiteColor];
            
            webView.scalesPageToFit = YES;
            
            webView.delegate = self;
            
            [webView loadHTMLString:_HTMLData baseURL:nil];
            [self.view addSubview:webView];
            
            
        }
        else{
            NSLog(@"社区活动详情：获取失败:responseObject:%@",responseObject);
            NSLog(@"社区活动详情：获取失败:responseObject:res:msg:%@",responseObject[@"res"][@"msg"]);
            
            
            // 1.2.1.1.2.2、获取失败：弹窗提示：获取失败的返回信息
            [self showHubWithLabelText:responseObject[@"res"][@"msg"] andHidAfterDelay:3.0];
            
        }
        
        
    } whenFailure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"社区活动详情：请求失败！失败原因：error：%@",error);
        
        
        [self showHubWithLabelText:@"请检查网络，重新加载" andHidAfterDelay:3.0];
    } withToken:self.onlyUser.userToken];
    
}



// 模型赋值
- (void)setActiveDetailsVCModel:(CYActiveDetailsVCModel *)activeDetailsVCModel{
    
    
    _activeDetailsVCModel = activeDetailsVCModel;
    
    self.title = activeDetailsVCModel.Title;
    
    
//    // 二、使用webView加载html
//    UIWebView * webView = [[UIWebView alloc]initWithFrame:CGRectMake(25.0 / 750.0 * cScreen_Width, 18.0 / 1334.0 * cScreen_Height, cScreen_Width - 2 * 25.0 / 750.0 * cScreen_Width, cScreen_Height - 64 - 18.0 / 1334.0 * cScreen_Height)];
//    
////    webView.backgroundColor = [UIColor whiteColor];
//    
//    [webView loadHTMLString:activeDetailsVCModel.Content baseURL:nil];
//    [self.view addSubview:webView];
}


// 设置webView
- (void)setWebView{
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, cScreen_Width , cScreen_Height - 64) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    _tableView.tableHeaderView = [[UIView alloc] init];
    [self.view addSubview:_tableView];
    
    
    
    [self showLoadingView];
    
    //    获取HTML数据
    [self getHTMLData];
    
    
    _htmlWebView = [[IMYWebView alloc] init];
    _htmlWebView.frame = CGRectMake(0, 0, _tableView.frame.size.width, 1);
    
    _titleLabel.textAlignment = 1;
//    _htmlWebView.delegate = self;
    _htmlWebView.scrollView.scrollEnabled = NO;//设置webview不可滚动，让tableview本身滚动即可
    _htmlWebView.scrollView.bounces = NO;
    _htmlWebView.opaque = NO;
    
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //    if (indexPath.row != 3) {
    //         return 60;
    //    }else{
    //
    return _webviewHight;//cell自适应webview的高度
    //    }
    
}


#pragma --tableView代理
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
    }
    if (indexPath.row == 0) {
        
        [cell.contentView addSubview:_htmlWebView];
        
        //加载HTML数据
        [_htmlWebView loadHTMLString:_HTMLData baseURL:nil];
        
    }else{
        
        //        cell.textLabel.text = [NSString stringWithFormat:@"第%ld行",(long)indexPath.row];
        
    }
    return cell;
}

-(void)webViewDidFinishLoad:(IMYWebView *)webView{
    
    NSString *meta = [NSString stringWithFormat:@"document.getElementsByName(\"viewport\")[0].content = \"width=%f, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no\"", webView.frame.size.width];
    [webView stringByEvaluatingJavaScriptFromString:meta];
    
//    [self.htmlWebView stringByEvaluatingJavaScriptFromString:     @"var script = document.createElement('script');"
//     "script.type = 'text/javascript';"
//     "script.text = /"function ResizeImages() { "
//         "var myimg,oldwidth,oldheight;"
//         "var maxwidth=320;"// 图片宽度
//         "for(i=0;i  maxwidth){"
//         "myimg.width = maxwidth;"
//         "}"
//         "}"
//         "}/";"
//         "document.getElementsByTagName('head')[0].appendChild(script);"];
//         [self.htmlWebView stringByEvaluatingJavaScriptFromString:@"ResizeImages();"];
//    
//    
//         [self.htmlWebView stringByEvaluatingJavaScriptFromString:@""];
    
    
    [self.htmlWebView evaluateJavaScript:@"document.documentElement.scrollHeight" completionHandler:^(id object, NSError *error) {
        CGFloat height = [object integerValue];
        
        if (error != nil) {
            
        }else{
            _webviewHight = height + 30;
            [_tableView beginUpdates];
            self.htmlWebView.frame = CGRectMake(_htmlWebView.frame.origin.x,_htmlWebView.frame.origin.y, _tableView.frame.size.width, _webviewHight );
            
            
        }
        
        [_tableView endUpdates];
    }];
    
    //    插入js代码，对图片进行点击操作
    [webView evaluateJavaScript:@"function assignImageClickAction(){var imgs=document.getElementsByTagName('img');var length=imgs.length;for(var i=0; i < length;i++){img=imgs[i];if(\"ad\" ==img.getAttribute(\"flag\")){var parent = this.parentNode;if(parent.nodeName.toLowerCase() != \"a\")return;}img.onclick=function(){window.location.href='image-preview:'+this.src}}}" completionHandler:^(id object, NSError *error) {
        
    }];
    [webView evaluateJavaScript:@"assignImageClickAction();" completionHandler:^(id object, NSError *error) {
        
    }];
    
    //获取HTML中的图片
    [self getImgs];
    
    
    [self hidenLoadingView];
}

-(BOOL)webView:(IMYWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    if ([request.URL isEqual:@"about:blank"])
    {
        return true;
    }
    if ([request.URL.scheme isEqualToString: @"image-preview"])
    {
        
        NSString *url = [request.URL.absoluteString substringFromIndex:14];
        
        
        //启动图片浏览器， 跳转到图片浏览页面
        if (_imageArray.count != 0) {
            
            HZPhotoBrowser *browserVc = [[HZPhotoBrowser alloc] init];
            browserVc.imageCount = self.imageArray.count; // 图片总数
            browserVc.currentImageIndex = [_imageArray indexOfObject:url];//当前点击的图片
            browserVc.delegate = self;
            [browserVc show];
            
        }
        return NO;
        
    }
    
    //    用户点击文章详情中的链接
    if ( navigationType == UIWebViewNavigationTypeLinkClicked ) {
        
        WebViewURLViewController *webViewVC = [WebViewURLViewController new];
        webViewVC.URLString = request.URL.absoluteString;
        [self.navigationController pushViewController:webViewVC animated:YES];
        
        
        return NO;
    }
    
    return YES;
}


#pragma mark - photobrowser代理方法
- (UIImage *)photoBrowser:(HZPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    //图片浏览时，未加载出图片的占位图
    return [UIImage imageNamed:@"gg_pic@2x"];
    
}

- (NSURL *)photoBrowser:(HZPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    NSString *urlStr = [self.imageArray[index] stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"];
    return [NSURL URLWithString:urlStr];
}
#pragma mark -- 获取文章中的图片个数
- (NSArray *)getImgs
{
    
    NSMutableArray *arrImgURL = [[NSMutableArray alloc] init];
    for (int i = 0; i < [self nodeCountOfTag:@"img"]; i++) {
        NSString *jsString = [NSString stringWithFormat:@"document.getElementsByTagName('img')[%d].src", i];
        [_htmlWebView evaluateJavaScript:jsString completionHandler:^(NSString *str, NSError *error) {
            
            if (error ==nil) {
                [arrImgURL addObject:str];
            }
            
            
            
        }];
    }
    _imageArray = [NSMutableArray arrayWithArray:arrImgURL];
    
    
    return arrImgURL;
}

// 获取某个标签的结点个数
- (NSInteger)nodeCountOfTag:(NSString *)tag
{
    
    NSString *jsString = [NSString stringWithFormat:@"document.getElementsByTagName('%@').length", tag];
    
    int count =  [[_htmlWebView stringByEvaluatingJavaScriptFromString:jsString] intValue];
    
    return count;
}


-(void)getHTMLData{
    
    
}

@end
