//
//  MusicPlayerViewController.h
//  iOSDeeper
//
//  Created by 包磊 on 17/5/24.
//  Copyright © 2017年 baolei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MusicPlayerViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *SingerPhoto;

@property (weak, nonatomic) IBOutlet UILabel *SongName;

@property (weak, nonatomic) IBOutlet UILabel *SingerName;

@property (weak, nonatomic) IBOutlet UIButton *DownLoadButton;
@property (weak, nonatomic) IBOutlet UIButton *SaveSongButton;

@property (weak, nonatomic) IBOutlet UIView *SongPalyProgress;

@property (weak, nonatomic) IBOutlet UIButton *LastSongButton;

@property (weak, nonatomic) IBOutlet UIButton *SongPlayButton;

@property (weak, nonatomic) IBOutlet UIButton *NextSongButton;

@property (weak, nonatomic) IBOutlet UIProgressView *MusicPlayProgress;



@end
