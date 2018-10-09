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
    BOOL isPickerVisible, isReminderVisible;
    UIColor *switchColor;
    UIPickerView *datetimePicker;
    UISwitch *switchView;
    NSDateFormatter *dateFormatter;
}

@end

@implementation SLReminderSettingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEE MMM dd HH:mm"];
    dateFormatter.timeStyle = NSDateFormatterShortStyle;
    dateFormatter.dateStyle = NSDateFormatterShortStyle;
    dateFormatter.doesRelativeDateFormatting = YES;
    
    datetimePicker = [[UIPickerView alloc] init];

    //UISwitchColor
    NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey: @"selectedColor"];
    switchColor = [NSKeyedUnarchiver unarchiveObjectWithData: colorData];
    
    NSDictionary *dict1 = @{@"title": @"Reminder", @"status": @YES, @"detail":@""};
    NSDictionary *dict2 = @{@"title": @"Date Time", @"status": @YES, @"detail":[dateFormatter stringFromDate:[NSDate date]]};
    reminderArray = [@[dict1, dict2] mutableCopy];
    
    self.editing = YES;
    self.tableView.allowsSelectionDuringEditing = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    
    isReminderVisible = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    

}

-(void)reminderSwitchChanged: (id)sender {
    
    NSMutableDictionary *changeStatus = [[reminderArray objectAtIndex:0] mutableCopy];
    UISwitch *switchControl = sender;
    
    int rowIndex = (int)[switchControl tag];
    BOOL switchStatus = switchControl.on;
    if (switchStatus) {
        isReminderVisible = YES;
        [changeStatus setValue: @YES forKey: @"status"];
    } else {
        isReminderVisible = NO;
        [changeStatus setValue: @NO forKey: @"status"];
    }
    [reminderArray replaceObjectAtIndex:0 withObject:changeStatus];
    [self.tableView reloadData];
    NSLog(@"rowIndex : %d", rowIndex);
}

-(void)doneClicked:(id)sender {
    NSLog(@"Keyboard Done Clicked.");
    [self.view endEditing:YES];
}

- (void)dateIsChanged:(id)sender{
    
    UIDatePicker *datePicker = (UIDatePicker *)sender;
    NSString *dateString = [dateFormatter stringFromDate:datePicker.date];
    
    NSMutableDictionary *changeStatus = [[reminderArray objectAtIndex:1] mutableCopy];
    [changeStatus setValue:dateString forKey:@"detail"];
    
    [reminderArray replaceObjectAtIndex:1 withObject:changeStatus];
    [self.tableView reloadData];
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
        
        switchView   = [[UISwitch alloc] initWithFrame: CGRectMake(800, 13, 175, 30)];
        switchView.tintColor   = switchColor;
        switchView.onTintColor = switchColor;
        cell.editingAccessoryView = switchView;
        
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
        cell.detailTextLabel.text = [reminderArray objectAtIndex:indexPath.row][@"detail"];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 1) {
        
        UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 50)];
        numberToolbar.barStyle = UIBarStyleDefault;
        numberToolbar.items = [NSArray arrayWithObjects:
                               [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil],
                               [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                               [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneClicked:)],
                               nil];
        [numberToolbar sizeToFit];

        
        UITextField *tf = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        UIDatePicker *datePicker = [[UIDatePicker alloc] init];
        datePicker.datePickerMode = UIDatePickerModeDateAndTime;
        datePicker.backgroundColor = UIColor.whiteColor;
        datePicker.minimumDate = [NSDate date];
        
        [datePicker setValue:switchColor forKey:@"textColor"];
        [datePicker addTarget:self action:@selector(dateIsChanged:) forControlEvents:UIControlEventValueChanged];
        tf.inputView = datePicker;
        tf.inputAccessoryView = numberToolbar;
        
        
        [self.view addSubview:tf];
        [tf becomeFirstResponder];
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    CGFloat height = self.tableView.rowHeight;
    if (indexPath.row == 0){
        height = 40.0f;
    } else if (indexPath.row == 1) {
        height = isReminderVisible ? 40.0f : 0.0f;
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
