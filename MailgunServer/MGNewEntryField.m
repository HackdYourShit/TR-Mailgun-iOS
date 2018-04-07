//
//  MGNewEntryField.m
//  MailgunServer
//
//  Created by teddyr on 2016-09-06.
//  Copyright © 2016 Teddy Rowan. All rights reserved.
//

#import "MGNewEntryField.h"

@implementation MGNewEntryField
@synthesize entryView, entryLabel, borderView;

- (id) initWithFrame:(CGRect)frame andTitle:(NSString *)title{
    self = [super init];
    if (self) {
        self.frame = frame;
        
        entryView = [[UITextField alloc] initWithFrame:CGRectMake(75, 0, self.frame.size.width-75, self.frame.size.height)];
        entryView.autocorrectionType = UITextAutocorrectionTypeNo;
        entryView.autocapitalizationType = UITextAutocapitalizationTypeNone;
        entryView.font = [UIFont systemFontOfSize:13];
        
        entryLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 60, self.frame.size.height)];
        entryLabel.font = [UIFont boldSystemFontOfSize:12];
        entryLabel.textAlignment = NSTextAlignmentLeft;
        entryLabel.textColor = [UIColor darkGrayColor];
        entryLabel.text = title;
        
        borderView = [[UIView alloc] initWithFrame:CGRectMake(-5, -2, 400, self.frame.size.height + 4)];
        borderView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        borderView.layer.borderWidth = 1;
        borderView.backgroundColor = [UIColor clearColor];
        
        [self addSubview:entryLabel];
        [self addSubview:borderView];
        [self addSubview:entryView];
        
    }
    return self;

}
@end
