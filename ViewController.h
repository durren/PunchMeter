//
//  ViewController.h
//  HandSpeed
//
//  Created by dshen on 10/9/12.
//  Copyright (c) 2012 dshen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioServices.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <AssetsLibrary/AssetsLibrary.h>
#include <CoreFoundation/CoreFoundation.h>

@interface ViewController : UIViewController <AVAudioPlayerDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UIAccelerationValue gravX;
    UIAccelerationValue gravY;
    UIAccelerationValue gravZ;
    UIAccelerationValue prevVelocity;
    __weak IBOutlet UIImageView *imageView;
    UIAccelerationValue prevAcce;
    UIImageView *bloodImage;
    UIImageView *imageViewForAnimation;
    __weak IBOutlet UILabel *speedLabel;
    double vmax;
    __weak IBOutlet UIButton *choosePhotoBtn;
    __weak IBOutlet UIButton *resetButton;
    __weak IBOutlet UIButton *settingsButton;
}

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *choosePhotoBtn;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (weak, nonatomic) IBOutlet UIButton *resetButton;
@property (weak, nonatomic) IBOutlet UIButton *settingsButton;
@property (weak, nonatomic) IBOutlet UILabel *speedLabel;
@property (strong) UIAccelerometer *sharedAcc;

-(IBAction)ResetButtonPressed:(id)sender;
- (IBAction)settingsButtonPressed:(id)sender;

@end
