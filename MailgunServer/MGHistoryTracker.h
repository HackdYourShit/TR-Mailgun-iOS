//
//  MGHistoryTracker.h
//  MailgunServer
//
//  Created by teddyr on 2016-08-19.
//  Copyright © 2016 Teddy Rowan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MGHistoryTracker : NSUserDefaults
{
    int capacity;
    int filled;
    NSString *title;
}

@property (nonatomic) int capacity;
@property (nonatomic) int filled;
@property (nonatomic, retain) NSString* title;

- (void) clearHistory;
- (void) printTracker;
- (void) addEntry:(NSString*)entry;
- (int) checkFill;

@end
