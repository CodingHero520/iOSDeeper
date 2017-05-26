//
//  RecorderViewController.m
//  iOSDeeper
//
//  Created by 包磊 on 17/5/25.
//  Copyright © 2017年 baolei. All rights reserved.
//

#import "RecorderViewController.h"
#import <AVFoundation/AVFoundation.h>
@interface RecorderViewController ()<AVAudioRecorderDelegate>
@property (nonatomic,strong)AVAudioRecorder * audioRecorder; //音频录音机
@property (nonatomic,strong)AVAudioPlayer * audioPlayer;     //音频播放器
@property (nonatomic,strong)NSTimer  * timer;
@end

@implementation RecorderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"录音";
}
//设置音频会话
-(void)setAudioSession{

    AVAudioSession * audioSession = [AVAudioSession sharedInstance];
    
    //设置为录音和播放状态，以便可以在录音完成之后播放录音
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];

    //会话端口激活
    [audioSession setActive:YES error:nil];
}
//取得录音文件保存路径
-(NSURL *)getSavePath{

    NSString * urlStr = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];

    urlStr = [urlStr stringByAppendingPathComponent:@"Recorder"];
    
    NSURL * url = [NSURL fileURLWithPath:urlStr];
    
    return url;
}
//取得录音录音文件设置
-(NSDictionary *)getAudioSetting{

    NSMutableDictionary * dict = [NSMutableDictionary dictionary];

    //设置录音格式
    [dict setObject:@(kAudioFormatLinearPCM) forKey:AVFormatIDKey];
    //设置录音格式
    [dict setObject:@(8000) forKey:AVSampleRateKey];
    //设置通道，这里采用单声道
    [dict setObject:@(1) forKey:AVNumberOfChannelsKey];
    //每个采样点位数 分为8，16，24，32
    [dict setObject:@(YES) forKey:AVLinearPCMBitDepthKey];
    //是否使用浮点数采样集
    [dict setObject:@(YES) forKey:AVLinearPCMIsFloatKey];
    //..其他设置
    return dict;
    

}

///获得录音对象
-(AVAudioRecorder *)audioRecorder{

    if (!_audioRecorder) {
        
        //创建录音文件保存的路径
        NSURL * url = [self getSavePath];
        //创建录音格式设置
        NSDictionary * setting = [self getAudioSetting];
        
        //创建录音机
        NSError * error = nil;
        _audioRecorder = [[AVAudioRecorder alloc] initWithURL:url settings:setting error:&error];
        _audioRecorder.delegate = self;
        //如果要监控声波则必须要设置为yes
        _audioRecorder.meteringEnabled = YES;
        if (error) {
            NSLog(@"创建录音机时发生了错误，错误的信息:%@",error.localizedDescription);\
            return nil;
        }
        
    }

    return _audioRecorder;
    
}

//创建播放器
-(AVAudioPlayer *)audioPlayer{


    if (!_audioPlayer) {
        
        NSURL* url = [self getSavePath];
        
        NSError * error = nil;
        
        _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        
        _audioPlayer.numberOfLoops = 0;
        
        [_audioPlayer prepareToPlay];
        
        if (error) {
            
            NSLog(@"创建播放器时发生错误，错误信息是:%@",error.localizedDescription);
            return nil;
        }
    }

    return _audioPlayer;

}
//录音声波定时器
-(NSTimer *)timer{

    if (!_timer) {
        
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(UpdateProgress) userInfo:nil repeats:YES];
    }
    return _timer;

}
-(void)UpdateProgress{

    [self.audioRecorder updateMeters];//更新测量值
    
    float power = [self.audioRecorder averagePowerForChannel:0];//去第一个通道的音频
    CGFloat progress = (1.0/160.0)*(power + 160.0);
    [self.RecordProgress setProgress:progress];
    
    

}

#pragma mark -- 录音机代理方法
-(void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag{

    if (![self.audioPlayer isPlaying]) {
        
        [self.audioPlayer play];
    }
    
    NSLog(@"录音停止之后，立刻播放录音文件");

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

- (IBAction)StartButton:(id)sender {
    
    if (![self.audioRecorder isRecording]) {
        
        [self.audioRecorder record];
        self.timer.fireDate = [NSDate distantPast];
    }
}

- (IBAction)PauseButton:(id)sender {
    
    if ([self.audioRecorder isRecording]) {
        [self.audioRecorder pause];
        self.timer.fireDate = [NSDate distantFuture];
        
    }
}

- (IBAction)ResumeButton:(id)sender {
    [self StartButton:sender];
}

- (IBAction)StopButton:(id)sender {
    
    [self.audioRecorder stop];
    self.timer.fireDate = [NSDate distantFuture];
    self.RecordProgress.progress = 0.0;
}
@end
