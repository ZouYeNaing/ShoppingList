//
//  SLMain2TableViewController.m
//  ShoppingList
//
//  Created by Zaw Ye Naing on 2017/08/19.
//  Copyright © 2017 Zaw Ye Naing. All rights reserved.
//

#import "SLMain2TableViewController.h"
#import "SLEdit2ViewController.h"
#import "SLAdd2ViewController.h"
#import "SLShoppingListData.h"
#import "AppDelegate.h"

@interface SLMain2TableViewController ()
{
    NSMutableArray *MainVCArray;
}

@end

@implementation SLMain2TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    NSLog(@"viewDidLoad");
    
    self.editing = YES;
    self.tableView.allowsSelectionDuringEditing = YES;
    
    [SLShoppingListData sharedInstance].SLData2Array  = [NSMutableArray arrayWithContentsOfFile: [[SLShoppingListData sharedInstance] dataFilePath: @"FinalList2"]];
    
    if (![SLShoppingListData sharedInstance].SLData2Array) {
        
        NSLog(@"No SLData2Array");
        
        MainVCArray = [NSMutableArray array];
        
        // Yes => Delete
        
        // NSDictionary *newDic2 = @{@"status": [NSNumber numberWithBool: NO], @"data": @"Short Pressed"}.mutableCopy;
        NSDictionary *newDic1 = @{@"status": [NSNumber numberWithBool: NO], @"data": @"Long Pressed"};
        NSDictionary *newDic2 = @{@"status": [NSNumber numberWithBool: NO], @"data": @"Short Pressed"};
        NSDictionary *newDic3 = @{@"status": [NSNumber numberWithBool: YES], @"data": @"Delete Row 1"};
        NSDictionary *newDic4 = @{@"status": [NSNumber numberWithBool: YES], @"data": @"Delete Row 2"};
        
        [MainVCArray addObject: newDic1];
        [MainVCArray addObject: newDic2];
        [MainVCArray addObject: newDic3];
        [MainVCArray addObject: newDic4];
        
        [SLShoppingListData sharedInstance].SLData2Array = MainVCArray;
        [[SLShoppingListData sharedInstance] save2Data];
        
    } else {
        
        NSLog(@"Is SLDataDict");
        
        MainVCArray = [SLShoppingListData sharedInstance].SLData2Array;
        
        NSLog(@"MainVCArray: %@", MainVCArray);
        
    }
    
    UILongPressGestureRecognizer *longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget: self action: @selector(onLongPress:)];
    longPressRecognizer.minimumPressDuration = 1.0f;
    [self.tableView addGestureRecognizer: longPressRecognizer];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear: animated];
    
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    UITabBarController *tabBarController = (UITabBarController *)delegate.window.rootViewController;
    NSLog(@"%lu", (unsigned long)tabBarController.selectedIndex);


    
    NSLog(@"viewWillAppear");
    
    MainVCArray = [SLShoppingListData sharedInstance].SLData2Array;
    
    NSLog(@"viewWillAppear, MainVCArray  : %@", MainVCArray);
    
    NSLog(@"viewWillAppear (Main), address  : %p", [SLShoppingListData sharedInstance].SLData2Array);
    
    [self.tableView reloadData];
    
}

-(void)viewDidAppear: (BOOL)animated {
    
    [super viewDidAppear: animated];

    int i = (int)[SLShoppingListData sharedInstance].tabBarController.selectedIndex;
    NSLog(@"tab Main2: %d", i);

    NSLog(@"viewDidAppear");
    
}
- (IBAction)deleteList:(id)sender {
    
    NSLog(@"deleteList");
    
    //
    NSMutableIndexSet *indexes = [NSMutableIndexSet indexSet];
    
    NSMutableArray *indexArray = [NSMutableArray array];
    
    for (int i=0; i < [MainVCArray count]; i++) {
        
        if ([[MainVCArray objectAtIndex: i][@"status"] boolValue] == YES) {
            
            [indexes addIndex : i];
            
            [indexArray addObject: [NSNumber numberWithInt: i]];
        }
    }
    NSLog(@"indexex: %@", indexes);
    NSLog(@"indexArray : %@", indexArray);
    
    /// final
    
    [CATransaction begin];
    [self.tableView setUserInteractionEnabled:NO];
    
    [CATransaction setCompletionBlock:^{
        // animation has finished
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
        [self.tableView setUserInteractionEnabled:YES];
    }];
    
    [self.tableView beginUpdates];
    
    //    [self.tableView deleteRowsAtIndexPaths: @[[NSIndexPath indexPathForRow: indexPath.row inSection: 0]] withRowAnimation: UITableViewRowAnimationBottom];
    
    for (int i=0; i < [indexArray count]; i++) {
        NSInteger test = [indexArray[i] integerValue];
        NSLog(@"indexex: %ld", (long)test);
        
        
        [self.tableView deleteRowsAtIndexPaths: @[[NSIndexPath indexPathForRow: test inSection: 0]]   withRowAnimation: UITableViewRowAnimationFade];
    }
    
    [MainVCArray removeObjectsAtIndexes: indexes];
    
    [self.tableView endUpdates];
    [SLShoppingListData sharedInstance].SLData2Array = MainVCArray;
    [[SLShoppingListData sharedInstance] save2Data];
    
    [CATransaction commit];
    
}
- (IBAction)addList:(id)sender {
    
    [self performSegueWithIdentifier: @"showAdd2ViewController" sender: nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [MainVCArray count];
    
}

- (UITableViewCell *)tableView: (UITableView *)tableView cellForRowAtIndexPath: (NSIndexPath *)indexPath {
    
    NSString *CellIdentifier = @"Cell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier forIndexPath: indexPath];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: CellIdentifier];
    }
    
    if ([[MainVCArray objectAtIndex: indexPath.row][@"status"] boolValue] == YES) {
        
        cell.textLabel.text = nil;
        cell.textLabel.attributedText = [self deletedText: [MainVCArray objectAtIndex: indexPath.row][@"data"]];
        
    } else {
        
        cell.textLabel.attributedText = nil;
        cell.textLabel.text = [MainVCArray objectAtIndex: indexPath.row][@"data"];
        
    }
    
    return cell;
}

-(NSAttributedString *)deletedText: (NSString *) deleteString {
    
    UIFont *font = [UIFont fontWithName:@"HiraKakuProN-W3" size: 15];
    NSDictionary* attributesDict = @{ NSStrikethroughStyleAttributeName: [NSNumber numberWithInt:NSUnderlineStyleSingle],
                                      NSForegroundColorAttributeName: [UIColor redColor],
                                      NSForegroundColorAttributeName: [UIColor redColor],
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
    
    [self performSegueWithIdentifier: @"showEdit2ViewController" sender: nil];
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if ([[MainVCArray objectAtIndex: indexPath.row][@"status"] boolValue] == NO) {
        
        NSLog(@"NO to YES");
        NSMutableDictionary *changeStatusDict = [NSMutableDictionary dictionary];
        [changeStatusDict setValue: [NSNumber numberWithBool: YES] forKey: @"status"];
        [changeStatusDict setValue: [MainVCArray objectAtIndex: indexPath.row][@"data"] forKey: @"data"];
        
        [CATransaction begin];
        
        [self.tableView setUserInteractionEnabled:NO];
        
        [CATransaction setCompletionBlock:^{
            // animation has finished
            [self.tableView reloadData];
            [self.tableView setUserInteractionEnabled:YES];
        }];
        
        [self.tableView beginUpdates];
        
        [self.tableView deleteRowsAtIndexPaths: @[[NSIndexPath indexPathForRow: indexPath.row inSection: 0]] withRowAnimation: UITableViewRowAnimationTop];
        [self.tableView insertRowsAtIndexPaths: @[[NSIndexPath indexPathForRow: MainVCArray.count - 1 inSection: 0]] withRowAnimation: UITableViewRowAnimationTop];
        
        [MainVCArray removeObjectAtIndex: indexPath.row];
        [MainVCArray addObject: changeStatusDict];
        
        [self.tableView endUpdates];
        
        [SLShoppingListData sharedInstance].SLData2Array = MainVCArray;
        [[SLShoppingListData sharedInstance] save2Data];
        
        [CATransaction commit];
        
        
        
    } else {
        
        NSLog(@"YES to No");
        
        NSMutableDictionary *changeStatusDict = [NSMutableDictionary dictionary];
        [changeStatusDict setValue: [NSNumber numberWithBool: NO] forKey: @"status"];
        [changeStatusDict setValue: [MainVCArray objectAtIndex: indexPath.row][@"data"] forKey: @"data"];
        
        NSLog(@"self index : %ld", (long)indexPath.row);
        NSLog(@"self index : %lu", [MainVCArray count]-1);
        
        if (indexPath.row == [MainVCArray count]-1) {
            
            /*
             [MainVCArray removeObjectAtIndex: indexPath.row];
             [MainVCArray insertObject: changeStatusDict atIndex: 0];
             [self.tableView reloadData];
             */
            
            
            [CATransaction begin];
            [self.tableView setUserInteractionEnabled:NO];
            
            [CATransaction setCompletionBlock:^{
                // animation has finished
                [self.tableView reloadData];
                [self.tableView setUserInteractionEnabled:YES];
            }];
            
            [self.tableView beginUpdates];
            
            [self.tableView deleteRowsAtIndexPaths: @[[NSIndexPath indexPathForRow: indexPath.row inSection: 0]] withRowAnimation: UITableViewRowAnimationTop];
            [self.tableView insertRowsAtIndexPaths: @[[NSIndexPath indexPathForRow: 0 inSection: 0]] withRowAnimation: UITableViewRowAnimationBottom];
            
            [MainVCArray removeObjectAtIndex: indexPath.row];
            [MainVCArray insertObject: changeStatusDict atIndex: 0];
            
            [self.tableView endUpdates];
            [SLShoppingListData sharedInstance].SLData2Array = MainVCArray;
            [[SLShoppingListData sharedInstance] save2Data];
            
            [CATransaction commit];
            
            
        } else {
            
            [CATransaction begin];
            [self.tableView setUserInteractionEnabled:NO];
            
            [CATransaction setCompletionBlock:^{
                // animation has finished
                [self.tableView reloadData];
                [self.tableView setUserInteractionEnabled:YES];
            }];
            
            [self.tableView beginUpdates];
            
            [self.tableView deleteRowsAtIndexPaths: @[[NSIndexPath indexPathForRow: indexPath.row inSection: 0]] withRowAnimation: UITableViewRowAnimationBottom];
            [self.tableView insertRowsAtIndexPaths: @[[NSIndexPath indexPathForRow: 0 inSection: 0]] withRowAnimation: UITableViewRowAnimationBottom];
            
            [MainVCArray removeObjectAtIndex: indexPath.row];
            [MainVCArray insertObject: changeStatusDict atIndex: 0];
            
            [self.tableView endUpdates];
            [SLShoppingListData sharedInstance].SLData2Array = MainVCArray;
            [[SLShoppingListData sharedInstance] save2Data];
            
            [CATransaction commit];
    
        }
        
    }
}

- (void)tableView: (UITableView *)tableView moveRowAtIndexPath: (NSIndexPath *)fromIndexPath toIndexPath: (NSIndexPath *)toIndexPath {
    
    if (fromIndexPath != toIndexPath ) {
        
        NSMutableDictionary *toMoveDict = MainVCArray[fromIndexPath.row];
        
        [MainVCArray removeObjectAtIndex: fromIndexPath.row];
        [MainVCArray insertObject: toMoveDict atIndex: toIndexPath.row];
        
        [SLShoppingListData sharedInstance].SLData2Array = MainVCArray;
        [[SLShoppingListData sharedInstance] save2Data];
        // [self.tableView reloadData];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
        
    }
}

- (BOOL)tableView: (UITableView *)tableview shouldIndentWhileEditingRowAtIndexPath: (NSIndexPath *)indexPath {
    
    return NO;
    
}

- (UITableViewCellEditingStyle)tableView: (UITableView *)tableView editingStyleForRowAtIndexPath: (NSIndexPath *)indexPath {
    
    return UITableViewCellEditingStyleNone;
    
}

- (BOOL)tableView: (UITableView *)tableView canMoveRowAtIndexPath: (NSIndexPath *)indexPath {
    
    return YES;
    
}

- (void)prepareForSegue: (UIStoryboardSegue *)segue sender: (id)sender {
    
    if([segue.identifier isEqualToString: @"showEdit2ViewController"]) {
        
        UINavigationController *navController = (UINavigationController*)[segue destinationViewController];
        SLEdit2ViewController *eventsController = (SLEdit2ViewController *)[navController topViewController];
        [eventsController setIndexpath: self.indexpath];
        
    } else if([segue.identifier isEqualToString: @"showAdd2ViewController"]) {
        
        UINavigationController *navController = (UINavigationController*)[segue destinationViewController];
        SLAdd2ViewController *eventsController = (SLAdd2ViewController *)[navController topViewController];
        NSLog(@"eventsController : %@", eventsController);
        
    }
}

@end
