//
//  StoreData.m
//  POQAPP
//
//  Created by sravan jinna on 26/03/2013.
//  Copyright (c) 2013 POQStudio. All rights reserved.
//

#import "StoreData.h"
#import "ApplicationConstants.h"
#import <CoreLocation/CLAvailability.h>
#import <CoreLocation/CLLocation.h>
//
//@interface StoreData()
//@property (nonatomic, retain) NSObject <StoreRequestDelegate> *delegate;
//
//@end

@implementation StoreData
@dynamic delegate;

- (id)initParserWithDelegate:(NSObject<StoreRequestDelegate> *)aDelegate;{
    self = [super init];
    if (self)
        self.delegate = aDelegate;
    return self;
}

- (void)didRetrieveData;{

    NSError *jsonParsingError = nil;
    NSDictionary *publicTimeline = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonParsingError];
    [self parseRequest:publicTimeline];
    // }
}
#pragma mark -
-(void)getParserRequest:(NSString *)latlon;{
    
    NSString *newUrl = [NSString stringWithFormat:@"%@%@",kURL,latlon];
    //NSString *newUrl = kURL;
    NSURL *url = [NSURL URLWithString:newUrl];
    request=[NSMutableURLRequest requestWithURL:url
                                    cachePolicy:NSURLRequestUseProtocolCachePolicy
                                timeoutInterval:10.0];
	[request setHTTPMethod: @"GET"];
    NSLog(@"Webservice is:%@",url);
    
    [self launch];
}
-(void)parseRequest:(id)inResults;{
    
    NSMutableArray *parsedBodyArray = [[NSMutableArray alloc] init];
    
    for(NSDictionary *mainDict in inResults){
        
        StoreElements *parsed = [[StoreElements alloc] init];
        
        parsed.ID = ([mainDict valueForKey:@"Id"] == [NSNull null]?@"NA":[mainDict valueForKey:@"Id"]);
        parsed.Name = ([mainDict valueForKey:@"Name"] == [NSNull null]?@"NA":[mainDict valueForKey:@"Name"]);
       
        NSLog(@"Name:%@",parsed.Name);
        parsed.Address = ([mainDict valueForKey:@"Address"] == [NSNull null]?@"NA":[mainDict valueForKey:@"Address"]);
        parsed.Address2 = ([mainDict valueForKey:@"Address2"] == [NSNull null]?@"NA":[mainDict valueForKey:@"Address2"]);
        parsed.City = ([mainDict valueForKey:@"City"] == [NSNull null]?@"NA":[mainDict valueForKey:@"City"]);
        parsed.County = ([mainDict valueForKey:@"County"] == [NSNull null]?@"NA":[mainDict valueForKey:@"County"]);
        parsed.Country = ([mainDict valueForKey:@"Country"] == [NSNull null]?@"NA":[mainDict valueForKey:@"Country"]);
         parsed.PostCode = ([mainDict valueForKey:@"PostCode"] == [NSNull null]?@"NA":[mainDict valueForKey:@"PostCode"]);
         parsed.Phone = ([mainDict valueForKey:@"Phone"] == [NSNull null]?@"NA":[mainDict valueForKey:@"Phone"]);
         parsed.Latitude = ([mainDict valueForKey:@"Latitude"] == [NSNull null]?@"NA":[mainDict valueForKey:@"Latitude"]);
         parsed.Longitude = ([mainDict valueForKey:@"Longitude"] == [NSNull null]?@"NA":[mainDict valueForKey:@"Longitude"]);
         parsed.Distance = ([mainDict valueForKey:@"Distance"] == [NSNull null]?@"NA":[mainDict valueForKey:@"Distance"]);
         parsed.MondayOpenTime = ([mainDict valueForKey:@"MondayOpenTime"] == [NSNull null]?@"NA":[mainDict valueForKey:@"MondayOpenTime"]);
         parsed.MondayCloseTime = ([mainDict valueForKey:@"MondayCloseTime"] == [NSNull null]?@"NA":[mainDict valueForKey:@"MondayCloseTime"]);
         parsed.TuesdayOpenTime = ([mainDict valueForKey:@"TuesdayOpenTime"] == [NSNull null]?@"NA":[mainDict valueForKey:@"TuesdayOpenTime"]);
         parsed.TuesdayCloseTime = ([mainDict valueForKey:@"TuesdayCloseTime"] == [NSNull null]?@"NA":[mainDict valueForKey:@"TuesdayCloseTime"]);
         parsed.WednesdayOpenTime = ([mainDict valueForKey:@"WednesdayOpenTime"] == [NSNull null]?@"NA":[mainDict valueForKey:@"WednesdayOpenTime"]);
         parsed.WednesdayCloseTime = ([mainDict valueForKey:@"WednesdayCloseTime"] == [NSNull null]?@"NA":[mainDict valueForKey:@"WednesdayCloseTime"]);
         parsed.ThursdayOpenTime = ([mainDict valueForKey:@"ThursdayOpenTime"] == [NSNull null]?@"NA":[mainDict valueForKey:@"ThursdayOpenTime"]);
         parsed.ThursdayCloseTime = ([mainDict valueForKey:@"ThursdayCloseTime"] == [NSNull null]?@"NA":[mainDict valueForKey:@"ThursdayCloseTime"]);
         parsed.FridayOpenTime = ([mainDict valueForKey:@"FridayOpenTime"] == [NSNull null]?@"NA":[mainDict valueForKey:@"FridayOpenTime"]);
         parsed.FridayCloseTime = ([mainDict valueForKey:@"FridayCloseTime"] == [NSNull null]?@"NA":[mainDict valueForKey:@"FridayCloseTime"]);
         parsed.SaturdayOpenTime = ([mainDict valueForKey:@"SaturdayOpenTime"] == [NSNull null]?@"NA":[mainDict valueForKey:@"SaturdayOpenTime"]);
         parsed.SaturdayCloseTime = ([mainDict valueForKey:@"SaturdayCloseTime"] == [NSNull null]?@"NA":[mainDict valueForKey:@"SaturdayCloseTime"]);
         parsed.SundayOpenTime = ([mainDict valueForKey:@"SundayOpenTime"] == [NSNull null]?@"NA":[mainDict valueForKey:@"SundayOpenTime"]);
         parsed.SundayCloseTime = ([mainDict valueForKey:@"SundayCloseTime"] == [NSNull null]?@"NA":[mainDict valueForKey:@"SundayCloseTime"]);
         parsed.Notes = ([mainDict valueForKey:@"Notes"] == [NSNull null]?@"NA":[mainDict valueForKey:@"Notes"]);
         parsed.VenueType = ([mainDict valueForKey:@"VenueType"] == [NSNull null]?@"NA":[mainDict valueForKey:@"VenueType"]);
          parsed.PictureUrl = ([mainDict valueForKey:@"PictureUrl"] == [NSNull null]?@"NA":[mainDict valueForKey:@"PictureUrl"]);
          parsed.Rating = ([mainDict valueForKey:@"Rating"] == [NSNull null]?@"NA":[mainDict valueForKey:@"Rating"]);
          parsed.VenueUrl = ([mainDict valueForKey:@"VenueUrl"] == [NSNull null]?@"NA":[mainDict valueForKey:@"VenueUrl"]);
          parsed.Neighborhoods = ([mainDict valueForKey:@"Neighborhoods"] == [NSNull null]?@"NA":[mainDict valueForKey:@"Neighborhoods"]);
         parsed.ClosingTime = ([mainDict valueForKey:@"ClosingTime"] == [NSNull null]?@"NA":[mainDict valueForKey:@"ClosingTime"]);
        parsed.TimeLeft = ([mainDict valueForKey:@"TimeLeft"] == [NSNull null]?@"NA":[mainDict valueForKey:@"TimeLeft"]);
        
        [parsedBodyArray addObject:parsed];
    }
    
    if ([self.delegate respondsToSelector:@selector(didGetParsedInfo:)]) {
        [self.delegate didGetParsedInfo:parsedBodyArray];
    }
}

- (void)connection:(NSURLConnection *)aConnection didFailWithError:(NSError *)anError{
    [self.delegate showConnectionError];
}

@end
