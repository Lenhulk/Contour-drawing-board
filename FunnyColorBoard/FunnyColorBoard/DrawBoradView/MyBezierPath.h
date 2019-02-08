//
//  MyBezierPath.h
//  12-画板
//
//  Created by xmg1 on 16/9/12.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyBezierPath : UIBezierPath

/**
 *  保存当前路径的颜色
 */
@property (nonatomic, strong) UIColor *lineColor;

@end
