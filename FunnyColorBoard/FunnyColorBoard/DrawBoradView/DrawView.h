//
//  DrawView.h
//  12-画板
//
//  Created by xmg1 on 16/9/12.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DrawView : UIView


//清屏
- (void)clear;
//撤销
- (void)undo;
//橡皮擦
- (void)erase;
//选择颜色
- (void)setLineColor:(UIColor *)color;
//设置线宽度
- (void)setLineWidth:(CGFloat)lineWidth;
//设置笔末
- (void)switchLine2Sharp;
- (void)switchLine2Circular;

//要绘制图片
@property (nonatomic, strong) UIImage *image;


@end
