//
//  LoadingVC.h
//  POQAPP
//
//  Created by sravan jinna on 08/03/2013.
//  Copyright (c) 2013 POQStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface LoadingVC : UIViewController {
    
    IBOutlet UIActivityIndicatorView *activityIndicator;
    IBOutlet UIView *tempView;
    
}

@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activity;
@property (nonatomic, retain) IBOutlet UIView *tempView;

- (void) activityIndicatorStart;
- (void) activityIndicatorStop;

@end
