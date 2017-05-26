//
//  TakePhotoViewController.m
//  iOSDeeper
//
//  Created by 包磊 on 17/5/26.
//  Copyright © 2017年 baolei. All rights reserved.
//

#import "TakePhotoViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

typedef void(^PropertyChangeBlock)(AVCaptureDevice  * captureDevice);

@interface TakePhotoViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *TakePhotoImage;
- (IBAction)TakePhotoButton:(id)sender;

- (IBAction)AutoFlash:(id)sender;

- (IBAction)OpenFlash:(id)sender;

- (IBAction)CloseFlash:(id)sender;


@property (nonatomic , strong)AVCaptureSession * captureSession; //负责输入和输出
@property (nonatomic , strong)AVCaptureDeviceInput * captureDeviceInput;//
@property (nonatomic , strong)AVCaptureStillImageOutput * captureStillImage;
@property (nonatomic , strong)AVCaptureVideoPreviewLayer * captureVideoPreviewLayer;
@end

@implementation TakePhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"拍照";
    
    
}

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    //初始化会话
    _captureSession = [[AVCaptureSession alloc] init];
    
    if ([_captureSession canSetSessionPreset:AVCaptureSessionPreset1280x720]) {
        
        _captureSession.sessionPreset = AVCaptureSessionPreset1280x720;
    }
    
    //获得输入设备
    AVCaptureDevice * captureDevice = [self getCameraDeviceWithPosition:AVCaptureDevicePositionBack];//取后置摄像头
    
    if (!captureDevice) {
        NSLog(@"在取后置摄像头的时候出现问题");
        return;
    }
    
    NSError * error = nil;
    //根据输入设备的初始化设备输入对像，用于获得输入数据
    _captureDeviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:captureDevice error:&error];
    
    if (error) {
        NSLog(@"取得设备输入对像时出错，错误的原因是:%@",error.localizedDescription);
        return;
    }
    
    //初始化设备输出对象 用于获得输出数据
    _captureStillImage = [[AVCaptureStillImageOutput alloc] init];
    
    NSDictionary * outputSetting = @{AVVideoCodecKey:AVVideoCodecJPEG};
    [_captureStillImage setOutputSettings:outputSetting];//输出设置
    
    //将设备输入添加到会话中
    if ([_captureSession canAddInput:_captureDeviceInput]) {
        
        [_captureSession addInput:_captureDeviceInput];
        
    }
    //将设备输出添加到会话中
    if ([_captureSession canAddOutput:_captureStillImage]) {
        
        [_captureSession addOutput:_captureStillImage];
    }
    
    //创建视频预览层，用于实时展示摄像头状态
    _captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    
    CALayer * layer = self.TakePhotoImage.layer;
    
    layer.masksToBounds = YES;
    
    _captureVideoPreviewLayer.frame = layer.bounds;
    
    _captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    
    //将视频预览层添加到界面中

    
    

}

#pragma mark -- 私有方法
-(AVCaptureDevice *)getCameraDeviceWithPosition:(AVCaptureDevicePosition *)position{


    NSArray * cameras = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];

    for (AVCaptureDevice * camera in cameras) {
    
        if (camera.position == position) {
            
            return camera;
        }
        
    
    }

    return  nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)TakePhotoButton:(id)sender {
}

- (IBAction)AutoFlash:(id)sender {
}

- (IBAction)OpenFlash:(id)sender {
}

- (IBAction)CloseFlash:(id)sender {
}
@end
