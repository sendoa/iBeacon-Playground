//
//  SPOBeaconCell.m
//  Beacons Playground
//
//  Created by Sendoa Portuondo on 15/02/14.
//  Copyright (c) 2014 Sendoa Portuondo. All rights reserved.
//

#import "SPOBeaconCell.h"
@import CoreLocation;

NSString * const SPOBeaconCellIdentifier = @"BeaconCell";

@interface SPOBeaconCell ()

@property (weak, nonatomic) IBOutlet UILabel *lblProximityUUID;
@property (weak, nonatomic) IBOutlet UILabel *lblMajor;
@property (weak, nonatomic) IBOutlet UILabel *lblMinor;
@property (weak, nonatomic) IBOutlet UILabel *lblRSSI;
@property (weak, nonatomic) IBOutlet UILabel *lblDistance;
@property (weak, nonatomic) IBOutlet UILabel *lblAccuracy;

@end

@implementation SPOBeaconCell

- (void)bindWithBeacon:(CLBeacon *)beacon
{
    self.lblProximityUUID.text = [beacon.proximityUUID UUIDString];
    self.lblMajor.text = [beacon.major stringValue];
    self.lblMinor.text = [beacon.minor stringValue];
    self.lblRSSI.text = [NSString stringWithFormat:@"%ld", (long)beacon.rssi];
    
    // Distance
    NSString *proximityString;
    switch (beacon.proximity) {
        case CLProximityImmediate:
            proximityString = @"Immediate";
            break;
        case CLProximityNear:
            proximityString = @"Near";
            break;
        case CLProximityFar:
            proximityString = @"Far";
            break;
        default:
            proximityString = @"Unknown";
            break;
    }
    self.lblDistance.text = proximityString;
    
    // Accuracy
    self.lblAccuracy.text = [NSString stringWithFormat:@"%.2f meters", beacon.accuracy];
}

@end
