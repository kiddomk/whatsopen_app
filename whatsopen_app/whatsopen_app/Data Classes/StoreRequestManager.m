//
//  StoreRequestManager.m
//  POQAPP
//
//  Created by sravan jinna on 26/03/2013.
//  Copyright (c) 2013 POQStudio. All rights reserved.
//

#import "StoreRequestManager.h"

@interface StoreRequestManager()
@property (nonatomic, retain) NSObject <StoreRequestManagerDelegate>  *delegate;

@end

@implementation StoreRequestManager
@synthesize delegate;


- (id)init
{
    self = [super init];
    if (self)
    {
        request = [[NSMutableURLRequest alloc] init];
        data = [[NSMutableData alloc] init];
    }
    return self;
}

- (id)initWithDelegate:(id<StoreRequestManagerDelegate>)caller
{
    self = [self init];
    if (self)
        delegate = caller;
    return self;
}

- (void)connection:(NSURLConnection *)aConnection didFailWithError:(NSError *)anError
{
    [data setLength:0];
    if ([delegate respondsToSelector:@selector(requestManager:didFailWithError:)])
        [delegate requestManager:self didFailWithError:[anError localizedDescription]];
}

- (void)connection:(NSURLConnection *)aConnection didReceiveResponse:(NSHTTPURLResponse *)aResponse {
    response = aResponse;
    if (![self isResponseValid])
    {
        [self cancel];
        if ([delegate respondsToSelector:@selector(requestManager:didFailWithError:)])
            [delegate requestManager:self didFailWithError:[NSString stringWithFormat:@"Invalid response code %i", [response statusCode]]];
    }
    [data setLength:0];
}

- (void)connection:(NSURLConnection *)aConnection didReceiveData:(NSData *)newData
{
    [data appendData:newData];
}

- (BOOL)isResponseValid
{
    NSLog(@"status code -> %i", [response statusCode]);
    if ([response statusCode] == 200)
        return YES;
    return NO;
}

- (void)didRetrieveData {} //overload

- (void)connectionDidFinishLoading:(NSURLConnection *)aConnection
{
    [self didRetrieveData];
    [data setLength:0];
}

- (void)launch
{
    connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection start];
}

- (void)cancel
{
    if (connection != nil)
    {
        [connection cancel];
        connection = nil;
        NSLog(@"Connection canceled");
    }
}

- (void)dealloc
{
    [self cancel];
    
}

@end
