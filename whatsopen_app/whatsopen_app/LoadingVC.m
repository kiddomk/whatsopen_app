//
//  LoadingVC.m
//  POQAPP
//
//  Created by sravan jinna on 08/03/2013.
//  Copyright (c) 2013 POQStudio. All rights reserved.
//

#import "LoadingVC.h"

@interface LoadingVC ()

@end

@implementation LoadingVC
@synthesize activity;
@synthesize tempView;


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.layer.cornerRadius = 5;
    self.view.layer.masksToBounds = YES;
}

- (void) activityIndicatorStart {
    
    [activity startAnimating];
}

- (void) activityIndicatorStop {
    
    [activity stopAnimating];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
