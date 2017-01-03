//
//  UIImage+CYImage.h
//  NZNYiOS
//
//  Created by 男左女右 on 16/8/17.
//  Copyright © 2016年 NZNY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (CYImage)

// instancetype 默认会识别当前是哪个类或者对象调用，就会转换成对应类的对象。

// 加载最原始的图片，没有渲染
+ (instancetype)imageWithOriginalName:(NSString *)imageName;

@end
