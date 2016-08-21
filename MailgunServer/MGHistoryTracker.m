//
//  MGHistoryTracker.m
//  MailgunServer
//
//  Created by teddyr on 2016-08-19.
//  Copyright © 2016 Teddy Rowan. All rights reserved.
//

#import "MGHistoryTracker.h"

@implementation MGHistoryTracker
@synthesize capacity;

/*
- (id) init{
    self = [super init];
    if (self) {
        
    }
    return self;
    
    
}
*/

- (void) clearHistory{
    for (int i = 1; i<=capacity; i++){
        [self setObject:nil forKey:[NSString stringWithFormat:@"%d",i]];
    }
}

- (void) printTracker{
    for (int i=1; i<= capacity; i++){
        NSLog(@"Index: %d, Stored:%@",i, [self objectForKey:[NSString stringWithFormat:@"%d", i]]);
    }
}

- (void) addEntry:(NSString *)entry{
    for (int i=(capacity-1); i>0; i--){
        if ([self objectForKey:[NSString stringWithFormat:@"%d", i]] != nil){
            [self setObject:[self objectForKey:[NSString stringWithFormat:@"%d", i]] forKey:[NSString stringWithFormat:@"%d",i+1]];
        }
    }
    [self setObject:entry forKey:@"1"];
}


@end
