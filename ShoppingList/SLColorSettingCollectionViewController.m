//
//  SLColorSettingCollectionViewController.m
//  ShoppingList
//
//  Created by Zaw Ye Naing on 2017/09/10.
//  Copyright © 2017 Zaw Ye Naing. All rights reserved.
//

#import "SLColorSettingCollectionViewController.h"
#import "SLShoppingListData.h"

@interface SLColorSettingCollectionViewController ()
{
    NSArray *colorCode;
}
@end

@implementation SLColorSettingCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] init];
    backButton.title = @"Setting";
    self.navigationController.navigationBar.topItem.backBarButtonItem = backButton;
    
    colorCode = [[NSArray alloc] initWithObjects:
                 [UIColor colorWithRed:0.56 green:0.56 blue:0.58 alpha:1.0],
                 [UIColor colorWithRed:1 green:0 blue:0.25 alpha:1],
                 [UIColor colorWithRed:1 green:0.5 blue:0 alpha:1],
                 [UIColor colorWithRed:1 green:0.75 blue:0 alpha:1],
                 
                 [UIColor colorWithRed:0.75 green:0 blue:1 alpha:1],
                 [UIColor colorWithRed:1 green:0 blue:0.75 alpha:1],
                 [UIColor colorWithRed:0 green:0 blue:1 alpha:1],
                 [UIColor colorWithRed:0.11 green:0.07 blue:0.44 alpha:1.0],
                 
                 [UIColor colorWithRed:0.00 green:0.59 blue:0.53 alpha:1.0],
                 [UIColor colorWithRed:0.30 green:0.69 blue:0.31 alpha:1.0],
                 [UIColor colorWithRed:0.47 green:0.33 blue:0.28 alpha:1.0],
                 [UIColor colorWithRed:0.00 green:0.00 blue:0.00 alpha:1.0],nil];

    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    // [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
}

- (NSString *)hexStringForColor:(UIColor *)color {
    const CGFloat *components = CGColorGetComponents(color.CGColor);
    CGFloat r = components[0];
    CGFloat g = components[1];
    CGFloat b = components[2];
    NSString *hexString=[NSString stringWithFormat:@"%02X%02X%02X", (int)(r * 255), (int)(g * 255), (int)(b * 255)];
    return hexString;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [colorCode count];
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier: reuseIdentifier forIndexPath: indexPath];
    
    NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey: @"selectedColor"];
    UIColor *color = [NSKeyedUnarchiver unarchiveObjectWithData: colorData];
    
    UIImageView *recipeImageView = (UIImageView *)[cell viewWithTag: 100];
    recipeImageView.image = nil;
    
    if([colorData isEqual: [NSKeyedArchiver archivedDataWithRootObject: [colorCode objectAtIndex: indexPath.row]]]) {
        // UIImageView *recipeImageView = (UIImageView *)[cell viewWithTag: 100];
        recipeImageView.image = [UIImage imageNamed: @"checkmark"];
    }
    
    cell.contentView.backgroundColor = [colorCode objectAtIndex: indexPath.row];
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"didSelectItemAtIndexPath: %@", [NSString stringWithFormat: @"%@", [colorCode objectAtIndex: indexPath.row]]);
    
    NSData *colorData = [NSKeyedArchiver archivedDataWithRootObject: [colorCode objectAtIndex: indexPath.row]];
    [[NSUserDefaults standardUserDefaults] setObject: colorData forKey: @"selectedColor"];
    
//    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath: indexPath];
//    UIImageView *recipeImageView = (UIImageView *)[cell viewWithTag: 100];
//    recipeImageView.image = [UIImage imageNamed: @"checkmark"];
    
    [self updateColor];
    
    [self.collectionView reloadData];
    
    NSString *iconName = [NSString stringWithFormat:@"icon_%@", [self hexStringForColor:[colorCode objectAtIndex: indexPath.row]]];
    if([iconName isEqualToString:@"icon_8E8E93"]) {
        [[UIApplication sharedApplication] setAlternateIconName:nil completionHandler:^(NSError * _Nullable error) {
            if(error) {
                NSLog(@"Error : %@", error.localizedDescription);
            }
        }];
    } else {
        [[UIApplication sharedApplication] setAlternateIconName:[NSString stringWithFormat:@"icon_%@", [self hexStringForColor:[colorCode objectAtIndex: indexPath.row]]] completionHandler:^(NSError * _Nullable error) {
            if(error) {
                NSLog(@"Error : %@", error.localizedDescription);
            }
        }];
    }
}

- (void)updateColor {
    
    NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey: @"selectedColor"];
    UIColor *color = [NSKeyedUnarchiver unarchiveObjectWithData: colorData];
    NSLog(@"UIColor : %@", color);
    if (color) {
        
        [[UINavigationBar appearance] setTintColor: color];
        // [[UINavigationBar appearance] setTitleTextAttributes: @{NSForegroundColorAttributeName: color}];
        [[UITextView appearance]      setTintColor: color];
        // [[UITabBar appearance]        setBarTintColor: color];
        [[UITabBar appearance]        setTintColor: color];
        self.tabBarController.tabBar.tintColor = color;
        self.navigationController.navigationBar.tintColor = color;
        [self.navigationController.navigationBar setTitleTextAttributes: @{NSForegroundColorAttributeName: color}];
    }
}

#pragma mark <UICollectionViewDelegate>

/*
 // Uncomment this method to specify if the specified item should be highlighted during tracking
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
 return YES;
 }
 */

/*
 // Uncomment this method to specify if the specified item should be selected
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
 return YES;
 }
 */

/*
 // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
 return NO;
 }
 
 - (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
 return NO;
 }
 
 - (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
 
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
