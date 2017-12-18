//
//  SLSettingTableViewController.m
//  ShoppingList
//
//  Created by Zaw Ye Naing on 2017/09/10.
//  Copyright © 2017 Zaw Ye Naing. All rights reserved.
//

#import "SLSettingTableViewController.h"
#import "SLTabSettingTableViewController.h"
#import "SLTabMManager.h"
#import "SLShoppingListData.h"

@interface SLSettingTableViewController ()
{
    NSMutableArray *settingDataArray;
    
    NSString *selectedFont;
    UIColor  *selectedColor;
}
@end

@implementation SLSettingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    settingDataArray = [NSMutableArray arrayWithObjects: @"Tab Setting", @"Color Setting", @"Font Setting", nil];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame: CGRectZero];
    
    NSLog(@"Count : %ld", [settingDataArray count]);
    NSLog(@"viewDidLoad SLSettingTableViewController");
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear: animated];
    
    NSLog(@"viewWillAppear");
    
    NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey: @"selectedColor"];
    
    selectedFont = [[NSUserDefaults standardUserDefaults] objectForKey: @"selectedFont"];
    selectedColor = [NSKeyedUnarchiver unarchiveObjectWithData: colorData];
    
    [[SLShoppingListData sharedInstance] updateColor];
    
    [self.tableView reloadData];
    
}

- (void) viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear: animated];
    
    NSLog(@"Count : %ld", [settingDataArray count]);

}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [settingDataArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *CellIdentifier = @"SettingCell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier forIndexPath: indexPath];
    
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: CellIdentifier];
    }
    
    if (selectedFont > 0) {
        cell.textLabel.font = [UIFont fontWithName: selectedFont size: 15];
    }
    
    cell.textLabel.text = [settingDataArray objectAtIndex: indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"didSelectRowAtIndexPath : %ld", indexPath.row);
    
    self.indexpath = indexPath;
    
    if (indexPath.row == 0) {
        
        [self performSegueWithIdentifier: @"tabSetting" sender:self];
        
    } else if(indexPath.row == 1) {
        
        [self performSegueWithIdentifier: @"colorSetting" sender:self];
        
    } else {
        
        [self performSegueWithIdentifier: @"fontSetting" sender:self];
        
    }
    
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue: (UIStoryboardSegue *)segue sender: (id)sender {
    
    NSLog(@"prepareForSegue: %ld", self.indexpath.row);
}

@end
