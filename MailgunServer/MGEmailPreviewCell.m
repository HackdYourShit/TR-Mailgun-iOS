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
    
    fullMessage = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 300, 450)];
    fullMessage.hidden = YES;
    [self addSubview:fullMessage];
    
    popoutButton = [[MGEmailPopoutView alloc] init];
    popoutButton = [MGEmailPopoutView buttonWithType:UIButtonTypeCustom];
    popoutButton.frame = CGRectMake(0, 0, 320, 70);
    [popoutButton setBackgroundColor:[UIColor clearColor]];
    
    // making this into a global function now that will populate one specific premade layer
    //[popoutButton addTarget:self action:@selector(popMessage) forControlEvents:UIControlEventTouchUpInside];

    
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
    
    [self bringSubviewToFront:fullMessage];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) populateWithRecipient:(NSString *)recipient withSubject:(NSString *)subject withMessage:(NSString *)message withDate:(NSString *)date withSuccess:(NSString *)status withNumber:(int)index{
    
    recipientLabel.text = [NSString stringWithFormat:@"TO: %@", recipient];
    messageLabel.text = message;//[message substringToIndex:24];
    dateLabel.text = [NSString stringWithFormat:@"SENT: %@", date];
    subjectLabel.text = subject;
    successLabel.text = status;
    storeY = index;
    
    fullMessage.text = message;
    fullMessage.numberOfLines = 6;
    
    messageLabel.font = [UIFont systemFontOfSize:10];
    recipientLabel.font = [UIFont systemFontOfSize:12];
    dateLabel.font = [UIFont systemFontOfSize:11];
    subjectLabel.font = [UIFont systemFontOfSize:11];
    successLabel.font = [UIFont boldSystemFontOfSize:12];
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
    
    /* // THIS IS THE HACKIEST WAY TO DO IT AND PROBABLY THE BEST. NEED TO PARSE THROUGH THE MGHISTORYTRACKERS TO FIND THE RIGHT MESSAGE THEN GO FROM THERE.
    self.frame = CGRectMake(0, -storeY + 150, 320, 580);
    self.layer.borderWidth = 2;
    self.layer.borderColor = [UIColor blackColor].CGColor;
    self.layer.cornerRadius = 5;
    fullMessage.hidden = NO;
    fullMessage.layer.borderColor = [UIColor greenColor].CGColor;
    fullMessage.layer.borderWidth = 3;
    fullMessage.layer.cornerRadius = 4;
    //fullMessage.backgroundColor = [UIColor greenColor];
    [self.superview bringSubviewToFront:self];
    */
        
    /* // ---- INTERESTING IDEA. SOME ISSUES IN EXECUTION
    self.frame = CGRectMake(0, 0, 320, 300);
    messageLabel.numberOfLines = 5;
    messageLabel.frame = CGRectMake(25, 280, 270, 120);
    [self.superview bringSubviewToFront:self];
    */
    
    // this is broken as fuck. fix it later.
    return;
    
    
    self.frame= CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    self.layer.borderWidth = 2;
    self.layer.borderColor = [UIColor blackColor].CGColor;
    self.layer.cornerRadius = 5;
    fullMessage.hidden = NO;
    
    fullMessage.layer.borderColor = [UIColor greenColor].CGColor;
    fullMessage.layer.borderWidth = 3;
    fullMessage.layer.cornerRadius = 4;
    fullMessage.backgroundColor = [UIColor whiteColor];
    
     [self.superview bringSubviewToFront:self];
    
    
}

@end
