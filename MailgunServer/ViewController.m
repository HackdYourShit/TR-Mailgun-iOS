//
//  ViewController.m
//  MailgunServer


// TO DO:
//   Find a way to attach images, hopefully from Photos Library. Looks to be not too bad to do.
    // https://developer.apple.com/library/ios/documentation/AudioVideo/Conceptual/CameraAndPhotoLib_TopicsForIOS/Articles/PickinganItemfromthePhotoLibrary.html

//   Refactor ViewController.m
        // Lots of duplicates for the Lbl stuff aka the preview shit
        // No comments..
        // Ordering of functions is fucking awful.

//   Make capacity tuneable in app

// Make a opening menu screen for API and domain input

#import "ViewController.h"

// what are these even for...?
#define INIT_HEIGHT_LAB 68
#define INIT_HEIGHT_BOX 110
#define SPACING 60
#define INIT_X 20

@interface ViewController ()
@end

@implementation ViewController
@synthesize toBox, fromBox, subjectBox, messageBox, sendButton, backgroundLayer, activeField, API_KEY, mailgunURL, lockView, locked, subjLbl, settingsButton, settingsLayer, backButton, toLbl, fromLbl, apiBox, urlBox, titleLabel, cancelChanges, urlLbl, apiLbl, creditsLabel, userPreferences, histDate, histSender, histMessage, histSubject, histRecipient, historyLayer, historyButton, historyBackButton, historyScroll, histStatus, histArray, n2_SendingLayer, menuLayer, messageEntryField, toEntryField, fromEntryField, subjEntryField, ccEntryField, messageView, MVBackButton, composeLabel, contactEmails, toContactPopUp, hideSendList, popSendList, ccContactPopUp, hideCCList, popCCList, SCREEN_HEIGHT, SCREEN_WIDTH;

- (void)viewDidLoad { //cleaned
    [super viewDidLoad];
    activeField = [[UITextView alloc] init];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    SCREEN_HEIGHT = screenRect.size.height;
    SCREEN_WIDTH = screenRect.size.width;
    
    userPreferences = [[NSUserDefaults alloc] initWithSuiteName:@"preferences"];
    //API_KEY = [userPreferences objectForKey:@"api_key"];
    //mailgunURL = [userPreferences objectForKey:@"mail_url"];
    API_KEY = [[MGPrivateAPIKeyHolder alloc] init].APIKey;
    mailgunURL = [[NSString alloc] initWithFormat:@"teddyrowan.com" ];
    
    
    // This makes me vomit.
    histMessage = [[MGHistoryTracker alloc] initWithSuiteName:@"messageTracker2"];
    histRecipient = [[MGHistoryTracker alloc] initWithSuiteName:@"recipientTracker2"];
    histSubject = [[MGHistoryTracker alloc] initWithSuiteName:@"subjectTracker2"];
    histSender = [[MGHistoryTracker alloc] initWithSuiteName:@"senderTracker2"];
    histDate = [[MGHistoryTracker alloc] initWithSuiteName:@"dateTracker2"];
    histStatus = [[MGHistoryTracker alloc] initWithSuiteName:@"statusTracker2"];
    histMessage.title = @"messages";
    histRecipient.title = @"recipient";
    histSubject.title = @"subject";
    histSender.title = @"sender";
    histDate.title = @"date";
    histStatus.title = @"status";
    histArray = [[NSMutableArray alloc] init];
    [histArray addObject:histMessage];
    [histArray addObject:histRecipient];
    [histArray addObject:histSubject];
    [histArray addObject:histSender];
    [histArray addObject:histDate];
    [histArray addObject:histStatus];
    
    [self setStorageLimit:25];
    //[self printTrackers];
    //[self clearTrackers];
    //[self clearTrackers];
    [self printTrackers];

    // viewDidLoad Helper Methods
    [self loadBackgroundLayer];
    [self loadSettingsLayer];
    [self loadHistoryLayer];
    [self loadN2_SendingLayer];
    [self loadMainMenuLayer];
} // viewDidLoad()


#pragma mark - ViewDidLoad Helper Functions
- (void) loadContactsList{
    contactEmails = [[NSMutableDictionary alloc] init];
    /* ---- GRABS YOUR CONTACTS EMAIL ADDRESSES ------*/
    CNContactStore *store = [[CNContactStore alloc] init];
    NSArray *keys = @[CNContactFamilyNameKey, CNContactGivenNameKey, CNContactPhoneNumbersKey, CNContactEmailAddressesKey,CNContactPostalAddressesKey, CNLabelWork, CNLabelDateAnniversary];
    NSString *containerId = store.defaultContainerIdentifier;
    NSPredicate *predicate = [CNContact predicateForContactsInContainerWithIdentifier:containerId];
    NSError *error;
    NSArray *cnContacts = [store unifiedContactsMatchingPredicate:predicate keysToFetch:keys error:&error];
    if (error) {
        NSLog(@"Error Grabbing Contacts. Not sure if this will crash...");
    } else {
        for (CNContact *contact in cnContacts) {
            if ([contact.emailAddresses count]){
                for (int i = 0; i < [contact.emailAddresses count]; i++){
                    NSString *contactName = [NSString stringWithFormat:@"%@ %@", contact.givenName, contact.familyName];
                    NSString *contactEmail = (NSString *)contact.emailAddresses[i].value;
                    [contactEmails setValue:contactName forKey:contactEmail];
                }
            }
        }
    }
    
    //for(NSString *key in [contactEmails allKeys]) {
    //    NSLog(@"%@: %@",key, [contactEmails objectForKey:key]);
    //}
}

- (void) loadSettingsLayer{
    settingsLayer = [[UIView alloc] init];
    settingsLayer.frame = self.view.frame;
    settingsLayer.center = CGPointMake(settingsLayer.center.x+SCREEN_WIDTH, settingsLayer.center.y);
    settingsLayer.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:settingsLayer];
    
    UILabel* settingsLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 25, 200, 60)];
    settingsLabel.text = @" APP SETTINGS ";
    settingsLabel.font = [UIFont boldSystemFontOfSize:18.0];
    settingsLabel.textAlignment = NSTextAlignmentCenter;
    settingsLabel.center = CGPointMake(self.view.center.x, settingsLabel.center.y);
    [settingsLayer addSubview:settingsLabel];
    
    
    backButton = [[UIButton alloc] init];
    backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(10, 35, 60, 40);
    backButton.backgroundColor = [UIColor clearColor];
    [backButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [backButton setTitle:@"MENU" forState:UIControlStateNormal];
    backButton.titleLabel.font = [UIFont systemFontOfSize:14];
    backButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    [backButton addTarget:self action:@selector(closeSettings) forControlEvents:UIControlEventTouchUpInside];
    [settingsLayer addSubview:backButton];
    
    
    UILabel* apiLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, INIT_HEIGHT_LAB+0*SPACING, 280, 30)];
    apiLabel.text = @" PRIVATE API-KEY:    ";
    apiLabel.font = [UIFont systemFontOfSize:12];
    [settingsLayer addSubview:apiLabel];
    
    apiBox = [[BorderedTextField alloc] init];
    apiBox.center = CGPointMake(self.view.center.x, INIT_HEIGHT_BOX + 0*SPACING);
    apiBox.textView.text = API_KEY;
    apiBox.textView.autocapitalizationType = UITextAutocapitalizationTypeNone;
    apiBox.textView.backgroundColor = [UIColor blackColor];
    [settingsLayer addSubview:apiBox];
    
    
    UIButton *showHideAPI = [[UIButton alloc] init];
    showHideAPI = [UIButton buttonWithType:UIButtonTypeCustom];
    showHideAPI.frame = CGRectMake(0, 0, 140, 30);
    showHideAPI.center = CGPointMake(apiBox.center.x, apiBox.center.y + SPACING*3.0/4.0);
    showHideAPI.backgroundColor = [UIColor colorWithRed:.65 green:.65 blue:.65 alpha:.9];
    [showHideAPI setTitle:@"Show / Hide" forState:UIControlStateNormal];
    [showHideAPI setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    showHideAPI.titleLabel.font = [UIFont systemFontOfSize:14];
    showHideAPI.layer.cornerRadius = 5;
    showHideAPI.layer.borderColor = [UIColor blackColor].CGColor;
    showHideAPI.layer.borderWidth = 1;
    [showHideAPI addTarget:self action:@selector(showHideAPIField) forControlEvents:UIControlEventTouchUpInside];
    [showHideAPI setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:25.0/255 green:25.0/255 blue:25.0/255 alpha:0.3]] forState:UIControlStateHighlighted];
    showHideAPI.clipsToBounds = YES;
    [self addGradient:showHideAPI];
    [settingsLayer addSubview:showHideAPI];
    
    
    UILabel* urlLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, INIT_HEIGHT_LAB+2*SPACING, 280, 30)];
    urlLabel.text = @" DOMAIN URL:    ";
    urlLabel.font = [UIFont systemFontOfSize:12];
    [settingsLayer addSubview:urlLabel];
    
    urlBox = [[BorderedTextField alloc] init];
    urlBox.center = CGPointMake(self.view.center.x, INIT_HEIGHT_BOX + 2*SPACING);
    urlBox.textView.text = mailgunURL;
    urlBox.textView.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [settingsLayer addSubview:urlBox];
    
    cancelChanges = [[UIButton alloc] init];
    cancelChanges = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelChanges.frame = CGRectMake((SCREEN_WIDTH-200)/2, INIT_HEIGHT_BOX+2.75*SPACING, 200, 60);
    cancelChanges.backgroundColor = [UIColor redColor];
    cancelChanges.titleLabel.textColor = [UIColor whiteColor];
    [cancelChanges setTitle:@"DISCARD CHANGES" forState:UIControlStateNormal];
    [cancelChanges addTarget:self action:@selector(cancelSettingsChange) forControlEvents:UIControlEventTouchUpInside];
    cancelChanges.layer.cornerRadius = 5;
    cancelChanges.layer.borderColor = [UIColor blackColor].CGColor;
    cancelChanges.layer.borderWidth = 1;
    [cancelChanges setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:254.0/255.0 green:180.0/255.0 blue:180.0/255.0 alpha:0.8]] forState:UIControlStateHighlighted];
    cancelChanges.clipsToBounds = YES;
    [self addGradient:cancelChanges];
    [settingsLayer addSubview:cancelChanges];
    
    
    apiLbl = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 0.0,apiBox.textView.frame.size.width - 10.0, 30)];
    [apiLbl setText:@"EX: key-4a41a48d30aafce3ccda648i0c90206b"];
    [apiLbl setBackgroundColor:[UIColor clearColor]];
    [apiLbl setTextColor:[UIColor lightGrayColor]];
    apiLbl.textAlignment = NSTextAlignmentCenter;
    apiLbl.font = [UIFont systemFontOfSize:11.0];
    apiBox.textView.delegate = (id)self;
    apiLbl.hidden = YES;
    [apiBox.textView addSubview:apiLbl];
    
    urlLbl = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 0.0,urlBox.textView.frame.size.width - 10.0, 30)];
    [urlLbl setText:@"EX: teddyrowan.com/"];
    [urlLbl setBackgroundColor:[UIColor clearColor]];
    [urlLbl setTextColor:[UIColor lightGrayColor]];
    urlLbl.textAlignment = NSTextAlignmentCenter;
    urlLbl.font = [UIFont systemFontOfSize:11.0];
    urlBox.textView.delegate = (id)self;
    urlLbl.hidden = YES;
    [urlBox.textView addSubview:urlLbl];
    
    NSString *versionText = [NSString stringWithFormat:@"%@.%@", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"], [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]];
    creditsLabel = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-280)/2, INIT_HEIGHT_LAB+4.8*SPACING, 280, 45)];
    creditsLabel.text = [[NSString stringWithFormat:@"Version %@.", versionText] uppercaseString];
    creditsLabel.textAlignment = NSTextAlignmentCenter;
    [settingsLayer addSubview:creditsLabel];
    
    
    UIImageView *settingsMGLogo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Mailgun180white.png"]];
    settingsMGLogo.frame = CGRectMake(50, 420, 90, 90);
    [settingsLayer addSubview:settingsMGLogo];
    
    UIImageView *settingsTRLogo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"TR_logo.png"]];
    settingsTRLogo.frame = CGRectMake(SCREEN_WIDTH/2, 420, 90, 90);
    [settingsLayer addSubview:settingsTRLogo];
    
    UILabel *customMGAppLabelSettings = [[UILabel alloc] initWithFrame:CGRectMake(0, 510, self.view.frame.size.width, 40)];
    customMGAppLabelSettings.text = @"CUSTOM MAILGUN APP BY TEDDYROWAN.COM";
    customMGAppLabelSettings.font = [UIFont systemFontOfSize:12];
    customMGAppLabelSettings.textColor = [UIColor blackColor];
    customMGAppLabelSettings.textAlignment = NSTextAlignmentCenter;
    [settingsLayer addSubview:customMGAppLabelSettings];
}

- (void) loadN2_SendingLayer{ // Minor cleaning
    /* --- NEED TO EMBED ALL THIS IN A SCROLL VIEW AND SCROLL DOWN AS THE MESSAGE GETS LONGER --- */
    n2_SendingLayer = [[UIView alloc] initWithFrame:self.view.frame];
    n2_SendingLayer.center = CGPointMake(n2_SendingLayer.center.x+SCREEN_WIDTH, n2_SendingLayer.center.y);
    n2_SendingLayer.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:n2_SendingLayer];
    
    /* ----- ADD SEND / CANCEL / IMAGE ATTACH BUTTONS ----- */
    UIButton *n2_SendButton = [[UIButton alloc] init];
    n2_SendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    n2_SendButton.frame = CGRectMake(SCREEN_WIDTH-60-10, 40, 60, 40);
    n2_SendButton.backgroundColor = [UIColor clearColor];
    [n2_SendButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [n2_SendButton setTitle:@"  Send" forState:UIControlStateNormal];
    [n2_SendButton addTarget:self action:@selector(n2_SendMessage) forControlEvents:UIControlEventTouchUpInside];
    [n2_SendingLayer addSubview:n2_SendButton];
    
    UIButton *n2_CancelButton = [[UIButton alloc] init];
    n2_CancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    n2_CancelButton.frame = CGRectMake(10, 40, 60, 40);
    n2_CancelButton.backgroundColor = [UIColor clearColor];
    [n2_CancelButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [n2_CancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [n2_CancelButton addTarget:self action:@selector(reShiftWindow) forControlEvents:UIControlEventTouchUpInside];
    [n2_SendingLayer addSubview:n2_CancelButton];
    
    composeLabel = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-140)/2, 40, 140, 40)];
    composeLabel.text = @"New Message";
    composeLabel.textColor = [UIColor blackColor];
    composeLabel.textAlignment = NSTextAlignmentCenter;
    [n2_SendingLayer addSubview:composeLabel];
    
    /* ----- ENTRY FIELDS ARE 32 PIX HIGH  ------ */
    int initHeight = 90;
    int fieldSpacing = 32;
    
    toEntryField = [[MGNewEntryField alloc] initWithFrame:CGRectMake(0, initHeight, SCREEN_WIDTH-40, 30) andTitle:@"TO:"];
    ccEntryField = [[MGNewEntryField alloc] initWithFrame:CGRectMake(0, initHeight + 1*fieldSpacing, SCREEN_WIDTH-40, 30) andTitle:@"CC:"];
    fromEntryField = [[MGNewEntryField alloc] initWithFrame:CGRectMake(0, initHeight+2*fieldSpacing, SCREEN_WIDTH-40, 30) andTitle:@"FROM:"];
    subjEntryField = [[MGNewEntryField alloc] initWithFrame:CGRectMake(0, initHeight+3*fieldSpacing, SCREEN_WIDTH-40, 30) andTitle:@"SUBJECT:"];
    fromEntryField.entryView.text = [NSString stringWithFormat:@"me@%@", mailgunURL];
    subjEntryField.entryView.autocorrectionType = UITextAutocorrectionTypeYes;
    subjEntryField.entryView.autocapitalizationType = UITextAutocapitalizationTypeSentences;
    [subjEntryField.entryView addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [n2_SendingLayer addSubview:toEntryField];
    [n2_SendingLayer addSubview:ccEntryField];
    [n2_SendingLayer addSubview:fromEntryField];
    [n2_SendingLayer addSubview:subjEntryField];
    
    
    /* --- MESSAGE FIELD:  ----- */
    //UITextView *messageEntryField = [[UITextView alloc] initWithFrame:CGRectMake(0, initHeight + 4*fieldSpacing, SCREEN_WIDTH, 300)];
    messageEntryField = [[UITextView alloc] initWithFrame:CGRectMake(0, initHeight + 4*fieldSpacing, SCREEN_WIDTH, 300)];
    messageEntryField.font = [UIFont systemFontOfSize:12];
    messageEntryField.delegate = (id)self;
    [n2_SendingLayer addSubview:messageEntryField];
    
    int circleSize = 30;
    
    /* ---- Circle buttons to bring up contacts list. ----- */
    double cOriginX = self.view.frame.size.width - circleSize-2;
    double cOriginY = initHeight+(fieldSpacing-circleSize)/2;
    popSendList = [[MGContactPopButton alloc] initWithFrame:CGRectMake(cOriginX, cOriginY, circleSize, circleSize) andColor:[UIColor greenColor]];
    hideSendList = [[MGContactPopButton alloc] initWithFrame:CGRectMake(cOriginX, cOriginY, circleSize, circleSize) andColor:[UIColor redColor]];
    [popSendList addTarget:self action:@selector(showToContactList) forControlEvents:UIControlEventTouchDown];
    [hideSendList addTarget:self action:@selector(hideToContactList) forControlEvents:UIControlEventTouchDown];
    [n2_SendingLayer addSubview:popSendList];
    [n2_SendingLayer addSubview:hideSendList];
    
    popCCList = [[MGContactPopButton alloc] initWithFrame:CGRectMake(cOriginX, cOriginY+fieldSpacing, circleSize, circleSize) andColor:[UIColor greenColor]];
    hideCCList = [[MGContactPopButton alloc] initWithFrame:CGRectMake(cOriginX, cOriginY+fieldSpacing, circleSize, circleSize) andColor:[UIColor redColor]];
    [popCCList addTarget:self action:@selector(showCCContactList) forControlEvents:UIControlEventTouchDown];
    [hideCCList addTarget:self action:@selector(hideCCContactList) forControlEvents:UIControlEventTouchDown];
    [n2_SendingLayer addSubview:popCCList];
    [n2_SendingLayer addSubview:hideCCList];
    
    // Pop-ups with your contact list
    toContactPopUp = [[MGContactPopUpList alloc] initWithDictionary:contactEmails];
    ccContactPopUp = [[MGContactPopUpList alloc] initWithDictionary:contactEmails];
    toContactPopUp.frame = CGRectMake(50, 150, toContactPopUp.frame.size.width, toContactPopUp.frame.size.height);
    ccContactPopUp.frame = CGRectMake(50, 150+fieldSpacing, ccContactPopUp.frame.size.width, toContactPopUp.frame.size.height);
    [n2_SendingLayer addSubview:toContactPopUp];
    [n2_SendingLayer addSubview:ccContactPopUp];
    
    
}

- (void) loadMainMenuLayer{ //Cleaned
    menuLayer = [[UIView alloc] initWithFrame:self.view.frame];
    menuLayer.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:menuLayer];
    
    UILabel *menuLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 40, 220, 30)];
    menuLabel.text = @"MENU";
    menuLabel.textAlignment = NSTextAlignmentCenter;
    menuLabel.font = [UIFont boldSystemFontOfSize:18];
    menuLabel.center = CGPointMake(SCREEN_WIDTH/2, menuLabel.center.y);
    [menuLayer addSubview:menuLabel];
    
    // Create the main menu buttons
    MGMainMenuNavigationButton *goToSend = [[MGMainMenuNavigationButton alloc] initWithFrame:CGRectMake(5, 90, SCREEN_WIDTH-10, 50) withTitle:@"Send a message"];
    MGMainMenuNavigationButton *goToHistory = [[MGMainMenuNavigationButton alloc] initWithFrame:CGRectMake(5, 150, SCREEN_WIDTH-10, 50) withTitle:@"View Sent Messages"];
    MGMainMenuNavigationButton *goToTrash = [[MGMainMenuNavigationButton alloc] initWithFrame:CGRectMake(5, 210, SCREEN_WIDTH-10, 50) withTitle:@"View Deleted Messages"];
    MGMainMenuNavigationButton *goToOptions = [[MGMainMenuNavigationButton alloc] initWithFrame:CGRectMake(5, 270, SCREEN_WIDTH-10, 50) withTitle:@"Change API Key / Mailgun URL"];
    MGMainMenuNavigationButton *goToOldSend = [[MGMainMenuNavigationButton alloc] initWithFrame:CGRectMake(5, 330, SCREEN_WIDTH-10, 50) withTitle:@"Deprecated Send Message Form"];
    goToSend.backgroundColor =    [UIColor colorWithRed:.95 green:.95 blue:.99 alpha:.8];
    goToHistory.backgroundColor = [UIColor colorWithRed:.95 green:.95 blue:.99 alpha:.8];
    goToOptions.backgroundColor = [UIColor colorWithRed:.95 green:.95 blue:.99 alpha:.8];
    goToTrash.backgroundColor =   [UIColor colorWithRed:.95 green:.40 blue:.40 alpha:.8];
    goToOldSend.backgroundColor = [UIColor colorWithRed:.99 green:.99 blue:.95 alpha:.8];
    [goToSend addTarget:self action:@selector(shiftWindow:) forControlEvents:UIControlEventTouchUpInside];
    [goToHistory addTarget:self action:@selector(shiftWindow:) forControlEvents:UIControlEventTouchUpInside];
    [goToOptions addTarget:self action:@selector(shiftWindow:) forControlEvents:UIControlEventTouchUpInside];
    [goToOldSend addTarget:self action:@selector(shiftWindow:) forControlEvents:UIControlEventTouchUpInside];
    [menuLayer addSubview:goToSend];
    [menuLayer addSubview:goToHistory];
    [menuLayer addSubview:goToTrash];
    [menuLayer addSubview:goToOptions];
    [menuLayer addSubview:goToOldSend];
    
    
    // Add the logos at the bottom of the app. Change these to be placed dynamically.
    UIImageView *menuMGLogo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Mailgun180white.png"]];
    menuMGLogo.frame = CGRectMake(SCREEN_WIDTH*3.0/16, SCREEN_HEIGHT-200, SCREEN_WIDTH/4, SCREEN_WIDTH/4);
    [menuLayer addSubview:menuMGLogo];
    
    UIImageView *menuTRLogo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"TR_logo.png"]];
    menuTRLogo.frame = CGRectMake(SCREEN_WIDTH*9.0/16, SCREEN_HEIGHT-200, SCREEN_WIDTH/4, SCREEN_WIDTH/4);
    [menuLayer addSubview:menuTRLogo];
    
    UILabel *customMGAppLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-100, SCREEN_WIDTH, 40)];
    customMGAppLabel.text = @"CUSTOM MAILGUN APP BY TEDDYROWAN.COM";
    customMGAppLabel.font = [UIFont systemFontOfSize:12];
    customMGAppLabel.textColor = [UIColor blackColor];
    customMGAppLabel.textAlignment = NSTextAlignmentCenter;
    [menuLayer addSubview:customMGAppLabel];
} // loadMainMenuLayer()

// Loading of the deprecated send message form. Need to either choose this one or rip this out.
- (void) loadBackgroundLayer{
    backgroundLayer = [[UIView alloc] init];
    backgroundLayer.frame = self.view.frame;
    backgroundLayer.center = CGPointMake(backgroundLayer.center.x+SCREEN_WIDTH, backgroundLayer.center.y);
    backgroundLayer.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backgroundLayer];
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 25, 200, 60)];
    titleLabel.text = [mailgunURL uppercaseString];
    titleLabel.font = [UIFont boldSystemFontOfSize:18.0];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.center = CGPointMake(self.view.center.x, titleLabel.center.y);
    [backgroundLayer addSubview:titleLabel];
    
    UILabel* toLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, INIT_HEIGHT_LAB+0*SPACING, 280, 30)];
    toLabel.text = @" TO:    ";
    toLabel.font = [UIFont systemFontOfSize:12];
    [backgroundLayer addSubview:toLabel];
    
    toBox = [[BorderedTextField alloc] init];
    toBox.center = CGPointMake(self.view.center.x, INIT_HEIGHT_BOX + 0*SPACING);
    toBox.textView.text = @"edward.rowan@alumni.ubc.ca"; // demo test email that i don't use anymore.
    toBox.textView.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [backgroundLayer addSubview:toBox];
    
    
    UILabel* fromLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, INIT_HEIGHT_LAB+1*SPACING, 280, 30)];
    fromLabel.text = @" FROM:    ";
    fromLabel.font = [UIFont systemFontOfSize:12];
    [backgroundLayer addSubview:fromLabel];
    
    fromBox = [[BorderedTextField alloc] init];
    fromBox.center = CGPointMake(self.view.center.x, INIT_HEIGHT_BOX+1*SPACING);
    fromBox.textView.text = @"Teddy Rowan <teddy@teddyrowan.com>";
    fromBox.textView.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [backgroundLayer addSubview:fromBox];
    
    UILabel* subjLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, INIT_HEIGHT_LAB+2*SPACING, 280, 30)];
    subjLabel.text = @" SUBJECT:    ";
    subjLabel.font = [UIFont systemFontOfSize:12];
    [backgroundLayer addSubview:subjLabel];
    
    subjectBox = [[BorderedTextField alloc] init];
    subjectBox.center = CGPointMake(self.view.center.x, INIT_HEIGHT_BOX+2*SPACING);
    subjectBox.textView.text = @"";
    [backgroundLayer addSubview:subjectBox];
    
    
    subjLbl = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 0.0,subjectBox.textView.frame.size.width - 10.0, 30)];
    [subjLbl setText:@"Enter a subject..."];
    [subjLbl setBackgroundColor:[UIColor clearColor]];
    [subjLbl setTextColor:[UIColor lightGrayColor]];
    subjLbl.textAlignment = NSTextAlignmentCenter;
    subjLbl.font = [UIFont systemFontOfSize:11.0];
    subjectBox.textView.delegate = (id)self;
    [subjectBox.textView addSubview:subjLbl];
    
    toLbl = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 0.0,toBox.textView.frame.size.width - 10.0, 30)];
    [toLbl setText:@"Enter a recipient..."];
    [toLbl setBackgroundColor:[UIColor clearColor]];
    [toLbl setTextColor:[UIColor lightGrayColor]];
    toLbl.textAlignment = NSTextAlignmentCenter;
    toLbl.font = [UIFont systemFontOfSize:11.0];
    toBox.textView.delegate = (id)self;
    toLbl.hidden = YES; // unhide it if i ever move away from keeping a default recipient. aka final version
    [toBox.textView addSubview:toLbl];
    
    fromLbl = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 0.0,fromBox.textView.frame.size.width - 10.0, 30)];
    [fromLbl setText:@"EX: Teddy Rowan <teddy@teddyrowan.com>"];
    [fromLbl setBackgroundColor:[UIColor clearColor]];
    [fromLbl setTextColor:[UIColor lightGrayColor]];
    fromLbl.textAlignment = NSTextAlignmentCenter;
    fromLbl.font = [UIFont systemFontOfSize:11.0];
    fromBox.textView.delegate = (id)self;
    fromLbl.hidden = YES; // unhide it if i ever move away from keeping a default recipient. aka final version
    [fromBox.textView addSubview:fromLbl];
    
    
    UILabel* msgLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, INIT_HEIGHT_LAB+3*SPACING, 280, 30)];
    msgLabel.text = @" MESSAGE:    ";
    msgLabel.font = [UIFont systemFontOfSize:12];
    [backgroundLayer addSubview:msgLabel];
    
    messageBox = [[BorderedTextField alloc] init];
    messageBox.center = CGPointMake(self.view.center.x, INIT_HEIGHT_BOX+3*SPACING);
    messageBox.textView.text = @"";
    messageBox.frame = CGRectMake(messageBox.frame.origin.x, messageBox.frame.origin.y, messageBox.frame.size.width, messageBox.frame.size.height+200);
    messageBox.textView.frame = CGRectMake(messageBox.textView.frame.origin.x, messageBox.textView.frame.origin.y, messageBox.textView.frame.size.width, messageBox.textView.frame.size.height+200);
    messageBox.textView.textAlignment = NSTextAlignmentLeft;
    messageBox.textView.delegate = (id)self;
    [backgroundLayer addSubview:messageBox];
    
    
    sendButton = [[UIButton alloc] init];
    sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sendButton.frame = CGRectMake((SCREEN_WIDTH-200)/2, 520, 200, 40);
    sendButton.backgroundColor = [UIColor redColor];
    sendButton.titleLabel.textColor = [UIColor whiteColor];
    [sendButton setTitle:@"UNLOCK TO SEND" forState:UIControlStateNormal];
    [sendButton addTarget:self action:@selector(deprecatedSendMessage) forControlEvents:UIControlEventTouchUpInside];
    sendButton.layer.cornerRadius = 2;
    [sendButton setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:254.0/255.0 green:180.0/255.0 blue:180.0/255.0 alpha:0.8]] forState:UIControlStateHighlighted];
    [backgroundLayer addSubview:sendButton];
    
    lockView = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width-25-35, 35, 35, 35)];
    lockView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"lock35.png"]];
    [lockView addTarget:self action:@selector(switchLock) forControlEvents:UIControlEventTouchUpInside];
    [backgroundLayer addSubview:lockView];
    locked = YES;
    
    UIButton *oldBackButton = [[UIButton alloc] init];
    oldBackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    oldBackButton.frame = CGRectMake(10, 35, 60, 40);
    oldBackButton.backgroundColor = [UIColor clearColor];
    [oldBackButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [oldBackButton setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [oldBackButton setTitle:@"MENU" forState:UIControlStateNormal];
    oldBackButton.titleLabel.font = [UIFont systemFontOfSize:14];
    oldBackButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    [oldBackButton addTarget:self action:@selector(reShiftWindow) forControlEvents:UIControlEventTouchUpInside];
    [backgroundLayer addSubview:oldBackButton];
}

// I need to fix sent message storage before i even look at this.
- (void) loadHistoryLayer{
    historyLayer = [[UIView alloc] initWithFrame:self.view.frame];
    historyLayer.frame = CGRectMake(0, 0, SCREEN_WIDTH, 700);
    historyLayer.center = CGPointMake(historyLayer.center.x+SCREEN_WIDTH, historyLayer.center.y);
    historyLayer.backgroundColor = [UIColor whiteColor];
    
    historyScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 90, SCREEN_WIDTH, SCREEN_HEIGHT)];
    historyScroll.layer.borderWidth = 1;
    historyScroll.layer.borderColor = [UIColor blackColor].CGColor;
    [historyLayer addSubview:historyScroll];
    
    int filledCapacity = [self findLargestHistory];
    
    NSLog(@"filledCapacity: %d", filledCapacity);
    
    for (int i = 1; i<=filledCapacity; i++){
        MGEmailPreviewCell *messageCell = [[MGEmailPreviewCell alloc] init];
        [messageCell awakeFromNib];
        messageCell.center = CGPointMake(SCREEN_WIDTH/2, 35 + messageCell.frame.size.height*(i-1));
        [messageCell populateWithRecipient:[histRecipient objectForKey:[NSString stringWithFormat:@"%d",i]]
                               withSubject:[histSubject objectForKey:[NSString stringWithFormat:@"%d",i]]
                               withMessage:[histMessage objectForKey:[NSString stringWithFormat:@"%d",i]]
                                  withDate:[histDate objectForKey:[NSString stringWithFormat:@"%d",i]]
                               withSuccess:[histStatus objectForKey:[NSString stringWithFormat:@"%d",i]]
                                withNumber:i];
        [historyScroll addSubview:messageCell];
        
        [self addGradient:messageCell];
        messageCell.popoutButton.titleLabel.text = [NSString stringWithFormat:@"%d", i];
        
        [messageCell.popoutButton addTarget:self action:@selector(selectCell:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    NSLog(@"filled: %d", filledCapacity);
    historyScroll.contentSize = CGSizeMake(SCREEN_WIDTH, filledCapacity*70);
    [historyScroll setScrollEnabled:YES];
    [self.view addSubview:historyLayer];
    
    
    UILabel* sentMessagesLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 25, 200, 60)];
    sentMessagesLabel.text = @" SENT MESSAGES ";
    sentMessagesLabel.font = [UIFont boldSystemFontOfSize:18.0];
    sentMessagesLabel.textAlignment = NSTextAlignmentCenter;
    sentMessagesLabel.center = CGPointMake(self.view.center.x, sentMessagesLabel.center.y);
    [historyLayer addSubview:sentMessagesLabel];
    
    
    historyBackButton = [[UIButton alloc] init];
    historyBackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    historyBackButton.frame = CGRectMake(10, 35, 60, 40);
    historyBackButton.backgroundColor = [UIColor clearColor];
    [historyBackButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [historyBackButton setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [historyBackButton setTitle:@"MENU" forState:UIControlStateNormal];
    historyBackButton.titleLabel.font = [UIFont systemFontOfSize:14];
    historyBackButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    [historyBackButton addTarget:self action:@selector(reShiftWindow) forControlEvents:UIControlEventTouchUpInside];
    [historyLayer addSubview:historyBackButton];
    
}



#pragma mark - Message Sending Methods
// Lock / Unlock sending of messages. Designed to prevent accidental and double sending.
- (void) switchLock{
    if (locked){
        lockView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"unlock35.png"]];
        sendButton.backgroundColor = [UIColor greenColor];
        [sendButton setTitle:@"SEND MESSAGE" forState:UIControlStateNormal];
        [sendButton setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:180.0/255.0 green:254.0/255.0 blue:180.0/255.0 alpha:0.8]] forState:UIControlStateHighlighted];
    } else {
        lockView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"lock35.png"]];
        sendButton.backgroundColor = [UIColor redColor];
        [sendButton setTitle:@"UNLOCK TO SEND" forState:UIControlStateNormal];
        [sendButton setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:254.0/255.0 green:180.0/255.0 blue:180.0/255.0 alpha:0.8]] forState:UIControlStateHighlighted];
    }
    locked = !locked;
}

// Send a message through the original deprecated send message form
- (void)deprecatedSendMessage{
    if (!locked){
        [self switchLock];
    } else {
        return;
    }
    
    // This works perfectly for now. Add images and cc and stuff after.
    // Note: you can still send with a custom name attached to the address, you just need to type
    //       it into the from bar and put quotes around the email address as desired.
    Mailgun *mailgun = [Mailgun clientWithDomain:mailgunURL apiKey:API_KEY];
    MGMessage *message = [MGMessage messageFrom:fromBox.textView.text
                                             to:toBox.textView.text
                                        subject:subjectBox.textView.text
                                           body:messageBox.textView.text];
    //UIImage *catImage = [UIImage imageNamed:@"sad_face.png"];
    //[message addImage:catImage withName:@"sad_face.png" type:PNGFileType];
    
    UIAlertController* alert2 = [UIAlertController  alertControllerWithTitle:@"Mailgun TR"
                                                                     message:@"To be set later."
                                                              preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [alert2 dismissViewControllerAnimated:YES completion:nil];}];
    [alert2 addAction:ok];
    
    
    [mailgun sendMessage:message success:^(NSString *messageId) {
        NSLog(@"Message %@ sent successfully!", messageId);
        [alert2 setMessage:@"Message Sent Successfully!"];
        [self presentViewController:alert2 animated:YES completion:nil];
        [self addToHistory:message withSuccess:YES];
        [self addSentEntry];
    } failure:^(NSError *error) {
        NSLog(@"Error sending message. The error was: %@", [error userInfo]);
        [alert2 setMessage:@"Message Failed to Send."];
        [self presentViewController:alert2 animated:YES completion:nil];
        [self addToHistory:message withSuccess:NO];
        [self addSentEntry];
    }];
}


// From new sending form
- (void)n2_SendMessage{
    NSLog(@"got to here");
    
    Mailgun *mailgun = [Mailgun clientWithDomain:mailgunURL apiKey:API_KEY];
    MGMessage *message = [MGMessage messageFrom:fromEntryField.entryView.text
                                             to:toEntryField.entryView.text
                                        subject:subjEntryField.entryView.text
                                           body:messageEntryField.text];
    //UIImage *catImage = [UIImage imageNamed:@"sad_face.png"];
    //[message addImage:catImage withName:@"sad_face.png" type:PNGFileType];
    
    // add cc only if it isn't empty
    //if (![ccEntryField.entryView.text isEqualToString:@""]){
    //    [message addCc:ccEntryField.entryView.text];
    //}
    
    UIAlertController* alert2 = [UIAlertController  alertControllerWithTitle:@"Mailgun TR"
                                                                     message:@"To be set later."
                                                              preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [alert2 dismissViewControllerAnimated:YES completion:nil];}];
    
    
    [alert2 setMessage:@"Attempting to send message. Please wait."];
    [self presentViewController:alert2 animated:YES completion:nil];
    
    [mailgun sendMessage:message success:^(NSString *messageId) {
        NSLog(@"Message %@ sent successfully!", messageId);
        [alert2 setMessage:@"Message Sent Successfully!"];
        [alert2 addAction:ok];
        [self addToHistory:message withSuccess:YES];
        [self addSentEntry];
        
        toEntryField.entryView.text = @"";
        ccEntryField.entryView.text = @"";
        subjEntryField.entryView.text = @"";
        messageEntryField.text = @"";
        composeLabel.text = @"New Message";
        
        // For some reason I can't just direct access [toContactPopUp.scroll subview]....
        //  Also should really move this into the class so that I can clear them all with one line of code.
        for (UIScrollView* scroll in [toContactPopUp subviews]){
            for (MGButtonWithCheckBox* cell in [scroll subviews]){
                if ([cell isKindOfClass:[MGButtonWithCheckBox class]]){
                    cell.checkImage.hidden = YES;
                }
            }
        }
        for (UIScrollView* scroll in [ccContactPopUp subviews]){
            for (MGButtonWithCheckBox* cell in [scroll subviews]){
                if ([cell isKindOfClass:[MGButtonWithCheckBox class]]){
                    cell.checkImage.hidden = YES;
                }
            }
        }
        
    } failure:^(NSError *error) {
        NSLog(@"Error sending message. The error was: %@", [error userInfo]);
        [alert2 setMessage:@"Message Failed to Send."];
        [alert2 addAction:ok];
        [self addToHistory:message withSuccess:NO];
        [self addSentEntry];
    }];
}

- (void) addSentEntry{
    
    for (MGEmailPreviewCell* cell in [historyScroll subviews]){
        cell.center = CGPointMake(cell.center.x, cell.center.y + 70);
    }
    historyScroll.contentSize = CGSizeMake(historyScroll.contentSize.width, historyScroll.contentSize.height + 70);
    MGEmailPreviewCell *messageCell = [[MGEmailPreviewCell alloc] init];
    [messageCell awakeFromNib];
    messageCell.center = CGPointMake(SCREEN_WIDTH/2, 35);
    [messageCell populateWithRecipient:[histRecipient objectForKey:[NSString stringWithFormat:@"%d",1]]
                           withSubject:[histSubject objectForKey:[NSString stringWithFormat:@"%d",1]]
                           withMessage:[histMessage objectForKey:[NSString stringWithFormat:@"%d",1]]
                              withDate:[histDate objectForKey:[NSString stringWithFormat:@"%d",1]]
                           withSuccess:[histStatus objectForKey:[NSString stringWithFormat:@"%d",1]]
                            withNumber:0];
    [historyScroll addSubview:messageCell];
    
}

#pragma mark - Methods for selecting recipient addresses from your contacts.
- (void) showToContactList{
    toContactPopUp.hidden = NO;
    hideSendList.hidden = NO;
    popSendList.hidden = YES;
    NSLog(@"showToContactList");
    [self hideCCContactList];
}

- (void) hideToContactList{
    toContactPopUp.hidden = YES;
    toEntryField.entryView.text = [NSString stringWithFormat:@"%@%@", toEntryField.entryView.text, toContactPopUp.lastSelected];
    hideSendList.hidden = YES;
    popSendList.hidden = NO;
    toContactPopUp.lastSelected = @"";
    NSLog(@"hideToContactList");
}

- (void) showCCContactList{
    ccContactPopUp.hidden = NO;
    hideCCList.hidden = NO;
    popCCList.hidden = YES;
    NSLog(@"showCCContactList");
    [self hideToContactList];
}

- (void) hideCCContactList{
    ccContactPopUp.hidden = YES;
    ccEntryField.entryView.text = [NSString stringWithFormat:@"%@%@", ccEntryField.entryView.text, ccContactPopUp.lastSelected];
    hideCCList.hidden = YES;
    popCCList.hidden = NO;
    ccContactPopUp.lastSelected = @"";
    NSLog(@"hideCCContactList");
}

#pragma mark - Sent Message Storage Methods
- (void)addToHistory:(MGMessage *)message withSuccess:(BOOL)success{
    if ([message.text isEqualToString:@""] || message.text == nil){
        [histMessage addEntry:@"- NO MESSAGE -"];
    } else {
        [histMessage addEntry:message.text];
    }
    
    if ([message.subject isEqualToString:@""] || message.subject == nil){
        [histSubject addEntry:@"- NO SUBJECT-"];
    } else {
        [histSubject addEntry:message.subject];
    }
    
    if ([message.from isEqualToString:@""] || message.from == nil){
        [histSender addEntry:@"- NO SENDER -"];
    } else {
        [histSender addEntry:message.from];
    }
    
    if ([message.to[0] isEqualToString:@""] || message.to[0] == nil){
        [histRecipient addEntry:@"- NO RECIPIENT -"];
    } else {
        [histRecipient addEntry:message.to[0]]; // for now only track the first recipient
    }
    
    
    if (success){
        [histStatus addEntry:@"SENT"];
    } else {
        [histStatus addEntry:@"FAILED"];
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"MMM d, yyyy HH:mm:ss";
    [histDate addEntry:[formatter stringFromDate:[NSDate date]]];
    
    [histMessage synchronize];
    [histRecipient synchronize];
    [histSubject synchronize];
    [histStatus synchronize];
    [histSender synchronize];
    [histDate synchronize];
    
}


- (void) setStorageLimit:(int)limit{
    for (MGHistoryTracker* track in histArray){
        track.capacity = limit;
    }
}

- (void) clearTrackers{
    for (MGHistoryTracker* track in histArray){
        NSLog(@"Clearing: %@", track.title);
        [track clearHistory];
    }
}

- (void) printTrackers{
    for (MGHistoryTracker* track in histArray){
        NSLog(@"Printing: %@", track.title);
        [track printTracker];
    }
}
- (int) findLargestHistory{
    int largest = 0;
    
    for (MGHistoryTracker* track in histArray){
        NSLog(@"checking: %@", track.title);
        NSLog(@"checkFill: %d", [track checkFill]);
        if ([track checkFill] > largest){
            largest = [track checkFill];
        }
    }
    
    return largest;
}

#pragma mark - Navigation Methods -- Screen exiting methods
- (void) cancelSettingsChange{
    [self reShiftWindow];
    
    apiBox.textView.text = API_KEY;
    urlBox.textView.text = mailgunURL;
    
    
    if(![apiBox.textView hasText]) {
        apiLbl.hidden = NO;
    }else{
        apiLbl.hidden = YES;
    }
    
    if(![urlBox.textView hasText]) {
        urlLbl.hidden = NO;
    }else{
        urlLbl.hidden = YES;
    }
}

- (void) closeSettings{
    [self reShiftWindow];
    
    API_KEY = apiBox.textView.text;
    mailgunURL = urlBox.textView.text;
    titleLabel.text = [mailgunURL uppercaseString];
}

#pragma mark - Navigation Methods -- Animated the changing between views
// Animate the change between the main menu and whatever screen we want.
- (void) shiftWindow:(id)sender{
    UIButton *btn = (UIButton*)sender;
    
    // Determine who the sender is and move that layer to the front.
    if ([btn.titleLabel.text isEqualToString:@"Send a message"]){
        [self.view bringSubviewToFront:n2_SendingLayer];
    } else if ([btn.titleLabel.text isEqualToString:@"View Sent Messages"]){
        [self loadHistoryLayer];
        [self.view bringSubviewToFront:historyLayer];
    } else if ([btn.titleLabel.text isEqualToString:@"Change API Key / Mailgun URL"]){
        [self.view bringSubviewToFront:settingsLayer];
    } else if ([btn.titleLabel.text isEqualToString:@"Deprecated Send Message Form"]){
        [self.view bringSubviewToFront:backgroundLayer];
    }
    
    [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionAllowUserInteraction  animations:^{
        menuLayer.center = CGPointMake(-SCREEN_WIDTH/2, menuLayer.center.y);
        settingsLayer.center = CGPointMake(SCREEN_WIDTH/2, settingsLayer.center.y);
        n2_SendingLayer.center = CGPointMake(SCREEN_WIDTH/2, n2_SendingLayer.center.y);
        historyLayer.center = CGPointMake(SCREEN_WIDTH/2, historyLayer.center.y);
        backgroundLayer.center = CGPointMake(SCREEN_WIDTH/2, backgroundLayer.center.y);
    } completion:^(BOOL finished) {}];
}

// Animate the transition back from any view to the main menu
- (void) reShiftWindow{
    [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionAllowUserInteraction  animations:^{
        menuLayer.center = CGPointMake(SCREEN_WIDTH/2, menuLayer.center.y);
        settingsLayer.center = CGPointMake(SCREEN_HEIGHT, settingsLayer.center.y);
        n2_SendingLayer.center = CGPointMake(SCREEN_HEIGHT, n2_SendingLayer.center.y);
        historyLayer.center = CGPointMake(SCREEN_HEIGHT, historyLayer.center.y);
        backgroundLayer.center = CGPointMake(SCREEN_HEIGHT, backgroundLayer.center.y);
    } completion:^(BOOL finished) {}];
    
    [self.view endEditing:YES];
}

#pragma mark - Sent Messages Screen Navigation
- (void)selectCell:(id) sender{
    UIButton *btn = (UIButton*) sender;
    int index = [btn.titleLabel.text intValue];
    NSLog(@"selected index: %d", index);
    [self loadMessageLayerWithIndex:index];
}


// Load a message in sent messages
// This method needs to be fixed so badly. Everything is there as MV____ but MV was for messageView which isn't even what things are called anymore
- (void)loadMessageLayerWithIndex:(int)index{
    messageView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:messageView];
    messageView.backgroundColor = [UIColor whiteColor];
    
    UIScrollView *messageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 60, self.view.frame.size.width, 600)];
    [messageView addSubview:messageScrollView];
    
    // This all needs to move to a custom class but will leave it for now because I want to redo all of it anyway
    // It actually was the idea behind MGEmailPopoutView but I never got around to building it.
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, 150, 20)];
    dateLabel.text = @"SENT: ";
    dateLabel.font = [UIFont boldSystemFontOfSize:16];
    [messageScrollView addSubview:dateLabel];
    
    UILabel *MVDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 40, 300, 30)];
    MVDateLabel.text = [histDate objectForKey:[NSString stringWithFormat:@"%d",index]];
    MVDateLabel.font = [UIFont systemFontOfSize:14];
    [messageScrollView addSubview:MVDateLabel];
    
    UILabel *toLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 80, 150, 20)];
    toLabel.text = @"TO: ";
    toLabel.font = [UIFont boldSystemFontOfSize:16];
    [messageScrollView addSubview:toLabel];
    
    UILabel *MVToLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, 300, 30)];
    MVToLabel.text = [histRecipient objectForKey:[NSString stringWithFormat:@"%d",index]];
    MVToLabel.font = [UIFont systemFontOfSize:14];
    [messageScrollView addSubview:MVToLabel];
    
    
    UILabel *fromLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 140, 150, 20)];
    fromLabel.text = @"SENDER: ";
    fromLabel.font = [UIFont boldSystemFontOfSize:16];
    [messageScrollView addSubview:fromLabel];
    
    UILabel *MVFromLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 160, 300, 30)];
    MVFromLabel.text = [histSender objectForKey:[NSString stringWithFormat:@"%d",index]];
    MVFromLabel.font = [UIFont systemFontOfSize:14];
    [messageScrollView addSubview:MVFromLabel];
    
    
    UILabel *subjectLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 200, 150, 20)];
    subjectLabel.text = @"SUBJECT: ";
    subjectLabel.font = [UIFont boldSystemFontOfSize:16];
    [messageScrollView addSubview:subjectLabel];
    
    UILabel *MVSubjectLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 220, 300, 30)];
    MVSubjectLabel.text = [histSubject objectForKey:[NSString stringWithFormat:@"%d",index]];
    MVSubjectLabel.font = [UIFont systemFontOfSize:14];
    [messageScrollView addSubview:MVSubjectLabel];
    
    
    UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 260, 150, 20)];
    messageLabel.text = @"MESSAGE: ";
    messageLabel.font = [UIFont boldSystemFontOfSize:16];
    [messageScrollView addSubview:messageLabel];
    
    UILabel *MVMessageLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 280, 280, 400)];
    MVMessageLabel.text = [histMessage objectForKey:[NSString stringWithFormat:@"%d",index]];
    MVMessageLabel.font = [UIFont systemFontOfSize:14];
    MVMessageLabel.numberOfLines = 0;
    [MVMessageLabel sizeToFit];
    [messageScrollView addSubview:MVMessageLabel];
    
    messageScrollView.contentSize = CGSizeMake(self.view.frame.size.width, MVMessageLabel.frame.origin.y + MVMessageLabel.frame.size.height + 100);
    
    
    // to block word scrolling behind title
    UIView *whiteBackground = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 75)];
    whiteBackground.backgroundColor = [UIColor whiteColor];
    [messageView addSubview:whiteBackground];
    
    MVBackButton = [[UIButton alloc] init];
    MVBackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    MVBackButton.frame = CGRectMake(10, 35, 60, 40);
    [MVBackButton setTitle:@"HISTORY" forState:UIControlStateNormal];
    MVBackButton.titleLabel.font = [UIFont systemFontOfSize:14];
    MVBackButton.backgroundColor = [UIColor clearColor];
    [MVBackButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [MVBackButton setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    MVBackButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    [MVBackButton addTarget:self action:@selector(MVGoBack) forControlEvents:UIControlEventTouchUpInside];
    [messageView addSubview:MVBackButton];
    
    UILabel* viewTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 25, 200, 60)];
    viewTitleLabel.text = @" SENT MESSAGE ";
    viewTitleLabel.font = [UIFont boldSystemFontOfSize:18.0];
    viewTitleLabel.textAlignment = NSTextAlignmentCenter;
    viewTitleLabel.center = CGPointMake(self.view.center.x, viewTitleLabel.center.y);
    [messageView addSubview:viewTitleLabel];
}

// This should just clear all of it.
- (void) MVGoBack{
    for (UIView* cont in [messageView subviews]){
        [cont removeFromSuperview];
    }
    
    [messageView removeFromSuperview];
}

#pragma mark - Miscellaneous Methos
- (void) showHideAPIField{
    double LIGHT_GREY = 0.87;
    if ([apiBox.textView.backgroundColor isEqual:[UIColor colorWithRed:LIGHT_GREY green:LIGHT_GREY blue:LIGHT_GREY alpha:1.0]]){
        apiBox.textView.backgroundColor = [UIColor blackColor];
        NSLog(@"change to black");
    } else {
        apiBox.textView.backgroundColor = [UIColor colorWithRed:LIGHT_GREY green:LIGHT_GREY blue:LIGHT_GREY alpha:1.0];
        NSLog(@"change to grey");
    }
}

// Dismiss the keyboard when you click out of a text field. I think this is only in the deprecated view?
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    if (backgroundLayer.frame.origin.x == 0){
        backgroundLayer.frame = self.view.frame;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TextView / TextField Helper Methods
// Move the background layer back into place and make sure the subjLbl message is there if it should be
- (void)textViewDidEndEditing:(UITextView *)theTextView{
    if (![subjectBox.textView hasText]) {
        subjLbl.hidden = NO;
    }
    
    if (theTextView == messageBox.textView){
        [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionAllowUserInteraction  animations:^{
            backgroundLayer.center = CGPointMake(backgroundLayer.center.x, backgroundLayer.center.y+210);
        } completion:^(BOOL finished) {}];
    }
    
    // New sending form
    if (theTextView == messageEntryField){
        [UIView animateWithDuration:.5 delay:0 options:UIViewAnimationOptionAllowUserInteraction  animations:^{
            n2_SendingLayer.center = CGPointMake(n2_SendingLayer.center.x, n2_SendingLayer.center.y+120);
        } completion:^(BOOL finished) {}];
    }
}

// Move the background layer if you're editting the message box so that you can see the whole box
- (void)textViewDidBeginEditing:(UITextView *)theTextView{
    if (theTextView == messageBox.textView){
        [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionAllowUserInteraction  animations:^{
            backgroundLayer.center = CGPointMake(backgroundLayer.center.x, backgroundLayer.center.y-210);
        } completion:^(BOOL finished) {}];
    }
    
    
    // New sending form
    if (theTextView == messageEntryField){
        [UIView animateWithDuration:.5 delay:0 options:UIViewAnimationOptionAllowUserInteraction  animations:^{
            n2_SendingLayer.center = CGPointMake(n2_SendingLayer.center.x, n2_SendingLayer.center.y-120);
        } completion:^(BOOL finished) {}];
    }
    
    
}

// Check on whether the subjLbl message should be there or not
- (void) textViewDidChange:(UITextView *)textView{
    if(![subjectBox.textView hasText]) {subjLbl.hidden = NO;}else{subjLbl.hidden = YES;}
    if(![toBox.textView hasText]) {toLbl.hidden = NO;}else{toLbl.hidden = YES;}
    if(![fromBox.textView hasText]) {fromLbl.hidden = NO;}else{fromLbl.hidden = YES;}
    if(![apiBox.textView hasText]) {apiLbl.hidden = NO;}else{apiLbl.hidden = YES;}
    if(![urlBox.textView hasText]) {urlLbl.hidden = NO;}else{urlLbl.hidden = YES;}
}

// For auto changing the label to the email message
- (void) textFieldDidChange:(UITextField *)textField{
    if ([subjEntryField.entryView isEqual:textField]){
        if ([textField hasText]){
            composeLabel.text = textField.text;
        } else {
            composeLabel.text = @"New Message";
        }
    }
}

#pragma mark - Shared UX Methods
// Adds a gradient to any views or buttons.
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

// Responsible for small flash when you click buttons
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
@end
