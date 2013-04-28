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

@property (nonatomic, retain) IBOutlet UILabel *closingTime;
@property (nonatomic, retain) IBOutlet UILabel *timeLeft;

@property (nonatomic, retain) IBOutlet UILabel *name;
@property (nonatomic, retain) IBOutlet UILabel *venueType;
@property (nonatomic, retain) IBOutlet UILabel *distance;

@property (nonatomic, retain) IBOutlet UILabel *address;

@property (nonatomic, retain) IBOutlet UILabel *city;

@property (nonatomic, retain) IBOutlet UILabel *postCode;
@property (nonatomic, retain) IBOutlet UILabel *telephone;

@property (nonatomic, retain) IBOutlet UITextView *notes;

@property (nonatomic, retain) IBOutlet UIImageView *ratingImageView;
@property (nonatomic, retain) IBOutlet UILabel *neighborhoods;

//VenueType: "Bar",
//PictureUrl: "http://s3-media4.ak.yelpcdn.com/bphoto/AfPu4cwEFr_5BU2OZjXaxg/l.jpg",
//Rating: 4,
//Neighborhoods: "Blackfriars",

- (IBAction)MapButton:(id)sender;
@end
