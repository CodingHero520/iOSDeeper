//
//  ViewController.m
//  iOSDeeper
//
//  Created by 包磊 on 17/5/24.
//  Copyright © 2017年 baolei. All rights reserved.
//

#import "ViewController.h"
#import "MusicPlayerViewController.h"
#import "RecorderViewController.h"
#import "VideoViewController.h"
#import "TakePhotoViewController.h"
@interface ViewController ()


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    [self addButtonAction];
    
}
-(void)addButtonAction{

    self.MusicPlayButton.tag   = 1;
    self.RecordButton   .tag   = 2;
    self.TakePictureButton.tag = 3;
    self.VideoPlayButton .tag  = 4;
    self.VideoRecordButton.tag = 5;
    

    [self.MusicPlayButton addTarget:self action:@selector(ClickButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.RecordButton addTarget:self action:@selector(ClickButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.TakePictureButton addTarget:self action:@selector(ClickButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.VideoPlayButton addTarget:self action:@selector(ClickButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.VideoRecordButton addTarget:self action:@selector(ClickButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
}
-(void)ClickButtonAction:(id)sender{
    
    UIButton * button = (UIButton *)sender;

    NSInteger indexOfButton = button.tag;
    
    MusicPlayerViewController * MPVC = [[MusicPlayerViewController alloc] initWithNibName:@"MusicPlayerViewController" bundle:nil];
    
    RecorderViewController   * RVC = [[RecorderViewController alloc] initWithNibName:@"RecorderViewController" bundle:nil];
    
    VideoViewController * VVC = [[VideoViewController alloc] initWithNibName:@"VideoViewController" bundle:nil];
    
    TakePhotoViewController * TPVC = [[TakePhotoViewController alloc] initWithNibName:@"TakePhotoViewController" bundle:nil];
    
    switch (indexOfButton) {
        case 1:
            
        {
            [self.navigationController pushViewController:MPVC animated:YES];
        
        }
            
            break;
        case 2:
        {
        
            [self.navigationController pushViewController:RVC animated:YES];
        }
            break;
        case 3:
        {
        
            [self.navigationController pushViewController:TPVC animated:YES];
        }
            break;
        case 5:
        {
        
            [self.navigationController pushViewController:VVC animated:YES];
        }
            break;
        default:
            break;
    }
    


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
