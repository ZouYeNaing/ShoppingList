//
//  SLMainTableViewController.m
//  ShoppingList
//
//  Created by Zaw Ye Naing on 2017/07/29.
//  Copyright © 2017 Zaw Ye Naing. All rights reserved.
//

#import "SLMainTableViewController.h"
#import "SLEditViewController.h"
#import "SLAddViewController.h"
#import "SLShoppingListData.h"
#import "SLTabMManager.h"
#import "AppDelegate.h"

@interface SLMainTableViewController ()
{
    NSMutableArray *mainVCArray;
    NSString *fontStyle;
    UILongPressGestureRecognizer *longPressRecognizer;
    
    UIBarButtonItem *singleDelete;
    UIBarButtonItem *doneDelete;
    
    UIBarButtonItem *barButtonItem0;
    UIBarButtonItem *barButtonItem1;
    
    UIBarButtonItem *barButtonItem;
    
    UIColor *color;
    
    int selectedTabIndex;
}

@end

@implementation SLMainTableViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    NSLog(@"viewDidLoad");
    
    self.editing = YES;
    self.tableView.allowsSelectionDuringEditing = YES;
    
    doneDelete     = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemDone
                                                                   target: self
                                                                   action: @selector(doneDeleteAction:)];
    singleDelete   = self.navigationController.topViewController.navigationItem.leftBarButtonItem;
    barButtonItem0 = self.navigationController.topViewController.navigationItem.rightBarButtonItems[0];
    barButtonItem1 = self.navigationController.topViewController.navigationItem.rightBarButtonItems[1];
    
    UIViewController *vc = [[SLShoppingListData sharedInstance].tabBarController.viewControllers objectAtIndex: [SLShoppingListData sharedInstance].tabBarController.selectedIndex];
    
    selectedTabIndex = (int)vc.tabBarItem.tag;
    
    // selectedTabIndex = (int)[SLShoppingListData sharedInstance].tabBarController.selectedIndex;
    
    [[SLShoppingListData sharedInstance] createNSDictionary];
    
    if (selectedTabIndex == 0) { // For first tab.
        
        // [SLShoppingListData sharedInstance].SLData0Array  = [NSMutableArray arrayWithContentsOfFile: [[SLShoppingListData sharedInstance] dataFilePath: @"FinalList0"]];
        
        [[SLShoppingListData sharedInstance].SLDict  setValue: [NSMutableArray arrayWithContentsOfFile: [[SLShoppingListData sharedInstance] dataFilePath: @"FinalList0"]]
                                                       forKey: @"List0"];
        
        // if (![SLShoppingListData sharedInstance].SLData0Array) {
        if (![[SLShoppingListData sharedInstance].SLDict objectForKey: @"List0"]) {
            
            NSLog(@"No SLDataArray");
            
            mainVCArray = [NSMutableArray array];
            
            // Yes => Delete
            
            // NSDictionary *newDic2 = @{@"status": [NSNumber numberWithBool: NO], @"data": @"Short Pressed"}.mutableCopy;
            NSDictionary *newDic1 = @{@"status": [NSNumber numberWithBool: NO], @"data": @"Long Pressed"};
            NSDictionary *newDic2 = @{@"status": [NSNumber numberWithBool: NO], @"data": @"Short Pressed"};
            NSDictionary *newDic3 = @{@"status": [NSNumber numberWithBool: YES], @"data": @"Delete Row 1"};
            NSDictionary *newDic4 = @{@"status": [NSNumber numberWithBool: YES], @"data": @"Delete Row 2"};
            
            [mainVCArray addObject: newDic1];
            [mainVCArray addObject: newDic2];
            [mainVCArray addObject: newDic3];
            [mainVCArray addObject: newDic4];
            
            [[SLShoppingListData sharedInstance] setSLDataArray: mainVCArray];
            [self changeTrashButtom: mainVCArray];
            [[SLShoppingListData sharedInstance] saveData];
            
        } else {
            
            NSLog(@"Is SLDataDict");
            
            // mainVCArray = [SLShoppingListData sharedInstance].SLData0Array;
            
            mainVCArray = [[SLShoppingListData sharedInstance].SLDict objectForKey: @"List0"];
            
            NSLog(@"mainVCArray First Tab: %@", mainVCArray);
            
        }
    } else if (selectedTabIndex == 1) { // For second tab.
        
        // [SLShoppingListData sharedInstance].SLData1Array  = [NSMutableArray arrayWithContentsOfFile: [[SLShoppingListData sharedInstance] dataFilePath: @"FinalList1"]];
        
        [[SLShoppingListData sharedInstance].SLDict setValue: [NSMutableArray arrayWithContentsOfFile: [[SLShoppingListData sharedInstance] dataFilePath: @"FinalList1"]]
                                                      forKey: @"List1"];
        
        // if (![SLShoppingListData sharedInstance].SLData1Array) {
        if (![[SLShoppingListData sharedInstance].SLDict objectForKey: @"List1"]) {
            
            NSLog(@"No SLData2Array");
            
            mainVCArray = [NSMutableArray array];
            
            // Yes => Delete
            
            // NSDictionary *newDic2 = @{@"status": [NSNumber numberWithBool: NO], @"data": @"Short Pressed"}.mutableCopy;
            NSDictionary *newDic1 = @{@"status": [NSNumber numberWithBool: NO], @"data": @"Long Pressed"};
            NSDictionary *newDic2 = @{@"status": [NSNumber numberWithBool: NO], @"data": @"Short Pressed"};
            NSDictionary *newDic3 = @{@"status": [NSNumber numberWithBool: YES], @"data": @"Delete Row 1"};
            NSDictionary *newDic4 = @{@"status": [NSNumber numberWithBool: YES], @"data": @"Delete Row 2"};
            
            [mainVCArray addObject: newDic1];
            [mainVCArray addObject: newDic2];
            [mainVCArray addObject: newDic3];
            [mainVCArray addObject: newDic4];
            
            [[SLShoppingListData sharedInstance] setSLDataArray: mainVCArray];
            [self changeTrashButtom: mainVCArray];
            [[SLShoppingListData sharedInstance] saveData];
            
        } else {
            
            NSLog(@"Is SLDataDict");
            
            // mainVCArray = [SLShoppingListData sharedInstance].SLData1Array;
            
            mainVCArray = [[SLShoppingListData sharedInstance].SLDict objectForKey: @"List1"];
            
            NSLog(@"mainVCArray Second Tab: %@", mainVCArray);
            
        }
        
    } else if (selectedTabIndex == 2) { // For third tab.
        
        // [SLShoppingListData sharedInstance].SLData2Array  = [NSMutableArray arrayWithContentsOfFile: [[SLShoppingListData sharedInstance] dataFilePath: @"FinalList2"]];
        
        [[SLShoppingListData sharedInstance].SLDict setValue: [NSMutableArray arrayWithContentsOfFile: [[SLShoppingListData sharedInstance] dataFilePath: @"FinalList2"]]
                                                      forKey: @"List2"];
        
        
        if (![[SLShoppingListData sharedInstance].SLDict objectForKey: @"List2"]) {
            
            NSLog(@"No SLData3Array");
            
            mainVCArray = [NSMutableArray array];
            
            // Yes => Delete
            
            // NSDictionary *newDic2 = @{@"status": [NSNumber numberWithBool: NO], @"data": @"Short Pressed"}.mutableCopy;
            NSDictionary *newDic1 = @{@"status": [NSNumber numberWithBool: NO], @"data": @"Long Pressed"};
            NSDictionary *newDic2 = @{@"status": [NSNumber numberWithBool: NO], @"data": @"Short Pressed"};
            NSDictionary *newDic3 = @{@"status": [NSNumber numberWithBool: YES], @"data": @"Delete Row 1"};
            NSDictionary *newDic4 = @{@"status": [NSNumber numberWithBool: YES], @"data": @"Delete Row 2"};
            
            [mainVCArray addObject: newDic1];
            [mainVCArray addObject: newDic2];
            [mainVCArray addObject: newDic3];
            [mainVCArray addObject: newDic4];
            
            [[SLShoppingListData sharedInstance] setSLDataArray: mainVCArray];
            [self changeTrashButtom: mainVCArray];
            [[SLShoppingListData sharedInstance] saveData];
            
        } else {
            
            NSLog(@"Is SLDataDict");
            
            // mainVCArray = [SLShoppingListData sharedInstance].SLData2Array;
            
            mainVCArray = [[SLShoppingListData sharedInstance].SLDict objectForKey: @"List2"];
            
            
            NSLog(@"mainVCArray Second Tab: %@", mainVCArray);
            
        }
        
    } else { // For second tab.
        
        // [SLShoppingListData sharedInstance].SLData3Array  = [NSMutableArray arrayWithContentsOfFile: [[SLShoppingListData sharedInstance] dataFilePath: @"FinalList3"]];
        
        [[SLShoppingListData sharedInstance].SLDict setValue: [NSMutableArray arrayWithContentsOfFile: [[SLShoppingListData sharedInstance] dataFilePath: @"FinalList3"]]
                                                      forKey: @"List3"];
        
        if (![[SLShoppingListData sharedInstance].SLDict objectForKey: @"List3"]) {
            
            NSLog(@"No SLData4Array");
            
            mainVCArray = [NSMutableArray array];
            
            // Yes => Delete
            
            // NSDictionary *newDic2 = @{@"status": [NSNumber numberWithBool: NO], @"data": @"Short Pressed"}.mutableCopy;
            NSDictionary *newDic1 = @{@"status": [NSNumber numberWithBool: NO], @"data": @"Long Pressed"};
            NSDictionary *newDic2 = @{@"status": [NSNumber numberWithBool: NO], @"data": @"Short Pressed"};
            NSDictionary *newDic3 = @{@"status": [NSNumber numberWithBool: YES], @"data": @"Delete Row 1"};
            NSDictionary *newDic4 = @{@"status": [NSNumber numberWithBool: YES], @"data": @"Delete Row 2"};
            
            [mainVCArray addObject: newDic1];
            [mainVCArray addObject: newDic2];
            [mainVCArray addObject: newDic3];
            [mainVCArray addObject: newDic4];
            
            [[SLShoppingListData sharedInstance] setSLDataArray: mainVCArray];
            [self changeTrashButtom: mainVCArray];
            [[SLShoppingListData sharedInstance] saveData];
            
        } else {
            
            NSLog(@"Is SLDataDict");
            
            // mainVCArray = [SLShoppingListData sharedInstance].SLData3Array;
            
            mainVCArray = [[SLShoppingListData sharedInstance].SLDict objectForKey: @"List3"];
            
            NSLog(@"mainVCArray Second Tab: %@", mainVCArray);
            
        }
        
    }
    
    longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget: self action: @selector(onLongPress:)];
    longPressRecognizer.minimumPressDuration = 1.0f;
    [self.tableView addGestureRecognizer: longPressRecognizer];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear: animated];
    
    NSLog(@"viewWillAppear");
    
    self.title = [[SLTabMManager sharedInstance] getTabBarTitle: selectedTabIndex];
    
    // NSMutableArray *tabSetting = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey: @"Tab"]];
    
    
    
    // [[SLTabMManager sharedInstance] setTabBarTitle: tabSetting];
    /*
    if(tabSetting.count > 0)
    {
        self.title = [tabSetting objectAtIndex: (int)selectedTabIndex][@"data"];
    }
    */
    // [[SLShoppingListData sharedInstance] updateColor];
    
    fontStyle = [[NSUserDefaults standardUserDefaults] objectForKey:@"selectedFont"];
    
    [self.tableView reloadData];
    
}

-(void)viewDidAppear: (BOOL)animated {
    
    [super viewDidAppear: animated];
    
    barButtonItem = self.navigationController.topViewController.navigationItem.rightBarButtonItems[1];
    [SLShoppingListData sharedInstance].trashButtonItem = barButtonItem;
    
    NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey: @"myColor"];
    color = [NSKeyedUnarchiver unarchiveObjectWithData: colorData];
    
    NSLog(@"viewDidAppear");
    
    NSLog(@"get tabdata : %@", [SLShoppingListData sharedInstance].getSLDataArray);
    
    mainVCArray = [SLShoppingListData sharedInstance].getSLDataArray;
    [self changeTrashButtom: mainVCArray];
    
    if (_listAdded.count > 0) {
        
        [self addListData];
        
    } else {
        
        NSLog(@"NO addListData.");
        
    }
    
    if (_listEdited.count > 0 || _EditedText.length > 0) {
        
        NSLog(@"_EditedText. : %@", _EditedText);
        NSLog(@"_listEdited. : %@", _listEdited);
        NSLog(@"_listEdited object at index. : %@", [mainVCArray objectAtIndex: self.indexpath.row]);
        
        [self editListData];
        
    } else {
        NSLog(@"NO addListData.");
    }
}

- (void)changeTrashButtom: (NSArray *)VCArray {
    for (int i=0; i < [VCArray count]; i++) {
        
        if ([[VCArray objectAtIndex: i][@"status"] boolValue] == YES) {
            barButtonItem.enabled = YES;
        } else
        {
            barButtonItem.enabled = NO;
        }
    }
}

- (IBAction)SingleDelete: (id)sender {
    
    NSLog(@"SingleDeleteAction");
    
    self.editing = NO;
    self.navigationItem.leftBarButtonItem = doneDelete;
    self.tableView.allowsSelection = NO;
    
    barButtonItem0.enabled = NO;
    barButtonItem1.enabled = NO;
    
}

-(IBAction) doneDeleteAction: (id)sender
{
    NSLog(@"doneDeleteAction");
    
    self.editing = YES;
    self.navigationItem.leftBarButtonItem = singleDelete;
    self.tableView.allowsSelection = YES;
    
    barButtonItem0.enabled = YES;
    barButtonItem1.enabled = YES;
    
}

- (IBAction)deleteAllList: (id)sender {
    
    NSLog(@"deleteAllList");
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle: nil
                                                                             message: nil
                                                                      preferredStyle: UIAlertControllerStyleActionSheet];
    [alertController addAction: [UIAlertAction actionWithTitle: @"Delete" style: UIAlertActionStyleDefault handler: ^(UIAlertAction *action) {
        [self deleteData];
    }]];
    [alertController addAction: [UIAlertAction actionWithTitle: @"Cancel" style: UIAlertActionStyleCancel handler: ^(UIAlertAction *action) {
        // [self cancelButtonPushed];
    }]];
    
    [self presentViewController: alertController animated: YES completion: nil];
    
}

-(void)deleteData {
    
    NSMutableIndexSet *indexes = [NSMutableIndexSet indexSet];
    
    NSMutableArray *indexArray = [NSMutableArray array];
    
    for (int i=0; i < [mainVCArray count]; i++) {
        
        if ([[mainVCArray objectAtIndex: i][@"status"] boolValue] == YES) {
            
            [indexes addIndex : i];
            
            [indexArray addObject: [NSNumber numberWithInt: i]];
        }
    }
    
    [CATransaction begin];
    [self.tableView setUserInteractionEnabled:NO];
    
    [CATransaction setCompletionBlock:^{
        [self.tableView reloadData];
        [self.tableView setUserInteractionEnabled:YES];
    }];
    
    [self.tableView beginUpdates];
    
    for (int i=0; i < [indexArray count]; i++) {
        NSInteger test = [indexArray[i] integerValue];
        NSLog(@"indexex: %ld", (long)test);
        
        [self.tableView deleteRowsAtIndexPaths: @[[NSIndexPath indexPathForRow: test inSection: 0]]   withRowAnimation: UITableViewRowAnimationFade];
    }
    
    [mainVCArray removeObjectsAtIndexes: indexes];
    [self.tableView endUpdates];
    
    [[SLShoppingListData sharedInstance] setSLDataArray: mainVCArray];
    [self changeTrashButtom: mainVCArray];
    [[SLShoppingListData sharedInstance] saveData];
    
    [CATransaction commit];
    
}


-(void)addListData {
    
    // NSMutableIndexSet *indexes = [NSMutableIndexSet indexSet];
    NSMutableArray *indexArray = [NSMutableArray array];
    
    for (int i=0; i < [_listAdded count]; i++) {
        
        // [indexes addIndex : i];
        [indexArray addObject: [NSNumber numberWithInt: i]];
        
    }
    
    NSLog(@"indexArray : %@", indexArray);
    
    //animation
    
    [CATransaction begin];
    [self.tableView setUserInteractionEnabled:NO];
    
    [CATransaction setCompletionBlock:^{
        
        [self.tableView reloadData];
        [_listAdded removeAllObjects]; // for unconflict adding data.
        
        [self.tableView setUserInteractionEnabled:YES];
    }];
    
    [self.tableView beginUpdates];
    
    for (int i=0; i < [indexArray count]; i++) {
        
        NSInteger addIndex = [indexArray[i] integerValue];
        NSLog(@"indexex: %ld", (long)addIndex);
        
        if ([_listAdded[i] isEqualToString:@""]) {
            
            NSLog(@"Added Empty.");
            
        } else {
            
            [self.tableView insertRowsAtIndexPaths: @[[NSIndexPath indexPathForRow: addIndex inSection: 0]] withRowAnimation:UITableViewRowAnimationTop];
            
            NSMutableDictionary *addList = [NSMutableDictionary dictionary];
            [addList setValue: [NSNumber numberWithBool: NO] forKey: @"status"];
            [addList setValue: _listAdded[i] forKey: @"data"];
            
            [mainVCArray insertObject: addList atIndex: 0];
            
        }
        
    }
    
    [self.tableView endUpdates];
    
    [[SLShoppingListData sharedInstance] setSLDataArray: mainVCArray];
    [self changeTrashButtom: mainVCArray];
    [[SLShoppingListData sharedInstance] saveData];
    
    [CATransaction commit];
    
}

-(void)editListData {
    
    // _EditedText has value;
    if (_EditedText.length > 0) {
        
        // animation.
        [CATransaction begin];
        [self.tableView setUserInteractionEnabled:NO];
        
        [CATransaction setCompletionBlock:^{
            
            [self.tableView reloadData];
            _EditedText = NULL; // for unconflict adding data.
            
            [self.tableView setUserInteractionEnabled:YES];
            
            [self addList];
        }];
        
        [self.tableView beginUpdates];
        // if (i == 0) {
            
            NSMutableDictionary *editList = [NSMutableDictionary dictionary];
            [editList setValue: [mainVCArray objectAtIndex: self.indexpath.row][@"status"] forKey: @"status"];
            [editList setValue: _EditedText forKey: @"data"];
            
            [self.tableView reloadRowsAtIndexPaths: @[[NSIndexPath indexPathForRow: self.indexpath.row inSection: 0]] withRowAnimation:UITableViewRowAnimationFade];
            
            [mainVCArray replaceObjectAtIndex: self.indexpath.row withObject: editList];
            
            // [mainVCArray insertObject: editList atIndex: 0];
            
        // }
        
        [self.tableView endUpdates];
        
        [[SLShoppingListData sharedInstance] setSLDataArray: mainVCArray];
        [self changeTrashButtom: mainVCArray];
        [[SLShoppingListData sharedInstance] saveData];
        
        
        [CATransaction commit];
        
    }
    
    return;
    
    /*
    // for detect edited index.
    NSMutableArray *indexArray = [NSMutableArray array];
    
    for (int i=0; i < [_listEdited count]; i++) {
        
        [indexArray addObject: [NSNumber numberWithInt: i]];
        
    }
    
    // animation.
    [CATransaction begin];
    [self.tableView setUserInteractionEnabled:NO];
    
    [CATransaction setCompletionBlock:^{
        
        [self.tableView reloadData];
        [_listEdited removeAllObjects]; // for unconflict adding data.
        
        [self.tableView setUserInteractionEnabled:YES];
    }];
    
    [self.tableView beginUpdates];
    
    for (int i = 0; i < [indexArray count]; i++) {
        
        NSInteger editIndex = [indexArray[i] integerValue];
        NSLog(@"indexex: %ld", (long)editIndex);
        
        if ([_listEdited[i] isEqualToString:@""]) {
            
            NSLog(@"Edited Empty.");
            
        } else {
            
            / *
            if (i == 0) {
                
                NSMutableDictionary *editList = [NSMutableDictionary dictionary];
                [editList setValue: [mainVCArray objectAtIndex: self.indexpath.row][@"status"] forKey: @"status"];
                [editList setValue: _listEdited[0] forKey: @"data"];
                
                [self.tableView reloadRowsAtIndexPaths: @[[NSIndexPath indexPathForRow: self.indexpath.row inSection: 0]] withRowAnimation:UITableViewRowAnimationFade];
                
                [mainVCArray replaceObjectAtIndex: self.indexpath.row withObject: editList];
                
                // [mainVCArray insertObject: editList atIndex: 0];
                
            } else {
                * /
                
                [self.tableView insertRowsAtIndexPaths: @[[NSIndexPath indexPathForRow: editIndex inSection: 0]] withRowAnimation:UITableViewRowAnimationTop];
                
                NSMutableDictionary *editList = [NSMutableDictionary dictionary];
                [editList setValue: [NSNumber numberWithBool: NO] forKey: @"status"];
                [editList setValue: _listEdited[i] forKey: @"data"];
                
                [mainVCArray insertObject: editList atIndex: 0];
            // }
        }
    }
    
    [self.tableView endUpdates];
    
    [[SLShoppingListData sharedInstance] setSLDataArray: mainVCArray];
    [self changeTrashButtom: mainVCArray];
    [[SLShoppingListData sharedInstance] saveData];
    
    [CATransaction commit];
    */
    
}

- (void)addList {
    // for detect edited index.
    NSMutableArray *indexArray = [NSMutableArray array];
    
    for (int i=0; i < [_listEdited count]; i++) {
        
        [indexArray addObject: [NSNumber numberWithInt: i]];
        
    }
    
    // animation.
    [CATransaction begin];
    [self.tableView setUserInteractionEnabled:NO];
    
    [CATransaction setCompletionBlock:^{
        
        [self.tableView reloadData];
        [_listEdited removeAllObjects]; // for unconflict adding data.
        
        [self.tableView setUserInteractionEnabled:YES];
    }];
    
    [self.tableView beginUpdates];
    
    for (int i = 0; i < [indexArray count]; i++) {
        
        NSInteger editIndex = [indexArray[i] integerValue];
        NSLog(@"indexex: %ld", (long)editIndex);
        
        if ([_listEdited[i] isEqualToString:@""]) {
            
            NSLog(@"Edited Empty.");
            
        } else {
            
            /*
             if (i == 0) {
             
             NSMutableDictionary *editList = [NSMutableDictionary dictionary];
             [editList setValue: [mainVCArray objectAtIndex: self.indexpath.row][@"status"] forKey: @"status"];
             [editList setValue: _listEdited[0] forKey: @"data"];
             
             [self.tableView reloadRowsAtIndexPaths: @[[NSIndexPath indexPathForRow: self.indexpath.row inSection: 0]] withRowAnimation:UITableViewRowAnimationFade];
             
             [mainVCArray replaceObjectAtIndex: self.indexpath.row withObject: editList];
             
             // [mainVCArray insertObject: editList atIndex: 0];
             
             } else {
             */
            
            [self.tableView insertRowsAtIndexPaths: @[[NSIndexPath indexPathForRow: editIndex inSection: 0]] withRowAnimation:UITableViewRowAnimationTop];
            
            NSMutableDictionary *editList = [NSMutableDictionary dictionary];
            [editList setValue: [NSNumber numberWithBool: NO] forKey: @"status"];
            [editList setValue: _listEdited[i] forKey: @"data"];
            
            [mainVCArray insertObject: editList atIndex: 0];
            // }
        }
    }
    
    [self.tableView endUpdates];
    
    [[SLShoppingListData sharedInstance] setSLDataArray: mainVCArray];
    [self changeTrashButtom: mainVCArray];
    [[SLShoppingListData sharedInstance] saveData];
    
    [CATransaction commit];
    

}

- (IBAction)addList: (id)sender {
    
    [self performSegueWithIdentifier: @"showAddViewController" sender: nil];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
}

- (NSInteger)tableView: (UITableView *)tableView numberOfRowsInSection: (NSInteger)section {
    
    return [mainVCArray count];
    
}

- (UITableViewCell *)tableView: (UITableView *)tableView cellForRowAtIndexPath: (NSIndexPath *)indexPath {
    
    NSString *CellIdentifier = @"Cell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier forIndexPath: indexPath];
    
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: CellIdentifier];
    }
    
    if ([[mainVCArray objectAtIndex: indexPath.row][@"status"] boolValue] == YES) {
        
        cell.textLabel.text = nil;
        cell.textLabel.attributedText = [self deletedText: [mainVCArray objectAtIndex: indexPath.row][@"data"]];
        
    } else {
        
        cell.textLabel.attributedText = nil;
        cell.textLabel.text = [mainVCArray objectAtIndex: indexPath.row][@"data"];
        
    }
    if (fontStyle > 0) {
        cell.textLabel.font = [UIFont fontWithName: fontStyle size: 15];
    }
    
    return cell;
}

-(NSAttributedString *)deletedText: (NSString *) deleteString {
    
    
    
    UIFont *font = [UIFont fontWithName:@"HiraKakuProN-W3" size: 15];
    NSDictionary* attributesDict = @{ NSStrikethroughStyleAttributeName: [NSNumber numberWithInt:NSUnderlineStyleSingle],
                                      NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                      NSStrikethroughColorAttributeName: color,
                                      NSFontAttributeName: font};
    
    
    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString: deleteString
                                                                         attributes: attributesDict];
    CGSize size = [attributedText size];
    [attributedText drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    return attributedText;
    
}

-(void)onLongPress: (UILongPressGestureRecognizer*)longPress {
    
    NSLog(@"UILongPressGestureRecognizer");
    
    if (longPress.state != UIGestureRecognizerStateBegan) {
        return;
    }
    
    CGPoint p = [longPress locationInView: self.tableView];
    self.indexpath = [self.tableView indexPathForRowAtPoint: p];
    
    if (self.indexpath == nil) {
        return;
    }
    
    [self performSegueWithIdentifier: @"showEditViewController" sender: nil];
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([[mainVCArray objectAtIndex: indexPath.row][@"status"] boolValue] == NO) {
        
        NSLog(@"NO to YES");
        NSMutableDictionary *changeStatusDict = [NSMutableDictionary dictionary];
        [changeStatusDict setValue: [NSNumber numberWithBool: YES] forKey: @"status"];
        [changeStatusDict setValue: [mainVCArray objectAtIndex: indexPath.row][@"data"] forKey: @"data"];
        
        [CATransaction begin];
        
        [self.tableView setUserInteractionEnabled:NO];
        
        [CATransaction setCompletionBlock:^{
            // animation has finished
            [self.tableView reloadData];
            [self.tableView setUserInteractionEnabled:YES];
        }];
        
        [self.tableView beginUpdates];
        
        if(indexPath.row == 0) {
            
            [self.tableView deleteRowsAtIndexPaths: @[[NSIndexPath indexPathForRow: indexPath.row inSection: 0]] withRowAnimation: UITableViewRowAnimationFade];
            [self.tableView insertRowsAtIndexPaths: @[[NSIndexPath indexPathForRow: mainVCArray.count - 1 inSection: 0]] withRowAnimation: UITableViewRowAnimationFade];
            
        } else if (indexPath.row == [mainVCArray count]-1) {
            
            [self.tableView deleteRowsAtIndexPaths: @[[NSIndexPath indexPathForRow: indexPath.row inSection: 0]] withRowAnimation: UITableViewRowAnimationFade];
            [self.tableView insertRowsAtIndexPaths: @[[NSIndexPath indexPathForRow: mainVCArray.count - 1 inSection: 0]] withRowAnimation: UITableViewRowAnimationFade];
            
        } else {
            
            [self.tableView deleteRowsAtIndexPaths: @[[NSIndexPath indexPathForRow: indexPath.row inSection: 0]] withRowAnimation: UITableViewRowAnimationTop];
            [self.tableView insertRowsAtIndexPaths: @[[NSIndexPath indexPathForRow: mainVCArray.count - 1 inSection: 0]] withRowAnimation: UITableViewRowAnimationTop];
            
        }
        
        [mainVCArray removeObjectAtIndex: indexPath.row];
        [mainVCArray addObject: changeStatusDict];
        
        [self.tableView endUpdates];
        
        [[SLShoppingListData sharedInstance] setSLDataArray: mainVCArray];
        [self changeTrashButtom: mainVCArray];
        [[SLShoppingListData sharedInstance] saveData];
        
        [CATransaction commit];
        
    } else {
        
        NSLog(@"YES to No");
        
        NSMutableDictionary *changeStatusDict = [NSMutableDictionary dictionary];
        [changeStatusDict setValue: [NSNumber numberWithBool: NO] forKey: @"status"];
        [changeStatusDict setValue: [mainVCArray objectAtIndex: indexPath.row][@"data"] forKey: @"data"];
        
        NSLog(@"self index : %ld", (long)indexPath.row);
        NSLog(@"self index : %lu", [mainVCArray count]-1);
        
        [CATransaction begin];
        [self.tableView setUserInteractionEnabled:NO];
        
        [CATransaction setCompletionBlock:^{
            // animation has finished
            [self.tableView reloadData];
            [self.tableView setUserInteractionEnabled:YES];
        }];
        
        [self.tableView beginUpdates];
        
        if (indexPath.row == [mainVCArray count]-1) {
            
            [self.tableView deleteRowsAtIndexPaths: @[[NSIndexPath indexPathForRow: indexPath.row inSection: 0]] withRowAnimation: UITableViewRowAnimationTop];
            [self.tableView insertRowsAtIndexPaths: @[[NSIndexPath indexPathForRow: 0 inSection: 0]] withRowAnimation: UITableViewRowAnimationBottom];
            
        } else if(indexPath.row == 0) {
            
            [self.tableView deleteRowsAtIndexPaths: @[[NSIndexPath indexPathForRow: indexPath.row inSection: 0]] withRowAnimation: UITableViewRowAnimationFade];
            [self.tableView insertRowsAtIndexPaths: @[[NSIndexPath indexPathForRow: 0 inSection: 0]] withRowAnimation: UITableViewRowAnimationFade];
            
        } else {
            
            [self.tableView deleteRowsAtIndexPaths: @[[NSIndexPath indexPathForRow: indexPath.row inSection: 0]] withRowAnimation: UITableViewRowAnimationBottom];
            [self.tableView insertRowsAtIndexPaths: @[[NSIndexPath indexPathForRow: 0 inSection: 0]] withRowAnimation: UITableViewRowAnimationBottom];
            
        }
        [mainVCArray removeObjectAtIndex: indexPath.row];
        [mainVCArray insertObject: changeStatusDict atIndex: 0];
        
        [self.tableView endUpdates];
        
        [[SLShoppingListData sharedInstance] setSLDataArray: mainVCArray];
        [self changeTrashButtom: mainVCArray];
        [[SLShoppingListData sharedInstance] saveData];
        
        [CATransaction commit];
    }
}

- (void)tableView: (UITableView *)tableView moveRowAtIndexPath: (NSIndexPath *)fromIndexPath toIndexPath: (NSIndexPath *)toIndexPath {
    self.tableView.delegate = self;
    if (fromIndexPath != toIndexPath ) {
        
        NSMutableDictionary *toMoveDict = mainVCArray[fromIndexPath.row];
        
        [mainVCArray removeObjectAtIndex: fromIndexPath.row];
        [mainVCArray insertObject: toMoveDict atIndex: toIndexPath.row];
        
        [[SLShoppingListData sharedInstance] setSLDataArray: mainVCArray];
        [self changeTrashButtom: mainVCArray];
        [[SLShoppingListData sharedInstance] saveData];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
        
    }
}


- (BOOL)tableView: (UITableView *)tableview shouldIndentWhileEditingRowAtIndexPath: (NSIndexPath *)indexPath {
    
    return NO;
    
}

- (UITableViewCellEditingStyle)tableView: (UITableView *)tableView editingStyleForRowAtIndexPath: (NSIndexPath *)indexPath {
    
    if (self.editing == YES) {
        return UITableViewCellEditingStyleNone;
        
    } else {
        
        return UITableViewCellEditingStyleDelete;
    }
    
}

- (BOOL)tableView: (UITableView *)tableView canMoveRowAtIndexPath: (NSIndexPath *)indexPath {
    
    return YES;
    
}

-(void)tableView:(UITableView *)tableView commitEditingStyle: (UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        NSLog(@"UITableViewCellEditingStyleDelete");
        NSLog(@"indexpath delete : %ld", (long)indexPath.row);
        
        [mainVCArray removeObjectAtIndex: indexPath.row];
        
        [self.tableView deleteRowsAtIndexPaths: @[[NSIndexPath indexPathForRow: indexPath.row inSection: 0]] withRowAnimation: UITableViewRowAnimationFade];
        
        [[SLShoppingListData sharedInstance] setSLDataArray: mainVCArray];
        [self changeTrashButtom: mainVCArray];
        [[SLShoppingListData sharedInstance] saveData];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }
}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue: (UIStoryboardSegue *)segue sender: (id)sender {
    
    
    if([segue.identifier isEqualToString: @"showEditViewController"]) {
        
        UINavigationController *navController = (UINavigationController*)[segue destinationViewController];
        SLEditViewController *eventsController = (SLEditViewController *)[navController topViewController];
        eventsController.delegate = self;
        [eventsController setIndexpath: self.indexpath];
        eventsController.isEditing = YES;
        
    }else if([segue.identifier isEqualToString: @"showAddViewController"]) {
        
        UINavigationController *navController = (UINavigationController*)[segue destinationViewController];
        SLEditViewController *eventsController = (SLEditViewController *)[navController topViewController];
        eventsController.delegate = self;
        // [eventsController setIndexpath: test];
        eventsController.isEditing = NO;
        
    }
}

#pragma mark - SLAddViewControllerDelegate

/*
-(void)addedList:(NSArray *)list {
    
    _listAdded = list.mutableCopy;
    
}
*/

#pragma mark - SLEditViewControllerDelegate

-(void)editedList:(NSString *)editedText newAdded:(NSArray *)list {
    
    _EditedText  = editedText;
    _listEdited = list.mutableCopy;
}

-(void)addedList:(NSArray *)list {
    
    _listAdded = list.mutableCopy;
    
}


@end
