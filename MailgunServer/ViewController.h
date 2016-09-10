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
#import "MGHistoryTracker.h"
#import "MGEmailPreviewCell.h"

#import "MGNewEntryField.h"


@interface ViewController : UIViewController
{
  //  int blah;
    NSString *API_KEY;
    NSString *mailgunURL;
    UITextView *activeField;
    
    NSUserDefaults *userPreferences;
    MGHistoryTracker *histMessage;
    MGHistoryTracker *histSubject;
    MGHistoryTracker *histDate;
    MGHistoryTracker *histSender;
    MGHistoryTracker *histRecipient;
    MGHistoryTracker *histStatus;
    
    NSMutableArray *histArray;
    
    /* ----- Mail Sending View ----- */
    UIView *backgroundLayer;
    
    BorderedTextField *toBox;
    BorderedTextField *fromBox;
    BorderedTextField *subjectBox;
    BorderedTextField *messageBox;
    
    UILabel *toLbl; // from Placeholder
    UILabel *fromLbl; // to Placeholder
    UILabel *subjLbl; // subjectBox Placeholder
    
    UILabel *titleLabel;
    
    UIButton *sendButton;
    UIButton* lockView;
    UIButton *historyButton;
    BOOL locked;
    
    
    /* ----- Settings View ----- */
    UIView *settingsLayer;
    UIButton* settingsButton;
    UIButton* backButton;
    BorderedTextField *apiBox;
    BorderedTextField *urlBox;
    UIButton* cancelChanges;;
    UILabel *apiLbl; // api Placeholder
    UILabel *urlLbl; // url Placeholder
    UILabel *creditsLabel;
    
    
    /* ----- History View ----- */
    UIView *historyLayer;
    UIScrollView *historyScroll;
    UIButton *historyBackButton;
    
    
    /* ----- New Sending View ----- */
    UIView *reSendingLayer;
    
    
    /* ---- Menu Layer ----- */
    UIView *menuLayer;
    
    

}

@property (nonatomic, retain) UIView* reSendingLayer;

@property (nonatomic, retain) UIView* menuLayer;


@property (nonatomic, retain) NSUserDefaults* userPreferences;
@property (nonatomic, retain) MGHistoryTracker* histMessage;
@property (nonatomic, retain) MGHistoryTracker* histSubject;
@property (nonatomic, retain) MGHistoryTracker* histDate;
@property (nonatomic, retain) MGHistoryTracker* histSender;
@property (nonatomic, retain) MGHistoryTracker* histRecipient;
@property (nonatomic, retain) MGHistoryTracker* histStatus;

@property (nonatomic, retain) NSMutableArray *histArray;

@property (nonatomic, retain) BorderedTextField* apiBox;
@property (nonatomic, retain) BorderedTextField* urlBox;

@property (nonatomic, retain) UILabel* titleLabel;
@property (nonatomic, retain) UILabel* subjLbl;
@property (nonatomic, retain) UILabel* toLbl;
@property (nonatomic, retain) UILabel* fromLbl;

@property (nonatomic, retain) UILabel* urlLbl;
@property (nonatomic, retain) UILabel* apiLbl;

@property (nonatomic, retain) UILabel* creditsLabel;

@property (nonatomic) BOOL locked;
//@property (nonatomic) int blah;
@property (nonatomic, retain) UIButton* lockView;
@property (nonatomic, retain) UIButton* settingsButton;
@property (nonatomic, retain) UIButton* backButton;
@property (nonatomic, retain) UIButton* historyButton;
@property (nonatomic, retain) UIButton* historyBackButton;


@property (nonatomic, retain) UIView* settingsLayer;
@property (nonatomic, retain) UIView* backgroundLayer;
@property (nonatomic, retain) UIScrollView* historyScroll;
@property (nonatomic, retain) UIView* historyLayer;
@property (nonatomic, retain) UITextView* activeField;

@property (nonatomic, retain) NSString* API_KEY;
@property (nonatomic, retain) NSString* mailgunURL;


@property (nonatomic, retain) BorderedTextField* messageBox;
@property (nonatomic, retain) BorderedTextField* toBox;
@property (nonatomic, retain) BorderedTextField* fromBox;
@property (nonatomic, retain) BorderedTextField* subjectBox;

@property (nonatomic, retain) UIButton* sendButton;
@property (nonatomic, retain) UIButton* cancelChanges;

- (void) sendMessage;
//-(IBAction)editingEnded:(id)sender;
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;


- (void) switchLock;
- (UIImage *)imageWithColor:(UIColor *)color;
- (void) openSettings;
- (void) closeSettings;
- (void) loadSettingsLayer;
- (void) cancelSettingsChange;


- (void) addToHistory:(MGMessage *)message withSuccess:(BOOL)success;
- (void) setStorageLimit:(int)limit;
- (void) clearTrackers;
- (void) printTrackers;

- (void) openHistory;
- (void) closeHistory;
- (void) loadHistoryLayer;
- (void) addSentEntry;
- (int) findLargestHistory;

- (void) loadNewSendingLayer;
- (void) loadMenuLayer;
- (void) loadBackgroundLayer;

- (void) goSettings;
- (void) goHistory;
- (void) goSendMessage;
- (void) goOldSend;
- (void) shiftWindow;
- (void) reShiftWindow;

@end

