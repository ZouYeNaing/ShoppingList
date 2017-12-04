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
    
    colorCode = [[NSArray alloc] initWithObjects:
                 [UIColor colorWithRed:1 green:0 blue:0 alpha:1],
                 [UIColor colorWithRed:1 green:0.25 blue:0 alpha:1],
                 [UIColor colorWithRed:1 green:0.5 blue:0 alpha:1],
                 [UIColor colorWithRed:1 green:0.75 blue:0 alpha:1],
                 [UIColor colorWithRed:1 green:1 blue:0 alpha:1],
                 [UIColor colorWithRed:0.75 green:1 blue:0 alpha:1],
                 [UIColor colorWithRed:0.5 green:1 blue:0 alpha:1],
                 [UIColor colorWithRed:0.25 green:1 blue:0 alpha:1],
                 [UIColor colorWithRed:0 green:1 blue:0 alpha:1],
                 [UIColor colorWithRed:0 green:1 blue:0.25 alpha:1],
                 [UIColor colorWithRed:0 green:1 blue:0.5 alpha:1],
                 [UIColor colorWithRed:0 green:1 blue:0.75 alpha:1],
                 [UIColor colorWithRed:0 green:1 blue:1 alpha:1],
                 [UIColor colorWithRed:0 green:0.75 blue:1 alpha:1],
                 [UIColor colorWithRed:0 green:0.5 blue:1 alpha:1],
                 [UIColor colorWithRed:0 green:0.25 blue:1 alpha:1],
                 [UIColor colorWithRed:0 green:0 blue:1 alpha:1],
                 [UIColor colorWithRed:0.25 green:0 blue:1 alpha:1],
                 [UIColor colorWithRed:0.5 green:0 blue:1 alpha:1],
                 [UIColor colorWithRed:0.75 green:0 blue:1 alpha:1],
                 [UIColor colorWithRed:1 green:0 blue:1 alpha:1],
                 [UIColor colorWithRed:1 green:0 blue:0.75 alpha:1],
                 [UIColor colorWithRed:1 green:0 blue:0.5 alpha:1],
                 [UIColor colorWithRed:1 green:0 blue:0.25 alpha:1],nil];
    
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    // [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    
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
    
    // cell.backgroundColor = [colorCode objectAtIndex: indexPath.row];
    
    NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey: @"myColor"];
    UIColor *color = [NSKeyedUnarchiver unarchiveObjectWithData: colorData];
    
    if([color isEqual: [colorCode objectAtIndex: indexPath.row]]) {
        NSLog(@"Color Equals");
        UIImageView *recipeImageView = (UIImageView *)[cell viewWithTag: 100];
        recipeImageView.image = [UIImage imageNamed: @"checkmark"];
        /*
        cell.contentView.backgroundColor = [UIColor blackColor];
        cell.layer.borderWidth = 0.5f;
        cell.layer.cornerRadius = 5.0f;
         */
    }
    
    cell.contentView.backgroundColor = [colorCode objectAtIndex: indexPath.row];
    
    /*
    UIImageView *recipeImageView = (UIImageView *)[cell viewWithTag: 100];
    recipeImageView.backgroundColor = [colorCode objectAtIndex: indexPath.row];
     */
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"didSelectItemAtIndexPath: %@", [NSString stringWithFormat: @"%@", [colorCode objectAtIndex: indexPath.row]]);
    
    NSData *colorData = [NSKeyedArchiver archivedDataWithRootObject: [colorCode objectAtIndex: indexPath.row]];
    [[NSUserDefaults standardUserDefaults] setObject: colorData forKey: @"myColor"];
    
    [self updateColor];
    
    [self.navigationController popViewControllerAnimated: YES];
    
}

- (void)updateColor {
    
    NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey: @"myColor"];
    UIColor *color = [NSKeyedUnarchiver unarchiveObjectWithData: colorData];
    NSLog(@"UIColor : %@", color);
    if (color) {
        
        [[UINavigationBar appearance] setTintColor: color];
        [[UITextView appearance]      setTintColor: color];
        // [[UITabBar appearance]        setBarTintColor: color];
        [[UITabBar appearance]        setTintColor: color];
        self.tabBarController.tabBar.tintColor = color;
        self.navigationController.navigationBar.tintColor = color;
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
