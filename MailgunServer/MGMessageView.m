//
//  MGMessageView.m
//  MailgunServer
//
//  Created by Teddy Rowan on 2018-04-12.
//  Copyright © 2018 Teddy Rowan. All rights reserved.
//

#import "MGMessageView.h"

@implementation MGMessageView
@synthesize messageLabel, toLabel, fromLabel, subjectLabel, dateLabel, messageScroll;

- (id) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        
    }
    return self;
}


@end


/*
 UIScrollView *messageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 60, self.view.frame.size.width, 600)];
 [messageView addSubview:messageScrollView];
 
 // This all needs to move to a custom class but will leave it for now because I want to redo all of it anyway
 // It actually was the idea behind MGEmailPopoutView but I never got around to building it.
 UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, 150, 20)];
 dateLabel.text = @"SENT: ";
 dateLabel.font = [UIFont boldSystemFontOfSize:16];
 [messageScrollView addSubview:dateLabel];
 
 UILabel *MVDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 40, 300, 30)];
 MVDateLabel.text = [histDate objectForKey:[NSString stringWithFormat:@"%d",index]];
 MVDateLabel.font = [UIFont systemFontOfSize:14];
 [messageScrollView addSubview:MVDateLabel];
 
 UILabel *toLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 80, 150, 20)];
 toLabel.text = @"TO: ";
 toLabel.font = [UIFont boldSystemFontOfSize:16];
 [messageScrollView addSubview:toLabel];
 
 UILabel *MVToLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, 300, 30)];
 MVToLabel.text = [histRecipient objectForKey:[NSString stringWithFormat:@"%d",index]];
 MVToLabel.font = [UIFont systemFontOfSize:14];
 [messageScrollView addSubview:MVToLabel];
 
 
 UILabel *fromLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 140, 150, 20)];
 fromLabel.text = @"SENDER: ";
 fromLabel.font = [UIFont boldSystemFontOfSize:16];
 [messageScrollView addSubview:fromLabel];
 
 UILabel *MVFromLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 160, 300, 30)];
 MVFromLabel.text = [histSender objectForKey:[NSString stringWithFormat:@"%d",index]];
 MVFromLabel.font = [UIFont systemFontOfSize:14];
 [messageScrollView addSubview:MVFromLabel];
 
 
 UILabel *subjectLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 200, 150, 20)];
 subjectLabel.text = @"SUBJECT: ";
 subjectLabel.font = [UIFont boldSystemFontOfSize:16];
 [messageScrollView addSubview:subjectLabel];
 
 UILabel *MVSubjectLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 220, 300, 30)];
 MVSubjectLabel.text = [histSubject objectForKey:[NSString stringWithFormat:@"%d",index]];
 MVSubjectLabel.font = [UIFont systemFontOfSize:14];
 [messageScrollView addSubview:MVSubjectLabel];
 
 
 UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 260, 150, 20)];
 messageLabel.text = @"MESSAGE: ";
 messageLabel.font = [UIFont boldSystemFontOfSize:16];
 [messageScrollView addSubview:messageLabel];
 
 UILabel *MVMessageLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 280, 280, 400)];
 MVMessageLabel.text = [histMessage objectForKey:[NSString stringWithFormat:@"%d",index]];
 MVMessageLabel.font = [UIFont systemFontOfSize:14];
 MVMessageLabel.numberOfLines = 0;
 [MVMessageLabel sizeToFit];
 [messageScrollView addSubview:MVMessageLabel];
 
 messageScrollView.contentSize = CGSizeMake(self.view.frame.size.width, MVMessageLabel.frame.origin.y + MVMessageLabel.frame.size.height + 100);
 
 
 */
