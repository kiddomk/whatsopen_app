//
//  DetailViewController.h
//  whatsopen_app
//
//  Created by Jun Seki on 27/04/2013.
//  Copyright (c) 2013 com.junseki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "StoreElements.h"

@interface DetailViewController : UIViewController <MKMapViewDelegate, UIScrollViewDelegate, CLLocationManagerDelegate> {
    UIImageView *imageView;
    MKMapView *mapView;
    IBOutlet UIScrollView *scrollView;
    CLLocationManager *locationManager;
}
@property (strong,nonatomic)IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) StoreElements *storeElements;

@property (nonatomic, retain) IBOutlet UILabel *address;
@property (nonatomic, retain) IBOutlet UILabel *address2;
@property (nonatomic, retain) IBOutlet UILabel *city;
@property (nonatomic, retain) IBOutlet UILabel *county;
@property (nonatomic, retain) IBOutlet UILabel *postCode;
@property (nonatomic, retain) IBOutlet UILabel *mondayOpen;
@property (nonatomic, retain) IBOutlet UILabel *mondayClose;
@property (nonatomic, retain) IBOutlet UILabel *tuesdayOpen;
@property (nonatomic, retain) IBOutlet UILabel *tuesdayClose;
@property (nonatomic, retain) IBOutlet UILabel *wednesdayOpen;
@property (nonatomic, retain) IBOutlet UILabel *wednesdayClose;
@property (nonatomic, retain) IBOutlet UILabel *thursdayOpen;
@property (nonatomic, retain) IBOutlet UILabel *thursdayClose;
@property (nonatomic, retain) IBOutlet UILabel *fridayOpen;
@property (nonatomic, retain) IBOutlet UILabel *fridayClose;
@property (nonatomic, retain) IBOutlet UILabel *saturdatOpen;
@property (nonatomic, retain) IBOutlet UILabel *saturdayClose;
@property (nonatomic, retain) IBOutlet UILabel *venueType;
@property (nonatomic, retain) IBOutlet UILabel *rating;
@property (nonatomic, retain) IBOutlet UILabel *neighborhoods;

//VenueType: "Bar",
//PictureUrl: "http://s3-media4.ak.yelpcdn.com/bphoto/AfPu4cwEFr_5BU2OZjXaxg/l.jpg",
//Rating: 4,
//Neighborhoods: "Blackfriars",

- (IBAction)MapButton:(id)sender;
@end
