//
//  StoreData.h
//  POQAPP
//
//  Created by sravan jinna on 26/03/2013.
//  Copyright (c) 2013 POQStudio. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "StoreElements.h"
#import "StoreRequestManager.h"

@protocol StoreRequestDelegate  <NSObject>

@optional

- (void) didGetParsedInfo:(NSMutableArray *)inBody;

@end

@interface StoreData : StoreRequestManager {
    
}

//@property (nonatomic, retain) NSObject <StoreRequestDelegate> *delegate;

- (id)initParserWithDelegate:(NSObject<StoreRequestDelegate> *)aDelegate;
- (void)didRetrieveData;

#pragma mark -

-(void)getParserRequest;
//-(void)parseRequest:(id)inResults;

@end
