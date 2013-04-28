//
//  HomeViewController.h
//  whatsopen_app
//
//  Created by Jun Seki on 27/04/2013.
//  Copyright (c) 2013 com.junseki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoreData.h"
#import "StoreElements.h"
#import <CoreLocation/CoreLocation.h>

@interface HomeViewController : UITableViewController<UITableViewDelegate, UITableViewDataSource> {
    

    StoreData *storeData;
    CLLocationManager *locationManager;
}

@property (nonatomic, retain) StoreData *storeData;
@property (nonatomic, retain) NSMutableArray *storeArray;

@property (nonatomic, retain) NSMutableArray *distanceArray;

@end
