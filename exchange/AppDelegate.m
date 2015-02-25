//
//  AppDelegate.m
//  exchange
//
//  Created by Doupan Guo on 2/20/15.
//  Copyright (c) 2015 Doupan Guo. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate () <UITabBarControllerDelegate>

@property (nonatomic, strong) UIViewController *postVc;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidLogin) name:DidLoginNotificationKey object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidLogout) name:DidLogoutNotificationKey object:nil];
    
    [Parse setApplicationId:ParseAppId clientKey:ParseClientKey];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    PFUser *user = [PFUser currentUser];
    UIViewController * vc;
    if (user == nil) {
        vc = [[LoginViewController alloc] init];
        self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:vc];
    } else {
        [self userDidLogin];
    }
   
   
    [self.window makeKeyAndVisible];
    

    return YES;
}

- (void)userDidLogin {
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    HomeViewController* vc1 = [[HomeViewController alloc] init];
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc1];
    self.postVc = [[PostViewController alloc] init];
    ProfileViewController *profileVc = [[ProfileViewController alloc] init];
    profileVc.user = [PFUser currentUser];
    
    NSArray* controllers = [NSArray arrayWithObjects:nvc, self.postVc, profileVc, nil];
    tabBarController.viewControllers = controllers;
    tabBarController.delegate = self;
    self.window.rootViewController = tabBarController;
    
    UIColor *customColor = [UIColor colorWithRed:199.0/255.0 green:89.0/255.0 blue:92.0/255.0 alpha:1];
    [[UITabBar appearance] setTintColor:customColor];
    [[UINavigationBar appearance] setBarTintColor:customColor];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    if (viewController == self.postVc) {
//        viewController.modalPresentationStyle = UIModalPresentationFormSheet;
//        viewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
//        [tabBarController presentViewController:viewController animated:YES completion:nil];
//        NSLog(@"post");
        return YES;
    }
    return YES;
    
}

- (void)userDidLogout {
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:[[LoginViewController alloc] init]];
    self.window.rootViewController = nvc;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
