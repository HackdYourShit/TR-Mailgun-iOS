//
//  MGEmailPreviewCell.h
//  MailgunServer
//
//  Created by teddyr on 2016-08-20.
//  Copyright © 2016 Teddy Rowan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGEmailPopoutView.h"

@interface MGEmailPreviewCell : UITableViewCell
{
    UILabel *recipientLabel;
    UILabel *dateLabel;
    UILabel *messageLabel;
    UILabel *subjectLabel;
    UILabel *successLabel;
    
    MGEmailPopoutView *popoutButton;
    UILabel *fullMessage;
    
    int storeY; // i need to pass this in... fuck. i could also parse through the MGHistoryTrackers to find the right one... that's annoying though.
    
    // Create a 2nd View that will become unhidden when the think is clicked. then bring that to the front and have a dismiss button on it. I think that should work...
    
}

@property (nonatomic, retain) MGEmailPopoutView* popoutButton;
@property (nonatomic, retain) UILabel* fullMessage;

@property (nonatomic, retain) UILabel* recipientLabel;
@property (nonatomic, retain) UILabel* subjectLabel;
@property (nonatomic, retain) UILabel* dateLabel;
@property (nonatomic, retain) UILabel* messageLabel;
@property (nonatomic, retain) UILabel* succesLabel;
@property (nonatomic) bool success;

- (void) populateWithRecipient:(NSString *)recipient withSubject:(NSString*)subject withMessage:(NSString *)message withDate:(NSString*)date withSuccess:(NSString *)status withNumber:(int)index;
- (void) popMessage;

@end
