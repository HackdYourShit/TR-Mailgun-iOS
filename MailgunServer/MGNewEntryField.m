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

- (id) init {
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, 320, 30);
        
        entryView = [[UITextField alloc] initWithFrame:CGRectMake(75, 0, self.frame.size.width-75, self.frame.size.height)];
        entryView.autocorrectionType = UITextAutocorrectionTypeNo;
        entryView.autocapitalizationType = UITextAutocapitalizationTypeNone;
        entryView.font = [UIFont systemFontOfSize:13];
        
        entryLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 60, self.frame.size.height)];
        entryLabel.font = [UIFont boldSystemFontOfSize:12];
        entryLabel.textAlignment = NSTextAlignmentLeft;
        
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



/*
UITextField *toField = [[UITextField alloc] initWithFrame:CGRectMake(50, 120, self.view.frame.size.width-50, 30)];
toField.autocorrectionType = UITextAutocorrectionTypeNo;
toField.font = [UIFont systemFontOfSize:13];

UILabel *toLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 120, 31, 30)];
toLabel.text = @"TO:";
toLabel.font = [UIFont boldSystemFontOfSize:12];
toLabel.textAlignment = NSTextAlignmentLeft;
toLabel.backgroundColor = [UIColor whiteColor];

UIView *toBorderView = [[UIView alloc] initWithFrame:CGRectMake(-5, 118, 400, 34)];
toBorderView.layer.borderWidth = 1;
toBorderView.layer.borderColor = [UIColor lightGrayColor].CGColor;
toBorderView.backgroundColor = [UIColor clearColor];

[reSendingLayer addSubview:toLabel];
[reSendingLayer addSubview:toBorderView];
[reSendingLayer addSubview:toField];
*/





@end
