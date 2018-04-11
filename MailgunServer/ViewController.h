//
//  ViewController.h
//  MailgunServer
//
//  Created by teddyr on 2016-08-14.
//  Copyright © 2016 Teddy Rowan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Contacts/Contacts.h>
#import "BorderedTextField.h"
#import "Mailgun.h"
#import "MGHistoryTracker.h"
#import "MGEmailPreviewCell.h"
#import "MGNewEntryField.h"
#import "MGContactPopUpList.h"
#import "MGPrivateAPIKeyHolder.h"

#import "MGContactPopButton.h"
#import "MGMainMenuNavigationButton.h"


@interface ViewController : UIViewController
{
    double SCREEN_WIDTH, SCREEN_HEIGHT;
    
    NSString *API_KEY, *mailgunURL;
    UITextView *activeField; // what is this? i think this is a remenant of old code. need to test though.
    
    NSUserDefaults *userPreferences;
    MGHistoryTracker *histMessage, *histSubject, *histDate, *histSender, *histRecipient, *histStatus;
    
    NSMutableArray *histArray;
    NSMutableDictionary *contactEmails;
    
    
    /* ----- Mail Sending View ----- */
    UIView *backgroundLayer; // rename this bullshit
    UILabel *titleLabel;
    UILabel *toLbl, *fromLbl, *subjLbl; // Placeholders for to, from, subject labels
    
    BorderedTextField *toBox, *fromBox, *subjectBox, *messageBox;
    UIButton *sendButton, *lockView, *historyButton;
    BOOL locked;
    
    
    /* ----- Settings View ----- */
    UIView *settingsLayer;
    UIButton* settingsButton, *backButton, *cancelchanges;
    BorderedTextField *apiBox, *urlBox;
    UILabel *apiLbl, *urlLbl, *creditsLabel; // Placeholders for api, url. Credits Label.
    
    
    /* ----- History View ----- */
    UIView *historyLayer;
    UIScrollView *historyScroll;
    UIButton *historyBackButton;
    
    
    /* ----- New Sending View ----- */
    UIView *n2_SendingLayer;
    UITextView *messageEntryField;
    MGNewEntryField *subjEntryField, *fromEntryField, *ccEntryField, *toEntryField;
    UILabel *composeLabel;
    MGContactPopUpList* toContactPopUp, *ccContactPopUp;
    MGContactPopButton *popSendList, *hideSendList, *popCCList, *hideCCList;
    
    
    /* ---- Menu Layer ----- */
    UIView *menuLayer;
    
    
    /* ---- Message View Layer ---- */
    UIView *messageView;
    UIButton *MVBackButton;
    
    
    

}

@property (nonatomic) BOOL locked;
@property (nonatomic) double SCREEN_WIDTH, SCREEN_HEIGHT;

@property (nonatomic, retain) BorderedTextField* messageBox, *toBox, *fromBox, *subjectBox, *apiBox, *urlBox;
@property (nonatomic, strong) MGContactPopButton *popSendList, *hideSendList, *popCCList, *hideCCList;
@property (nonatomic, retain) MGContactPopUpList* toContactPopUp, *ccContactPopUp;
@property (atomic, retain) MGHistoryTracker* histMessage, *histSubject, *histDate, *histSender, *histRecipient, *histStatus;
@property (nonatomic, retain) MGNewEntryField* subjEntryField, *fromEntryField, *ccEntryField, *toEntryField;
@property (nonatomic, retain) NSMutableArray *histArray;
@property (nonatomic, retain) NSMutableDictionary* contactEmails;
@property (atomic, retain)    NSUserDefaults* userPreferences;
@property (nonatomic, retain) NSString* API_KEY, *mailgunURL;
@property (nonatomic, retain) UIScrollView* historyScroll;
@property (nonatomic, retain) UITextView* activeField, *messageEntryField;
@property (nonatomic, retain) UIButton* lockView, *settingsButton, *backButton, *historyButton, *historyBackButton, *sendButton, *cancelChanges, *MVBackButton;
@property (nonatomic, retain) UILabel* titleLabel, *subjLbl, *toLbl, *fromLbl, *urlLbl, *apiLbl, *creditsLabel, *composeLabel;
@property (nonatomic, retain) UIView* settingsLayer, *backgroundLayer, *historyLayer, *n2_SendingLayer, *menuLayer, *messageView;



/// ViewDidLoad Helper Functions
- (void) loadContactsList;
- (void) loadSettingsLayer; // load settings screen
- (void) loadN2_SendingLayer;
- (void) loadMainMenuLayer;
- (void) loadBackgroundLayer; // deprecated send message screen
- (void) loadHistoryLayer;


// Message Sending Methods
- (void) switchLock; // Unlock sending in deprecated compose view
- (void) deprecatedSendMessage; // send a message from the old sending form
- (void) n2_SendMessage; // send a message from the new sending form
- (void) addSentEntry; // add a new entry to sent messages history after you send a message

// Methods for selecting recipient addresses from your contacts.
- (void) showToContactList;
- (void) hideToContactList;
- (void) showCCContactList;
- (void) hideCCContactList;


// Sent Message Storage Methods
- (void) addToHistory:(MGMessage *)message withSuccess:(BOOL)success;
- (void) setStorageLimit:(int)limit;
- (void) clearTrackers;
- (void) printTrackers;
- (int) findLargestHistory;


// Navigation Methods -- Screen exiting methods
- (void) cancelSettingsChange; // cancel out of changing settings
- (void) closeSettings;

// Navigation Methods -- Animate the changing between views
- (void) shiftWindow:(id)sender;
- (void) reShiftWindow;


// Sent Messages Screen Navigation
- (void)selectCell:(id) sender; // Determine which Sent Message was selected
- (void)loadMessageLayerWithIndex:(int)index; // Select a Sent Message to View
- (void)MVGoBack; // Go from Individual Sent Message in History to Sent Messages Folder


// Miscellaneous Methods
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event; // dismiss keyboard when done editting
- (void) showHideAPIField; // cover or uncover API key display in settings screen


// Shared UX Methods
- (void) addGradient:(UIView *)obj;
- (UIImage *)imageWithColor:(UIColor *)color;

@end

