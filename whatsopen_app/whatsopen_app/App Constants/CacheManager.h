//
//  CacheManager.h
//  POQAPP
//
//  Created by sravan jinna on 15/04/2013.
//  Copyright (c) 2013 POQStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kCacheUpdated	@"kCacheUpdated"
#define kFlagUpdated	@"kFlagUpdated"


@interface CacheManager : NSObject {
    
    BOOL caching;
    NSMutableArray *downloadQueue;
    NSMutableDictionary *appCache;
    NSMutableArray *noImageCache;
}

+ (CacheManager *) sharedInstance;

- (UIImage *) imageForProduct:(NSString *)inProduct atPosition:(NSInteger)position;
- (UIImage *) largeImageForProduct:(NSString *)inProduct atPosition:(NSInteger)position;

- (void) cacheImage:(UIImage *) inImage forProduct:(NSString *) inProduct atPosition:(NSInteger)position;
- (void) cacheLargeImage:(UIImage *) inImage forProduct:(NSString *) inProduct atPosition:(NSInteger)position;

- (void) downloadImageFromURL:(NSURL *)imageURL forProduct:(NSString *)inProduct atPosition:(NSInteger)position;
- (void) downloadLargeImageFromURL:(NSURL *)imageURL forProduct:(NSString *)inProduct atPosition:(NSInteger)position;

- (void) clearCache;
- (void) clearMemberCache;

@end
