//
//  BorderedTextField.h
//  MailgunServer
//
//  Created by teddyr on 2016-08-14.
//  Copyright © 2016 Teddy Rowan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BorderedTextField : UIView
{
    UITextView *textView;
}

@property (nonatomic, retain) UITextView* textView;

@end
