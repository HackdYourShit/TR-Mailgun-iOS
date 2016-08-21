//
//  MGEmailPreviewCell.m
//  MailgunServer
//
//  Created by teddyr on 2016-08-20.
//  Copyright © 2016 Teddy Rowan. All rights reserved.
//

#import "MGEmailPreviewCell.h"

@implementation MGEmailPreviewCell
@synthesize success, messageLabel, recipientLabel, dateLabel, subjectLabel;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    recipientLabel  = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, 290, 20)];
    subjectLabel    = [[UILabel alloc] initWithFrame:CGRectMake(15, 22, 290, 15)];
    messageLabel    = [[UILabel alloc] initWithFrame:CGRectMake(25, 28, 270, 30)];
    dateLabel       = [[UILabel alloc] initWithFrame:CGRectMake(15, 50, 180, 15)];
    successLabel    = [[UILabel alloc] initWithFrame:CGRectMake(255, 50, 50, 15)];
    
    self.frame = CGRectMake(0, 0, 320, 70);
    self.backgroundColor = [UIColor whiteColor];
    self.layer.borderColor = [UIColor blackColor].CGColor;
    self.layer.borderWidth = 1;
    
    [self addSubview:recipientLabel];
    [self addSubview:messageLabel];
    [self addSubview:dateLabel];
    [self addSubview:subjectLabel];
    [self addSubview:successLabel];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) populateWithRecipient:(NSString *)recipient withSubject:(NSString *)subject withMessage:(NSString *)message withDate:(NSString *)date withSuccess:(NSString *)status{
    recipientLabel.text = [NSString stringWithFormat:@"TO: %@", recipient];
    messageLabel.text = message;//[message substringToIndex:24];
    dateLabel.text = [NSString stringWithFormat:@"SENT: %@", date];
    subjectLabel.text = subject;
    successLabel.text = status;
    
    messageLabel.font = [UIFont systemFontOfSize:10];
    recipientLabel.font = [UIFont systemFontOfSize:12];
    dateLabel.font = [UIFont systemFontOfSize:11];
    subjectLabel.font = [UIFont systemFontOfSize:11];
    successLabel.font = [UIFont systemFontOfSize:12];
    successLabel.textAlignment = NSTextAlignmentRight;
    
    messageLabel.textColor = [UIColor grayColor];
    successLabel.textColor = [UIColor blackColor];
    if (![status compare:[NSString stringWithFormat:@"SENT"]]){
        successLabel.textColor = [UIColor greenColor];
    } else {
        successLabel.textColor = [UIColor redColor];
    }
}

@end
