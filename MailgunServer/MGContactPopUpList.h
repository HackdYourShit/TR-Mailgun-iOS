//
//  MGContactPopUpList.h
//  MailgunServer
//
//  Created by teddyr on 2016-11-01.
//  Copyright © 2016 Teddy Rowan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGButtonWithCheckBox.h"

@interface MGContactPopUpList : UIView
{
    NSString *lastSelected;
    UIScrollView *scroll;
}

@property(nonatomic, strong) NSString* lastSelected;
@property(nonatomic, strong) UIScrollView* scroll;

- (id) initWithDictionary:(NSDictionary*)contactList;
- (UIImage *)imageWithColor:(UIColor *)color;
- (void) addEmail:(id)sender;
- (NSString *) getEmails;
@end
