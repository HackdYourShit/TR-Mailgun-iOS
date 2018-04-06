//
//  MGPrivateAPIKey.h
//  MailgunServer
//
//  Created by Teddy Rowan on 2018-04-06.
//  Copyright © 2018 Teddy Rowan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MGPrivateAPIKeyHolder : NSObject
{
    NSString *APIKey;
}

@property (nonatomic, strong) NSString *APIKey;

@end
