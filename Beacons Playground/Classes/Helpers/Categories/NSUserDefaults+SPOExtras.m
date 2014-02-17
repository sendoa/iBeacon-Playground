//
//  NSUserDefaults+SPOExtras.m
//  Beacons Playground
//
//  Created by Sendoa Portuondo on 16/02/14.
//  Copyright (c) 2014 Sendoa Portuondo. All rights reserved.
//

#import "NSUserDefaults+SPOExtras.h"

static NSString * const spo_NSUserDefaultsLatestRegionStateKey = @"LatestRegionState";

@implementation NSUserDefaults (SPOExtras)

#pragma mark - Standard defaults
- (void)spo_registerStandardDefaults
{
    NSDictionary *defaults = @{
                               spo_NSUserDefaultsLatestRegionStateKey   : @(0)
                               };
    
    [self registerDefaults:defaults];
}

#pragma mark - Latest region state
- (void)spo_setLatestRegionState:(NSInteger)state
{
    [[NSUserDefaults standardUserDefaults] setInteger:state forKey:spo_NSUserDefaultsLatestRegionStateKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSInteger)spo_latestRegionState
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:spo_NSUserDefaultsLatestRegionStateKey];
}

@end
