//
//  StoreTableCell.h
//  whatsopen_app
//
//  Created by Jun Seki on 27/04/2013.
//  Copyright (c) 2013 com.junseki. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StoreTableCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UIImageView *mainImageView;
@property (nonatomic, retain) IBOutlet UILabel *storeName;
@property (nonatomic, retain) IBOutlet UILabel *storeAddress;
@property (nonatomic, retain) IBOutlet UILabel *storeDistance;

@end
