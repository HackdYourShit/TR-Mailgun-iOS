//
//  MGContactPopUpList.h
//  MailgunServer
//
//  Created by teddyr on 2016-11-01.
//  Copyright © 2016 Teddy Rowan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MGContactPopUpList : UIView
{
    NSString *lastSelected;
}

@property(nonatomic, strong) NSString* lastSelected;

- (id) initWithDictionary:(NSDictionary*)contactList;
- (UIImage *)imageWithColor:(UIColor *)color;
- (void) addEmail:(id)sender;
- (NSString *) getEmails;
@end
