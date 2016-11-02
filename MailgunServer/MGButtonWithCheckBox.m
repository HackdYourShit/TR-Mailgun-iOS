//
//  MGButtonWithCheckBox.m
//  MailgunServer
//
//  Created by teddyr on 2016-11-02.
//  Copyright © 2016 Teddy Rowan. All rights reserved.
//

#import "MGButtonWithCheckBox.h"

@implementation MGButtonWithCheckBox
@synthesize checkImage;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        checkImage = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width-frame.size.height, frame.size.height/4, frame.size.height/2, frame.size.height/2)];
        checkImage.image = [UIImage imageNamed:@"checkbox.png"];
        [self addSubview:checkImage];
    }
    
    return self;
}

@end
