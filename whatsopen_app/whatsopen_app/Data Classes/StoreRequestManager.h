//
//  StoreRequestManager.h
//  POQAPP
//
//  Created by sravan jinna on 26/03/2013.
//  Copyright (c) 2013 POQStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

@class StoreRequestManager;

@protocol StoreRequestManagerDelegate <NSObject>
@optional
- (void)requestManager:(StoreRequestManager *)manager didFailWithError:(NSString *)error;
@end

@interface StoreRequestManager : NSObject {
    
    NSObject <StoreRequestManagerDelegate> *delegate;
    NSMutableURLRequest *request;
    NSMutableData *data;
    NSHTTPURLResponse *response;
    NSURLConnection *connection;
    
}

//@property (nonatomic, retain) NSObject <HomeRequestManagerDelegate>  *delegate;


- (id)initWithDelegate:(NSObject<StoreRequestManagerDelegate> *)delegate;
- (void)launch;
- (void)cancel;
- (BOOL)isResponseValid;
- (void)didRetrieveData;


@end
