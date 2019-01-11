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
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] init];
    backButton.title = NSLocalizedString(@"Setting", "");
    self.navigationController.navigationBar.topItem.backBarButtonItem = backButton;
    self.title = NSLocalizedString(@"Font Setting", "");
    fontFamily = [[NSArray alloc] initWithArray:[UIFont familyNames]];
    
    for (NSString *familyName in [UIFont familyNames]){
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
    
    // selectedRow = [[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedIndex"] intValue];

    selectedRow = [[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedIndex"] intValue];
    
    

}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear: animated];
    
    [self.tableView scrollToRowAtIndexPath: [NSIndexPath indexPathForRow: selectedRow inSection: 0] atScrollPosition: UITableViewScrollPositionTop animated: YES];
    
}

#pragma mark - Table view data source

- (NSInteger)tableView: (UITableView *)tableView numberOfRowsInSection: (NSInteger)section {
    
    return [fontFamily count];
    
}


- (UITableViewCell *)tableView: (UITableView *)tableView cellForRowAtIndexPath: (NSIndexPath *)indexPath {
    
    NSString *CellIdentifier = @"fontSettingCell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier forIndexPath: indexPath];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: CellIdentifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
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
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath: indexPath];
	[cell setSelected: YES animated: YES];
	[cell setAccessoryType: UITableViewCellAccessoryCheckmark];
    
    [self.tableView scrollToRowAtIndexPath: [NSIndexPath indexPathForRow: selectedRow inSection: 0] atScrollPosition: UITableViewScrollPositionTop animated: YES];
    
    [[NSUserDefaults standardUserDefaults] setObject:@(selectedRow) forKey: @"selectedIndex"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat: @"%@", [fontFamily objectAtIndex: selectedRow]] forKey: @"selectedFont"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.tableView reloadData];
    
    // [self.navigationController popViewControllerAnimated:YES];
    
}

@end
