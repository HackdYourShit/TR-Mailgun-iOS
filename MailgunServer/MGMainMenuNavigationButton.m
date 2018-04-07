//
//  MGMainMenuNavigationButton.m
//  MailgunServer
//
//  Created by Teddy Rowan on 2018-04-06.
//  Copyright © 2018 Teddy Rowan. All rights reserved.
//

#import "MGMainMenuNavigationButton.h"

@implementation MGMainMenuNavigationButton

- (id) initWithFrame:(CGRect)frame withTitle:(NSString*)title{
    self = [super initWithFrame:frame];
    if (self){
        [self setTitle:title forState:UIControlStateNormal];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.layer.borderColor = [UIColor blackColor].CGColor;
        self.layer.borderWidth = 1;
        self.layer.cornerRadius = 5;
        self.clipsToBounds = YES;
        [self setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:180.0/255.0 green:254.0/255.0 blue:180.0/255.0 alpha:0.2]] forState:UIControlStateHighlighted];
        [self addGradient:self];
    }
    return self;
}

- (UIImage *) imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void) addGradient:(UIView *)obj{
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = obj.layer.bounds;
    gradient.colors = [NSArray arrayWithObjects:
                       (id)[UIColor colorWithWhite:1.0f alpha:0.1f].CGColor,
                       (id)[UIColor colorWithWhite:0.4f alpha:0.5f].CGColor,
                       nil];
    gradient.locations = [NSArray arrayWithObjects:
                          [NSNumber numberWithFloat:0.0f],
                          [NSNumber numberWithFloat:1.0f],
                          nil];
    gradient.cornerRadius = obj.layer.cornerRadius;
    [obj.layer addSublayer:gradient];
}


@end
