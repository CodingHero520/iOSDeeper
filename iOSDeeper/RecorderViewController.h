//
//  RecorderViewController.h
//  iOSDeeper
//
//  Created by 包磊 on 17/5/25.
//  Copyright © 2017年 baolei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecorderViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIProgressView *RecordProgress;
- (IBAction)StartButton:(id)sender;

- (IBAction)PauseButton:(id)sender;
- (IBAction)ResumeButton:(id)sender;
- (IBAction)StopButton:(id)sender;

@end
