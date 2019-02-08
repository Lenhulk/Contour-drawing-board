//
//  FCBColorPickerView.m
//  FunnyColorBoard
//
//  Created by Lenhulk on 2018/6/2.
//  Copyright © 2018年 Niti. All rights reserved.
//

#import "FCBColorPickerView.h"
#import "WSColorImageView.h"

@interface FCBColorPickerView()
@property (weak, nonatomic) IBOutlet UIView *showingSquare;
@property (weak, nonatomic) IBOutlet UIView *colorPad;
@property (nonatomic, weak) WSColorImageView *colorPicker;
@property (nonatomic, strong) UIColor *selColor;
@end

@implementation FCBColorPickerView


- (void)layoutSubviews{
    [super layoutSubviews];
    
    if (!self.colorPicker) {
        WSColorImageView *ws = [[WSColorImageView alloc]initWithFrame:self.colorPad.bounds];
        ws.currentColorBlock = ^(UIColor *color){
//            self.selColor = color;
            self.showingSquare.backgroundColor = color;
        };
        [self.colorPad addSubview:ws];
        self.colorPicker = ws;
    }
}

- (IBAction)didTapPickBtn:(id)sender {
    if (self.pickupBlock) {
        self.pickupBlock(self.colorPicker.selColor);
    }
    
    [UIView transitionWithView:self duration:0.5 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        
    }];
}




@end
