//
//  MGContactPopUpList.m
//  MailgunServer
//
//  Created by teddyr on 2016-11-01.
//  Copyright © 2016 Teddy Rowan. All rights reserved.
//

#import "MGContactPopUpList.h"

@implementation MGContactPopUpList

- (id) initWithDictionary:(NSDictionary *)contactList{
    self = [super init];
    if (self) {
        int spacing = 40;
        int count = 0;
        
        self.frame = CGRectMake(0, 0, 200, 140);
        self.backgroundColor = [UIColor whiteColor];
        self.layer.borderColor = [UIColor darkGrayColor].CGColor;
        self.layer.borderWidth = 3;
        self.layer.cornerRadius = 3;
        self.clipsToBounds = YES;
        
        UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:self.frame];

        for(NSString *key in [contactList allKeys]) {
            UIButton *cell = [[UIButton alloc] initWithFrame:CGRectMake(0, spacing*count, self.frame.size.width, spacing)];
            cell.layer.borderWidth = 1;
            cell.layer.borderColor = [UIColor blackColor].CGColor;
            cell.layer.cornerRadius = 2;
            [scroll addSubview:cell];
            
            UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(3, 2, self.frame.size.width-4, spacing/2)];
            nameLabel.text = key;
            nameLabel.font = [UIFont systemFontOfSize:12];
            [cell addSubview:nameLabel];
            
            UILabel *emailLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, spacing/2, self.frame.size.width-4, spacing/2)];
            emailLabel.text = [contactList objectForKey:key];
            emailLabel.font = [UIFont systemFontOfSize:12];
            [cell addSubview:emailLabel];
            
            [cell setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:180.0/255.0 green:250.0/255.0 blue:180.0/255.0 alpha:0.8]] forState:UIControlStateHighlighted];
            
            cell.titleLabel.text = emailLabel.text;
            [cell addTarget:self action:@selector(addEmail:) forControlEvents:UIControlEventTouchUpInside];
            count++;

        }
        
        scroll.contentSize = CGSizeMake(self.frame.size.width, spacing*[contactList count]);
        scroll.clipsToBounds = YES;
        [self addSubview:scroll];
        
    }
    return self;

}

- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (NSString *)addEmail:(id)sender{
    UIButton* btn = (UIButton*)sender;
    NSLog(@"addEmail: %@", btn.titleLabel.text);
    return btn.titleLabel.text;
}


@end
