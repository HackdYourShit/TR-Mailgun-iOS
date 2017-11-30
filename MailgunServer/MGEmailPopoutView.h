//
//  MGEmailPopoutView.h
//  MailgunServer
//
//  Created by teddyr on 2016-08-25.
//  Copyright © 2016 Teddy Rowan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MGEmailPopoutView : UIButton
{
    UILabel *fullMessage;
}

@property (nonatomic, retain) UILabel* fullMessage;

@end
