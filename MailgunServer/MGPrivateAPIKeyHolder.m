//
//  MGPrivateAPIKey.m
//  MailgunServer
//
//  Created by Teddy Rowan on 2018-04-06.
//  Copyright © 2018 Teddy Rowan. All rights reserved.
//

#import "MGPrivateAPIKeyHolder.h"

@implementation MGPrivateAPIKeyHolder
@synthesize APIKey;
- (id) init{
    self = [super init];
    if (self){
        //APIKey = @"key-e0a9097a1bb7c65df36f9df5cf00ab25"; // your API key goes here.
        APIKey = @"abcdefghijklmnopqrstuvwxyz"; // your API key goes here.
    }
    return self;
}
@end
