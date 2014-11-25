//
//  RageIAPHelper.m
//  In App Purchase Test
//
//  Created by Swapnil Godambe on 16/02/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "RageIAPHelper.h"

@implementation RageIAPHelper

+ (RageIAPHelper *)sharedInstance {
    static dispatch_once_t once;
    static RageIAPHelper * sharedInstance;
    dispatch_once(&once, ^{
        
        
        NSSet * productIdentifiers = [NSSet setWithObjects:
                                      @"whoot_best",
                                      @"whoot_better",
                                      @"Whoot_Good",
                                      nil];
        
        
        sharedInstance = [[self alloc] initWithProductIdentifiers:productIdentifiers];
    });
    return sharedInstance;
}

@end
