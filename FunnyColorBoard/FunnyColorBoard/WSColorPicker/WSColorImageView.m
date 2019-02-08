//
//  WSColorImageView.m
//  1111
//
//  Created by iMac on 16/12/12.
//  Copyright © 2016年 zws. All rights reserved.
//

#import "WSColorImageView.h"

@interface WSColorImageView ()
@property (nonatomic, weak) UIImageView *circleDot;

@end

@implementation WSColorImageView

- (UIImageView *)circleDot{
    if (!_circleDot) {
        UIImageView *dot = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"followCircle"]];
        [self addSubview:dot];
        _circleDot = dot;
    }
    return _circleDot;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.width)];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.image = [UIImage imageNamed:@"paletteColor"];
        self.userInteractionEnabled = YES;
        self.layer.cornerRadius = frame.size.width/2;
        self.layer.masksToBounds = YES;
//        self.clipsToBounds = YES;
        
        // 默认值
        self.circleDot.center = self.center;
        self.selColor = [UIColor whiteColor];
        
    }
    return self;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    CGPoint pointL = [touch locationInView:self];
    
    if ([self pointInPalette:pointL]) {
        UIColor *color = [self colorAtPixel:pointL];
        self.selColor = color;
        self.circleDot.center = pointL;
        
        if (self.currentColorBlock) {
            self.currentColorBlock(self.selColor);
        }
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    CGPoint pointL = [touch locationInView:self];

    
    if ([self pointInPalette:pointL]) {
        UIColor *color = [self colorAtPixel:pointL];
        self.selColor = color;
        self.circleDot.center = pointL;
        
        if (self.currentColorBlock) {
            self.currentColorBlock(self.selColor);
        }
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint pointL = [touch locationInView:self];
    
    if ([self pointInPalette:pointL]) {
        UIColor *color = [self colorAtPixel:pointL];
        self.selColor = color;
        self.circleDot.center = pointL;
        
        if (self.currentColorBlock) {
            self.currentColorBlock(self.selColor);
        }
    }
}

// 判断是否在圆内
- (BOOL)pointInPalette:(CGPoint)point{
    if (pow(point.x - self.bounds.size.width/2, 2)+pow(point.y-self.bounds.size.width/2, 2) <= pow(self.bounds.size.width/2, 2)) {
        return YES;
    } else {
        return NO;
    }
}

- (UIColor *)colorAtPixel:(CGPoint)point {
    if (!CGRectContainsPoint(CGRectMake(0.0f, 0.0f, self.image.size.width, self.image.size.height), point)) {
        return nil;
    }
    
    NSInteger pointX = trunc(point.x);
    NSInteger pointY = trunc(point.y);
    CGImageRef cgImage = self.image.CGImage;
    NSUInteger width = self.image.size.width;
    NSUInteger height = self.image.size.height;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    int bytesPerPixel = 4;
    int bytesPerRow = bytesPerPixel * 1;
    NSUInteger bitsPerComponent = 8;
    unsigned char pixelData[4] = { 0, 0, 0, 0 };
    CGContextRef context = CGBitmapContextCreate(pixelData,
                                                 1,
                                                 1,
                                                 bitsPerComponent,
                                                 bytesPerRow,
                                                 colorSpace,
                                                 kCGImageAlphaPremultipliedLast |     kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    CGContextSetBlendMode(context, kCGBlendModeCopy);
    
    CGContextTranslateCTM(context, -pointX, pointY-(CGFloat)height);
    CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, (CGFloat)width, (CGFloat)height), cgImage);
    CGContextRelease(context);
    
    CGFloat red   = (CGFloat)pixelData[0] / 255.0f;
    CGFloat green = (CGFloat)pixelData[1] / 255.0f;
    CGFloat blue  = (CGFloat)pixelData[2] / 255.0f;
    CGFloat alpha = (CGFloat)pixelData[3] / 255.0f;
    
//    NSLog(@"%f***%f***%f***%f",red,green,blue,alpha);
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

- (void)setImage:(UIImage *)image {
    UIImage *temp = [self imageForResizeWithImage:image resize:CGSizeMake(self.frame.size.width, self.frame.size.width)];
    [super setImage:temp];
    
}

- (UIImage *)imageForResizeWithImage:(UIImage *)picture resize:(CGSize)resize {
    CGSize imageSize = resize; //CGSizeMake(25, 25)
    UIGraphicsBeginImageContextWithOptions(imageSize, NO,0.0);
    CGRect imageRect = CGRectMake(0.0, 0.0, imageSize.width, imageSize.height);
    [picture drawInRect:imageRect];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    return image;
}


@end
