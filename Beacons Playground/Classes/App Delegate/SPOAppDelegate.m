//
//  SPOAppDelegate.m
//  Beacons Playground
//
//  Created by Sendoa Portuondo on 14/02/14.
//  Copyright (c) 2014 Sendoa Portuondo. All rights reserved.
//

#import "SPOAppDelegate.h"
@import CoreLocation;

@interface SPOAppDelegate () <CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation SPOAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[NSUserDefaults standardUserDefaults] spo_registerStandardDefaults];
    
    [self setupLocationManager];
    
    return YES;
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region
{
    NSLog(@"Beacon region state determined from App Delegate: %ld", (long)state);
    
    if (state == CLRegionStateOutside) {
        NSLog(@"You're outside beacons region");
        // Show local notification if necessary
        if ([[NSUserDefaults standardUserDefaults] spo_latestRegionState] != state) {
            UILocalNotification *notification = [[UILocalNotification alloc] init];
            notification.alertBody = @"You're OUTSIDE beacons region";
            notification.soundName = UILocalNotificationDefaultSoundName;
            [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
            
            [[NSUserDefaults standardUserDefaults] spo_setLatestRegionState:state];
        }
    } else if (state == CLRegionStateInside) {
        NSLog(@"You're inside beacons region");
        // Show local notification if necessary
        if ([[NSUserDefaults standardUserDefaults] spo_latestRegionState] != state) {
            // Try to present notification
            UILocalNotification *notification = [[UILocalNotification alloc] init];
            notification.alertBody = @"You're INSIDE beacons region";
            notification.soundName = UILocalNotificationDefaultSoundName;
            [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
            
            [[NSUserDefaults standardUserDefaults] spo_setLatestRegionState:state];
        }
    } else {
        NSLog(@"Unknown state determined for region");
        [[NSUserDefaults standardUserDefaults] spo_setLatestRegionState:state];
    }
}

#pragma mark - Helpers
- (void)setupLocationManager
{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
}

@end
