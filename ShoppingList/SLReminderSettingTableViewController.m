//
//  SLReminderSettingTableViewController.m
//  ShoppingList
//
//  Created by zawyenaing on 2018/10/05.
//  Copyright © 2018 Zaw Ye Naing. All rights reserved.
//

#import "SLReminderSettingTableViewController.h"

@interface SLReminderSettingTableViewController ()
{
    NSMutableArray *reminderArray;
    BOOL isPickerVisible;
    UIColor *switchColor;
    UIPickerView *datetimePicker;
}

@end

@implementation SLReminderSettingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    datetimePicker = [[UIPickerView alloc] init];
    
    //UISwitchColor
    NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey: @"selectedColor"];
    switchColor = [NSKeyedUnarchiver unarchiveObjectWithData: colorData];
    
    NSDictionary *dict1 = @{@"title": @"Reminder", @"status": @YES, @"detail":@""};
    NSDictionary *dict2 = @{@"title": @"Date Time", @"status": @YES, @"detail":@""};
    NSDictionary *dict3 = @{@"title": @"", @"status": @YES, @"detail":@""};
    reminderArray = [@[dict1, dict2, dict3] mutableCopy];
    
    self.editing = YES;
    self.tableView.allowsSelectionDuringEditing = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    
    isPickerVisible = NO;
    datetimePicker.hidden = YES;
    datetimePicker.translatesAutoresizingMaskIntoConstraints = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)reminderSwitchChanged: (id)sender {
    
    UISwitch *switchControl = sender;
    int rowIndex = (int)[switchControl tag];

}

- (void)showStatusPickerCell {
    isPickerVisible = YES;
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    datetimePicker.alpha = 0.0f;
    [UIView animateWithDuration:0.25
                     animations:^{
                         self->datetimePicker.alpha = 1.0f;
                     } completion:^(BOOL finished){
                         self->datetimePicker.hidden = NO;
                     }];
}

- (void)hideStatusPickerCell {
    isPickerVisible = NO;
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    [UIView animateWithDuration:0.25
                     animations:^{
                         self->datetimePicker.alpha = 0.0f;
                     }
                     completion:^(BOOL finished){
                         self->datetimePicker.hidden = YES;
                     }];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return reminderArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *CellIdentifier = @"ReminderCell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier forIndexPath: indexPath];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: CellIdentifier];
    }
    
    if (indexPath.row == 0) {
        
        UISwitch *switchView   = [[UISwitch alloc] initWithFrame: CGRectMake(800, 13, 175, 30)];
        cell.editingAccessoryView = switchView;
        switchView.tintColor   = switchColor;
        switchView.onTintColor = switchColor;
        [switchView addTarget: self
                       action: @selector(reminderSwitchChanged:)
             forControlEvents: UIControlEventValueChanged];
        
        if([[reminderArray objectAtIndex: indexPath.row][@"status"] boolValue] == YES) {
            [switchView setOn: YES animated: NO];
        } else {
            [switchView setOn: NO animated: NO];
        }
        cell.textLabel.text = [reminderArray objectAtIndex:indexPath.row][@"title"];
    } else if (indexPath.row == 1){
        
        cell.textLabel.text = [reminderArray objectAtIndex:indexPath.row][@"title"];
        cell.detailTextLabel.text = @"today";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 1) {
        if (isPickerVisible){
            [self hideStatusPickerCell];
        } else {
            [self showStatusPickerCell];
        }
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    CGFloat height = self.tableView.rowHeight;
    if (indexPath.row == 0){

    } else if (indexPath.row == 2) {
        height = isPickerVisible ? 216.0f : 0.0f;
    }
    return height;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView *footerView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, self.view.frame.size.width, 40)];
    
    UILabel *detailLabel = [[UILabel alloc] initWithFrame: CGRectMake(10, 0, self.view.frame.size.width - 20, 40)];
    detailLabel.textColor = [UIColor grayColor];
    detailLabel.numberOfLines = 0;
    detailLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    detailLabel.text = @"Reminder";
    detailLabel.textAlignment = NSTextAlignmentCenter;
    [detailLabel setFont: [UIFont systemFontOfSize: 14]];
    [footerView addSubview: detailLabel];
    
    return footerView;
}

- (UITableViewCellEditingStyle)tableView: (UITableView *)tableView editingStyleForRowAtIndexPath: (NSIndexPath *)indexPath {

    return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView: (UITableView *)tableview shouldIndentWhileEditingRowAtIndexPath: (NSIndexPath *)indexPath {
    
    return NO;
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
