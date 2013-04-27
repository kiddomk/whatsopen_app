//
//  GlobalSettings.h
//  POQ
//
//  Created by sravan jinna on 17/10/2012.
//  Copyright (c) 2012 poqstudio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ApplicationMacros.h"

extern NSString *CategoriesChangedNotification;

@interface GlobalSettings : NSObject {
    
}

+(BOOL)validateEmail: (NSString *) email;
+ (NSString *)getUUID;
+ (UIButton *) customNavBackButton;
+ (NSString *)createUUID;


@end
