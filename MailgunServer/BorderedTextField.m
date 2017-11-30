//
//  BorderedTextField.m
//  MailgunServer
//
//  Created by teddyr on 2016-08-14.
//  Copyright © 2016 Teddy Rowan. All rights reserved.
//

#import "BorderedTextField.h"

#define WIDTH 290
#define HEIGHT 38
#define BORDER_WIDTH 1
#define WIDTH_MULTIPLE 8
#define CORNER 4
#define LIGHT_GREY 0.87


@implementation BorderedTextField
@synthesize textView;


- (id) init{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, WIDTH, HEIGHT);
        self.backgroundColor = [UIColor blackColor];
        
        textView = [[UITextView alloc] initWithFrame:CGRectMake(WIDTH_MULTIPLE/2, WIDTH_MULTIPLE/2, WIDTH-WIDTH_MULTIPLE*BORDER_WIDTH, HEIGHT-WIDTH_MULTIPLE*BORDER_WIDTH)];
        textView.backgroundColor = [UIColor colorWithRed:LIGHT_GREY green:LIGHT_GREY blue:LIGHT_GREY alpha:1.0];
;
        textView.textAlignment = NSTextAlignmentCenter;
        
        self.layer.borderWidth = BORDER_WIDTH;
        self.layer.cornerRadius = CORNER;
        self.layer.borderColor = [UIColor blackColor].CGColor;
        

        [self addSubview:textView];
        
        //self.layer.borderColor = [UIColor redColor].CGColor;
        //self.layer.borderWidth = 1;
    }
    return self;
    
    
}

@end
