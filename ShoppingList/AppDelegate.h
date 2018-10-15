//
//  AppDelegate.h
//  ShoppingList
//
//  Created by Zaw Ye Naing on 2017/07/28.
//  Copyright © 2017 Zaw Ye Naing. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate, UNUserNotificationCenterDelegate>

@property (strong, nonatomic) UIWindow *window;

- (void)addEventsFor3DTouchEvents;

@end

