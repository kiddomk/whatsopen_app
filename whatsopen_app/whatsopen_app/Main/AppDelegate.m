//
//  MSAppDelegate.m
//  MSNavigationPaneViewController
//
//  Created by Eric Horacek on 11/20/12.
//  Copyright (c) 2012-2013 Monospace Ltd. All rights reserved.
//
//  This code is distributed under the terms and conditions of the MIT license.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and thise permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "AppDelegate.h"
#import "MSNavigationPaneViewController.h"
#import "MasterViewController.h"
#import "CacheManager.h"
#import "LoadingVC.h"
#import "HomeViewController.h"
#import "CRNavigationController.h"

@implementation AppDelegate
@synthesize loadingVC;

+ (AppDelegate *)sharedAppDelegate {
    
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

//    self.navigationPaneViewController = [[MSNavigationPaneViewController alloc] init];
//
//    MasterViewController *masterViewController = [[MasterViewController alloc] init];
//    masterViewController.navigationPaneViewController = self.navigationPaneViewController;
//    self.navigationPaneViewController.masterViewController = masterViewController;
    
    HomeViewController *homeViewController =[[HomeViewController alloc]init];
    
//    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    self.window.rootViewController = self.navigationPaneViewController;//homeViewController;//
//    [self.window makeKeyAndVisible];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];

    CRNavigationController *nvc = [[CRNavigationController alloc] initWithRootViewController:homeViewController];
    self.window.rootViewController = nvc;
    
    UIColor *navigationTextColor = [UIColor whiteColor];
    
    self.window.tintColor = navigationTextColor;
    
    [[UINavigationBar appearance] setTitleTextAttributes:@{
                                                           NSForegroundColorAttributeName : navigationTextColor
                                                           }];
    
    return YES;
}

- (void) showLoadingView {
    if (loadingVC==nil) {
        loadingVC = [[LoadingVC alloc] init];
        loadingVC.view.center = self.window.center;
        [self.window addSubview:loadingVC.view];
        [loadingVC activityIndicatorStart];

    }
   }

- (void) hideLoadingView {
    
    [loadingVC activityIndicatorStop];
    [loadingVC.view removeFromSuperview];
}

@end
