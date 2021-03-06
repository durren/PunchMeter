//
//  SettingsController.m
//  HandSpeed
//
//  Created by dshen on 11/5/12.
//  Copyright (c) 2012 dshen. All rights reserved.
//

#import "SettingsController.h"
#import "AppDelegate.h"

@interface SettingsController ()

@end

@implementation SettingsController
@synthesize vibrationSwitch, bloodSwitch, soundSwitch, explosionsSwitch;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([[defaults objectForKey:@"sound"] integerValue] == 1) {
        [soundSwitch setOn:TRUE];
    } else {
        [soundSwitch setOn:FALSE];
    }
    if ([[defaults objectForKey:@"vibration"] integerValue] == 1) {
        [vibrationSwitch setOn:TRUE];
    } else {
        [vibrationSwitch setOn:FALSE];
    }
    if ([[defaults objectForKey:@"blood"] integerValue] == 1) {
        [bloodSwitch setOn:TRUE];
    } else {
        [bloodSwitch setOn:FALSE];
    }
    if ([[defaults objectForKey:@"explosions"] integerValue] == 1) {
        [explosionsSwitch setOn:TRUE];
    } else {
        [explosionsSwitch setOn:FALSE];
    }

    [super viewDidLoad];
    

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

- (void)viewDidUnload {
    [self setExplosionsSwitch:nil];
    [self setBloodSwitch:nil];
    [self setSoundSwitch:nil];
    [self setVibrationSwitch:nil];
    [super viewDidUnload];
}

- (IBAction)vibrationSwitchChanged:(id)sender {
    [self save];
}

- (IBAction)soundSwitchChanged:(id)sender {
    [self save];

}

- (IBAction)bloodSwitchChanged:(id)sender {
    [self save];
}

- (IBAction)explosionsSwitchChanged:(id)sender {
    [self save];
}

- (void)save {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:[soundSwitch isOn] forKey:@"sound"];
    [defaults setBool:[vibrationSwitch isOn] forKey:@"vibration"];
    [defaults setBool:[bloodSwitch isOn] forKey:@"blood"];
    [defaults setBool:[explosionsSwitch isOn] forKey:@"explosions"];
    [defaults synchronize];
NSLog(@"Data saved");
}
@end
