//
//  MGMainMenuNavigationButton.h
//  MailgunServer
//
//  Created by Teddy Rowan on 2018-04-06.
//  Copyright © 2018 Teddy Rowan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MGMainMenuNavigationButton : UIButton


- (id) initWithFrame:(CGRect)frame withTitle:(NSString*)title;
- (void) addGradient:(UIView *)obj;
- (UIImage *) imageWithColor:(UIColor *)color;

@end
