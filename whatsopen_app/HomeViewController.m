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

@interface HomeViewController ()

@end

@implementation HomeViewController

@synthesize storeArray, storeData, distanceArray;


- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar.png"] forBarMetrics:UIBarMetricsDefault];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
   
    
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
    [refresh addTarget:self
                action:@selector(refreshView:)
                 forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refresh;
    
    StoreData *_parser = [[StoreData alloc] initParserWithDelegate:self];
    self.storeData = _parser;
    _parser=nil;

    locationManager = [[CLLocationManager alloc] init];
    latitude = locationManager.location.coordinate.latitude;
    lontitude = locationManager.location.coordinate.longitude;
    
    NSString *latlon=[NSString stringWithFormat:@"%f,%f",latitude,lontitude];
    
    [self.storeData getParserRequest:latlon];
    NSLog(@"location: %@",latlon);
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];

}

//get distance on the site
-(void)didGetParsedInfo:(NSMutableArray *)inBody {
    
    self.storeArray = inBody;
    
//    locationManager = [[CLLocationManager alloc] init];
//    distanceArray = [[NSMutableArray alloc] init];
//    
//    for(StoreElements *storeElements in inBody) {
//        
//        double lat = locationManager.location.coordinate.latitude;
//        double lon = locationManager.location.coordinate.longitude;
//        
//        
//        NSString *lat1 = storeElements.Latitude;
//        NSString *lon1 = storeElements.Longitude;
//        double lat2 = [lat1 doubleValue];
//        double lon2 = [lon1 doubleValue];
//        
//        CLLocation *locA = [[CLLocation alloc] initWithLatitude:lat longitude:lon];
//        CLLocation *locB = [[CLLocation alloc] initWithLatitude:lat2 longitude:lon2];
//        CLLocationDistance distance = [locA distanceFromLocation:locB];
//        
//        NSLog(@"distance is :%f", distance);
//        NSLog(@"miles :%f", (distance/1000));
//        
//        NSString *dString = [NSString stringWithFormat:@"%.2f", (distance/1000)];
//        [distanceArray addObject:dString];
//        
//    }
    
    [self.tableView reloadData];
}



 -(void)refreshView:(UIRefreshControl *)refresh {
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Refreshing data..."];
   
      //get new geo location
     locationManager = [[CLLocationManager alloc] init];
     latitude = locationManager.location.coordinate.latitude;
     lontitude = locationManager.location.coordinate.longitude;
     
     StoreData *_parser = [[StoreData alloc] initParserWithDelegate:self];
     self.storeData = _parser;
     _parser=nil;
     [self performSelector:@selector(updateTable) withObject:nil afterDelay:2.0];

    
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
       [formatter setDateFormat:@"MMM d, h:mm a"];
        NSString *lastUpdated = [NSString stringWithFormat:@"Last updated on %@",[formatter stringFromDate:[NSDate date]]];
        refresh.attributedTitle = [[NSAttributedString alloc] initWithString:lastUpdated];
         [refresh endRefreshing];
     
}


- (void) updateTable {
    NSString *latlon=[NSString stringWithFormat:@"%f,%f",latitude,lontitude];
    [self.storeData getParserRequest:latlon];
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
    [cell.storeName setFont:[UIFont fontWithName:@"Proxima Nova" size:26]];
    cell.storeName.text = _storeElements.Name;
    
   // [cell.storeAddress setFont:[UIFont fontWithName:@"Proxima Nova" size:16]];
    cell.venueTypeLabel.text = _storeElements.VenueType;
    cell.storeDistance.text =[NSString stringWithFormat:@"%@ %@", _storeElements.Distance, @"miles"];
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

@end
