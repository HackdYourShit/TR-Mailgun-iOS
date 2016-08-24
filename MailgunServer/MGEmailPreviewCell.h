//
//  MGEmailPreviewCell.h
//  MailgunServer
//
//  Created by teddyr on 2016-08-20.
//  Copyright © 2016 Teddy Rowan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MGEmailPreviewCell : UITableViewCell
{
    UILabel *recipientLabel;
    UILabel *dateLabel;
    UILabel *messageLabel;
    UILabel *subjectLabel;
    UILabel *successLabel;
    
    UIButton *popoutButton;
    NSString *fullMessage;
}

@property (nonatomic, retain) UIButton* popoutButton;
@property (nonatomic, retain) NSString* fullMessage;

@property (nonatomic, retain) UILabel* recipientLabel;
@property (nonatomic, retain) UILabel* subjectLabel;
@property (nonatomic, retain) UILabel* dateLabel;
@property (nonatomic, retain) UILabel* messageLabel;
@property (nonatomic, retain) UILabel* succesLabel;
@property (nonatomic) bool success;

- (void) populateWithRecipient:(NSString *)recipient withSubject:(NSString*)subject withMessage:(NSString *)message withDate:(NSString*)date withSuccess:(NSString *)status;
- (void) popMessage;

@end
