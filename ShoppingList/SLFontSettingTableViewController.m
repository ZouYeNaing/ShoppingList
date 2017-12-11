//
//  SLFontSettingTableViewController.m
//  ShoppingList
//
//  Created by Zaw Ye Naing on 2017/09/10.
//  Copyright © 2017 Zaw Ye Naing. All rights reserved.
//

#import "SLFontSettingTableViewController.h"

@interface SLFontSettingTableViewController ()
{
    NSArray *fontFamily;
    int selectedRow;
    UIColor *switchColor;
}
@end

@implementation SLFontSettingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    fontFamily = [[NSArray alloc] initWithArray:[UIFont familyNames]];
    
    for (NSString *familyName in [UIFont familyNames]){
        
        NSLog(@"Family name: %@", familyName);
        for (NSString *fontName in [UIFont fontNamesForFamilyName:familyName]) {
            NSLog(@"--Font name: %@", fontName);
        }
    }
    
    NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey: @"selectedColor"];
    switchColor = [NSKeyedUnarchiver unarchiveObjectWithData: colorData];
    
    [[UITableViewCell appearance] setTintColor: switchColor];
    
}

- (void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear: animated];
    
    selectedRow = [[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedIndex"] intValue];
    
    NSLog(@"selected font: %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"selectedFont"]);

}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear: animated];
    
    [self.tableView scrollToRowAtIndexPath: [NSIndexPath indexPathForRow: selectedRow inSection: 0] atScrollPosition: UITableViewScrollPositionTop animated: YES];
    
}

- (void) viewWillDisappear:(BOOL)animated{
    
    [[NSUserDefaults standardUserDefaults] setObject:@(selectedRow) forKey:@"selectedIndex"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat: @"%@", [fontFamily objectAtIndex: selectedRow]] forKey:@"selectedFont"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [fontFamily count];
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *CellIdentifier = @"fontSettingCell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier forIndexPath: indexPath];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: CellIdentifier];
    }
    
    if(indexPath.row == selectedRow){
        
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        
    }
    else{
        cell.accessoryType = UITableViewCellAccessoryNone;

    }
    cell.textLabel.text = [fontFamily objectAtIndex: indexPath.row];
    cell.textLabel.font = [UIFont fontWithName: [fontFamily objectAtIndex: indexPath.row] size:15];
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"didSelectRowAtIndexPath : %@", [fontFamily objectAtIndex: indexPath.row]);
    selectedRow = (int)indexPath.row;
    //[self.tableView reloadData];
    
    [self.navigationController popViewControllerAnimated:YES];
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
