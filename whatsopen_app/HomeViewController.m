//
//  HomeViewController.m
//  whatsopen_app
//
//  Created by Jun Seki on 27/04/2013.
//  Copyright (c) 2013 com.junseki. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeTableViewCell.h"
#import "DetailViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController
@synthesize storeListTableView;
@synthesize storeArray, storeData, distanceArray;

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:nil] forBarMetrics:UIBarMetricsDefault];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    StoreData *_parser = [[StoreData alloc] initParserWithDelegate:self];
    self.storeData = _parser;
    _parser=nil;
     [self.storeData getParserRequest];
    
    
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
    [refresh addTarget:self
                action:@selector(refreshView:)
                 forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refresh;
    
       
    [self.storeListTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
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
        
        //NSLog(@"distance is :%f", distance);
        //NSLog(@"miles :%f", (distance/1000));
        
        NSString *dString = [NSString stringWithFormat:@"%.2f", (distance/1000)];
        [distanceArray addObject:dString];
        
    }
    
    [self.storeListTableView reloadData];
}



 -(void)refreshView:(UIRefreshControl *)refresh {
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Refreshing data..."];
   
      // custom refresh logic would be placed here...
    
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
       [formatter setDateFormat:@"MMM d, h:mm a"];
        NSString *lastUpdated = [NSString stringWithFormat:@"Last updated on %@",[formatter stringFromDate:[NSDate date]]];
        refresh.attributedTitle = [[NSAttributedString alloc] initWithString:lastUpdated];
         [refresh endRefreshing];
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
    
    NSString *nibTitle = @"HomeTableViewCell";
    
    
    static NSString *CellIdentifier = @"HomeTableViewCell";
    
    HomeTableViewCell *cell = (HomeTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:nibTitle owner:self options:nil];
        cell = [nib objectAtIndex:0];
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    }
    
    StoreElements *_storeElements = [self.storeArray objectAtIndex:indexPath.row];
    cell.storeName.text = _storeElements.Name;
    cell.storeAddress.text = _storeElements.Address;
    cell.storeDistance.text = [NSString stringWithFormat:@"%@ %@", [distanceArray objectAtIndex:indexPath.row], @"miles"];
    return cell;
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
