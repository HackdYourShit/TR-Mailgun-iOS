//
//  MGEmailPreviewCell.m
//  MailgunServer
//
//  Created by teddyr on 2016-08-20.
//  Copyright © 2016 Teddy Rowan. All rights reserved.
//

#import "MGEmailPreviewCell.h"

@implementation MGEmailPreviewCell
@synthesize success, messageLabel, recipientLabel, dateLabel, subjectLabel, popoutButton, fullMessage;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    recipientLabel  = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, 290, 20)];
    subjectLabel    = [[UILabel alloc] initWithFrame:CGRectMake(15, 22, 290, 15)];
    messageLabel    = [[UILabel alloc] initWithFrame:CGRectMake(25, 28, 270, 30)];
    dateLabel       = [[UILabel alloc] initWithFrame:CGRectMake(15, 50, 180, 15)];
    successLabel    = [[UILabel alloc] initWithFrame:CGRectMake(255, 50, 50, 15)];
    
    fullMessage = [[NSString alloc] init];
    fullMessage = @"";
    
    popoutButton = [[UIButton alloc] init];
    popoutButton = [UIButton buttonWithType:UIButtonTypeCustom];
    popoutButton.frame = CGRectMake(0, 0, 320, 70);
    [popoutButton setBackgroundColor:[UIColor clearColor]];
    [popoutButton addTarget:self action:@selector(popMessage) forControlEvents:UIControlEventTouchUpInside];

    
    self.frame = CGRectMake(0, 0, 320, 70);
    self.backgroundColor = [UIColor whiteColor];
    self.layer.borderColor = [UIColor blackColor].CGColor;
    self.layer.borderWidth = 1;
    
    [self addSubview:recipientLabel];
    [self addSubview:messageLabel];
    [self addSubview:dateLabel];
    [self addSubview:subjectLabel];
    [self addSubview:successLabel];
    [self addSubview:popoutButton];
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
    
    fullMessage = message;
    
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

- (void) popMessage{
    NSLog(@"attempting to popMessage");
    /* // ---- INTERESTING IDEA. SOME ISSUES IN EXECUTION
    self.frame = CGRectMake(0, 0, 320, 300);
    messageLabel.numberOfLines = 5;
    messageLabel.frame = CGRectMake(25, 280, 270, 120);
    [self.superview bringSubviewToFront:self];
    */
    
    /* // ---- COULDN'T GET ALERT VIEW TO POP UP
    UIAlertController* alert2 = [UIAlertController  alertControllerWithTitle:@"Mailgun TR"
                                                                     message:@"To be set later."
                                                              preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [alert2 dismissViewControllerAnimated:YES completion:nil];}];
    [alert2 addAction:ok];
    [alert2 setMessage:@"Message Sent Successfully!"];
    [self.superview.inputViewController presentViewController:alert2 animated:YES completion:nil];
     */
}

@end
