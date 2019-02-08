//
//  UIColor+NTExtension.h
//  GameGrade
//
//  Created by Neo on 2018/1/3.
//  Copyright © 2018年 Neo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (NTExtension)

// UIColor转成hex 16
+ (NSString *)hexStringFromColor:(UIColor *)color;

// 透明度固定为1，以0x开头的十六进制转换成的颜色
+ (UIColor *)colorWithHex:(long)hexColor;

// 0x开头的十六进制转换成的颜色,透明度可调整
+ (UIColor *)colorWithHex:(long)hexColor alpha:(float)opacity;

// 颜色转换三：iOS中十六进制的颜色（以#开头）转换为UIColor
+ (UIColor *)colorWithHexString: (NSString *)color;

// 颜色转换为RGB数组
+ (NSMutableArray<NSNumber *> *) changeUIColorToRGB:(UIColor *)color;

@end
