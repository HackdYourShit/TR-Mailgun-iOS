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


@end
