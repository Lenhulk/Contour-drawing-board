//
//  PanBoldSlider.m
//  FunnyColorBoard
//
//  Created by 大雄 on 2018/6/3.
//  Copyright © 2018年 Niti. All rights reserved.
//

#import "PanBoldSlider.h"

@interface PanBoldSlider()
@property (weak, nonatomic) IBOutlet UILabel *boldLb;
@property (nonatomic, strong) UISlider *sizeSlider;
@property (nonatomic, strong) CAShapeLayer *sliderBackLayer;
@property (nonatomic, assign) CGFloat lineBold;
@end

@implementation PanBoldSlider

- (UISlider *)sizeSlider
{
    if (!_sizeSlider) {
        _sizeSlider = [[UISlider alloc] init];
        _sizeSlider.thumbTintColor = [UIColor redColor];
        _sizeSlider.minimumTrackTintColor = [UIColor clearColor];
        _sizeSlider.maximumTrackTintColor = [UIColor clearColor];
        _sizeSlider.minimumValue = 1;
        _sizeSlider.maximumValue = 30;
        _sizeSlider.value = 5;
        _sizeSlider.continuous = NO;
        [_sizeSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventTouchDragInside];
        
    }

    return _sizeSlider;
}

- (CAShapeLayer *)sliderBackLayer
{
    if (!_sliderBackLayer) {
        _sliderBackLayer = [CAShapeLayer layer];
//        _sliderBackLayer.frame = CGRectMake(0, 0, 6, 240);
        _sliderBackLayer.frame = CGRectMake(kSCREEN_W/6.0*2-6, kSCREEN_H-kAPPTOPS_H-260-30, 12, 260);
        
        UIBezierPath *path = [[UIBezierPath alloc] init];
        [path moveToPoint:CGPointMake(0, 0)];
        [path addLineToPoint:CGPointMake(12, 0)];
        [path addLineToPoint:CGPointMake(6, 240)];
        [path addLineToPoint:CGPointMake(0, 0)];
        _sliderBackLayer.fillColor = [UIColor colorWithWhite:1.0 alpha:0.5].CGColor;
        _sliderBackLayer.lineJoin = kCALineJoinRound;
        _sliderBackLayer.lineCap = kCALineCapRound;
        _sliderBackLayer.path = path.CGPath;
        
        
    }
    return _sliderBackLayer;
}

- (void)sliderValueChanged:(id)sender
{
    UISlider *slider = (UISlider *)sender;
    CGFloat lineBold = slider.value;
    self.lineBold = lineBold;
    self.boldLb.text = [NSString stringWithFormat:@"%.1f", lineBold];
}

- (IBAction)tapOkBtn:(id)sender {
    if (self.lineBoldBlock) {
        self.lineBoldBlock(self.lineBold);
    }
    
    [UIView transitionWithView:self duration:0.5 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        
    }];
}


- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self addSubview:self.sizeSlider];
    [self.sizeSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(28);
        make.width.mas_equalTo(260);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-50-kAPPTOPS_H-50);
        make.leading.mas_equalTo(kSCREEN_W/6.0*2);
//        make.centerX.equalTo(self.mas_centerX).offset(-60);
    }];
    CGAffineTransform rotation = CGAffineTransformMakeRotation(M_PI * 1.5);
    CGAffineTransform move = CGAffineTransformMakeTranslation(-130, 0);
    CGAffineTransform transforms = CGAffineTransformConcat(rotation, move);
    self.sizeSlider.transform = transforms;
//    self.sizeSlider.transform = CGAffineTransformMakeRotation(M_PI * 1.5);
    
    
    [self.layer addSublayer:self.sliderBackLayer];
}

- (void)awakeFromNib{
    [super awakeFromNib];
    
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
