//
//  AppDelegate.m
//  LauchAD
//
//  Created by 刘成利 on 2017/2/16.
//  Copyright © 2017年 刘成利. All rights reserved.
//

#import "AppDelegate.h"
#import "LauchADViewController.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    // 1.广告页
    LauchADViewController *lauchADVC = [[LauchADViewController alloc]init];
    // 广告页完毕后进入的根控制器或导航控制器
    lauchADVC.homeRootVC  = [ViewController new];
    lauchADVC.imgUrl      = @"https://store.storeimages.cdn-apple.com/8749/as-images.apple.com/is/image/AppleInc/aos/published/images/i/ph/iphone7/plus/iphone7-plus-silver-select-2016_AV2?wid=175&hei=352&fmt=png-alpha&qlt=95&.v=1471567499972";
    
    
    self.window                    = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor    = [UIColor whiteColor];
    self.window.rootViewController = lauchADVC;
    [self.window makeKeyAndVisible];
 

    // 2.广告页回调,广告结束后执行下面代码
    lauchADVC.eventBlock  = ^(NSInteger tag){
        switch (tag) {
            case 1:{
                NSLog(@"点击广告");
                
                
            }
                break;
            case 2:
                NSLog(@"展示结束or点击跳转");
                
                break;
            case 3:
                NSLog(@"网络异常or超时");
                
                break;
                
            case 4:
                NSLog(@"二级广告页返回事件");
                break;
            default:
                break;
        }
        
    };

    
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
