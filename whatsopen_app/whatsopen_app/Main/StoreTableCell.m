//
//  StoreTableCell.m
//  POQAPP
//
//  Created by sravan jinna on 27/03/2013.
//  Copyright (c) 2013 POQStudio. All rights reserved.
//

#import "StoreTableCell.h"

@implementation StoreTableCell
    
@synthesize venueTypeLabel, storeDistance, storeName,closingTimeLabel;
@synthesize mainImageView,ratingImageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end