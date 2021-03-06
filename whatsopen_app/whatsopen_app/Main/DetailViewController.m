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

@synthesize imageView,closingTime,timeLeft,name,venueType,distance,address,city,postCode,telephone,notes,ratingImageView,neighborhoods;

int hours, minutes, seconds;
int secondsLeft;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated{
    
    UIFont *titleFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:16];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,200,44)];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setFont:titleFont];
    titleLabel.textColor=[UIColor whiteColor];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    
    
    
    titleLabel.text=self.storeElements.Name;
    [titleLabel setNumberOfLines:2];
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0,0,200,44)];
    [titleView setBackgroundColor:[UIColor clearColor]];
    // [titleView setCenter:[self.navigationItem.titleView center]];
    [titleView addSubview: titleLabel];
    [self.navigationItem setTitleView:titleView];
    
    
}

-(void)viewDidAppear:(BOOL)animated{
    if (IS_IPHONE_5) {
         scrollView.contentSize = CGSizeMake(320, 520 + notes.contentSize.height);
    }
    else
    {
        scrollView.contentSize = CGSizeMake(320, 600 + notes.contentSize.height);
    }
   
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //count down
    secondsLeft = [storeElements.SecondsLeft intValue];
    [self countdownTimer];
     timeLeft.text = [self returnTime:[storeElements.SecondsLeft intValue]];
    
    //change button
    UIImage *buttonImage = [UIImage imageNamed:@"arrow2.png"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:buttonImage forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 14, 28);
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = customBarItem;
    
    
    
    mapView.delegate = self;
    mapView.showsUserLocation = YES;
    
    CLLocationCoordinate2D annotationCoord;
    
    double latitude = [self.storeElements.Latitude doubleValue];
    double longitude = [self.storeElements.Longitude doubleValue];
    //NSLog(@"%f and %f", latitude, longitude);
    
    annotationCoord.latitude = latitude;
    annotationCoord.longitude = longitude;
    
    
    
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
   // scrollView.contentSize = CGSizeMake(320, 568);
   // scrollView.contentInset = UIEdgeInsetsMake(0.0, 0.0, 100.0, 0.0);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = YES;
    scrollView.scrollsToTop = NO;
    scrollView.directionalLockEnabled = YES;
    scrollView.delegate = self;
    scrollView.alwaysBounceVertical = YES;
    scrollView.bounces = YES;
    scrollView.bouncesZoom = NO;
    

    name.text=self.storeElements.Name;
    address.text = [NSString stringWithFormat:@"%@\n%@\n%@\n\n%@",self.storeElements.Address,self.storeElements.City,self.storeElements.PostCode,self.storeElements.Phone];
    venueType.text = self.storeElements.VenueType;
    //city.text = self.storeElements.City;
    distance.text=[NSString stringWithFormat:@"%@ miles away",self.storeElements.Distance];
    //postCode.text = self.storeElements.PostCode;
    //telephone.text = self.storeElements.Phone;
    
    venueType.text = self.storeElements.VenueType;
    closingTime.text=[NSString stringWithFormat:@"Open until %@",self.storeElements.ClosingTime];
    
    neighborhoods.text = self.storeElements.Neighborhoods;
    NSURL *url = [NSURL URLWithString:self.storeElements.PictureUrl];
    imageView.imageURL=url;
    
    notes.text=self.storeElements.Notes;
    
    CGRect frame = notes.frame;
    frame.size.height = notes.contentSize.height;
    notes.frame = frame;
    
    
    //closingTime.text=self.storeElements.ClosingTime;
    
    
    //rating
    UIImage *image;
    double ratingNumber = [self.storeElements.Rating doubleValue];
    
    if (ratingNumber==0.5||ratingNumber==1.0) {
        image= [UIImage imageNamed: @"1star.png"];
    }
    else if (ratingNumber==1.5||ratingNumber==2.0)
    {
        image= [UIImage imageNamed: @"2star.png"];
    }
    else if (ratingNumber==2.5||ratingNumber==3.0)
    {
        image= [UIImage imageNamed: @"3star.png"];
    }
    else if (ratingNumber==3.5||ratingNumber==4.0)
    {
        image= [UIImage imageNamed: @"4star.png"];
    }
    else if (ratingNumber==4.5||ratingNumber==5.0)
    {
        image= [UIImage imageNamed: @"5star.png"];
    }
    [ratingImageView setImage:image];

   
}
- (void) back {
    [self.navigationController popViewControllerAnimated:YES];
    [timer invalidate];
}


- (void) mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    
    //self.mapView.centerCoordinate = userLocation.location.coordinate;
    CLLocationCoordinate2D annotationCoord;
    
    double latitude = [self.storeElements.Latitude doubleValue];
    double longitude = [self.storeElements.Longitude doubleValue];
    //NSLog(@"%f and %f", latitude, longitude);
    
    annotationCoord.latitude = latitude;
    annotationCoord.longitude = longitude;
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(annotationCoord, 0.5*METERS_PER_MILE, 0.5*METERS_PER_MILE);
    [self.mapView setRegion:[self.mapView regionThatFits:viewRegion] animated:YES];
}


- (IBAction)MapButton:(id)sender {
    
    double latitude = [self.storeElements.Latitude doubleValue];
    double longitude = [self.storeElements.Longitude doubleValue];
//    NSString *coString = [NSString stringWithFormat:@"%f,%f", latitude,longitude];
//    NSString *loString = [NSString stringWithFormat:@"%f,%f", locationManager.location.coordinate.latitude, locationManager.location.coordinate.longitude];
//    NSString *combinedString = [NSString stringWithFormat:@"%@%@%@%@%@", @"saddr=", coString, @"&",@"daddr=", loString];
//    NSURL *mapURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://maps.apple.com/?%@", combinedString]];
//    //NSLog(@"url is :%@", mapURLgit);
//    [[UIApplication sharedApplication] openURL:mapURL];
    
    
    Class mapItemClass = [MKMapItem class];
    if (mapItemClass && [mapItemClass respondsToSelector:@selector(openMapsWithItems:launchOptions:)])
    {
        // Create an MKMapItem to pass to the Maps app
        CLLocationCoordinate2D coordinate =CLLocationCoordinate2DMake(latitude, longitude);
        MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:coordinate
                                                       addressDictionary:nil];
        MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];

        [mapItem setName:storeElements.Name];
        
        // Set the directions mode to "Walking"
        // Can use MKLaunchOptionsDirectionsModeDriving instead
        NSDictionary *launchOptions = @{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeWalking};
        // Get the "Current User Location" MKMapItem
        MKMapItem *currentLocationMapItem = [MKMapItem mapItemForCurrentLocation];
        // Pass the current location and destination map items to the Maps app
        // Set the direction mode in the launchOptions dictionary
        [MKMapItem openMapsWithItems:@[currentLocationMapItem, mapItem]
                       launchOptions:launchOptions];
    }
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

#pragma mark - count down

- (void)updateCounter:(NSTimer *)theTimer {
    if(secondsLeft > 0 ){
        secondsLeft -- ;
        timeLeft.text = [self returnTime:secondsLeft];
       
    }
    else{
        secondsLeft = [storeElements.SecondsLeft intValue];

    }
}

-(void)countdownTimer{
    
    secondsLeft = hours = minutes = seconds = 0;
   
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateCounter:) userInfo:nil repeats:YES];

}
-(NSString *)returnTime:(int)inputSeconds{
    
    hours = inputSeconds / 3600;
    minutes = (inputSeconds % 3600) / 60;
    seconds = (inputSeconds %3600) % 60;
    return [NSString stringWithFormat:@"%02d:%02d:%02d left", hours, minutes, seconds];
}

@end
