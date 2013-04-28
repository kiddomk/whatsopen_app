//
//  StoreTableCell.h
//  POQAPP
//
//  Created by sravan jinna on 27/03/2013.
//  Copyright (c) 2013 POQStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@class StoreTableCell;

@interface StoreTableCell : UITableViewCell {
    
}

@property (nonatomic, retain) IBOutlet UIImageView *mainImageView;
@property (nonatomic, retain) IBOutlet UILabel *storeName;
@property (nonatomic, retain) IBOutlet UILabel *storeDistance;
@property (nonatomic, retain) IBOutlet UILabel *venueTypeLabel;
@property (nonatomic, retain) IBOutlet UILabel *closingTimeLabel;
@property (nonatomic, retain) IBOutlet UIImageView *ratingImageView;

@end
