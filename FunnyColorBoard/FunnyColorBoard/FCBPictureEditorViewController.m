//
//  FCBPictureEditorViewController.m
//  FunnyColorBoard
//
//  Created by Lenhulk on 2018/5/27.
//  Copyright © 2018年 Niti. All rights reserved.
//

#import "FCBPictureEditorViewController.h"
#import "UIViewController+Alert.h"
#import "DrawView.h"
#import "HandlView.h"
#import <ProgressHUD.h>
#import <IFMMenu/IFMMenu.h>
#import "FCBColorPickerView.h"
#import "PanBoldSlider.h"
#import <AudioToolbox/AudioToolbox.h>
#import "LTNavigationControllerShouldPopProtocol.h"

NS_ENUM(NSInteger, DropdownComponent) {
    DropdownComponentTool = 0,    // 笔/橡皮
    DropdownComponentColor,       // 颜色
    DropdownComponentLineWidth,   // 线宽
    DropdownComponentShape,       // 笔末
    DropdownComponentAlbum,       // 相册
    DropdownComponentRepeal,      // 撤销
    DropdownComponentCount
};

static SystemSoundID soundEffectID = 0;
@interface FCBPictureEditorViewController () <UIImagePickerControllerDelegate, LTNavigationControllerShouldPopProtocol>
{
    BOOL _isBeginEdit;
    BOOL _isPan;
    UIColor *_selColor;
}
@property (nonatomic, weak) UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIView *dropdownMenu;
@property (weak, nonatomic) IBOutlet UIStackView *drawToolBtnsStack;
@property (weak, nonatomic) IBOutlet DrawView *drawView;
@property (weak, nonatomic) UIButton *startBtn;
@property (nonatomic, weak) HandlView *handleView;
@property (nonatomic, weak) FCBColorPickerView *colorPicker;
@property (nonatomic, weak) PanBoldSlider *boldSlider;

@property (strong, nonatomic) NSArray<NSString *> *componentTitles;
@property (strong, nonatomic) NSArray<NSString *> *shapeTitles;
@end

@implementation FCBPictureEditorViewController


#pragma mark - LAZYLOAD
- (FCBColorPickerView *)colorPicker{
    if (!_colorPicker) {
        FCBColorPickerView *picker = [FCBColorPickerView viewFromXib];
        picker.frame = CGRectMake(0, 0, kSCREEN_W, kSCREEN_H-kAPPTOPS_H);
        picker.pickupBlock = ^(UIColor *color) {
            [self.drawView setLineColor:color];
        } ;
        picker.alpha = 0;
        [self.view addSubview:picker];
        _colorPicker = picker;
    }
    return _colorPicker;
}

- (PanBoldSlider *)boldSlider{
    if (!_boldSlider) {
        PanBoldSlider *slider = [PanBoldSlider viewFromXib];
        slider.frame = CGRectMake(0, 0, kSCREEN_W, kSCREEN_H-kAPPTOPS_H);
        slider.lineBoldBlock = ^(CGFloat lineB) {
            [self.drawView setLineWidth:lineB];
        } ;
        slider.alpha = 0;
        [self.view addSubview:slider];
        _boldSlider = slider;
    }
    return _boldSlider;
}

#pragma mark - VIEW LIFE
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.title = NSLocalizedString(@"Edit", nil);
    _isPan = YES;
    _selColor = [UIColor redColor];
    
    // 先给用户拉伸图片
//    [self setupSizingImageView];
    [self setupSizingImg:self.selImg];
    // 设置图片
//    self.drawView.image = self.selImg;
    // 设置保存按钮
    [self setupSaveBtn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - SETUP
- (void)setupSaveBtn {
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Save", nil) style:UIBarButtonItemStyleDone target:self action:@selector(savePicture)];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)setupStartBtn{
    UIButton *sBtn = [UIButton buttonWithType:UIButtonTypeSystem];
//    NSAttributedString *start = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"StartEdit", nil)                                                 attributes:@{NSForegroundColorAttributeName:[UIColor redColor], NSFontAttributeName:[UIFont fontWithName:@"Avenir-Medium" size:28]}];
//    [sBtn setAttributedTitle:start forState:UIControlStateNormal];
    [sBtn setImage:[UIImage imageNamed:@"appiicon_bianji"] forState:UIControlStateNormal];
    [sBtn addTarget:self action:@selector(tapStartBtn:) forControlEvents:UIControlEventTouchDown];
    self.startBtn = sBtn;
    [self.view addSubview:sBtn];
    [sBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.height.mas_equalTo(170);
        make.bottom.equalTo(self.view).offset(-70);
    }];
}


#pragma mark - TOOL VIEW & LOGIC
- (IBAction)tapDropdownTool:(UIButton *)sender {
    __weak typeof(self) wSelf = self;
    UIImage *panImg = [UIImage imageNamed:@"appiicon_bijian"];
    UIImage *eraImg = [UIImage imageNamed:@"appiicon_xiangpi"];
    IFMMenuItem *item1 = [IFMMenuItem itemWithImage:panImg title:NSLocalizedString(@"Brush", nil) action:^(IFMMenuItem * _Nonnull item) {
        __strong typeof(self)sSelf = wSelf;
        [sSelf.drawView setLineColor:sSelf->_selColor];
        sSelf->_isPan = YES;
        [sender setImage:panImg forState:UIControlStateNormal];
    }];
    IFMMenuItem *item2 = [IFMMenuItem itemWithImage:eraImg title:NSLocalizedString(@"Eraser", nil) action:^(IFMMenuItem * _Nonnull item) {
        __strong typeof(self)sSelf = wSelf;
        [sSelf.drawView erase];
        sSelf->_isPan = NO;
        [sender setImage:eraImg forState:UIControlStateNormal];
    }];
    NSArray *menuItems = @[item1, item2];
    IFMMenu *menu = [[IFMMenu alloc] initWithItems:menuItems];
    // 转换坐标系
    CGRect viewRect = [self.view convertRect:sender.frame fromView:self.dropdownMenu];
    [menu showFromRect:viewRect inView:self.view];
}

- (IBAction)tapDropdownSharp:(UIButton *)sender {
    __weak typeof(self) wSelf = self;
    UIImage *cirImg = [UIImage imageNamed:@"appiicon_yuanjiao"];
    UIImage *shpImg = [UIImage imageNamed:@"appiicon_jianjiao"];
    IFMMenuItem *item1 = [IFMMenuItem itemWithImage:cirImg title:NSLocalizedString(@"Round", nil) action:^(IFMMenuItem * _Nonnull item) {
        __strong typeof(self)sSelf = wSelf;
        [sSelf.drawView switchLine2Circular];
        sSelf->_isPan = YES;
        [sender setImage:cirImg forState:UIControlStateNormal];
    }];
    IFMMenuItem *item2 = [IFMMenuItem itemWithImage:shpImg title:NSLocalizedString(@"Sharp", nil) action:^(IFMMenuItem * _Nonnull item) {
        __strong typeof(self)sSelf = wSelf;
        [sSelf.drawView switchLine2Sharp];
        sSelf->_isPan = NO;
        [sender setImage:shpImg forState:UIControlStateNormal];
    }];
    NSArray *menuItems = @[item1, item2];
    IFMMenu *menu = [[IFMMenu alloc] initWithItems:menuItems];
    
    CGRect viewRect = [self.view convertRect:sender.frame fromView:self.dropdownMenu];
    [menu showFromRect:viewRect inView:self.view];
}

//TODO: 添加动画
- (IBAction)tapDropdownLineBold:(id)sender {
    
    [UIView transitionWithView:self.boldSlider duration:0.5 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.boldSlider.alpha = 1.0;
    } completion:^(BOOL finished) {
        
    }];
}

- (IBAction)tapDropdownColor:(id)sender {
    
    [UIView transitionWithView:self.boldSlider duration:0.5 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.colorPicker.alpha = 1.0;
    } completion:^(BOOL finished) {

    }];

}

- (IBAction)tapDropdownRepeal:(id)sender {
    [self.drawView undo];
}

- (IBAction)tapAddNewImg:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    picker.delegate = self;
    picker.allowsEditing = YES;
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - IMAGE ACTION
//把绘制的内容给保存到系统相册当中
- (void)savePicture{
    [self showAlertVCWithTitle:NSLocalizedString(@"SavePicture", nil) message:NSLocalizedString(@"It will be saved to your photo album.", nil) agreeText:NSLocalizedString(@"Yes", nil) agreeHandle:^{
        
        //对画板生成一张图片
        UIGraphicsBeginImageContextWithOptions(self.drawView.bounds.size, NO, [UIScreen mainScreen].scale);
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        [self.drawView.layer renderInContext:ctx];
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        //注意, 完成时调用的方法必须得是didFinishSavingWithError:contextInfo:
        UIImageWriteToSavedPhotosAlbum(newImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        [ProgressHUD show];
        
    } agreeAcStyle:UIAlertActionStyleDefault cancelText:NSLocalizedString(@"Notnow", nil) cancelHandle:^{
        
    }];
    
}
//当保存照片完成时调用
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error == nil) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        [ProgressHUD showSuccess:NSLocalizedString(@"SaveSuccess", nil)];
    } else {
        [ProgressHUD dismiss];
        [self showAlertVCWithTitle:@"Save Failure" message:[NSString stringWithFormat:@"%@", error.localizedDescription]];
    }
}

#pragma mark - UIImagePickerControllerDelegate
//完成选择图片
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    //选择框消失
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    [self setupSizingImg:image];
}
//取消选择图片
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark - READY 2 START
// 点击了开始
- (void)tapStartBtn:(UIButton *)sender {
    NSString *soundName = [[NSBundle mainBundle] pathForResource:@"polaroid.wav" ofType:nil];
    NSURL *url = [NSURL fileURLWithPath:soundName];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef _Nonnull)(url), &soundEffectID);
    AudioServicesPlaySystemSound(soundEffectID);
    
    // 将拉伸后的图片根据区域绘制到画板中
    [UIView animateWithDuration:0.25 animations:^{
        //设置为透明
        self.handleView.alpha = 0;
    }completion:^(BOOL finished){
        [UIView animateWithDuration:0.25 animations:^{
            self.handleView.alpha = 1;
            
        }completion:^(BOOL finished) {
            //对当前View.HandleImageUIView截屏
            
            //1.开启位图上下文 加了scale
            UIGraphicsBeginImageContextWithOptions(self.drawView.bounds.size, NO, [UIScreen mainScreen].scale);
            //2.获取位图上下文
            CGContextRef ctx =  UIGraphicsGetCurrentContext();
            //3.把当前View的内容渲染到上下文
            [self.handleView.layer renderInContext:ctx];
            //4.从上下文当中获取图片
            UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
            //5.关闭上下文
            UIGraphicsEndImageContext();
            self.drawView.image = newImage;
            [self.handleView removeFromSuperview];
 
        }];
    }];
    self.startBtn.hidden = YES;
    for (UIButton *toolB in self.drawToolBtnsStack.subviews) {
        toolB.enabled = YES;
    }
}

// 添加图片用于布局
- (void)setupSizingImg:(UIImage *)img{
    for (UIButton *toolB in self.drawToolBtnsStack.subviews) {
        toolB.enabled = NO;
    }
    
    HandlView *hanleV = [[HandlView alloc] init];
    hanleV.backgroundColor = [UIColor clearColor];
    hanleV.frame = self.drawView.frame;
    hanleV.image = img;
    self.handleView = hanleV;
    [self.view addSubview:hanleV];
    [self.view bringSubviewToFront:self.dropdownMenu];
    
    // 添加开始按钮
    [self setupStartBtn];
}

// 返回阻止
- (BOOL)lt_navigationControllerShouldPopWhenSystemBackBtnClick:(LTNavigationController *)navC{
    
    [self showAlertVCWithTitle:NSLocalizedString(@"AbandonEditing", nil) message:NSLocalizedString(@"Your edited picture will not be save.", nil) agreeText:NSLocalizedString(@"Yes", nil) agreeHandle:^{
        [self.navigationController popViewControllerAnimated:YES];
    } agreeAcStyle:UIAlertActionStyleDestructive cancelText:NSLocalizedString(@"No", nil) cancelHandle:^{
        
    }];
    
    return NO;
}



@end
