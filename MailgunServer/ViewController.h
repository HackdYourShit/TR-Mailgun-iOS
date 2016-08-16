//
//  ViewController.h
//  MailgunServer
//
//  Created by teddyr on 2016-08-14.
//  Copyright © 2016 Teddy Rowan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Mailgun.h"
#import "BorderedTextField.h"

@interface ViewController : UIViewController
{
  //  int blah;

    BorderedTextField *fromBox;
    BorderedTextField *toBox;
    BorderedTextField *messageBox;
    BorderedTextField *subjectBox;
    
    UILabel *subjLbl; // subjectBox Placeholder
    UILabel *toLbl; // from Placeholder
    UILabel *fromLbl; // to Placeholder
    
    UIView *backgroundLayer; // put everything on this layer then I can move the whole thing when the text input comes up so that you can still see the input.
    UIView *settingsLayer;
    
    UIButton *sendButton;
    
    UITextView *activeField;
    
    UIButton* lockView;
    BOOL locked;
    
    UIButton* settingsButton;
    UIButton* backButton;
    
    NSString *API_KEY;
    NSString *mailgunURL;
}

@property (nonatomic, retain) UILabel* subjLbl;
@property (nonatomic, retain) UILabel* toLbl;
@property (nonatomic, retain) UILabel* fromLbl;


@property (nonatomic) BOOL locked;
//@property (nonatomic) int blah;
@property (nonatomic, retain) UIButton* lockView;
@property (nonatomic, retain) UIButton* settingsButton;
@property (nonatomic, retain) UIButton* backButton;

@property (nonatomic, retain) UIView* settingsLayer;
@property (nonatomic, retain) UIView* backgroundLayer;
@property (nonatomic, retain) UITextView* activeField;

@property (nonatomic, retain) NSString* API_KEY;
@property (nonatomic, retain) NSString* mailgunURL;


@property (nonatomic, retain) BorderedTextField* messageBox;
@property (nonatomic, retain) BorderedTextField* toBox;
@property (nonatomic, retain) BorderedTextField* fromBox;
@property (nonatomic, retain) BorderedTextField* subjectBox;

@property (nonatomic, retain) UIButton* sendButton;

- (void) sendMessage;
//-(IBAction)editingEnded:(id)sender;
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;


- (void) switchLock;
- (UIImage *)imageWithColor:(UIColor *)color;
- (void) openSettings;
- (void) closeSettings;
- (void) loadSettingsLayer;

@end

