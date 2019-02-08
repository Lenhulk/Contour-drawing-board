//
//  DrawView.m
//  12-画板
//
//  Created by xmg1 on 16/9/12.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "DrawView.h"
#import "MyBezierPath.h"

@interface DrawView ()

/**
 *  当前绘制的路径
 */
@property (nonatomic, strong) UIBezierPath *path;

/**
 *  记录绘制的所有路径
 */
@property (nonatomic, strong) NSMutableArray *pathArray;

/**
 *  当前绘制线的宽度
 */
@property (nonatomic, assign) CGFloat width;
//当前绘制的颜色
@property (nonatomic, strong) UIColor *color;
// 橡皮颜色
@property (nonatomic, strong) UIColor *eraColor;
@property (assign, nonatomic) CGLineJoin pathLineJoin;
@property (assign, nonatomic) CGLineCap pathLineCap;



@end

@implementation DrawView


- (NSMutableArray *)pathArray {
    
    if (_pathArray == nil) {
        _pathArray = [NSMutableArray array];
    }
    return _pathArray;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    //添加手势
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self addGestureRecognizer:pan];
    
    
    //设置默认
    self.width = 5;
    self.color = [UIColor whiteColor]; // 画笔
    self.eraColor = [UIColor whiteColor];
    self.pathLineCap = kCGLineCapRound;
    self.pathLineJoin = kCGLineJoinRound;
}

- (void)pan:(UIPanGestureRecognizer *)pan {
    
    //获取当前手指的点
    CGPoint curP = [pan locationInView:self];
    //画线
    if (pan.state == UIGestureRecognizerStateBegan) {
        //创建路径
        MyBezierPath *path = [MyBezierPath bezierPath];
        [path moveToPoint:curP];
        
        //设置状态
        path.lineWidth = self.width;
        path.lineJoinStyle = self.pathLineJoin;
        path.lineCapStyle = self.pathLineCap;
        path.lineColor = self.color;
        
        //保存路径
        self.path = path;
        [self.pathArray addObject:self.path];
        
    }else if (pan.state == UIGestureRecognizerStateChanged) {
        
        //添加线到手指所在的点
        [self.path addLineToPoint:curP];
        //重绘
        [self setNeedsDisplay];
    }
    
}

- (void)drawRect:(CGRect)rect {
    
    //绘制所有的路径
    for (MyBezierPath *path in self.pathArray) {
        //判断,如果是图片,采用图片的画法
        if ([path isKindOfClass:[UIImage class]]) {
            //采用 绘制图片的画法
            UIImage *image = (UIImage *)path;
            [image drawInRect:rect];
        
        }else {
            //不是 就是路径
            [path.lineColor set];
            [path stroke];
        }
        
    }
}

//清屏
- (void)clear {
    
    //清空数组
    [self.pathArray removeAllObjects];
    //重绘
    [self setNeedsDisplay];
    
}

//撤销
- (void)undo {
    // 不清除最后一条（图片）
    if (self.pathArray.count == 1) {
        return ;
    }
    //删除数组当中最后一个元素
    [self.pathArray removeLastObject];
    //重绘
    [self setNeedsDisplay];
}

//设置线宽度
- (void)setLineWidth:(CGFloat)lineWidth {
    self.width = lineWidth;
}

//橡皮擦
- (void)erase {
    [self setLineColor:self.eraColor];
}

//选择颜色
- (void)setLineColor:(UIColor *)color {
    self.color = color;
}

- (void)switchLine2Sharp{
    self.pathLineJoin = kCGLineJoinBevel;
    self.pathLineCap = kCGLineCapButt;
}

- (void)switchLine2Circular{
    self.pathLineJoin = kCGLineJoinRound;
    self.pathLineCap = kCGLineCapRound;
}

- (void)setImage:(UIImage *)image {
    _image = image;
    [self.pathArray addObject:image];
    
    // 获取橡皮擦颜色 为背景主色
//    self.eraColor = [self mostColor:image];
    if (self.pathArray.count == 1) {
        self.eraColor = [UIColor colorWithRed:0.882353 green:0.882353 blue:0.882353 alpha:1.0];
    }
    //0.882353 0.882353 0.882353 1
    
    //重绘
    [self setNeedsDisplay];
}


/*
#pragma mark - 获取图片主色调

-(UIColor*)mostColor:(UIImage*)image{
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
    int bitmapInfo = kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedLast;
#else
    int bitmapInfo = kCGImageAlphaPremultipliedLast;
#endif
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL,
                                                 image.size.width,
                                                 image.size.height,
                                                 8, //bits per component
                                                 image.size.width*4,
                                                 colorSpace,
                                                 bitmapInfo);

    CGRect drawRect = CGRectMake(0, 0, image.size.width, image.size.height);
    CGContextDrawImage(context, drawRect, image.CGImage);
    CGColorSpaceRelease(colorSpace);
    
    //第二步 取每个点的像素值
    unsigned char* data = CGBitmapContextGetData (context);
    
    if (data == NULL) return nil;
    NSArray *MaxColor=nil;
    // NSCountedSet *cls=[NSCountedSet setWithCapacity:thumbSize.width*thumbSize.height];
    float maxScore=0;
    for (int x=0; x<image.size.width*image.size.height; x++) {
        
        int offset = 4*x;
        int red = data[offset];
        int green = data[offset+1];
        int blue = data[offset+2];
        int alpha =  data[offset+3];
        
        if (alpha<25)continue;
        
        float h,s,v;
        
        RGBtoHSV(red, green, blue, &h, &s, &v);
        
        float y = MIN(abs(red*2104+green*4130+blue*802+4096+131072)>>13, 235);
        y= (y-16)/(235-16);
        if (y>0.9) continue;
        
        float score = (s+0.1)*x;
        if (score>maxScore) {
            maxScore = score;
        }
        MaxColor=@[@(red),@(green),@(blue),@(alpha)];
        
    }
    
    CGContextRelease(context);
    return [UIColor colorWithRed:([MaxColor[0] intValue]/255.0f) green:([MaxColor[1] intValue]/255.0f) blue:([MaxColor[2] intValue]/255.0f) alpha:([MaxColor[3] intValue]/255.0f)];
}


static void RGBtoHSV( float r, float g, float b, float *h, float *s, float *v )
{
    float min, max, delta;
    min = MIN( r, MIN( g, b ));
    max = MAX( r, MAX( g, b ));
    *v = max;               // v
    delta = max - min;
    if( max != 0 )
        *s = delta / max;       // s
    else {
        // r = g = b = 0        // s = 0, v is undefined
        *s = 0;
        *h = -1;
        return;
    }
    if( r == max )
        *h = ( g - b ) / delta;     // between yellow & magenta
    else if( g == max )
        *h = 2 + ( b - r ) / delta; // between cyan & yellow
    else
        *h = 4 + ( r - g ) / delta; // between magenta & cyan
    *h *= 60;               // degrees
    if( *h < 0 )
        *h += 360;
}
*/


@end
