//
//  SettingsController.h
//  HandSpeed
//
//  Created by dshen on 11/5/12.
//  Copyright (c) 2012 dshen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsController : UITableViewController {
    
}
@property (weak, nonatomic) IBOutlet UISwitch *explosionsSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *bloodSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *soundSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *vibrationSwitch;

- (IBAction)vibrationSwitchChanged:(id)sender;
- (IBAction)soundSwitchChanged:(id)sender;
- (IBAction)bloodSwitchChanged:(id)sender;
- (IBAction)explosionsSwitchChanged:(id)sender;
- (void)save;

@end
