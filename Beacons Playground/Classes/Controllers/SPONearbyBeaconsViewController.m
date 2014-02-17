//
//  SPOMainViewController.m
//  Beacons Playground
//
//  Created by Sendoa Portuondo on 14/02/14.
//  Copyright (c) 2014 Sendoa Portuondo. All rights reserved.
//

#import "SPONearbyBeaconsViewController.h"
@import CoreLocation;
@import CoreBluetooth;
#import "SPOBeaconCell.h"

static NSString * const SPOMainViewControllerBeaconsProximityUUID = @"B9407F30-F5F8-466E-AFF9-25556B57FE6D";
static NSString * const SPOMainViewControllerBeaconsRegionIdentifier = @"com.sportuondo.beacons";

@interface SPONearbyBeaconsViewController () <CLLocationManagerDelegate, CBPeripheralManagerDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CBPeripheralManager *peripheralmanager;
@property (copy, nonatomic) NSArray *beacons;

@end

@implementation SPONearbyBeaconsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupLocationManagerForBeaconDetection];
    
    // Force the iOS Bluetooth service activation system message
    self.peripheralmanager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil];
}

#pragma mark - CBPeripheralManagerDelegate
- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral
{
    
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region
{
    NSLog(@"Beacon region state determined: %ld", (long)state);
    
    if (state == CLRegionStateOutside) {
        [self.locationManager stopRangingBeaconsInRegion:(CLBeaconRegion *)region];
    } else if (state == CLRegionStateInside) {        
        if ([CLLocationManager isRangingAvailable]) {
            [self.locationManager startRangingBeaconsInRegion:(CLBeaconRegion *)region];
        } else {
            NSLog(@"Beacon ranging not available. Most probably this device doesn't support Bluetooth 4.0");
        }
    } else {
        NSLog(@"Unknown state determined for region");
        [[NSUserDefaults standardUserDefaults] spo_setLatestRegionState:state];
    }
}

- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
    NSLog(@"Beacons ranged");
    
    self.beacons = beacons;
    [self.tableView reloadData];
    
    if ([beacons count] > 0) {
        CLBeacon *closestBeacon = [beacons firstObject];
        
        switch (closestBeacon.proximity) {
            case CLProximityImmediate:
                NSLog(@"Closest beacon %@ located immediately close to you with Major %ld and Minor: %ld", [closestBeacon.proximityUUID UUIDString], (long)closestBeacon.major.integerValue, (long)closestBeacon.minor.integerValue);
                break;
            case CLProximityNear:
                NSLog(@"Closest beacon %@ located near you with Major %ld and Minor: %ld", [closestBeacon.proximityUUID UUIDString], (long)closestBeacon.major.integerValue, (long)closestBeacon.minor.integerValue);
                break;
            case CLProximityFar:
                NSLog(@"Closest beacon %@ located far from you with Major %ld and Minor: %ld", [closestBeacon.proximityUUID UUIDString], (long)closestBeacon.major.integerValue, (long)closestBeacon.minor.integerValue);
                break;
            default:
                NSLog(@"Closest beacon %@ has unknown proximity with Major %ld and Minor: %ld", [closestBeacon.proximityUUID UUIDString], (long)closestBeacon.major.integerValue, (long)closestBeacon.minor.integerValue);
                break;
        }
    }
}

#pragma mark - UITableViewDelegate & UITableViewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.beacons count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SPOBeaconCell *cell = [tableView dequeueReusableCellWithIdentifier:SPOBeaconCellIdentifier];
    [cell bindWithBeacon:self.beacons[indexPath.row]];
    
    return cell;
}

#pragma mark - Helpers
- (void)setupLocationManagerForBeaconDetection
{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    // Create the beacons region
    CLBeaconRegion *beaconRegion = [self createBeaconRegionWithUUID:[[NSUUID alloc] initWithUUIDString:SPOMainViewControllerBeaconsProximityUUID]
                                                           identifier:SPOMainViewControllerBeaconsRegionIdentifier];
    if ([CLLocationManager isMonitoringAvailableForClass:[beaconRegion class]]) {
        [self.locationManager startMonitoringForRegion:beaconRegion];
    } else {
        NSLog(@"Beacon monitoring not available. Most probably this device doesn't support Bluetooth 4.0");
    }
}

- (CLBeaconRegion *)createBeaconRegionWithUUID:(NSUUID *)proximityUUID identifier:(NSString *)identifier
{
    CLBeaconRegion *beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:proximityUUID identifier:identifier];
    beaconRegion.notifyEntryStateOnDisplay = YES;
    
    return beaconRegion;
}

@end
