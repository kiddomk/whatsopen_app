//
//  DownloadLightWeight.h
//  POQAPP
//
//  Created by sravan jinna on 15/04/2013.
//  Copyright (c) 2013 POQStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CacheManager.h"

@interface DownloadLightWeight : NSObject {
    
    NSURL *url;
	NSString *product;
	NSInteger position;
	BOOL large;
	
	CacheManager *cacheManager;
	
	NSURLConnection *connection;
	NSMutableData *imageData;
}

@property(nonatomic,retain)NSURL *url;
@property(nonatomic,retain)NSString *product;
@property(nonatomic,assign)NSInteger position;
@property(nonatomic,assign)BOOL	large;
@property(nonatomic,retain)CacheManager *cacheManager;

-(void) fetch;


@end
