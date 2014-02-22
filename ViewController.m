//
//  ViewController.m
//  HandSpeed
//
//  Created by dshen on 10/9/12.
//  Copyright (c) 2012 dshen. All rights reserved.
//

#import "ViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <QuartzCore/QuartzCore.h>

@interface ViewController ()

@end

@implementation ViewController

@synthesize sharedAcc = _sharedAcc;
@synthesize speedLabel;
@synthesize choosePhotoBtn;
@synthesize imageView;
bool accOn;
double vmax = 0.0f;
int noVelocity = 0;
int numViews = 5;
int punch = 0;

#define kAccelerometerFrequency        50.0 //Hz
#define kFilteringFactor 0.1

- (void)viewDidLoad
{
    [self loadSettings];
    [super viewDidLoad];
    [UIView setAnimationDelegate:self];
    self.imageView.frame = [[UIScreen mainScreen] applicationFrame];
    [self.imageView initWithImage:[UIImage imageNamed:@"brownTexture.png"]];
    // Do any additional setup after loading the view, typically from a nib.
    self.sharedAcc = [UIAccelerometer sharedAccelerometer];
    self.sharedAcc.delegate = self;
    self.sharedAcc.updateInterval = 1 / kAccelerometerFrequency;
    accOn=true;
    
    gravX = gravY = gravZ = prevVelocity = prevAcce = 0.f;
}

- (void)viewDidUnload
{
    speedLabel = nil;
    [self setSpeedLabel:nil];
    resetButton = nil;
    [self setResetButton:nil];
    [self setChoosePhotoBtn:nil];
    choosePhotoBtn = nil;
    imageView = nil;
    imageView = nil;
    [self setImageView:nil];
    settingsButton = nil;
    [self setSettingsButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return NO;
    //return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (UIAccelerationValue)tendToZero:(UIAccelerationValue)value {
    if (value < 0) {
        return ceil(value);
    } else {
        return floor(value);
    }
}

#define kAccelerometerFrequency        50.0 //Hz
#define kFilteringFactor 0.1
- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {
    if (accOn) {
        gravX = (acceleration.x * kFilteringFactor) + (gravX * (1.0 - kFilteringFactor));
        gravY = (acceleration.y * kFilteringFactor) + (gravY * (1.0 - kFilteringFactor));
        gravZ = (acceleration.z * kFilteringFactor) + (gravZ * (1.0 - kFilteringFactor));
        
        UIAccelerationValue accelX = acceleration.x - ( (acceleration.x * kFilteringFactor) + (gravX * (1.0 - kFilteringFactor)) );
        
        UIAccelerationValue accelY = acceleration.y - ( (acceleration.y * kFilteringFactor) + (gravY * (1.0 - kFilteringFactor)) );
        UIAccelerationValue accelZ = acceleration.z - ( (acceleration.z * kFilteringFactor) + (gravZ * (1.0 - kFilteringFactor)) );
        accelX *= 9.81f;
        accelY *= 9.81f;
        accelZ *= 9.81f;
        accelX = [self tendToZero:accelX];
        accelY = [self tendToZero:accelY];
        accelZ = [self tendToZero:accelZ];
        
        UIAccelerationValue vector = sqrt(pow(accelX,2)+pow(accelY,2)+pow(accelZ, 2));
        UIAccelerationValue acce = vector - prevVelocity;
        UIAccelerationValue velocity = (((acce - prevAcce)/2) * (1/kAccelerometerFrequency)) + prevVelocity;
        //NSLog(@"X %g Y %g Z %g, Vector %g, Velocity %g",accelX,accelY,accelZ,vector,velocity);
        if (velocity > 0.2) {
            noVelocity = 0;
            NSLog(@"X %g Y %g Z %g, Vector %g, Velocity %g",accelX,accelY,accelZ,vector,velocity);
            if (vmax < velocity) {
                vmax = velocity;
            }
            punch++;
            /*
            NSNumber *vNumber = [NSNumber numberWithFloat:(float)velocity];
            NSLog(@"%@", vNumber);
            [velocityArray addObject:vNumber];
            NSLog(@"%@", velocityArray);*/
        } else if (velocity <= .2) {
            noVelocity++;
            if (noVelocity > 65) {
                vmax=0;
            }
        }
            
        if (punch >= 9) {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            if ([[defaults objectForKey:@"vibration"] integerValue] == 1) {
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            }
            
            dispatch_queue_t dispatchQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            
            dispatch_async(dispatchQueue, ^(void) {
                NSBundle *mainBundle = [NSBundle mainBundle];
                NSString *filePath;
                //NSLog(@"%g", vmax);
                if (vmax > .2 && vmax <= .34) {
                    filePath = [mainBundle pathForResource:@"Jab" ofType:@"wav"];
                } else if (vmax > .34 && vmax < .36) {
                    filePath = [mainBundle pathForResource:@"RightCross" ofType:@"wav"];
                } else if (vmax >= .36) {
                    filePath = [mainBundle pathForResource:@"RightHook" ofType:@"wav"];
                }
                NSData *fileData = [NSData dataWithContentsOfFile:filePath];
                NSError *error = nil;
                
                self.audioPlayer = [[AVAudioPlayer alloc] initWithData:fileData error:&error];
                if (self.audioPlayer != nil) {
                    self.audioPlayer.delegate = self;
                    if ([self.audioPlayer prepareToPlay] && [self.audioPlayer play]) {
                        //started playing
                    } else {
                        //failed to play
                    }
                } else {
                    //failed to instandiate player
                }
                
                
            });
            punch = 0;
                    
            float x = 0;
            float y = 0;
            
            for (int i=0; i<15; i++) {
                if (i==0) {
                    x = rand_lim(300);
                    y = rand_lim(390);
                    if ([[defaults objectForKey:@"blood"] integerValue] == 1) {
                        
                        bloodImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Blood_transparent.png"]];
                        [self.view addSubview:bloodImage];
                        bloodImage.frame = CGRectMake(0,0,100,100);
                        bloodImage.center = CGPointMake(x,y);
                        
                        //make the blood fade out
                        [UIView animateWithDuration:10
                                         animations:^{bloodImage.alpha = 0.0f;
                                             bloodImage.transform = CGAffineTransformMakeScale(0.3, rand_lim(3));}
                                         completion:^(BOOL finished){ [bloodImage removeFromSuperview];
                                             
                                         }];
                    }
                    
                }
                if ([[defaults objectForKey:@"explosions"] integerValue] == 1) {
                    UIImageView *imageViewForAnimation = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"star.png"]];
                    float starSize = rand_lim(120);
                    imageViewForAnimation.frame = CGRectMake(0,0,starSize,starSize);
                    
                    imageViewForAnimation.center = CGPointMake(x,y);
                    imageViewForAnimation.alpha = 1.0f;
                    CGRect imageFrame = imageViewForAnimation.frame;
                    //Your image frame.origin from where the animation need to get start
                    CGPoint viewOrigin = imageViewForAnimation.frame.origin;
                    viewOrigin.y = viewOrigin.y + imageFrame.size.height / 2.0f;
                    viewOrigin.x = viewOrigin.x + imageFrame.size.width / 2.0f;
                    
                    imageViewForAnimation.frame = imageFrame;
                    imageViewForAnimation.layer.position = viewOrigin;
                    [self.view addSubview:imageViewForAnimation];
                    
                    // Set up fade out effect
                    CABasicAnimation *fadeOutAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
                    [fadeOutAnimation setToValue:[NSNumber numberWithFloat:0.0]];
                    fadeOutAnimation.fillMode = kCAFillModeForwards;
                    fadeOutAnimation.removedOnCompletion = NO;
                    
                    // Set up scaling
                    CABasicAnimation *resizeAnimation = [CABasicAnimation animationWithKeyPath:@"bounds.size"];
                    [resizeAnimation setToValue:[NSValue valueWithCGSize:CGSizeMake(40.0f, imageFrame.size.height * (40.0f / imageFrame.size.width))]];
                    resizeAnimation.fillMode = kCAFillModeForwards;
                    resizeAnimation.removedOnCompletion = NO;
                    
                    // Set up path movement
                    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
                    pathAnimation.calculationMode = kCAAnimationPaced;
                    pathAnimation.fillMode = kCAFillModeForwards;
                    pathAnimation.removedOnCompletion = NO;
                    //Setting Endpoint of the animation
                    CGPoint endPoint = CGPointMake(rand_lim(390),rand_lim(390));
                    //to end animation in last tab use
                    //CGPoint endPoint = CGPointMake( 320-40.0f, 480.0f);
                    CGMutablePathRef curvedPath = CGPathCreateMutable();
                    CGPathMoveToPoint(curvedPath, NULL, viewOrigin.x, viewOrigin.y);
                    CGPathAddCurveToPoint(curvedPath, NULL, endPoint.x, viewOrigin.y, endPoint.x, viewOrigin.y, endPoint.x, endPoint.y);
                    pathAnimation.path = curvedPath;
                    CGPathRelease(curvedPath);
                    
                    CAAnimationGroup *group = [CAAnimationGroup animation];
                    group.fillMode = kCAFillModeForwards;
                    group.removedOnCompletion = NO;
                    [group setAnimations:[NSArray arrayWithObjects:fadeOutAnimation, pathAnimation, resizeAnimation, nil]];
                    group.duration = 0.7f;
                    group.delegate = self;
                    [group setValue:imageViewForAnimation forKey:@"imageViewBeingAnimated"];
                    
                    CATransform3D rotationTransform = CATransform3DMakeRotation(1.0f * M_PI, 0, 0, 1.0);
                    CABasicAnimation* rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
                    
                    rotationAnimation.toValue = [NSValue valueWithCATransform3D:rotationTransform];
                    rotationAnimation.duration = 0.25f;
                    rotationAnimation.cumulative = YES;
                    rotationAnimation.repeatCount = 10;
                    
                    [imageViewForAnimation.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];

                    [imageViewForAnimation.layer addAnimation:group forKey:@"savingAnimation"];
                }
            }
            
            
            
        }
            
        self.speedLabel.text = [NSString stringWithFormat:@"%g", (vmax)*100];
        prevAcce = acce;
        prevVelocity = velocity;
    } else {
        punch = 0;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}


-(IBAction)ResetButtonPressed:(id)sender
{
    dispatch_queue_t dispatchQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(dispatchQueue, ^(void) {
        NSBundle *mainBundle = [NSBundle mainBundle];
        NSString *filePath;
        //NSLog(@"%g", vmax);
                    filePath = [mainBundle pathForResource:@"RightHook" ofType:@"wav"];
        NSData *fileData = [NSData dataWithContentsOfFile:filePath];
        NSError *error = nil;
        
        self.audioPlayer = [[AVAudioPlayer alloc] initWithData:fileData error:&error];
        if (self.audioPlayer != nil) {
            self.audioPlayer.delegate = self;
            if ([self.audioPlayer prepareToPlay] && [self.audioPlayer play]) {
                //started playing
            } else {
                //failed to play
            }
        } else {
            //failed to instandiate player
        }
        
        
    });
    [UIView animateWithDuration:0.2
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         // Scale
                         //CGAffineTransform scale = CGAffineTransformMakeScale(1.5,1.5);
                         
                         // Apply them to the view
                         self.resetButton.transform = CGAffineTransformMakeScale(2.0,2.0);
                         self.resetButton.transform = CGAffineTransformMakeScale(1.0,1.0);
                         
                     }
                     completion:^(BOOL finished) {
                         accOn=false;
                         self.speedLabel.text = @"0";
                         vmax = 0.0f;
                         
                         accOn=true;
                         
                         //clear out all the blood
                         while([self.view.subviews count] > numViews) {
                             [[self.view.subviews lastObject] removeFromSuperview];
                         }
                         
                     }];
 
}

- (IBAction)settingsButtonPressed:(id)sender {
    dispatch_queue_t dispatchQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(dispatchQueue, ^(void) {
        NSBundle *mainBundle = [NSBundle mainBundle];
        NSString *filePath;
        //NSLog(@"%g", vmax);
        filePath = [mainBundle pathForResource:@"RightHook" ofType:@"wav"];
        NSData *fileData = [NSData dataWithContentsOfFile:filePath];
        NSError *error = nil;
        
        self.audioPlayer = [[AVAudioPlayer alloc] initWithData:fileData error:&error];
        if (self.audioPlayer != nil) {
            self.audioPlayer.delegate = self;
            if ([self.audioPlayer prepareToPlay] && [self.audioPlayer play]) {
                //started playing
            } else {
                //failed to play
            }
        } else {
            //failed to instandiate player
        }
        
        
    });
    
    [UIView animateWithDuration:0.2
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         // Scale
                         //CGAffineTransform scale = CGAffineTransformMakeScale(1.5,1.5);
                         
                         // Apply them to the view
                         self.settingsButton.transform = CGAffineTransformMakeScale(2.0,2.0);
                         self.settingsButton.transform = CGAffineTransformMakeScale(1.0,1.0);
                         
                     } completion:^(BOOL finished) {
                         
                         
                     }];
}

-(IBAction) getPhoto:(id) sender {
    [self.imageView initWithImage:[UIImage imageNamed:@"brownTexture.png"]];
    /*CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.duration = 0.125;
    animation.repeatCount = 1;
	animation.autoreverses = YES;
    animation.removedOnCompletion = YES;
    animation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.5, 1.5, 1.0)];
	[self.choosePhotoBtn.layer addAnimation:animation forKey:@"pulseAnimation"];*/
    
    /*self.choosePhotoBtn.transform = CGAffineTransformMakeScale(1.5,1.5);
    [UIView beginAnimations:@"ScaleButton" context:NULL];
    [UIView setAnimationDuration: 0.2f];
    [UIView setAnimationRepeatCount:1];
    [UIView setAnimationRepeatAutoreverses:FALSE];
    self.choosePhotoBtn.transform = CGAffineTransformMakeScale(1.0,1.0);
    [UIView commitAnimations];*/
    dispatch_queue_t dispatchQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(dispatchQueue, ^(void) {
        NSBundle *mainBundle = [NSBundle mainBundle];
        NSString *filePath;
        //NSLog(@"%g", vmax);
        filePath = [mainBundle pathForResource:@"RightHook" ofType:@"wav"];
        NSData *fileData = [NSData dataWithContentsOfFile:filePath];
        NSError *error = nil;
        
        self.audioPlayer = [[AVAudioPlayer alloc] initWithData:fileData error:&error];
        if (self.audioPlayer != nil) {
            self.audioPlayer.delegate = self;
            if ([self.audioPlayer prepareToPlay] && [self.audioPlayer play]) {
                //started playing
            } else {
                //failed to play
            }
        } else {
            //failed to instandiate player
        }
        
        
    });
    [UIView animateWithDuration:0.2
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         // Scale
                         //CGAffineTransform scale = CGAffineTransformMakeScale(1.5,1.5);
                         
                         // Apply them to the view
                         self.choosePhotoBtn.transform = CGAffineTransformMakeScale(2.0,2.0);
                         self.choosePhotoBtn.transform = CGAffineTransformMakeScale(1.0,1.0);
                         
                     } completion:^(BOOL finished) {
                         UIImagePickerController * picker = [[UIImagePickerController alloc] init];
                         
                         // Don't forget to add UIImagePickerControllerDelegate in your .h
                         picker.delegate = self;
                         
                         if((UIButton *) sender == choosePhotoBtn) {
                             picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
                         } else {
                             picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                         }
                         
                         [self presentModalViewController:picker animated:YES];
                     }];
}

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag{
    NSLog(@"HI");
    [[self.view.subviews lastObject] removeFromSuperview];
    
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [imageView setImage:image];
    
    [self dismissModalViewControllerAnimated:YES];
    while([self.view.subviews count] > numViews) {
        [[self.view.subviews lastObject] removeFromSuperview];
    }
}

int rand_lim(int limit) {
    /* return a random number between 0 and limit inclusive.
     */
    
    int divisor = RAND_MAX/(limit+1);
    int retval;
    
    do {
        retval = rand() / divisor;
    } while (retval > limit);
    
    return retval;
}

- (void)loadSettings {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys: [NSNumber numberWithInt:1], @"sound", [NSNumber numberWithInt:1], @"vibration", [NSNumber numberWithInt:1], @"explosions", [NSNumber numberWithInt:1], @"blood", nil];
    [defaults registerDefaults:dict];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSLog(@"hidfsadf");
    
}



@end
