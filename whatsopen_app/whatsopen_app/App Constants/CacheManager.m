//
//  CacheManager.m
//  POQAPP
//
//  Created by sravan jinna on 15/04/2013.
//  Copyright (c) 2013 POQStudio. All rights reserved.
//

#import "CacheManager.h"
#import "DownloadLightWeight.h"

@implementation CacheManager

static CacheManager *sharedInstance = nil;

+ (CacheManager *) sharedInstance {
	if (!sharedInstance) {
		sharedInstance = [[self alloc] init];
	}
	return sharedInstance;
}

- (id) init
{
    self = [super init];
	if (self)
    {
		// do we have the directory structure that we require?
		BOOL isDir;
		caching = YES;
		
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDirectory = [paths objectAtIndex:0];
        
		NSFileManager *fm = [NSFileManager defaultManager];
		
		NSString *imagesPath = [documentsDirectory stringByAppendingPathComponent:@"Images"];
		NSString *productsPath = [documentsDirectory stringByAppendingPathComponent:@"Products"];
		
		if ([fm fileExistsAtPath:imagesPath isDirectory:&isDir] && !isDir) {
			// something's gone screwy and we've got something that we weren't expecting
			NSLog(@"file exists where our image cache directory should be - directory structure error - going cacheless");
			caching = NO;
		} else if (![fm fileExistsAtPath:imagesPath]) {
            NSError *error;
			//[fm createDirectoryAtPath:imagesPath attributes:nil];
            [fm createDirectoryAtPath:imagesPath withIntermediateDirectories:YES attributes:nil error:&error];
		}
        
		if ([fm fileExistsAtPath:productsPath isDirectory:&isDir] && !isDir) {
			// something's gone screwy and we've got something that we weren't expecting
			NSLog(@"file exists where our profile cache directory should be - directory structure error - going cacheless");
			caching = NO;
		} else if (![fm fileExistsAtPath:productsPath]) {
            NSError *error;
			//[fm createDirectoryAtPath:productsPath attributes:nil];
            [fm createDirectoryAtPath:productsPath withIntermediateDirectories:YES attributes:nil error:&error];
		}
		
		downloadQueue = [[NSMutableArray alloc] initWithCapacity:10];
		appCache = [[NSMutableDictionary alloc] initWithCapacity:20];
		noImageCache = [[NSMutableArray alloc] initWithCapacity:20];
	}
	
	return self;
}

- (UIImage *) imageForProduct:(NSString *)inProduct atPosition:(NSInteger)position {
	UIImage *image = nil;
	
	if (caching) {
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDirectory = [paths objectAtIndex:0];
		NSString *imagePath = [NSString stringWithFormat:@"%@/%@-%d.png",
							   [documentsDirectory stringByAppendingPathComponent:@"Images"],
							   inProduct,
							   position];
		
		if ([[NSFileManager defaultManager] fileExistsAtPath:imagePath]) {
			image = [UIImage imageWithContentsOfFile:imagePath];
		}
		
		
	}
	
	return image;
}

-(UIImage *) largeImageForProduct:(NSString *)inProduct atPosition:(NSInteger)position {
	UIImage *image = nil;
	
	if (caching) {
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDirectory = [paths objectAtIndex:0];
		NSString *imagePath = [NSString stringWithFormat:@"%@/l-%@-%d.jpeg",
							   [documentsDirectory stringByAppendingPathComponent:@"Images"],
							   inProduct,
							   position];
		
		if ([[NSFileManager defaultManager] fileExistsAtPath:imagePath]) {
			image = [UIImage imageWithContentsOfFile:imagePath];
		}
		
		
	}
	
	return image;
}

- (void) cacheImage:(UIImage *)inImage forProduct:(NSString *)inProduct atPosition:(NSInteger)position {
	if (caching) {
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDirectory = [paths objectAtIndex:0];
		NSString *imagePath = [NSString stringWithFormat:@"%@/%@-%d.png",
							   [documentsDirectory stringByAppendingPathComponent:@"Images"],
							   inProduct,
							   position];
        
		NSData *data = UIImageJPEGRepresentation(inImage, 0.9);
		
		if ([[NSFileManager defaultManager] fileExistsAtPath:imagePath]) {
			NSError *error;
			
			[[NSFileManager defaultManager] removeItemAtPath:imagePath error:&error];
		}
        
		[[NSFileManager defaultManager] createFileAtPath:imagePath contents:data attributes:nil];
		[[NSNotificationCenter defaultCenter] postNotificationName:kCacheUpdated object:inProduct];
		
        //		NSLog(@"cache updated for %@", inUsername);
	}
}

- (void) cacheLargeImage:(UIImage *)inImage forProduct:(NSString *)inProduct atPosition:(NSInteger)position {
	if (caching) {
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDirectory = [paths objectAtIndex:0];
		NSString *imagePath = [NSString stringWithFormat:@"%@/l-%@-%d.png",
							   [documentsDirectory stringByAppendingPathComponent:@"Images"],
							   inProduct,
							   position];
		
		NSData *data = UIImageJPEGRepresentation(inImage, 0.9);
		
		if ([[NSFileManager defaultManager] fileExistsAtPath:imagePath]) {
			NSError *error;
			
			[[NSFileManager defaultManager] removeItemAtPath:imagePath error:&error];
		}
		
		[[NSFileManager defaultManager] createFileAtPath:imagePath contents:data attributes:nil];
		[[NSNotificationCenter defaultCenter] postNotificationName:kCacheUpdated object:inProduct];
		
        //		NSLog(@"large cache updated for %@", inUsername);
	}
}

- (void) downloadImageFromURL:(NSURL *)imageURL forProduct:(NSString *)inProduct atPosition:(NSInteger)position {
	DownloadLightWeight *df = [[DownloadLightWeight alloc] init];
	
	df.url = imageURL;
	df.product = inProduct;
	df.position = position;
	df.cacheManager = self;
	
	[df fetch];

}

- (void) downloadLargeImageFromURL:(NSURL *)imageURL forProduct:(NSString *)inProduct atPosition:(NSInteger)position {
	DownloadLightWeight *df = [[DownloadLightWeight alloc] init];
	
	df.url = imageURL;
	df.product = inProduct;
	df.position = position;
	df.cacheManager = self;
	df.large = YES;
	
	[df fetch];
	
}

- (void) clearCache {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
    
	NSString *imagePath = [NSString stringWithFormat:@"%@",
						   [documentsDirectory stringByAppendingPathComponent:@"Images"]];
	
	NSError *error;
	
	[[NSFileManager defaultManager] removeItemAtPath:imagePath error:&error];
}

- (void) clearMemberCache {
	[appCache removeAllObjects];
}



@end
