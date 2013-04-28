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
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:nil] forBarMetrics:UIBarMetricsDefault];
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
    [self.storeData getParserRequest];
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];

}


-(void)didGetParsedInfo:(NSMutableArray *)inBody {
    
    self.storeArray = inBody;
    
    locationManager = [[CLLocationManager alloc] init];
    distanceArray = [[NSMutableArray alloc] init];
    
    for(StoreElements *storeElements in inBody) {
        
        double lat = locationManager.location.coordinate.latitude;
        double lon = locationManager.location.coordinate.longitude;
        
        
        NSString *lat1 = storeElements.Latitude;
        NSString *lon1 = storeElements.Longitude;
        double lat2 = [lat1 doubleValue];
        double lon2 = [lon1 doubleValue];
        
        CLLocation *locA = [[CLLocation alloc] initWithLatitude:lat longitude:lon];
        CLLocation *locB = [[CLLocation alloc] initWithLatitude:lat2 longitude:lon2];
        CLLocationDistance distance = [locA distanceFromLocation:locB];
        
        NSLog(@"distance is :%f", distance);
        NSLog(@"miles :%f", (distance/1000));
        
        NSString *dString = [NSString stringWithFormat:@"%.2f", (distance/1000)];
        [distanceArray addObject:dString];
        
    }
    
    [self.tableView reloadData];
}



 -(void)refreshView:(UIRefreshControl *)refresh {
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Refreshing data..."];
   
      // custom refresh logic would be placed here...
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
    
    [self.storeData getParserRequest];
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
    cell.storeName.text = _storeElements.Name;
    cell.storeAddress.text = _storeElements.Address;
    cell.storeDistance.text = [NSString stringWithFormat:@"%@ %@", [distanceArray objectAtIndex:indexPath.row], @"miles"];
    
    NSLog(@"picture Url: %@",_storeElements.PictureUrl);
    NSURL *url = [NSURL URLWithString:_storeElements.PictureUrl];
    cell.mainImageView.imageURL=url;
    
    return cell;
}



-(void)customLabelWithName:(NSString *)nameString
           withVenueType:(NSString *)venueTypeString
           withClosingTime:(NSString *)closingTimeString
                   withDistance:(NSString *)distanceString
                withRating:(NSString *)ratingString
                     onCell:(StoreTableCell *)cell
{
        /*name label */
        UILabel *nameLabel;
        nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(14, 230, 320, 40)];
        [nameLabel setFont:[UIFont systemFontOfSize:35]];
        [nameLabel setTextColor:[UIColor whiteColor]];
        [nameLabel setBackgroundColor:[UIColor clearColor]];
        [nameLabel setTextAlignment:NSTextAlignmentLeft];
        nameLabel.text=nameString;
        [cell addSubview:nameLabel];
    
    /*venueType label */
    UILabel *venueTypeLabel;
    venueTypeLabel=[[UILabel alloc]initWithFrame:CGRectMake(14, 250, 100, 10)];
    [venueTypeLabel setFont:[UIFont systemFontOfSize:15]];
    [venueTypeLabel setTextColor:[UIColor whiteColor]];
    [venueTypeLabel setBackgroundColor:[UIColor clearColor]];
    [venueTypeLabel setTextAlignment:NSTextAlignmentLeft];
    venueTypeLabel.text=venueTypeString;
    [cell addSubview:venueTypeLabel];
    
    /*venueType label */
    UILabel *closingTimeLabel;
    closingTimeLabel=[[UILabel alloc]initWithFrame:CGRectMake(240, 81, 127, 25)];
    [closingTimeLabel setFont:[UIFont systemFontOfSize:18]];
    [closingTimeLabel setTextColor:[UIColor whiteColor]];
    [closingTimeLabel setBackgroundColor:[UIColor clearColor]];
    [closingTimeLabel setTextAlignment:NSTextAlignmentRight];
    closingTimeLabel.text=closingTimeString;
    [cell addSubview:closingTimeLabel];
    
    /*distance label */
    UILabel *distanceLabel;
    distanceLabel=[[UILabel alloc]initWithFrame:CGRectMake(240, 102, 127, 25)];
    [distanceLabel setFont:[UIFont systemFontOfSize:18]];
    [distanceLabel setTextColor:[UIColor whiteColor]];
    [distanceLabel setBackgroundColor:[UIColor clearColor]];
    [distanceLabel setTextAlignment:NSTextAlignmentRight];
    distanceLabel.text=distanceString;
    [cell addSubview:distanceLabel];
    
    /*rating label */
    UILabel *ratingLabel;
    ratingLabel=[[UILabel alloc]initWithFrame:CGRectMake(240, 250, 127, 25)];
    [ratingLabel setFont:[UIFont systemFontOfSize:18]];
    [ratingLabel setTextColor:[UIColor whiteColor]];
    [ratingLabel setBackgroundColor:[UIColor clearColor]];
    [ratingLabel setTextAlignment:NSTextAlignmentRight];
    ratingLabel.text=ratingString;
    [cell addSubview:ratingLabel];
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    
    DetailViewController *detailViewController = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
    
    StoreElements *_storeElements = [self.storeArray objectAtIndex:indexPath.row]; 
     // Pass the selected object to the new view controller.
           detailViewController.storeElements = _storeElements;
    [self.navigationController pushViewController:detailViewController animated:YES];

}

@end
