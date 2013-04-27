//
//  DownloadLightWeight.m
//  POQAPP
//
//  Created by sravan jinna on 15/04/2013.
//  Copyright (c) 2013 POQStudio. All rights reserved.
//

#import "DownloadLightWeight.h"

@implementation DownloadLightWeight

@synthesize url;
@synthesize product;
@synthesize position;
@synthesize cacheManager;
@synthesize large;

-(void) fetch {
	NSURLRequest *request = [NSURLRequest requestWithURL:url];
	connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	imageData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[imageData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	UIImage *image = [UIImage imageWithData:imageData];
	
	if ([imageData length] > 0 && image) {
		if (large) {
			[cacheManager cacheLargeImage:image
                              forProduct:product
                               atPosition:position];
		} else {
			[cacheManager cacheImage:image
						 forProduct:product
						  atPosition:position];
		}
        
	} else {
		[cacheManager cacheImage:[UIImage imageNamed:@"noimage.png"]
					 forProduct:product
					  atPosition:position];
	}
}


@end
