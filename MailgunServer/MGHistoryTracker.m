//
//  MGHistoryTracker.m
//  MailgunServer
//
//  Created by teddyr on 2016-08-19.
//  Copyright © 2016 Teddy Rowan. All rights reserved.
//

#import "MGHistoryTracker.h"

@implementation MGHistoryTracker
@synthesize capacity, filled, title;

- (id) init{
    self = [super init];
    if (self) {
        filled = 0;
        [self checkFill];
        title = [[NSString alloc] initWithFormat:@""];
    }
    return self;
}


- (void) clearHistory{
    for (int i = 1; i<=capacity; i++){
        [self setObject:@" " forKey:[NSString stringWithFormat:@"%d",i]];
        [self removeObjectForKey:[NSString stringWithFormat:@"%d",i]];
    }
}

- (void) printTracker{
    for (int i=1; i<= capacity; i++){
        NSLog(@"Index: %d, Stored:%@",i, [self objectForKey:[NSString stringWithFormat:@"%d", i]]);
    }
}

- (void) addEntry:(NSString *)entry{
    for (int i=(capacity-1); i>0; i--){
//        if (!([[self objectForKey:[NSString stringWithFormat:@"%d", i]] isEqualToString:@" "] || ([self objectForKey:[NSString stringWithFormat:@"%d", i]] == nil))){
              [self setObject:[self objectForKey:[NSString stringWithFormat:@"%d", i]] forKey:[NSString stringWithFormat:@"%d",i+1]];
  //      }
    }
    [self setObject:entry forKey:@"1"];
    
    if (filled < capacity){filled ++;}
}

- (int) checkFill{
    for (int i=1; i<=capacity; i++){
        if (!([[self objectForKey:[NSString stringWithFormat:@"%d", i]] isEqualToString:@" "] || ([self objectForKey:[NSString stringWithFormat:@"%d", i]] == nil))){
            filled = i;
        } else {
            return i-1;
        }
    }
    return capacity;
}


@end
