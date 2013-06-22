//
//  MasterViewController.m
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
//  The above copyright notice and this permission notice shall be included in
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

#import "MasterViewController.h"
#import "HomeViewController.h"
#import "ClubsViewController.h"
#import "RestaurantsViewController.h"
#import "SettingsViewController.h"
#import "AboutUsViewController.h"
#import <netinet/in.h>
#import <SystemConfiguration/SystemConfiguration.h>

NSString * const MasterViewControllerCellReuseIdentifier = @"MasterViewControllerCellReuseIdentifier";

typedef NS_ENUM(NSUInteger, MasterViewControllerTableViewSectionType) {
    MasterViewControllerTableViewSectionTypeAppearanceTypes,
    MasterViewControllerTableViewSectionTypeControls,
    MasterViewControllerTableViewSectionTypeAbout,
    MasterViewControllerTableViewSectionTypeCount
};

@interface MasterViewController () <MSNavigationPaneViewControllerDelegate>

@property (nonatomic, strong) NSDictionary *paneViewControllerTitles;

@property (nonatomic, strong) NSDictionary *paneViewControllerClasses;


@property (nonatomic, strong) NSDictionary *sectionTitles;
@property (nonatomic, strong) NSArray *tableViewSectionBreaks;

@property (nonatomic, strong) UIBarButtonItem *paneRevealBarButtonItem;

- (void)navigationPaneRevealBarButtonItemTapped:(id)sender;


@end

@implementation MasterViewController

#pragma mark - UIViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar.png"] forBarMetrics:UIBarMetricsDefault];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationPaneViewController.delegate = self;
    
    // Default to the "None" appearance type
    [self transitionToViewController:MSPaneViewControllerTypeHome];
    
    if (![self connectedToNetwork ]) {
        
        
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Network Connection"
														message:@"Your device does not appear to be connected to the network. Please try again when you have network connection"
													   delegate:nil
											  cancelButtonTitle:@"OK"
											  otherButtonTitles:nil];
		
		[alert show];
    }
    
}

#pragma mark - MasterViewController

- (void)initialize
{
    self.paneViewControllerType = NSUIntegerMax;
    self.paneViewControllerTitles = @{
                                      @(MSPaneViewControllerTypeHome) : @"After Hours",
                                      @(MSPaneViewControllerTypeClubs) : @"Clubs",
                                      @(MSPaneViewControllerTypeRestaurants) : @"Restaurants",
                                      @(MSPaneViewControllerTypeControls) : @"Settings",
                                      @(MSPaneViewControllerTypeAboutUs) : @"About Us"
    };
    

    self.paneViewControllerClasses = @{
        @(MSPaneViewControllerTypeHome) : HomeViewController.class,
        @(MSPaneViewControllerTypeClubs): ClubsViewController.class,
        @(MSPaneViewControllerTypeRestaurants):RestaurantsViewController.class,
        @(MSPaneViewControllerTypeControls) : SettingsViewController.class,
        @(MSPaneViewControllerTypeAboutUs) : AboutUsViewController.class
    };


    
    self.sectionTitles = @{
        @(MasterViewControllerTableViewSectionTypeAppearanceTypes) : @"Things near you",
        @(MasterViewControllerTableViewSectionTypeControls) : @"Controls",
        @(MasterViewControllerTableViewSectionTypeAbout) : @"About",
    };
    
    self.tableViewSectionBreaks = @[
        @(MSPaneViewControllerTypeControls),
        @(MSPaneViewControllerTypeAboutUs),
        @(MSPaneViewControllerTypeCount)
    ];
}

- (MSPaneViewControllerType)paneViewControllerTypeForIndexPath:(NSIndexPath *)indexPath
{
    MSPaneViewControllerType paneViewControllerType;
    if (indexPath.section == 0) {
        paneViewControllerType = indexPath.row;
    } else {
        paneViewControllerType = ([self.tableViewSectionBreaks[(indexPath.section - 1)] integerValue] + indexPath.row);
    }
    NSAssert(paneViewControllerType < MSPaneViewControllerTypeCount, @"Invalid Index Path");
    return paneViewControllerType;
}

- (void)transitionToViewController:(MSPaneViewControllerType)paneViewControllerType
{
    if (paneViewControllerType == self.paneViewControllerType) {
        [self.navigationPaneViewController setPaneState:MSNavigationPaneStateClosed animated:YES completion:nil];
        return;
    }
    
    BOOL animateTransition = self.navigationPaneViewController.paneViewController != nil;
    

    Class paneViewControllerClass = self.paneViewControllerClasses[@(paneViewControllerType)];
    NSParameterAssert([paneViewControllerClass isSubclassOfClass:UIViewController.class]);
    UIViewController *paneViewController = (UIViewController *)[[paneViewControllerClass alloc] init];

    
    paneViewController.navigationItem.title = self.paneViewControllerTitles[@(paneViewControllerType)];
    
    //change button
    UIImage *buttonImage = [UIImage imageNamed:@"MSBarButtonIconNavigationPane.png"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:buttonImage forState:UIControlStateNormal];
    button.frame = CGRectMake(00, 0, buttonImage.size.width, buttonImage.size.height);
    [button addTarget:self action:@selector(navigationPaneRevealBarButtonItemTapped:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    self.paneRevealBarButtonItem =customBarItem;
    
    //[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"MSBarButtonIconNavigationPane.png"] style:UIBarButtonItemStylePlain target:self action:@selector(navigationPaneRevealBarButtonItemTapped:)];
    
    
    paneViewController.navigationItem.leftBarButtonItem = self.paneRevealBarButtonItem;
        
    UINavigationController *paneNavigationViewController = [[UINavigationController alloc] initWithRootViewController:paneViewController];
    [self.navigationPaneViewController setPaneViewController:paneNavigationViewController animated:animateTransition completion:nil];
    
    self.paneViewControllerType = paneViewControllerType;
}



- (void)navigationPaneRevealBarButtonItemTapped:(id)sender
{
    [self.navigationPaneViewController setPaneState:MSNavigationPaneStateOpen animated:YES completion:nil];
}



#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return MasterViewControllerTableViewSectionTypeCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return [self.tableViewSectionBreaks[section] integerValue];
    } else {
        return ([self.tableViewSectionBreaks[section] integerValue] - [self.tableViewSectionBreaks[(section - 1)] integerValue]);
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.sectionTitles[@(section)];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MasterViewControllerCellReuseIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MasterViewControllerCellReuseIdentifier];
    }
    MSPaneViewControllerType paneViewControllerType = [self paneViewControllerTypeForIndexPath:indexPath];
    cell.textLabel.text = self.paneViewControllerTitles[@(paneViewControllerType)];
    
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MSPaneViewControllerType paneViewControllerType = [self paneViewControllerTypeForIndexPath:indexPath];
    [self transitionToViewController:paneViewControllerType];
    

    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - MSNavigationPaneViewControllerDelegate

- (void)navigationPaneViewController:(MSNavigationPaneViewController *)navigationPaneViewController didUpdateToPaneState:(MSNavigationPaneState)state
{
    // Ensure that the pane's table view can scroll to top correctly
    self.tableView.scrollsToTop = (state == MSNavigationPaneStateOpen);
}


- (BOOL) connectedToNetwork {
	struct sockaddr_in zeroAddress;
	bzero(&zeroAddress, sizeof(zeroAddress));
	zeroAddress.sin_len = sizeof(zeroAddress);
	zeroAddress.sin_family = AF_INET;
	
	SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr*) &zeroAddress);
	SCNetworkReachabilityFlags flags;
	
	BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
	CFRelease(defaultRouteReachability);
	
	if (!didRetrieveFlags) {
		// can't retrieve flags
		return NO;
	}
	
	BOOL isReachable = flags & kSCNetworkFlagsReachable;
	BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
	
	return (isReachable && !needsConnection) ? YES : NO;
}


@end
