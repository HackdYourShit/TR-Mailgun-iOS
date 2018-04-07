//
//  MGContactPopButton.m
//  MailgunServer
//
//  Created by Teddy Rowan on 2018-04-06.
//  Copyright © 2018 Teddy Rowan. All rights reserved.
//

#import "MGContactPopButton.h"

@implementation MGContactPopButton

- (id) initWithFrame:(CGRect)frame andColor:(UIColor*)color{
    self = [super initWithFrame:frame];
    if (self){
        self.backgroundColor = color;
        self.layer.cornerRadius = self.frame.size.height/2;
        self.layer.borderWidth = 1;
        self.layer.borderColor = [UIColor blackColor].CGColor;
        
        // these are two different buttons for now, switch to one dual purpose one eventually.
        if ([color isEqual:[UIColor greenColor]]){
            self.hidden = NO;
            [self setTitle:@"+" forState:UIControlStateNormal];
        } else {
            self.hidden = YES;
            [self setTitle:@"-" forState:UIControlStateNormal];
        }
        
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    return self;
}

@end
