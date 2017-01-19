//
//  CYMyUserInfoLocationVC.m
//  nzny
//
//  Created by 男左女右 on 2017/1/5.
//  Copyright © 2017年 nznychina. All rights reserved.
//

#import "CYMyUserInfoLocationVC.h"

#import "ActionSheetCustomPicker.h"
#import "MJExtension.h"



@interface CYMyUserInfoLocationVC () <ActionSheetCustomPickerDelegate>


@property (nonatomic,strong) NSArray *addressArr; // 解析出来的最外层数组
@property (nonatomic,strong) NSArray *provinceArr; // 省
@property (nonatomic,strong) NSArray *countryArr; // 市
@property (nonatomic,strong) NSArray *districtArr; // 区
@property (nonatomic,assign) NSInteger index1; // 省下标
@property (nonatomic,assign) NSInteger index2; // 市下标
@property (nonatomic,assign) NSInteger index3; // 区下标
@property (nonatomic,strong) ActionSheetCustomPicker *picker; // 选择器




@end

@implementation CYMyUserInfoLocationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"区域";
    
    if (self.selections.count) {
        self.index1 = [self.selections[0] integerValue];
        self.index2 = [self.selections[1] integerValue];
        self.index3 = [self.selections[2] integerValue];
    }
    // 一定要先加载出这三个数组，不然就蹦了
    [self calculateFirstData];
    
    
    // 添加选择器视图
    [self addLocationSelectView];
                                                                                                                     
}


// 添加选择器视图
- (void)addLocationSelectView{
    
    self.locationLab.text = self.onlyUser.City;
    
    
    // 点击出现地址选择器：View
    self.showAreaSelectView.userInteractionEnabled = YES;
    [self.showAreaSelectView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showAreaSelectViewClick)]];
    
    
    
    
}

// 点击出现地址选择器：View
- (void)showAreaSelectViewClick{
    NSLog(@"// 点击出现地址选择器：View");
    
    
    self.picker = [[ActionSheetCustomPicker alloc]initWithTitle:@"选择地区" delegate:self showCancelButton:YES origin:self.view initialSelections:@[@(self.index1),@(self.index2),@(self.index3)]];
    
    self.picker.tapDismissAction  = TapActionSuccess;
    
    
    // 可以自定义左边和右边的按钮
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    cancelButton.frame = CGRectMake(0, 0, 44, 44);
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    // 添加左边取消button
    [self.picker setCancelButton:[[UIBarButtonItem alloc] initWithCustomView:cancelButton]];
    
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [doneButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    doneButton.frame = CGRectMake(0, 0, 44, 44);
    [doneButton setTitle:@"完成" forState:UIControlStateNormal];
    
    [doneButton addTarget:self action:@selector(doneButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    // 添加右边完成button
    [self.picker setDoneButton:[[UIBarButtonItem alloc] initWithCustomView:doneButton]];
    
    
    [self.picker showActionSheetPicker];
}


// 添加右边完成button
- (void)doneButtonClick{
    NSLog(@"添加右边完成button：点击事件");
    
    NSString *firstAddress = self.provinceArr[self.index1];
    NSString *secondAddress = self.countryArr[self.index2];
    NSString *thirdAddress = self.districtArr[self.index3];
    NSMutableString *detailAddress = [[NSMutableString alloc] init];
    if (self.index1 < self.provinceArr.count) {
        [detailAddress appendString:firstAddress];
    }
    if (self.index2 < self.countryArr.count) {
        [detailAddress appendString:secondAddress];
    }
    if (self.index3 < self.districtArr.count) {
        [detailAddress appendString:thirdAddress];
    }
    //    // 此界面显示
    //    self.locationLab.text = detailAddress;
    
    // 最新地址
    NSString *newLocationStr = [NSString stringWithFormat:@"%@-%@-%@",firstAddress,secondAddress,thirdAddress];
    
    // 回调到上一个界面
    //    self.myBlock(detailAddress,@[@(self.index1),@(self.index2),@(self.index3)]);
    
    // 网络请求：修改地址
    [self requestChangeLocationWithArea:newLocationStr];
    
}


// 根据传进来的下标数组计算对应的三个数组
- (void)calculateFirstData
{
    // 拿出省的数组
    [self loadFirstData];
    
    NSMutableArray *cityNameArr = [[NSMutableArray alloc] init];
    // 根据省的index1，默认是0，拿出对应省下面的市
    for (NSDictionary *cityName in [self.addressArr[self.index1] allValues].firstObject) {
        
        NSString *name1 = cityName.allKeys.firstObject;
        [cityNameArr addObject:name1];
    }
    // 组装对应省下面的市
    self.countryArr = cityNameArr;
    //                             index1对应省的字典         市的数组 index2市的字典   对应市的数组
    // 这里的allValue是取出来的大数组，取第0个就是需要的内容
    self.districtArr = [[self.addressArr[self.index1] allValues][0][self.index2] allValues][0];
}

// 拿出省的数组
- (void)loadFirstData
{
    // 注意JSON后缀的东西和Plist不同，Plist可以直接通过contentOfFile抓取，Json要先打成字符串，然后用工具转换
    NSString *path = [[NSBundle mainBundle] pathForResource:@"address" ofType:@"json"];
    NSLog(@"%@",path);
    NSString *jsonStr = [NSString stringWithContentsOfFile:path usedEncoding:nil error:nil];
    self.addressArr = [jsonStr mj_JSONObject];
    
    NSMutableArray *firstName = [[NSMutableArray alloc] init];
    for (NSDictionary *dict in self.addressArr)
    {
        NSString *name = dict.allKeys.firstObject;
        [firstName addObject:name];
    }
    // 第一层是省份 分解出整个省份数组
    self.provinceArr = firstName;
}

#pragma mark - UIPickerViewDataSource Implementation
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    // Returns
    switch (component)
    {
        case 0: return self.provinceArr.count;
        case 1: return self.countryArr.count;
        case 2:return self.districtArr.count;
        default:break;
    }
    return 0;
}
#pragma mark UIPickerViewDelegate Implementation

// returns width of column and height of row for each component.
//- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
//{
//    switch (component)
//    {
//        case 0: return SCREEN_WIDTH /4;
//        case 1: return SCREEN_WIDTH *3/8;
//        case 2: return SCREEN_WIDTH *3/8;
//        default:break;
//    }
//
//    return 0;
//}

/*- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
 {
 return
 }
 */
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (component)
    {
        case 0: return self.provinceArr[row];break;
        case 1: return self.countryArr[row];break;
        case 2:return self.districtArr[row];break;
        default:break;
    }
    return nil;
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel* label = (UILabel*)view;
    if (!label)
    {
        label = [[UILabel alloc] init];
        [label setFont:[UIFont systemFontOfSize:14]];
    }
    
    NSString * title = @"";
    switch (component)
    {
        case 0: title =   self.provinceArr[row];break;
        case 1: title =   self.countryArr[row];break;
        case 2: title =   self.districtArr[row];break;
        default:break;
    }
    label.textAlignment = NSTextAlignmentCenter;
    label.text=title;
    return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch (component)
    {
        case 0:
        {
            self.index1 = row;
            self.index2 = 0;
            self.index3 = 0;
            //            [self calculateData];
            // 滚动的时候都要进行一次数组的刷新
            [self calculateFirstData];
            [pickerView reloadComponent:1];
            [pickerView reloadComponent:2];
            [pickerView selectRow:0 inComponent:1 animated:YES];
            [pickerView selectRow:0 inComponent:2 animated:YES];
        }
            break;
            
        case 1:
        {
            self.index2 = row;
            self.index3 = 0;
            //            [self calculateData];
            [self calculateFirstData];
            [pickerView selectRow:0 inComponent:2 animated:YES];
            [pickerView reloadComponent:2];
        }
            break;
        case 2:
            self.index3 = row;
            break;
        default:break;
    }
}
//
//- (void)calculateData
//{
//    [self loadFirstData];
//    NSDictionary *provincesDict = self.addressArr[self.index1];
//    NSMutableArray *countryArr1 = [[NSMutableArray alloc] init];
//    for (NSDictionary *contryDict in provincesDict.allValues.firstObject) {
//        NSString *name = contryDict.allKeys.firstObject;
//        [countryArr1 addObject:name];
//    }
//    self.countryArr = countryArr1;
//
//    self.districtArr = [provincesDict.allValues.firstObject[self.index2] allValues].firstObject;
//
//}

- (void)configurePickerView:(UIPickerView *)pickerView
{
    pickerView.showsSelectionIndicator = NO;
}

// 点击done的时候回调
- (void)actionSheetPickerDidSucceed:(ActionSheetCustomPicker *)actionSheetPicker origin:(id)origin
{
//    NSString *firstAddress = self.provinceArr[self.index1];
//    NSString *secondAddress = self.countryArr[self.index2];
//    NSString *thirdAddress = self.districtArr[self.index3];
//    NSMutableString *detailAddress = [[NSMutableString alloc] init];
//    if (self.index1 < self.provinceArr.count) {
//        [detailAddress appendString:firstAddress];
//    }
//    if (self.index2 < self.countryArr.count) {
//        [detailAddress appendString:secondAddress];
//    }
//    if (self.index3 < self.districtArr.count) {
//        [detailAddress appendString:thirdAddress];
//    }
////    // 此界面显示
////    self.locationLab.text = detailAddress;
//    
//    // 最新地址
//    NSString *newLocationStr = [NSString stringWithFormat:@"%@-%@-%@",firstAddress,secondAddress,thirdAddress];
//    
//    // 回调到上一个界面
////    self.myBlock(detailAddress,@[@(self.index1),@(self.index2),@(self.index3)]);
//    
//    // 网络请求：修改地址
//    [self requestChangeLocationWithArea:newLocationStr];
}

// 网络请求：修改地址
- (void)requestChangeLocationWithArea:(NSString *)area{
    
    // 请求数据：修改地址
    NSString *newUrl = [NSString stringWithFormat:@"%@?userId=%@&city=%@",cModifyAreaUrl,self.onlyUser.userID,area];
    
    // 编码：url里面有中文
    NSString *tempUrl = [newUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"newUrl:%@",tempUrl);
    // 显示加载
    [self showLoadingView];
    
    // 请求数据：修改地址
    [CYNetWorkManager postRequestWithUrl:tempUrl params:nil progress:^(NSProgress *uploadProgress) {
        NSLog(@"修改地址进度：%@",uploadProgress);
        
    } whenSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"修改地址：请求成功！");
        
        [self hidenLoadingView];
        
        // 1、
        NSString *code = responseObject[@"code"];
        
        // 1.2.1.1.2、和成功的code 匹配
        if ([code isEqualToString:@"0"]) {
            NSLog(@"修改地址：获取成功！");
            NSLog(@"修改地址：%@",responseObject);
            
            
            // 修改地址
            // 此界面显示
            self.locationLab.text = area;
            
            // 返回上一个界面
//            [self.navigationController popViewControllerAnimated:YES];
            
        }
        else{
            NSLog(@"修改地址：获取失败:responseObject:%@",responseObject);
            NSLog(@"修改地址：获取失败:responseObject:res:msg:%@",responseObject[@"res"][@"msg"]);
            // 1.2.1.1.2.2、获取失败：弹窗提示：获取失败的返回信息
            //            [self showHubWithLabelText:responseObject[@"res"][@"msg"] andHidAfterDelay:3.0];
            
        }
        
        
    } whenFailure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"修改地址：请求失败！:error:%@",error);
        
        [self showHubWithLabelText:@"请检查网络，重新加载" andHidAfterDelay:3.0];
        
    } withToken:self.onlyUser.userToken];
    
}


// 使用当前位置：点击事件
- (IBAction)useCurrentLocationBtnClick:(id)sender {
    NSLog(@"使用当前位置：点击事件");
    
    // 网络请求：获取当前位置
    
    self.ifOpenNearbyPeopleVC = NO;
    
    // 定位：获取位置信息，地理位置编码、反编码
    [self getLocationManager];
}


// 定位：位置变更后的回调
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    
    // 获取其中的一个位置
    CLLocation *location = locations.firstObject;
    
    NSLog(@"定位：当前的位置：%@",location);
    
    
    // 关闭定位
    [self.locationManager stopUpdatingLocation];
    
    // 地理位置反编码
    [self locationWithLatitude:location.coordinate.latitude andLongitude:location.coordinate.longitude];
}

// 经纬度 -> 地理位置（地理位置反编码）
- (void)locationWithLatitude:(CLLocationDegrees)latitude andLongitude:(CLLocationDegrees)longitude{
    
    // 根据经纬度，实例化一个位置信息
    CLLocation *location = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    
    // 生成地理位置编码类（编码、反编码 都需要这个类）
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    // 反编码
    //     把一个位置信息：location， 转成地理位置
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        NSLog(@"反编码：把一个位置信息：location， 转成地理位置");
        
        
        // 取出地标信息 （是一个数组，取出其中一个）
        CLPlacemark *placeMark = placemarks.firstObject;
        
        // 取出详细的位置信息
        NSDictionary *infoDic = placeMark.addressDictionary;
        NSLog(@"infoDic:%@",infoDic);
        
        for (NSString *tmpKey in infoDic) {
            
            NSLog(@"key:%@，obj：%@",tmpKey,infoDic[tmpKey]);
        }
        
        // 当前地址
        NSString *newLocationStr = [NSString stringWithFormat:@"%@-%@-%@",infoDic[@"State"],infoDic[@"City"],infoDic[@"SubLocality"]];
        // 网络请求：修改地址
        [self requestChangeLocationWithArea:newLocationStr];
    }];
}


- (NSArray *)provinceArr
{
    if (_provinceArr == nil) {
        _provinceArr = [[NSArray alloc] init];
    }
    return _provinceArr;
}
-(NSArray *)countryArr
{
    if(_countryArr == nil)
    {
        _countryArr = [[NSArray alloc] init];
    }
    return _countryArr;
}

- (NSArray *)districtArr
{
    if (_districtArr == nil) {
        _districtArr = [[NSArray alloc] init];
    }
    return _districtArr;
}

-(NSArray *)addressArr
{
    if (_addressArr == nil) {
        _addressArr = [[NSArray alloc] init];
    }
    return _addressArr;
}


@end
