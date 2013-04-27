//
//  DetailViewController.m
//  whatsopen_app
//
//  Created by Jun Seki on 27/04/2013.
//  Copyright (c) 2013 com.junseki. All rights reserved.
//

#import "DetailViewController.h"
#import "AsyncImageView.h"

#define METERS_PER_MILE 1609.344

@interface DetailViewController ()

@end

@implementation DetailViewController

@synthesize mapView, scrollView;
@synthesize storeElements;
@synthesize address, address2, city, county, postCode;
@synthesize mondayOpen, mondayClose, tuesdayOpen, tuesdayClose, wednesdayOpen, wednesdayClose, thursdayOpen, thursdayClose, fridayOpen, fridayClose, saturdatOpen, saturdayClose;
@synthesize venueType,rating,neighborhoods,imageView;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = self.storeElements.Name;
    
    mapView.delegate = self;
    mapView.showsUserLocation = YES;
    
    CLLocationCoordinate2D annotationCoord;
    
    double latitude = [self.storeElements.Latitude doubleValue];
    double longitude = [self.storeElements.Longitude doubleValue];
    //NSLog(@"%f and %f", latitude, longitude);
    
    annotationCoord.latitude = latitude;
    annotationCoord.longitude = longitude;
    
    //MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:annotationCoord addressDictionary:<#(NSDictionary *)#>];
    
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(annotationCoord, 5*METERS_PER_MILE, 5*METERS_PER_MILE);
    [mapView setRegion:viewRegion animated:YES];
    //[mapView addAnnotation:annotationCoord];
    
    MKPointAnnotation *annotationPoint = [[MKPointAnnotation alloc] init];
    annotationPoint.coordinate = annotationCoord;
    
    annotationPoint.title = self.storeElements.Name;
    annotationPoint.subtitle = self.storeElements.Address;
    [mapView addAnnotation:annotationPoint];
    
    locationManager = [[CLLocationManager alloc] init];
    [locationManager setDelegate:self];
    [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    [locationManager setDistanceFilter:kCLDistanceFilterNone];
    [locationManager startUpdatingLocation];
    
    
    //scroll view start
    scrollView.pagingEnabled = NO;
    scrollView.contentSize = CGSizeMake(320, 600);
    scrollView.contentInset = UIEdgeInsetsMake(0.0, 0.0, 100.0, 0.0);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = YES;
    scrollView.scrollsToTop = NO;
    scrollView.directionalLockEnabled = YES;
    scrollView.delegate = self;
    scrollView.alwaysBounceVertical = YES;
    scrollView.bounces = YES;
    scrollView.bouncesZoom = NO;
    
    address.text = self.storeElements.Address;
    address2.text = self.storeElements.Address2;
    city.text = self.storeElements.City;
    county.text = self.storeElements.County;
    postCode.text = self.storeElements.PostCode;
    mondayOpen.text = self.storeElements.MondayOpenTime;
    mondayClose.text = self.storeElements.MondayCloseTime;
    tuesdayOpen.text = self.storeElements.TuesdayOpenTime;
    tuesdayClose.text = self.storeElements.TuesdayCloseTime;
    wednesdayOpen.text = self.storeElements.WednesdayOpenTime;
    wednesdayClose.text = self.storeElements.WednesdayCloseTime;
    thursdayOpen.text = self.storeElements.ThursdayOpenTime;
    thursdayClose.text = self.storeElements.ThursdayCloseTime;
    fridayOpen.text = self.storeElements.FridayOpenTime;
    fridayClose.text = self.storeElements.FridayCloseTime;
    saturdatOpen.text = self.storeElements.SaturdayOpenTime;
    saturdayClose.text = self.storeElements.SaturdayCloseTime;
    venueType.text = self.storeElements.VenueType;
    rating.text=self.storeElements.Rating;
    neighborhoods.text = self.storeElements.Neighborhoods;
    NSURL *url = [NSURL URLWithString:self.storeElements.PictureUrl];
    imageView.imageURL=url;
}

-(void)scrollViewDidScroll:(UIScrollView *)aScrollView {
    
    float oldX = 0.0f;
    [aScrollView setContentOffset: CGPointMake(oldX, aScrollView.contentOffset.y)];
}


- (void) mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    
    //self.mapView.centerCoordinate = userLocation.location.coordinate;
    CLLocationCoordinate2D annotationCoord;
    
    double latitude = [self.storeElements.Latitude doubleValue];
    double longitude = [self.storeElements.Longitude doubleValue];
    //NSLog(@"%f and %f", latitude, longitude);
    
    annotationCoord.latitude = latitude;
    annotationCoord.longitude = longitude;
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(annotationCoord, 5*METERS_PER_MILE, 5*METERS_PER_MILE);
    [self.mapView setRegion:[self.mapView regionThatFits:viewRegion] animated:YES];
}


- (IBAction)MapButton:(id)sender {
    
    double latitude = [self.storeElements.Latitude doubleValue];
    double longitude = [self.storeElements.Longitude doubleValue];
    NSString *coString = [NSString stringWithFormat:@"%f,%f", latitude,longitude];
    NSString *loString = [NSString stringWithFormat:@"%f,%f", locationManager.location.coordinate.latitude, locationManager.location.coordinate.longitude];
    NSString *combinedString = [NSString stringWithFormat:@"%@%@%@%@%@", @"saddr=", coString, @"&",@"daddr=", loString];
    NSURL *mapURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://maps.apple.com/?%@", combinedString]];
    //NSLog(@"url is :%@", mapURLgit);
    [[UIApplication sharedApplication] openURL:mapURL];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    NSDate* eventDate = newLocation.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    if (abs(howRecent) < 5.0) {
        //NSLog(@"New Latitude %+.6f, Longitude %+.6f", newLocation.coordinate.latitude, newLocation.coordinate.longitude);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
