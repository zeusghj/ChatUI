//
//  AppDelegate.m
//  ChatUI
//
//  Created by 郭洪军 on 9/14/16.
//  Copyright © 2016 Guo Hongjun. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _window.backgroundColor = [UIColor whiteColor];
    [_window makeKeyAndVisible];
    
    MainViewController* mainController = [[MainViewController alloc] init];
    UINavigationController* mainNavi = [[UINavigationController alloc] initWithRootViewController:mainController];
    [_window setRootViewController:mainNavi];
    
    return YES;
}


@end
