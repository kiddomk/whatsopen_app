//
//  GlobalSettings.m
//  POQ
//
//  Created by sravan jinna on 17/10/2012.
//  Copyright (c) 2012 poqstudio. All rights reserved.
//
#import "GlobalSettings.h"

@implementation GlobalSettings


+(BOOL) validateEmail: (NSString *) email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    BOOL isValid = [emailTest evaluateWithObject:email];
    return isValid;
}

+ (NSString *)getUUID {
    NSString *string = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceUUID"];
    if (string == nil) {
        CFUUIDRef   uuid;
        CFStringRef uuidStr;
        
        uuid = CFUUIDCreate(NULL);
        uuidStr = CFUUIDCreateString(NULL, uuid);
        
        string = [NSString stringWithFormat:@"%@", uuidStr];
        [[NSUserDefaults standardUserDefaults] setObject:string forKey:@"deviceUUID"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        CFRelease(uuidStr);
        CFRelease(uuid);
    }
    
    return string;
}

+(UIButton *) customNavBackButton {
    UIImage *buttonImage = [UIImage imageNamed:@"nav-back.png"];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setImage:buttonImage forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, buttonImage.size.width, buttonImage.size.height);
    return button;
    
}

+ (NSString *)createUUID {
    
    NSString *uIdentifier = [[NSUserDefaults standardUserDefaults] objectForKey:@"Unique identifier for myApp"];
    
    if (!uIdentifier) {
        
        CFUUIDRef uuidRef = CFUUIDCreate(NULL);
        
        CFStringRef uuidStringRef = CFUUIDCreateString(NULL, uuidRef);
        
        CFRelease(uuidRef);
        
        uIdentifier = [NSString stringWithString:(__bridge NSString *)uuidStringRef];
        
        CFRelease(uuidStringRef);
        
        [[NSUserDefaults standardUserDefaults] setObject:uIdentifier forKey:@"Unique identifier for myApp"];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
    
    return uIdentifier;
}

@end

