
//
//  VideoViewController.m
//  iOSDeeper
//
//  Created by 包磊 on 17/5/25.
//  Copyright © 2017年 baolei. All rights reserved.
//

#import "VideoViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
@interface VideoViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic,assign)BOOL ISVIDEO; //yes表示录制视频
@property (nonatomic,strong)UIImagePickerController * imagePicker;
@property (weak, nonatomic) IBOutlet UIImageView *photo; //照片展示视图
@property (strong,nonatomic)AVPlayer * player;//播放器，用于录制完成视频后播放

@end

@implementation VideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"视频录制";
    self.ISVIDEO = YES;
}
//完成
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{


    NSString * mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        UIImage * image;
        if (self.imagePicker.allowsEditing) {
            
            image = [info objectForKey:UIImagePickerControllerEditedImage];
            
        }else{
        
            image = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        }
        [self.photo setImage:image];
        
    }else if([mediaType isEqualToString:(NSString *)kUTTypeMovie]){
    
        NSURL * url = [info objectForKey:UIImagePickerControllerMediaURL];
    
        NSString * urlstr = [url path];
        
        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(urlstr)) {
            //保存视频到相册，注意也可以使用alassetlibrary来保存
            UISaveVideoAtPathToSavedPhotosAlbum(urlstr, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
        }
        
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];

}
-(UIImagePickerController *)imagePicker{

    if (!_imagePicker) {
        _imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        _imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
        if (self.ISVIDEO) {
            _imagePicker.mediaTypes = @[(NSString *)kUTTypeMovie];
            _imagePicker.videoQuality = UIImagePickerControllerQualityTypeIFrame1280x720;
            _imagePicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;
        }else{
        
            _imagePicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
        
        }
        _imagePicker.allowsEditing = YES;
        _imagePicker.delegate = self;
    }

    return _imagePicker;

}
-(void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{

    if (error) {
        NSLog(@"保存视频过程中发生错误%@",error.localizedDescription);
    }else{
    
        NSURL * url = [NSURL fileURLWithPath:videoPath];
        _player = [AVPlayer playerWithURL:url];
        AVPlayerLayer * playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
        playerLayer.frame = self.photo.frame;
        [self.photo.layer addSublayer:playerLayer];
        [_player play];
    }
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

- (IBAction)TakePhoto:(id)sender {
    
    [self presentViewController:self.imagePicker animated:YES completion:nil];
}
@end
