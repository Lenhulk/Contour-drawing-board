//
//  ViewController.m
//  FunnyColorBoard
//
//  Created by Lenhulk on 2018/5/24.
//  Copyright © 2018年 Niti. All rights reserved.
//

#import "ViewController.h"
#import "FCBPictureEditorViewController.h"
#import "FCBCameraViewController.h"
#import "UIImage+Extension.h" 

@interface ViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate>
{
    BOOL _isEntering;
}
@property (weak, nonatomic) UIButton *cameraBtn;

@end

@implementation ViewController

- (UIButton *)cameraBtn{
    if (!_cameraBtn) {
        UIButton *camBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *img = [UIImage imageNamed:@"appiicon_xiang"];
        camBtn.frame = CGRectMake(0, 0, img.size.width, img.size.height);
        [camBtn setImage:img forState:UIControlStateNormal];
        [self.view addSubview:camBtn];
        camBtn.center = self.view.center;
        
        // 添加手势
        UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc]
                                              initWithTarget:self action:@selector(handleSwipe:)];
        recognizer.delegate = self;
        [camBtn addGestureRecognizer:recognizer];
        
        _cameraBtn = camBtn;
    }
    return _cameraBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO; // 取消左滑返回
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        self.cameraBtn.center = self.view.center;
    } completion:^(BOOL finished) {
        self->_isEntering = NO;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)handleSwipe:(UIPanGestureRecognizer *)swipe{
    if (swipe.state == UIGestureRecognizerStateChanged) {
        CGPoint offset = [swipe translationInView:self.view];
        NSLog(@"%@", NSStringFromCGPoint(offset));
        self.cameraBtn.nt_centerY = self.cameraBtn.nt_centerY + offset.y;
        [swipe setTranslation:CGPointZero inView:self.view];
        
        CGFloat btnCentY = self.cameraBtn.nt_centerY;
        
        if (_isEntering) {
            return;
        }
        if (btnCentY < self.view.nt_centerY-200) {
            _isEntering = YES;
            CATransition *tran = [CATransition animation];
            tran.type = @"cameraIrisHollowOpen";
            tran.duration = 0.4;
            [self.navigationController.view.layer addAnimation:tran forKey:nil];
            
            FCBCameraViewController *camVc = [[FCBCameraViewController alloc] init];
            [self.navigationController pushViewController:camVc animated:NO];
            
        }else if(btnCentY > self.view.nt_centerY+200){
            _isEntering = YES;
            UIImagePickerController *picker = [[UIImagePickerController alloc]init];
            //设置图片源(相簿)
            picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            //设置代理
            picker.delegate = self;
            //设置可以编辑
            picker.allowsEditing = YES;
            //打开界面
            [self presentViewController:picker animated:YES completion:nil];
        }
        
    } else if (swipe.state == UIGestureRecognizerStateEnded) {
        
        [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            self.cameraBtn.center = self.view.center;
        } completion:^(BOOL finished) {
            
        }];
    }
}


 

#pragma mark - UIImagePickerControllerDelegate

//完成选择图片
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    //选择框消失
    [picker dismissViewControllerAnimated:YES completion:nil];
    image = [image fixOrientation];
    
    CATransition *tran = [CATransition animation];
    tran.type = @"cameraIrisHollowOpen";
    tran.duration = 0.4;
    [self.navigationController.view.layer addAnimation:tran forKey:nil];
    
    FCBPictureEditorViewController *vc = [[FCBPictureEditorViewController alloc] init];
    cv::Mat imgMat;
    UIImageToMat(image, imgMat);
    cv::Mat edgeMat = [OpenCVManager coverToEdge:imgMat];
    vc.selImg = MatToUIImage(edgeMat);
    [self.navigationController pushViewController:vc animated:YES];
}

//取消选择图片
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [picker dismissViewControllerAnimated:YES completion:nil];

    self.cameraBtn.center = self.view.center;
    
    self->_isEntering = NO;
    
}

@end
