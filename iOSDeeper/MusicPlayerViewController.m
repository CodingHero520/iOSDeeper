//
//  MusicPlayerViewController.m
//  iOSDeeper
//
//  Created by 包磊 on 17/5/24.
//  Copyright © 2017年 baolei. All rights reserved.
//

#import "MusicPlayerViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "MPMusicPlayerViewController.h"
@interface MusicPlayerViewController ()<AVAudioPlayerDelegate>

@property (nonatomic,strong)AVAudioPlayer * MusicPlayer;

@property (nonatomic,weak)NSTimer * timer;

@end

@implementation MusicPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];


    [self.SongPlayButton addTarget:self action:@selector(CliclPlayAction:) forControlEvents:UIControlEventTouchUpInside];
    
   //导航条上配一个按钮

    [self AddNavItem];
}
-(void)AddNavItem{
    
    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithTitle:@"下一页" style:UIBarButtonItemStyleDone target:self action:@selector(TapNavItem)];

    self.navigationItem.rightBarButtonItem = item;

}
-(void)TapNavItem{

    MPMusicPlayerViewController * mpvc = [[MPMusicPlayerViewController alloc] init];
    
    [self.navigationController pushViewController:mpvc animated:YES];

}

-(void)CliclPlayAction:(id)sender{

    UIButton * button = (UIButton *)sender;
    
    button.selected =! button.selected;
    
    if (button.selected) {
        
        [self.SongPlayButton setTitle:@"暂停" forState:UIControlStateNormal];
        
        [self startplay];
     
    }else{
    
        [self.SongPlayButton setTitle:@"播放" forState:UIControlStateNormal];
        
        [self pauseplay];
        
    }
   
}

-(AVAudioPlayer *)MusicPlayer{

    if (!_MusicPlayer) {
        
        NSString * urlstr = [[NSBundle mainBundle] pathForResource:@"黄致列 - 默.mp3" ofType:nil];
        
        
        NSURL * url = [NSURL fileURLWithPath:urlstr];
        
        NSError * error = nil;
        
        //初始化播放器。注意这里的url 只能是文件的路径
        _MusicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        
        //设置播放器的属性
        _MusicPlayer.numberOfLoops = 0; //0表示不循环
        
        _MusicPlayer.delegate = self;
        
        [_MusicPlayer prepareToPlay];//加载音频文件到缓存
        
        if (error) {
            NSLog(@"播放器创建失败，错误原因:%@",error.localizedDescription);
            return nil;
        }
        //设置后台播放模式
        AVAudioSession * audioSession = [AVAudioSession sharedInstance];
        
        [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
        
        [audioSession setActive:YES error:nil];
        
        //添加通知 ，拔出耳机后暂停播放
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(routechange:) name:AVAudioSessionRouteChangeNotification object:nil];
    }
    
    return _MusicPlayer;

}
//输出改变 执行这个方法
-(void)routechange:(NSNotification *)notification{
    NSDictionary * dic = notification.userInfo;
    
    int changeReason = [dic[AVAudioSessionRouteChangeReasonKey] intValue];
    
    if (changeReason == AVAudioSessionRouteChangeReasonOldDeviceUnavailable) {
        
        AVAudioSessionRouteDescription * routeDescription = dic[AVAudioSessionRouteChangePreviousRouteKey];
        
        AVAudioSessionPortDescription * portDescription  = [routeDescription.outputs firstObject];
        //原设备为耳机则暂停
        if ([portDescription.portType isEqualToString:@"Headphones"]) {
            
            [self pauseplay];
        }
    }
    

}
-(void)dealloc{


    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVAudioSessionRouteChangeNotification object:nil];
}
//播放
-(void)startplay{

    if (![self.MusicPlayer isPlaying]) {
        
        [self.MusicPlayer play];
        self.timer.fireDate = [NSDate distantPast];//重启定时器
        
    }

}

-(void)pauseplay{

    if ([self.MusicPlayer isPlaying]) {
        
        [self.MusicPlayer pause];
        
        self.timer.fireDate = [NSDate distantFuture];
    }

}

-(NSTimer *)timer{

    if (!_timer) {
        
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(updateProgress) userInfo:nil repeats:YES];
        
    
    }

    return _timer;
}
-(void)updateProgress{
    
    float progress = self.MusicPlayer.currentTime / self.MusicPlayer.duration;
    
    [self.MusicPlayProgress setProgress:progress animated:YES];
    
    

}
-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{


    NSLog(@"音乐播放完成");
    
    //根据实际情况播放完成可以将会话关闭， 其他音频应用继续播放
    [[AVAudioSession sharedInstance] setActive:NO error:nil];
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

@end
