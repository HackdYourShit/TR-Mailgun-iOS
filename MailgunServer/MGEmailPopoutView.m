//
//  MGEmailPopoutView.m
//  MailgunServer
//
//  Created by teddyr on 2016-08-25.
//  Copyright © 2016 Teddy Rowan. All rights reserved.
//

// THE IDEA BEHIND THIS IS THAT IT WILL CONTAIN A LABEL (MAYBE SOMETHING SCROLLABLE?) OR SOMETHING THAT IS EMBEDDED IN A BUTTON THAT IS EMBEDDED IN A MGEMAILPREVIEWCELL AND WILL POPOUT (UNHIDE) WHEN YOU CLICK ON THE CELL  


#import "MGEmailPopoutView.h"

@implementation MGEmailPopoutView
@synthesize fullMessage;

- (id) init{
    self = [super init];
    if (self) {
        
        /*
        self.backgroundColor = [UIColor grayColor];
        
        self.layer.borderColor = [UIColor greenColor].CGColor;
        self.layer.borderWidth = 3;
        self.layer.cornerRadius = 4;
        //fullMessage.backgroundColor = [UIColor whiteColor];
         */
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
