//
//  MGMessageView.h
//  MailgunServer
//
//  Created by Teddy Rowan on 2018-04-12.
//  Copyright © 2018 Teddy Rowan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MGMessageView : UIView
{
    UILabel *subjectLabel, *fromLabel, *toLabel, *dateLabel, *messageLabel;
    UIScrollView *messageScroll;
}

@property (nonatomic, strong) UILabel *subjectLabel, *fromLabel, *toLabel, *dateLabel, *messageLabel;
@property (nonatomic, strong) UIScrollView *messageScroll;

@end
