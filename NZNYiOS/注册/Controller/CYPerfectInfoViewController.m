//
//  CYPerfectInfoViewController.m
//  NZNYiOS
//
//  Created by 男左女右 on 16/9/17.
//  Copyright © 2016年 NZNY. All rights reserved.
//

#import "CYPerfectInfoViewController.h"

// 完善信息View
#import "CYPerfectInfoMainView.h"

// 根视图
#import "CYMainTabBarController.h"
#define kMaxLength 20

@interface CYPerfectInfoViewController ()<UINavigationControllerDelegate,UIAlertViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate>

// 完善信息视图
@property (nonatomic,strong) CYPerfectInfoMainView *perfectInfoMainView;

// 性别：是否为男士
@property (nonatomic,copy) NSString *gender;

// 图片选择控制器：相册和相机都会用到这个类
@property (nonatomic,strong) UIImagePickerController *picker;

// 返回的图片的地址
@property (nonatomic,copy) NSString *headImgPathReturn;

@end

@implementation CYPerfectInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"完善信息";
    
    // 设置完善信息View
    [self setPerfectInfoMainView];
    
    
}

// 设置完善信息View
- (void)setPerfectInfoMainView{
    
    _perfectInfoMainView = [[[NSBundle mainBundle] loadNibNamed:@"CYPerfectInfoMainView" owner:nil options:nil] lastObject];
    
    _perfectInfoMainView.frame = CGRectMake(0, 0, cScreen_Width, cScreen_Height - 64);
    
    // 1、头像点击事件：手势
    _perfectInfoMainView.headImgView.userInteractionEnabled = YES;
    [_perfectInfoMainView.headImgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(perfectInfoHeadImgViewChangeClick)]];
    
    
    
    // 2、nameTextField监听事件
    // 2.1
//    [_perfectInfoMainView.nameTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    // 2.2
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange) name:UITextFieldTextDidChangeNotification object:_perfectInfoMainView.nameTF];
    
    
    // 3、男士头像点击事件：手势
    //  3.1默认男士选择；
    _gender = @"男";
    _perfectInfoMainView.manImgView.image = [UIImage imageNamed:@"男士选择"];
    //  3.2手势
    _perfectInfoMainView.manImgView.userInteractionEnabled = YES;
    [_perfectInfoMainView.manImgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(manImgViewClick)]];
    
    // 4、女士头像点击事件：手势
    _perfectInfoMainView.ladyImgView.userInteractionEnabled = YES;
    [_perfectInfoMainView.ladyImgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ladyImgViewClick)]];
    
    // 5、完成button：点击事件
    [_perfectInfoMainView.finishBtn addTarget:self action:@selector(finishBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    // 11.5号，决定去掉：跳过button
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"跳过" style:1 target:self action:@selector(skipRightBarButtonItemClick)];
    
    
    self.view = _perfectInfoMainView;
    
    
}

// 右侧跳过button：rightBarButtonItem 点击事件
- (void)skipRightBarButtonItemClick{
    NSLog(@"右侧跳过button：点击事件");
    
    
    // 1、处理为：调到登录界面，让用户登录
//    [self dismissViewControllerAnimated:YES completion:nil];
    
    
    // 2、处理为：直接登录
    [self loginSuccess];
    
    
}

// 2、nameTextField监听事件
- (void)textFieldDidChange{
    NSLog(@"nameTextField 监听事件");
    
    // 获取当前的键盘模式
    NSLog(@"%@",[[UITextInputMode currentInputMode] primaryLanguage]);
    
    // 判断nameTextField是否为空
    if ([_perfectInfoMainView.nameTF.text isEqualToString:@""]) {
        
        NSLog(@"nameTextField为空，完成button,未激活");
        
        // nameTextField 是空的，则完成button，不可用
        _perfectInfoMainView.finishBtn.enabled = NO;
        
        // 完成button，不可用下的背景图片
        [_perfectInfoMainView.finishBtn setBackgroundImage:[UIImage imageNamed:@"完成未激活"] forState:UIControlStateDisabled];
    }
    else {
        NSLog(@"完成激活");
        
        // nameTextField 是有值，则完成button，可用
        _perfectInfoMainView.finishBtn.enabled = YES;
        
        // 完成button，可用下的背景图片
        [_perfectInfoMainView.finishBtn setBackgroundImage:[UIImage imageNamed:@"完成激活"] forState:UIControlStateNormal];
    }
    
//    
//    NSString *toBeString = _perfectInfoMainView.nameTF.text;
//    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage]; // 键盘输入模式
//    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
//        UITextRange *selectedRange = [_perfectInfoMainView.nameTF markedTextRange];
//        //获取高亮部分
//        UITextPosition *position = [_perfectInfoMainView.nameTF positionFromPosition:selectedRange.start offset:0];
//        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
//        if (!position) {
//            if (toBeString.length > kMaxLength) {
//                _perfectInfoMainView.nameTF.text = [toBeString substringToIndex:kMaxLength];
//            }
//        }
//        // 有高亮选择的字符串，则暂不对文字进行统计和限制
//        else{
//            
//        }
//    }
//    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
//    else{
//        if (toBeString.length > kMaxLength) {
//            _perfectInfoMainView.nameTF.text = [toBeString substringToIndex:kMaxLength];
//        }
//    }
}

// 女士头像点击事件：手势
- (void)ladyImgViewClick{
    NSLog(@"女士头像点击事件：手势");
    
//    if ([_gender isEqualToString:@"男"]) {
    
        _perfectInfoMainView.ladyImgView.image = [UIImage imageNamed:@"女士选择"];
        
        _perfectInfoMainView.manImgView.image = [UIImage imageNamed:@"男士未选"];
        
        _gender = @"女";
//    }
    
}

// 男士头像点击事件：手势
- (void)manImgViewClick{
    NSLog(@"男士头像点击事件：手势");
    
//    if ([_gender isEqualToString:@"女"]) {
    
        _perfectInfoMainView.manImgView.image = [UIImage imageNamed:@"男士选择"];
        
        _perfectInfoMainView.ladyImgView.image = [UIImage imageNamed:@"女士未选"];
        
        _gender = @"男";
//    }
    
}
// 头像点击事件：手势
- (void)perfectInfoHeadImgViewChangeClick{
    NSLog(@"头像点击事件：手势");
    
    // 选择框：相机、相册
    UIActionSheet *sheet;
    
    // 判断是否支持相机
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        sheet = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"拍照",@"从相册选择", nil];
    }
    else {
        
        sheet = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"从相册选择", nil];
    }
    
    //
    sheet.tag = 2555;
    [sheet showInView:self.view];
    
    
}

// 选择框：相机、相册，选择的是哪一个：代理事件
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (actionSheet.tag == 2555) {
        
        NSUInteger sourceType = 0;
        
        // 判断是否支持相机
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            switch (buttonIndex) {
                case 0:
                    // 取消
                    return;
                case 1:
                    // 相机
                    sourceType = UIImagePickerControllerSourceTypeCamera;
                    
                    break;
                case 2:
                    // 相册
                    sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    
                    break;
                    
                default:
                    break;
            }
        }
        else {
            
            if (buttonIndex == 0) {
                
                return;
            }
            else {
                sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            }
        }
        
        // 跳转到相机或相册页面。
        UIImagePickerController *imgPickerController = [[UIImagePickerController alloc] init];
        
        imgPickerController.delegate = self;
        imgPickerController.allowsEditing = YES;
        imgPickerController.sourceType = sourceType;
        
        [self presentViewController:imgPickerController animated:YES completion:nil];
        
//        [imgPickerController release];
    }
}

// ImagePicker delegate 事件
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    NSLog(@"imageInfo：%@",info);
    // 1、上传图片，返回图片保存的路径
    [self uploadImgWithImg:image];
}

// 上传图片2
- (void)uploadImgWithImg:(UIImage *)image{
    
    NSDictionary *uploadImgParams = @{
                                      @"UserId":self.onlyUser.userID,
                                      @"FileType":@"image"
                                      };
    
    
    [CYNetWorkManager uploadImgRequestWithUrl:cUploadImgUrl params:uploadImgParams constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSLog(@"上传图片：处理图片！");
        
        // 对图片进行压缩（参数一：要压缩的图片，参数二：压缩质量，可不写）
        NSData *data = UIImageJPEGRepresentation(image, 0.001);
        
        NSLog(@"image:%@",image);
        NSLog(@"data:%@",data);
        
        // 文件名
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.jpg",str];
        
        NSLog(@"fileName:%@",fileName);
        
        // 参数一：文件转换后的data数据
        // 参数二：图片放入的文件夹的名字
        // 参数三：图片的名字
        // 参数四：文件的类型
        [formData appendPartWithFileData:data name:@"FileData" fileName:fileName mimeType:@"image/jpg"];
        
    } progress:^(NSProgress *uploadProgress) {
        NSLog(@"上传进度：%@",uploadProgress);
        
    } whenSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"上传图片请求：请求成功！");
        NSLog(@"responseObject:%@",responseObject);
        
        
        // 2.3.1.1、获取code 值
        NSString *code = responseObject[@"code"];
        
        // 2.3.1.2、判断返回值
        if ([code isEqualToString:@"0"]) {
            NSLog(@"上传图片：成功！");
            NSLog(@"msg:%@",responseObject[@"res"][@"msg"]);
            
            // 上传图片成功，修改imageView
            _perfectInfoMainView.headImgView.image = image;
            
            // 相对路径
            _headImgPathReturn = responseObject[@"res"][@"data"][@"path"];
            
        }
        else{
            NSLog(@"上传图片：失败！");
            NSLog(@"msg:%@",responseObject[@"res"][@"msg"]);
            NSLog(@"~~~~~~~");
            
            // 2.3.1.2.2、上传图片失败，弹窗
            [self showHubWithLabelText:responseObject[@"res"][@"msg"] andHidAfterDelay:3.0];
        }
        
        
    } whenFailure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"上传图片：请求失败！");
        NSLog(@"error:%@",error);
        
        [self showHubWithLabelText:@"网络错误，请重新上传！" andHidAfterDelay:3.0];
        
    } withToken:self.onlyUser.userToken];
    
}

// 完成button：点击事件
- (void)finishBtnClick{
    NSLog(@"点击完成button 哟~");
    
    
    BOOL isName = [CYUtilities checkUserName:_perfectInfoMainView.nameTF.text];
    
    if (!isName) {
        
        [self showHubWithLabelText:@"请输入4个汉字以内的中文名" andHidAfterDelay:3.0];
    }
    else if (_headImgPathReturn == nil) {
        
        [self showHubWithLabelText:@"请上传头像！" andHidAfterDelay:3.0];
    }
    else{
        
        NSLog(@"完成button，可以提交信息到主界面！");
        // 2.2、参数
        NSDictionary *furRegisterParams = @{
                                      @"UserId":self.onlyUser.userID,
                                      @"Portrait":self.headImgPathReturn,
                                      @"Gender":self.gender,
                                      @"RealName":self.perfectInfoMainView.nameTF.text
                                      
                                      };
        
        
        // 2.3、网络请求：提交：ID、头像str、性别、姓名
        [CYNetWorkManager postRequestWithUrl:cFurRegisterUrl params:furRegisterParams progress:^(NSProgress *uploadProgress) {
            NSLog(@"上传进度：%@",uploadProgress);
            
        } whenSuccess:^(NSURLSessionDataTask *task, id responseObject) {
            NSLog(@"完善信息：请求成功！");
            
            
            // 2.3.1.1、获取code 值
            NSString *code = responseObject[@"code"];
            
            
            // 2.3.1.2、判断返回值
            if ([code isEqualToString:@"0"]) {
                NSLog(@"完善信息：成功！");
                
                // 2.3.1.2.1、完善信息成功，直接登录
                // 创建mainTabbar，设置为根视图控制器
//                [self dismissViewControllerAnimated:YES completion:nil];
                [self loginSuccess];
                
            }
            else{
                NSLog(@"完善信息：失败！");
                
                NSLog(@"%@",responseObject[@"res"][@"msg"]);
                
                // 2.3.1.2.2、完善信息失败，弹窗
                [self showHubWithLabelText:responseObject[@"res"][@"msg"] andHidAfterDelay:3.0];
            }
        } whenFailure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"完善信息：请求失败！");
            NSLog(@"失败error：%@",error);
            
            // 2.3.2、完善信息：请求失败
            [self showHubWithLabelText:@"完善信息失败，可能是网络有问题，请检查网络再试一遍!" andHidAfterDelay:3.0];
        } withToken:self.onlyUser.userToken];
        
    }
    
}
//
//// 监听alert按钮的点击
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//    
//    if (buttonIndex == 0) {
//        
//        NSLog(@"点击了取消");
//    }
//    else{
//        
//        NSLog(@"点击了确定");
//        
//#warning 请求数据：接口，提交用户信息到后台
//        // 请求数据：接口，提交用户信息到后台
//        
//    }
//}


@end
