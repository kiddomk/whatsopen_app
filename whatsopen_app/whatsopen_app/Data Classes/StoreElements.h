//
//  StoreElements.h
//  POQAPP
//
//  Created by sravan jinna on 26/03/2013.
//  Copyright (c) 2013 POQStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StoreElements : NSObject {
    
    NSString *ID;
    NSString *Name;
    NSString *Address;
    NSString *Address2;
    NSString *City;
    NSString *County;
    NSString *Country;
    NSString *PostCode;
    NSString *Phone;
    NSString *Latitude;
    NSString *Longitude;
    NSString *Distance;
    NSString *MondayOpenTime;
    NSString *MondayCloseTime;
    NSString *TuesdayOpenTime;
    NSString *TuesdayCloseTime;
    NSString *WednesdayOpenTime;
    NSString *WednesdayCloseTime;
    NSString *ThursdayOpenTime;
    NSString *ThursdayCloseTime;
    NSString *FridayOpenTime;
    NSString *FridayCloseTime;
    NSString *SaturdayOpenTime;
    NSString *SaturdayCloseTime;
    NSString *SundayOpenTime;
    NSString *SundayCloseTime;
    NSString *Notes;
    NSString *VenueType;
    NSString *PictureUrl;
    NSString *Rating;
    NSString *VenueUrl;
    NSString *Neighborhoods;
//VenueType: "Pub",
//PictureUrl: "http://s3-media2.ak.yelpcdn.com/bphoto/rn3V0QThjFerfzWZuv5gOQ/l.jpg",
//Rating: 4,
//VenueUrl: "http://www.yelp.co.uk/biz/tin-pan-alley-london",
//Neighborhoods: "Soho",
}

@property (nonatomic, retain) NSString *ID;
@property (nonatomic, retain) NSString *Name;
@property (nonatomic, retain) NSString *Address;
@property (nonatomic, retain) NSString *Address2;
@property (nonatomic, retain) NSString *City;
@property (nonatomic, retain) NSString *County;
@property (nonatomic, retain) NSString *Country;
@property (nonatomic, retain) NSString *PostCode;
@property (nonatomic, retain) NSString *Phone;
@property (nonatomic, retain) NSString *Latitude;
@property (nonatomic, retain) NSString *Longitude;
@property (nonatomic, retain) NSString *Distance;
@property (nonatomic, retain) NSString *MondayOpenTime;
@property (nonatomic, retain) NSString *MondayCloseTime;
@property (nonatomic, retain) NSString *TuesdayOpenTime;
@property (nonatomic, retain) NSString *TuesdayCloseTime;
@property (nonatomic, retain) NSString *WednesdayOpenTime;
@property (nonatomic, retain) NSString *WednesdayCloseTime;
@property (nonatomic, retain) NSString *ThursdayOpenTime;
@property (nonatomic, retain) NSString *ThursdayCloseTime;
@property (nonatomic, retain) NSString *FridayOpenTime;
@property (nonatomic, retain) NSString *FridayCloseTime;
@property (nonatomic, retain) NSString *SaturdayOpenTime;
@property (nonatomic, retain) NSString *SaturdayCloseTime;
@property (nonatomic, retain) NSString *SundayOpenTime;
@property (nonatomic, retain) NSString *SundayCloseTime;
@property (nonatomic, retain) NSString *Notes;
@property (nonatomic, retain) NSString *VenueType;
@property (nonatomic, retain) NSString *PictureUrl;
@property (nonatomic, retain) NSString *Rating;
@property (nonatomic, retain) NSString *VenueUrl;
@property (nonatomic, retain) NSString *Neighborhoods;

@end
