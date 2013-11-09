//
//  HomeViewController.m
//  whatsopen_app
//
//  Created by Jun Seki on 27/04/2013.
//  Copyright (c) 2013 com.junseki. All rights reserved.
//

#import "HomeViewController.h"
#import "StoreTableCell.h"
#import "DetailViewController.h"
#import "AsyncImageView.h"
#import "AppDelegate.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

@synthesize storeArray, storeData, distanceArray;
@synthesize nomatchesView,matchesLabel;



- (void)viewWillAppear:(BOOL)animated {
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar.png"] forBarMetrics:UIBarMetricsDefault];
    UIColor *tintColor = [UIColor colorWithRed:152/255.f green:36/255.f blue:25/255.f alpha:1];
    self.navigationController.navigationBar.barTintColor = tintColor;
    
    UIFont *titleFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,320,44)];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setFont:titleFont];
    titleLabel.textColor=[UIColor whiteColor];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.text=@"AFTER HOURS";
    [titleLabel setNumberOfLines:1];
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0,0,320,44)];
    [titleView setBackgroundColor:[UIColor clearColor]];
    // [titleView setCenter:[self.navigationItem.titleView center]];
    [titleView addSubview: titleLabel];
    [self.navigationItem setTitleView:titleView];
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //starting loading
    [[AppDelegate sharedAppDelegate] showLoadingView];
   
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    
    [refresh addTarget:self
                action:@selector(refreshView:)
                 forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refresh;
    
    //get location
    [self updateTable];
    
    //no results label
    nomatchesView = [[UIView alloc] initWithFrame:self.view.frame];
    nomatchesView.backgroundColor = [UIColor clearColor];
    
    matchesLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,80,300,320)];
    matchesLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16];
    matchesLabel.numberOfLines = 2;
    matchesLabel.lineBreakMode = NSLineBreakByWordWrapping;
    matchesLabel.shadowColor = [UIColor lightTextColor];
    matchesLabel.textColor = [UIColor darkGrayColor];
    matchesLabel.shadowOffset = CGSizeMake(0, 1);
    matchesLabel.backgroundColor = [UIColor clearColor];
    matchesLabel.textAlignment =  NSTextAlignmentCenter;
    
    //Here is the text for when there are no results
    matchesLabel.text = @"Time to go home :-(";
    
    
    nomatchesView.hidden = YES;
    [nomatchesView addSubview:matchesLabel];
    [self.tableView insertSubview:nomatchesView belowSubview:self.tableView];
    
    //[self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];

}

//get distance on the site
-(void)didGetParsedInfo:(NSMutableArray *)inBody {
    
    self.storeArray = inBody;
    
    //If there is no table data, unhide the "No matches" view
    if([storeArray count] == 0 ){
        nomatchesView.hidden = NO;
    } else {
        nomatchesView.hidden = YES;
    }
    
    [self.tableView reloadData];
    
    //stop loading
    [[AppDelegate sharedAppDelegate] hideLoadingView];
}



 -(void)refreshView:(UIRefreshControl *)refresh {
     
     //starting loading
     [[AppDelegate sharedAppDelegate] showLoadingView];
     
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Refreshing data..."];
   
//      //get new geo location
//     locationManager = [[CLLocationManager alloc] init];
//     latitude = locationManager.location.coordinate.latitude;
//     lontitude = locationManager.location.coordinate.longitude;
//     
//    self.storeData = [[StoreData alloc] initParserWithDelegate:self];

     [self performSelector:@selector(updateTable) withObject:nil afterDelay:1.0];

    
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
       [formatter setDateFormat:@"MMM d, h:mm a"];
        NSString *lastUpdated = [NSString stringWithFormat:@"Last updated on %@",[formatter stringFromDate:[NSDate date]]];
        refresh.attributedTitle = [[NSAttributedString alloc] initWithString:lastUpdated];
         [refresh endRefreshing];
     
     //stop loading
     [[AppDelegate sharedAppDelegate] hideLoadingView];
}


- (void) updateTable {
    /**initialize location manager**/
    if (nil == locationManager)
        locationManager = [[CLLocationManager alloc] init];
    
    //set the delegate for the location manager
    //locationManager.delegate = self;
    // set your desired accuracy
    locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    [locationManager setDelegate:self];
    [locationManager startUpdatingLocation];
    
    self.storeData = [[StoreData alloc] initParserWithDelegate:self];
    
    
    latitude = locationManager.location.coordinate.latitude;
    lontitude = locationManager.location.coordinate.longitude;
    
    NSString *latlon=[NSString stringWithFormat:@"%f,%f",latitude,lontitude];
    
    [self.storeData getParserRequest:latlon];
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    
    return [storeArray count];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *nibTitle = @"StoreTableCell";
    
    
    static NSString *CellIdentifier = @"StoreTableCell";
    
    StoreTableCell *cell = (StoreTableCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    if (cell == nil) {
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:nibTitle owner:self options:nil];
        cell = [nib objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        
    } else {
        //cancel loading previous image for cell
        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:cell.imageView];
    }
    StoreElements *_storeElements = [self.storeArray objectAtIndex:indexPath.row];
    [cell.storeName setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:26]];
    cell.storeName.text = _storeElements.Name;
    
   // [cell.storeAddress setFont:[UIFont fontWithName:@"Proxima Nova" size:16]];
    cell.venueTypeLabel.text = _storeElements.VenueType;
    double milesDouble = [_storeElements.Distance doubleValue];
    cell.storeDistance.text =[NSString stringWithFormat:@"%.1f %@", milesDouble, @"miles"];
    cell.closingTimeLabel.text=[NSString stringWithFormat:@"%@",_storeElements.ClosingTime];
    //[NSString stringWithFormat:@"%@ %@", [distanceArray objectAtIndex:indexPath.row], @"miles"];
    
    //#hard coded closing time
    //cell.closingTimeLabel.text=_storeElements.SundayCloseTime;
    [self customRatingImageWithNumber:_storeElements.Rating onCell:cell];
    NSLog(@"picture Url: %@",_storeElements.PictureUrl);
    NSURL *url = [NSURL URLWithString:_storeElements.PictureUrl];
    
    cell.mainImageView.imageURL=url;
    
    return cell;
}

-(void)customRatingImageWithNumber:(NSString *)number
                     onCell:(StoreTableCell *)cell
{
    UIImage *image;
    double ratingNumber = [number doubleValue];
    
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
    [cell.ratingImageView setImage:image];
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    
    DetailViewController *detailViewController = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
    
    StoreElements *_storeElements = [self.storeArray objectAtIndex:indexPath.row]; 
     // Pass the selected object to the new view controller.
    
    NSURL *url = [NSURL URLWithString:_storeElements.PictureUrl];
    detailViewController.imageView.imageURL=url;
    
           detailViewController.storeElements = _storeElements;
    [self.navigationController pushViewController:detailViewController animated:YES];

}

#pragma mark - connection error
-(void)showConnectionError{
    
    nomatchesView.hidden=NO;
    
}

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    
    if (status == kCLAuthorizationStatusNotDetermined) {
        
        
    }else if (status == kCLAuthorizationStatusDenied) {
        
         matchesLabel.text = @"Please enable location services :-p";
        nomatchesView.hidden=NO;
        self.storeData =nil;
        [self.tableView reloadData];
    }
    else if (status == kCLAuthorizationStatusAuthorized) {
        nomatchesView.hidden=YES;
        [self updateTable];
    } else {
        
    }
}

@end
