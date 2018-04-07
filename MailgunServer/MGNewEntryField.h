//
//  MGNewEntryField.h
//  MailgunServer
//
//  Created by teddyr on 2016-09-06.
//  Copyright © 2016 Teddy Rowan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MGNewEntryField : UIView
{
    UIView *borderView;
    UILabel *entryLabel;
    UITextField *entryView;
}

@property (nonatomic, retain) UIView *borderView;
@property (nonatomic, retain) UILabel *entryLabel;
@property (nonatomic, retain) UITextField *entryView;

- (id) initWithFrame:(CGRect)frame andTitle:(NSString*)title;

@end
