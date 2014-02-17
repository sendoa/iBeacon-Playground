//
//  SPOBeaconCell.h
//  Beacons Playground
//
//  Created by Sendoa Portuondo on 15/02/14.
//  Copyright (c) 2014 Sendoa Portuondo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CLBeacon;

UIKIT_EXTERN NSString * const SPOBeaconCellIdentifier;

@interface SPOBeaconCell : UITableViewCell

- (void)bindWithBeacon:(CLBeacon *)beacon;

@end
