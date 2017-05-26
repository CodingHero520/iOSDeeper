//
//  MPMusicPlayerViewController.m
//  iOSDeeper
//
//  Created by 包磊 on 17/5/24.
//  Copyright © 2017年 baolei. All rights reserved.
//

#import "MPMusicPlayerViewController.h"
#import <MediaPlayer/MediaPlayer.h>
@interface MPMusicPlayerViewController ()<MPMediaPickerControllerDelegate>

{

    NSString * songName;
}

@property (nonatomic,strong)MPMusicPlayerController * MusicPlayer;
@property (nonatomic,strong)MPMediaPickerController * MediaPlayer;
@end

@implementation MPMusicPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"播放手机音乐库中的音乐";
}
//获得音乐播放器
-(MPMusicPlayerController *)MusicPlayer{


    if (!_MusicPlayer) {
        
        _MusicPlayer = [MPMusicPlayerController systemMusicPlayer];
        
        [_MusicPlayer beginGeneratingPlaybackNotifications];
        //监听播放的状态
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackStateChange:) name:MPMusicPlayerControllerPlaybackStateDidChangeNotification object:nil];
    }
    
    return _MusicPlayer;


}
-(void)dealloc{

     [self.MusicPlayer endGeneratingPlaybackNotifications];

}
//获得媒体选择器
-(MPMediaPickerController *)MediaPlayer{


    if (!_MediaPlayer) {
        
        //初始化媒体选择器 这里设置的媒体的类型是音乐，其实哲理可以选择视频，广播等
        _MediaPlayer = [[MPMediaPickerController alloc] initWithMediaTypes:MPMediaTypeMovie];
        
        _MediaPlayer.allowsPickingMultipleItems = YES;//允许多选
        _MediaPlayer.prompt = @"请选择要播放的音乐";
        _MediaPlayer.delegate = self;
        
    }

    return _MediaPlayer;

}
//取得媒体的队列
-(MPMediaQuery *)getLocalMediaQuery{


    MPMediaQuery * mediaQueue = [MPMediaQuery songsQuery];

    for (MPMediaItem * item in mediaQueue.items) {
        
        NSLog(@"标题:%@,%@",item.title,item.albumTitle);
        
    }

    return mediaQueue;

}
//取得媒体的集合
-(MPMediaItemCollection * )getLocalMediaItemCollection{
    
    MPMediaQuery * mediaQueue = [MPMediaQuery songsQuery];
    
    NSMutableArray * array = [NSMutableArray array];
    
    for (MPMediaItem * item in mediaQueue.items) {
        
        [array addObject:item];
        
        NSLog(@"标题:%@ , %@",item.title,item.albumTitle);
    }
    
    MPMediaItemCollection * mediaitemcollection = [[MPMediaItemCollection alloc] initWithItems:[array copy]];

    return mediaitemcollection;

}
//选择完歌曲之后，点击完成之后执行的方法
#pragma mark --  MPMediaPickerController代理方法
-(void)mediaPicker:(MPMediaPickerController *)mediaPicker didPickMediaItems:
(MPMediaItemCollection *)mediaItemCollection{
        

    MPMediaItem * mediaitem = [mediaItemCollection.items firstObject];

    NSLog(@"标题:%@,表演者:%@,专辑:%@",mediaitem.title,mediaitem.artist,mediaitem.albumTitle);
    
    [self.MusicPlayer setQueueWithItemCollection:mediaItemCollection];
    
    [self dismissViewControllerAnimated:YES completion:nil];

}

//取消选择器
-(void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker{


    [self dismissViewControllerAnimated:YES completion:nil];

}

-(void)playbackStateChange:(NSNotification *)notificaation{
/*
 MPMusicPlaybackStateStopped,
 MPMusicPlaybackStatePlaying,
 MPMusicPlaybackStatePaused,
 MPMusicPlaybackStateInterrupted,
 MPMusicPlaybackStateSeekingForward,
 MPMusicPlaybackStateSeekingBackward

 */
    switch (self.MusicPlayer.playbackState) {
        case MPMusicPlaybackStatePlaying:
            NSLog(@"正在播放...");
            break;
        case MPMusicPlaybackStatePaused:
            NSLog(@"播放暂停...");
            break;
        case MPMusicPlaybackStateStopped:
            NSLog(@"播放停止...");
            break;
        case MPMusicPlaybackStateInterrupted:
            NSLog(@"播放中止...");
            break;
        case MPMusicPlaybackStateSeekingForward:
            NSLog(@"播放下一首...");
            break;
        case MPMusicPlaybackStateSeekingBackward:
            NSLog(@"播放上一首...");
            break;
        default:
            break;
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

- (IBAction)MusicPauseButton:(id)sender {
    
    [self.MusicPlayer pause];
}

- (IBAction)MusicPlayButton:(id)sender {
    
    [self.MusicPlayer play];
}

//播放下一首
- (IBAction)MusicNextButton:(id)sender {
    
    

}

- (IBAction)MusicStopButton:(id)sender {
    
    [self.MusicPlayer stop];
}

- (IBAction)MediaPlayButton:(id)sender {
    
    [self presentViewController:self.MediaPlayer animated:YES completion:nil];
}

- (IBAction)MusicLastButton:(id)sender {
    
      
}
@end
