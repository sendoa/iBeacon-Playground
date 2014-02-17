//
//  SPOBeaconTransmitterViewController.m
//  Beacons Playground
//
//  Created by Sendoa Portuondo on 17/02/14.
//  Copyright (c) 2014 Sendoa Portuondo. All rights reserved.
//

#import "SPOBeaconTransmitterViewController.h"
@import CoreLocation;
@import CoreBluetooth;

static NSString * const SPOBeaconTransmitterViewControllerBeaconProximityUUID = @"B9407F30-F5F8-466E-AFF9-25556B57FE6D";
static NSString * const SPOBeaconTransmitterViewControllerBeaconRegionIdentifier = @"com.sportuondo.beacons";

@interface SPOBeaconTransmitterViewController () <CBPeripheralManagerDelegate>

@property (strong, nonatomic) CLBeaconRegion *beaconRegion;
@property (strong, nonatomic) CBPeripheralManager *peripheralManager;
@property (copy, nonatomic) NSDictionary *beaconPeripheralData;
@property (weak, nonatomic) IBOutlet UIButton *btnToggleEmitter;

- (IBAction)toggleEmittingButtonTapped:(id)sender;

@end

@implementation SPOBeaconTransmitterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [self setupBeaconRegion];
}

- (void)dealloc
{
    [self.peripheralManager removeObserver:self forKeyPath:@"isAdvertising"];
}

#pragma mark - CBPeripheralManagerDelegate
- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral
{
    if (peripheral.state == CBPeripheralManagerStatePoweredOn) {
        NSLog(@"Beacon powered on and preparing to start advertising");
        [self.peripheralManager startAdvertising:self.beaconPeripheralData];
        [self.btnToggleEmitter setTitle:@"Stop advertising" forState:UIControlStateNormal];
    } else if (peripheral.state == CBPeripheralManagerStatePoweredOff) {
        NSLog(@"Beacon powered off");
        [self.peripheralManager stopAdvertising];
        [self.btnToggleEmitter setTitle:@"Start advertising" forState:UIControlStateNormal];
    } else if (peripheral.state == CBPeripheralManagerStateUnsupported) {
        NSLog(@"The platform doesn't support the BLE peripheral/server role.");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"BLE not supported"
                                                        message:@"This device does not support Bluetooth 4.0"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    } else if (peripheral.state == CBPeripheralManagerStateUnauthorized) {
        NSLog(@"The app is not authorized to use the BLE peripheral/server role");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"BLE not supported"
                                                        message:@"This device does not support Bluetooth 4.0"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

#pragma mark - Action methods
- (IBAction)toggleEmittingButtonTapped:(id)sender {
    if (self.peripheralManager.isAdvertising) {
        [self.peripheralManager stopAdvertising];
        [self.btnToggleEmitter setTitle:@"Start advertising" forState:UIControlStateNormal];
    } else {
        if (self.peripheralManager.state == CBPeripheralManagerStatePoweredOn) {
            [self.peripheralManager startAdvertising:self.beaconPeripheralData];
            [self.btnToggleEmitter setTitle:@"Stop advertising" forState:UIControlStateNormal];
        } else {
            NSLog(@"The peripheral manager is not powered yet");
            [self setupPeripheralManager];
        }
    }
}

#pragma mark - Helpers
- (void)setupBeaconRegion
{
    NSUUID *proximityUUID = [[NSUUID alloc] initWithUUIDString:SPOBeaconTransmitterViewControllerBeaconProximityUUID];
    self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:proximityUUID
                                                                major:1
                                                                minor:1
                                                           identifier:SPOBeaconTransmitterViewControllerBeaconRegionIdentifier];
}

- (void)setupPeripheralManager {
    self.beaconPeripheralData = [self.beaconRegion peripheralDataWithMeasuredPower:nil];
    self.peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self
                                                                     queue:nil
                                                                   options:nil];
}

@end
