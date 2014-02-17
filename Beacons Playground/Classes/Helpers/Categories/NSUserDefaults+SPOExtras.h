//
//  NSUserDefaults+SPOExtras.h
//  Beacons Playground
//
//  Created by Sendoa Portuondo on 16/02/14.
//  Copyright (c) 2014 Sendoa Portuondo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSUserDefaults (SPOExtras)

#pragma mark - Standard defaults
- (void)spo_registerStandardDefaults;

#pragma mark - Latest region state
- (void)spo_setLatestRegionState:(NSInteger)state;
- (NSInteger)spo_latestRegionState;

@end
