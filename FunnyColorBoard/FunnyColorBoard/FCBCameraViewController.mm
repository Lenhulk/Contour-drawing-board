//
//  FCBCameraViewController.m
//  FunnyColorBoard
//
//  Created by Lenhulk on 2018/5/27.
//  Copyright © 2018年 Niti. All rights reserved.
//

#import "FCBCameraViewController.h"
#import "FCBPictureEditorViewController.h"
#import "UIView+NTExtension.h"
#import <AudioToolbox/AudioToolbox.h>

static SystemSoundID soundEffectID = 0;
@interface FCBCameraViewController ()<AVCaptureVideoDataOutputSampleBufferDelegate>
//当前视频会话
@property (nonatomic, strong) AVCaptureSession *session;
//摄像头
@property (nonatomic, strong) AVCaptureDevice *device;
//摄像头前面输入
@property (nonatomic, strong) AVCaptureDeviceInput *frontCameraInput;
//摄像头前面输入
@property (nonatomic, strong) AVCaptureDeviceInput *backCameraInput;
//是否是前置摄像头,默认是no
@property (nonatomic, assign) BOOL isDevicePositionFront;
//创建ImageView
@property (nonatomic, strong) UIImageView *showingImgView;

@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;
@end

@implementation FCBCameraViewController


#pragma mark - SETUP
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad {
    [super viewDidLoad];

    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.title = NSLocalizedString(@"Take A Picture", nil);
    // 添加切换摄像头按钮
    [self createNavBtn];
    // 设置视频格式
    [self initVideoSet];
    // 创建渲染图像
    [self createLayer];
    // 添加“拍照”按钮
    [self setupTakePictureChangeQualityBtn];
}


- (void)setupTakePictureChangeQualityBtn{
    UIButton *tBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [tBtn setImage:[UIImage imageNamed:@"appiicon_camera"] forState:UIControlStateNormal];
    [tBtn addTarget:self action:@selector(getEdgeImageAndEdit) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:tBtn];
    [tBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-30);
    }];
    
    UIButton *qBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [qBtn setImage:[UIImage imageNamed:@"appiicon_HD"] forState:UIControlStateNormal];
    [qBtn addTarget:self action:@selector(changeQuality) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:qBtn];
    [qBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(tBtn.mas_left).offset(-50);
        make.centerY.equalTo(tBtn).offset(10);
    }];
}

- (void)changeQuality{
    if (self.session.sessionPreset == AVCaptureSessionPresetHigh) {
        self.session.sessionPreset = AVCaptureSessionPresetMedium;
    } else {
        self.session.sessionPreset = AVCaptureSessionPresetHigh;
    }
}

-(void)createNavBtn{
    UIButton *rBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    //    [rBtn setTitle:@"切换摄像头" forState:UIControlStateNormal];
    [rBtn setImage:[UIImage imageNamed:@"exchagecam"] forState:UIControlStateNormal];
    [rBtn sizeToFit];
    [rBtn addTarget:self action:@selector(navBtnToChangeCammer) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:rBtn];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)createLayer{
    UIImageView *imgV = [[UIImageView alloc] init];
    imgV.contentMode = UIViewContentModeScaleAspectFill;
    self.showingImgView = imgV;
    [self.view addSubview:self.showingImgView];
    [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.view);
    }];
}


#pragma mark - 跳转到图片编辑
- (void)getEdgeImageAndEdit{
    NSString *soundName = [[NSBundle mainBundle] pathForResource:@"shutter.wav" ofType:nil];
    NSURL *url = [NSURL fileURLWithPath:soundName];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef _Nonnull)(url), &soundEffectID);
    AudioServicesPlaySystemSound(soundEffectID);
    
    FCBPictureEditorViewController *editVc = [[FCBPictureEditorViewController alloc] initWithNibName:@"FCBPictureEditorViewController" bundle:nil];
    editVc.selImg = self.showingImgView.image;
    [self.navigationController pushViewController:editVc animated:YES];
}


#pragma mark - 视频初始化设置
-(void)initVideoSet{
    
    //创建一个Session会话，控制输入输出流
    AVCaptureSession *session = [[AVCaptureSession alloc]init];
    //设置视频质量
    session.sessionPreset = AVCaptureSessionPresetHigh;
    self.session = session;
    
    //选择输入设备,默认是后置摄像头
    AVCaptureDeviceInput *input = self.backCameraInput;
    //设置视频输出流
    AVCaptureVideoDataOutput *output = [[AVCaptureVideoDataOutput alloc]init];
    
    //设置输出格式
    NSDictionary *settings = [[NSDictionary alloc] initWithObjectsAndKeys:
                              [NSNumber numberWithUnsignedInt:kCVPixelFormatType_32BGRA],                                   kCVPixelBufferPixelFormatTypeKey,nil];
    output.videoSettings = settings;
    
    //设置输出的代理
    dispatch_queue_t videoQueue = dispatch_queue_create("VideoQueue", DISPATCH_QUEUE_SERIAL);
    [output setSampleBufferDelegate:self queue:videoQueue];
    
    //将输入输出添加到会话，连接
    if ([session canAddInput:input]) {
        [session addInput:input];
    }
    if ([session canAddOutput:output]) {
        [session addOutput:output];
    }
    
    
     //创建预览图层
//     AVCaptureVideoPreviewLayer *previewLayer = [[AVCaptureVideoPreviewLayer alloc]initWithSession:session];
//     //设置layer大小
//     CGFloat layerW = self.view.bounds.size.width - 40;
//     previewLayer.frame = CGRectMake(20, 70, layerW, layerW);
//     //视频大小根据frame大小自动调整
//     previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
//     [self.view.layer addSublayer:previewLayer];
//     self.previewLayer = previewLayer;

     //创建一个处理后的预览图层,用来标记
//     CAShapeLayer *targetLayer = [CAShapeLayer layer];
//     targetLayer.frame = previewLayer.frame;
//     [self.view.layer addSublayer:targetLayer];
//     targetLayer.backgroundColor = [UIColor clearColor].CGColor;
//     self.tagLayer = targetLayer;
    
    
    //启动session
    [session startRunning];
    

}

#pragma mark - 获取视频帧，处理视频
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection{
    [NSThread sleepForTimeInterval:0.5];
    //将视频帧转换为cvmat,默认已经转换为
    cv::Mat imgMat;
    imgMat = [OpenCVManager bufferToMat:sampleBuffer];
    if (imgMat.empty()) {
        return;
    }
    // ***** 转轮廓图 *****
    cv::Mat edgeMat = [OpenCVManager coverToEdge:imgMat];
    
    //TODO: 可以添加文字
    //cv::putText(edgeMat, "Edge Image", cvPoint(10, 40), 0, 1.0, cvScalar(0,255,0));
    
    //在异步线程中，将任务同步添加至主线程，不会造成死锁
    dispatch_sync(dispatch_get_main_queue(), ^{
        self.showingImgView.image = MatToUIImage(edgeMat);
    });
}


#pragma mark - 摄像头
-(void)navBtnToChangeCammer{
    if ( self.isDevicePositionFront ){
        [self.session stopRunning];
        [self.session removeInput:self.frontCameraInput];
        if ([self.session canAddInput:self.backCameraInput]) {
            [self.session addInput:self.backCameraInput];
            [self.session startRunning];
        }
    }else{
        [self.session stopRunning];
        [self.session removeInput:self.backCameraInput];
        if ([self.session canAddInput:self.frontCameraInput]) {
            [self.session addInput:self.frontCameraInput];
            [self.session startRunning];
        }
    }
}

- (AVCaptureDeviceInput *)backCameraInput {
    if (_backCameraInput == nil) {
        NSError *error;
        AVCaptureDevice *device = [self cameraWithPosition:AVCaptureDevicePositionBack];
        _backCameraInput = [[AVCaptureDeviceInput  alloc] initWithDevice:device error:&error];
        if (error) {
            NSLog(@"后置摄像头获取失败");
        }
    }
    self.isDevicePositionFront = NO;
    return _backCameraInput;
}

- (AVCaptureDeviceInput *)frontCameraInput {
    if (_frontCameraInput == nil) {
        NSError *error;
        AVCaptureDevice *device = [self cameraWithPosition:AVCaptureDevicePositionFront];
        _frontCameraInput = [[AVCaptureDeviceInput alloc] initWithDevice:device error:&error];
        if (error) {
            NSLog(@"前置摄像头获取失败");
        }
    }
    self.isDevicePositionFront = YES;
    return _frontCameraInput;
}

- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for ( AVCaptureDevice *device in devices )
        if ( device.position == position ){
            // 自动对焦。（更改这个设置的时候必须先锁定设备，修改完后再解锁，否则崩溃？）
            [device lockForConfiguration:nil];
            // 聚焦模式
            if ([device isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
                [device setFocusMode:AVCaptureFocusModeAutoFocus];
            }else{
                NSLog(@"聚焦模式修改失败");
            }
            //曝光模式
//            if ([device isExposureModeSupported:AVCaptureExposureModeAutoExpose]) {
//                [device setExposureMode:AVCaptureExposureModeAutoExpose];
//            }else{
//                NSLog(@"曝光模式修改失败");
//            }
            [device unlockForConfiguration];
            self.device = device;
            return device;
        }
    return nil;
}


- (void)dealloc {
    NSLog(@"解脱");
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
