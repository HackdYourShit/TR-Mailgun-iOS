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
#import <Contacts/Contacts.h>
#import "MGContactPopUpList.h"


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
    
    NSMutableDictionary *contactEmails;
    
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
    
    
    /* ----- New Sending View ----- */ // Fields are needed to grab the text when you're sending a message
    UIView *reSendingLayer;
    UITextView *messageEntryField;
    MGNewEntryField *subjEntryField;
    MGNewEntryField *fromEntryField;
    MGNewEntryField *ccEntryField;
    MGNewEntryField *toEntryField;
    UILabel *composeLabel;
    MGContactPopUpList* toContactPopUp;
    UIButton *popSendList;
    UIButton *hideSendList;
    MGContactPopUpList* ccContactPopUp;
    UIButton *popCCList;
    UIButton *hideCCList;
    
    /* ---- Menu Layer ----- */
    UIView *menuLayer;
    
    
    /* ---- Message View Layer ---- */
    UIView *messageView;
    //UILabel *MVSenderLabel;
    //UILabel *MVRecipientLabel;
    //UILabel *MVCCLabel;
    //UILabel *MVMessageLabel;
    UIButton *MVBackButton;
    

}

@property (nonatomic, retain) UILabel* composeLabel;
@property (nonatomic, retain) UIView* messageView;
@property (nonatomic, retain) UIButton* MVBackButton;

@property (nonatomic, retain) MGContactPopUpList* toContactPopUp;
@property (nonatomic, retain) UIButton* popSendList;
@property (nonatomic, retain) UIButton* hideSendList;

@property (nonatomic, retain) MGContactPopUpList* ccContactPopUp;
@property (nonatomic, retain) UIButton* popCCList;
@property (nonatomic, retain) UIButton* hideCCList;


@property (nonatomic, retain) NSMutableDictionary* contactEmails;

@property (nonatomic, retain) UIView* reSendingLayer;

@property (nonatomic, retain) UIView* menuLayer;
@property (nonatomic, retain) UITextView* messageEntryField;
@property (nonatomic, retain) MGNewEntryField* subjEntryField;
@property (nonatomic, retain) MGNewEntryField* fromEntryField;
@property (nonatomic, retain) MGNewEntryField* ccEntryField;
@property (nonatomic, retain) MGNewEntryField* toEntryField;

@property (atomic, retain) NSUserDefaults* userPreferences;
@property (atomic, retain) MGHistoryTracker* histMessage;
@property (atomic, retain) MGHistoryTracker* histSubject;
@property (atomic, retain) MGHistoryTracker* histDate;
@property (atomic, retain) MGHistoryTracker* histSender;
@property (atomic, retain) MGHistoryTracker* histRecipient;
@property (atomic, retain) MGHistoryTracker* histStatus;

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
//- (void) openSettings;
//- (void) closeSettings;
- (void) loadSettingsLayer;
- (void) cancelSettingsChange;


- (void) addToHistory:(MGMessage *)message withSuccess:(BOOL)success;
- (void) setStorageLimit:(int)limit;
- (void) clearTrackers;
- (void) printTrackers;

//- (void) openHistory;
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

- (void) showHideAPIField;
- (void) sendMessageNew;

- (void)selectCell:(id) sender;
- (void)loadMessageLayerWithIndex:(int)index;
- (void)MVGoBack;

- (void) showToContactList;
- (void) hideToContactList;

- (void) showCCContactList;
- (void) hideCCContactList;

@end

