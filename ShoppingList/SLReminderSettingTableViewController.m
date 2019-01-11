//
//  SLReminderSettingTableViewController.m
//  ShoppingList
//
//  Created by zawyenaing on 2018/10/05.
//  Copyright © 2018 Zaw Ye Naing. All rights reserved.
//
#import <UserNotifications/UserNotifications.h>
#import "SLReminderSettingTableViewController.h"

@interface SLReminderSettingTableViewController ()
{
    NSMutableArray *reminderInfoArray;
    BOOL isReminderVisible;
    UIColor *switchColor;
    UIPickerView *datetimePicker;
    UITextField *datePickerTextfield;
    UISwitch *switchView;
    NSDateFormatter *dateFormatter;
    UNUserNotificationCenter *center;
}

@end

@implementation SLReminderSettingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] init];
    backButton.title = NSLocalizedString(@"Setting", "");
    self.navigationController.navigationBar.topItem.backBarButtonItem = backButton;
    
    self.title = NSLocalizedString(@"Reminder", "");
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEE MMM dd HH:mm"];
    dateFormatter.timeStyle = NSDateFormatterShortStyle;
    dateFormatter.dateStyle = NSDateFormatterShortStyle;
    dateFormatter.doesRelativeDateFormatting = YES;
    
    datetimePicker = [[UIPickerView alloc] init];

    //UISwitchColor
    NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey: @"selectedColor"];
    switchColor = [NSKeyedUnarchiver unarchiveObjectWithData: colorData];
    
    self.editing = YES;
    self.tableView.allowsSelectionDuringEditing = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    
    reminderInfoArray = [[[NSUserDefaults standardUserDefaults] objectForKey:@"reminderInfo"] mutableCopy];
    if([[reminderInfoArray objectAtIndex: 0][@"status"] boolValue] == YES) {
        [switchView setOn: YES animated: NO];
        isReminderVisible = YES;
        center = [UNUserNotificationCenter currentNotificationCenter];
//        center.delegate = self;
    } else {
        [switchView setOn: NO animated: NO];
        isReminderVisible = NO;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

-(void)reminderSwitchChanged: (id)sender {
    
    NSMutableDictionary *changeStatus = [[reminderInfoArray objectAtIndex:0] mutableCopy];
    NSMutableDictionary *changeReminderDetail = [[reminderInfoArray objectAtIndex:1] mutableCopy];
    UISwitch *switchControl = sender;
    
    BOOL switchStatus = switchControl.on;
    if (switchStatus) {
        center = [UNUserNotificationCenter currentNotificationCenter];
//        center.delegate = self;
        isReminderVisible = YES;
        [changeStatus setValue: @YES forKey: @"status"];
    } else {
        [center removeAllPendingNotificationRequests];
        isReminderVisible = NO;
        [changeStatus setValue: @NO forKey: @"status"];
        [changeReminderDetail setValue:@"" forKey:@"detail"];
    }
    [reminderInfoArray replaceObjectAtIndex:0 withObject:changeStatus];
    [reminderInfoArray replaceObjectAtIndex:1 withObject:changeReminderDetail];
    
    [[NSUserDefaults standardUserDefaults] setValue:[reminderInfoArray mutableCopy] forKey:@"reminderInfo"];
    [self.tableView reloadData];
}

-(void)doneClicked:(id)sender {
    
    NSLog(@"Keyboard Done Clicked.");
    NSMutableDictionary *changeStatus = [[reminderInfoArray objectAtIndex:1] mutableCopy];
    NSDate *remindDate = [changeStatus objectForKey:@"detail"];
    
    if ([remindDate isKindOfClass:[NSDate class]]) {
        [datePickerTextfield resignFirstResponder];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Reminder", "")
                                                                                 message:[NSString stringWithFormat:NSLocalizedString(@"Remind me at %@", ""), [dateFormatter stringFromDate:remindDate]]
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {
                                                             
         NSDateComponents *triggerDate = [[NSCalendar currentCalendar] components:NSCalendarUnitYear + NSCalendarUnitMonth + NSCalendarUnitDay + NSCalendarUnitHour + NSCalendarUnitMinute fromDate:remindDate];
         UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:triggerDate repeats:NO];
         
         UNMutableNotificationContent *localNotification = [UNMutableNotificationContent new];
         localNotification.title = [NSString localizedUserNotificationStringForKey:@"Reminder" arguments:nil];
         localNotification.body  = [NSString localizedUserNotificationStringForKey:@"Let's me remind you." arguments:nil];
         localNotification.sound = [UNNotificationSound defaultSound];
         
         UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"Reminder" content:localNotification trigger:trigger];
         [self->center removeAllPendingNotificationRequests];
//         self->center.delegate = self;
         [self->center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
             if (nil == error) {
                 NSLog(@"Notification created");
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [self->reminderInfoArray replaceObjectAtIndex:1 withObject:changeStatus];
                     [[NSUserDefaults standardUserDefaults] setValue:[self->reminderInfoArray mutableCopy] forKey:@"reminderInfo"];
                 });
                 
             }
         }];
                                                         }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", "") style:UIAlertActionStyleCancel
                                                             handler:^(UIAlertAction * action) {
                                                                 dispatch_async(dispatch_get_main_queue(),
                                                                                ^{
                                                                                    [self->datePickerTextfield becomeFirstResponder];
                                                                                }
                                                                                );
                                                             }];
        [alertController addAction:okAction];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
    } else {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Warning", "")
                                                                                 message:NSLocalizedString(@"Please select date & time", "")
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {
                                                         }];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
}

- (void)dateIsChanged:(id)sender{
    
    UIDatePicker *datePicker = (UIDatePicker *)sender;
    NSMutableDictionary *changeStatus = [[reminderInfoArray objectAtIndex:1] mutableCopy];
    
    NSString *changedDate = [dateFormatter stringFromDate:datePicker.date];
    NSString *nowDate         = [dateFormatter stringFromDate:[NSDate date]];
    
    if ([changedDate isEqualToString:nowDate]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Warning", "")
                                                                                 message:NSLocalizedString(@"Please choose different from current date & time.", "")
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {
                                                         }];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    } else {
        [changeStatus setValue:datePicker.date forKey:@"detail"];
        
        [reminderInfoArray replaceObjectAtIndex:1 withObject:changeStatus];
        [self.tableView reloadData];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return reminderInfoArray.count;
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
        
        if([[reminderInfoArray objectAtIndex: indexPath.row][@"status"] boolValue] == YES) {
            [switchView setOn: YES animated: NO];
        } else {
            [switchView setOn: NO animated: NO];
        }
        cell.textLabel.text = NSLocalizedString(@"Enable", "");
        
    } else if (indexPath.row == 1){
        
        NSDate *date              = [reminderInfoArray objectAtIndex:indexPath.row][@"detail"];
        cell.textLabel.text       = NSLocalizedString(@"Reminder me at", "");
        cell.detailTextLabel.text = [dateFormatter stringFromDate:date];
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
                               [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"Done", "") style:UIBarButtonItemStyleDone target:self action:@selector(doneClicked:)],
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
        datePickerTextfield = tf;
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
    }
    return height;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView *footerView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, self.view.frame.size.width, 40)];
    
    UILabel *detailLabel = [[UILabel alloc] initWithFrame: CGRectMake(10, 0, self.view.frame.size.width - 20, 40)];
    detailLabel.textColor = [UIColor grayColor];
    detailLabel.numberOfLines = 0;
    detailLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    detailLabel.text = NSLocalizedString(@"Reminder", "");
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
