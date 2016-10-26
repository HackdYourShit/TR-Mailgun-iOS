//
//  ViewController.m
//  MailgunServer

// TO DO:
//   Find a way to attach images, hopefully from Photos Library. Looks to be not too bad to do.
    // https://developer.apple.com/library/ios/documentation/AudioVideo/Conceptual/CameraAndPhotoLib_TopicsForIOS/Articles/PickinganItemfromthePhotoLibrary.html
//   Add extra inputs for your name when sending / receiving?
//   Bit of reformatting to look more like Mail app


//   Refactor ViewController.m
        // Lots of duplicates for the Lbl stuff aka the preview shit
        // No comments..
        // Ordering of functions is fucking awful.

//   Add CC and multiple sending tracking status.
//   Add button in settings page for number of sent messages saved

//  Redesign intro page

//  Add in an address book type menu that lets you quickly fill in the to/cc/from fields
        // Can i just connect to contacts?

// Add support for deleted messages
    // Both a deleted messages page and the capability for deleting messages

// When new message send is attempted, the history entry for it isn't gradient-ed


// TO COMMIT CHANGES through command line:
    // Terminal -- CD to ./Desktop/Teddy/tinker/MailgunServer
    // git init
    // git commit -am 'description'

#import "ViewController.h"
#define INIT_HEIGHT_LAB 68
#define INIT_HEIGHT_BOX 110
#define SPACING 60
#define INIT_X 20
#define SCREEN_WIDTH 320
#define SCREEN_HEIGHT 480  // this is wrong. 560?

@interface ViewController ()
@end

@implementation ViewController
@synthesize toBox, fromBox, subjectBox, messageBox, sendButton, backgroundLayer, activeField, API_KEY, mailgunURL, lockView, locked, subjLbl, settingsButton, settingsLayer, backButton, toLbl, fromLbl, apiBox, urlBox, titleLabel, cancelChanges, urlLbl, apiLbl, creditsLabel, userPreferences, histDate, histSender, histMessage, histSubject, histRecipient, historyLayer, historyButton, historyBackButton, historyScroll, histStatus, histArray, reSendingLayer, menuLayer, messageEntryField, toEntryField, fromEntryField, subjEntryField, ccEntryField, messageView, MVBackButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    activeField = [[UITextView alloc] init];
    
    userPreferences = [[NSUserDefaults alloc] initWithSuiteName:@"preferences"];
    //API_KEY = [userPreferences objectForKey:@"api_key"];
    //mailgunURL = [userPreferences objectForKey:@"mail_url"];
    API_KEY = [[NSString alloc] initWithFormat:@"key-9a01fe9d60afece3eeda648f0d90206a"];
    mailgunURL = [[NSString alloc] initWithFormat:@"teddyrowan.com" ];
    
    
    histMessage = [[MGHistoryTracker alloc] initWithSuiteName:@"messageTracker"];
    histRecipient = [[MGHistoryTracker alloc] initWithSuiteName:@"recipientTracker"];
    histSubject = [[MGHistoryTracker alloc] initWithSuiteName:@"subjectTracker"];
    histSender = [[MGHistoryTracker alloc] initWithSuiteName:@"senderTracker"];
    histDate = [[MGHistoryTracker alloc] initWithSuiteName:@"dateTracker"];
    histStatus = [[MGHistoryTracker alloc] initWithSuiteName:@"statusTracker"];
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
    
    [self setStorageLimit:50];
    //[self printTrackers];
    //[self clearTrackers];
    //[self printTrackers];
    
    [self loadBackgroundLayer];
    [self loadSettingsLayer];
    [self loadHistoryLayer];
    [self loadNewSendingLayer];
    [self loadMenuLayer];
    
}

// Old send message form
- (void) loadBackgroundLayer{
    backgroundLayer = [[UIView alloc] init];
    backgroundLayer.frame = self.view.frame;
    backgroundLayer.center = CGPointMake(backgroundLayer.center.x+320, backgroundLayer.center.y);
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
    toBox.textView.text = @"edward.rowan@alumni.ubc.ca";
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
    sendButton.frame = CGRectMake(60, 520, 200, 40);
    sendButton.backgroundColor = [UIColor redColor];
    sendButton.titleLabel.textColor = [UIColor whiteColor];
    [sendButton setTitle:@"UNLOCK TO SEND" forState:UIControlStateNormal];
    [sendButton addTarget:self action:@selector(sendMessage) forControlEvents:UIControlEventTouchUpInside];
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
    [oldBackButton addTarget:self action:@selector(closeHistory) forControlEvents:UIControlEventTouchUpInside];
    [backgroundLayer addSubview:oldBackButton];
}


- (void) loadMenuLayer{
    menuLayer = [[UIView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:menuLayer];
    menuLayer.backgroundColor = [UIColor whiteColor];
    
    UILabel *menuLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 40, 220, 30)];
    menuLabel.text = @"MENU";
    menuLabel.textAlignment = NSTextAlignmentCenter;
    menuLabel.font = [UIFont boldSystemFontOfSize:18];
    [menuLayer addSubview:menuLabel];
    
    /* ---- TURN THESE BUTTONS INTO A CLASS ---- */
    UIButton *goToSend = [[UIButton alloc] init];
    goToSend = [UIButton buttonWithType:UIButtonTypeCustom];
    goToSend.frame = CGRectMake(5, 90, 310, 50);
    [goToSend setTitle:@"Send a message" forState:UIControlStateNormal];
    goToSend.layer.borderColor = [UIColor blackColor].CGColor;
    goToSend.layer.borderWidth = 1;
    [goToSend setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    goToSend.layer.cornerRadius = 5;
    goToSend.backgroundColor = [UIColor colorWithRed:.95 green:.95 blue:.99 alpha:.8];
    [goToSend addTarget:self action:@selector(goSendMessage) forControlEvents:UIControlEventTouchUpInside];
    [goToSend setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:180.0/255.0 green:254.0/255.0 blue:180.0/255.0 alpha:0.2]] forState:UIControlStateHighlighted];
    goToSend.clipsToBounds = YES;
    [menuLayer addSubview:goToSend];
    
    
    CAGradientLayer *sendGradient = [CAGradientLayer layer];
    sendGradient.frame = goToSend.layer.bounds;
    sendGradient.colors = [NSArray arrayWithObjects:
                            (id)[UIColor colorWithWhite:1.0f alpha:0.1f].CGColor,
                            (id)[UIColor colorWithWhite:0.4f alpha:0.5f].CGColor,
                            nil];
    sendGradient.locations = [NSArray arrayWithObjects:
                               [NSNumber numberWithFloat:0.0f],
                               [NSNumber numberWithFloat:1.0f],
                               nil];
    
    sendGradient.cornerRadius = goToSend.layer.cornerRadius;
    [goToSend.layer addSublayer:sendGradient];
    
    
    UIButton *goToHistory = [[UIButton alloc] init];
    goToHistory = [UIButton buttonWithType:UIButtonTypeCustom];
    goToHistory.frame = CGRectMake(5, 150, 310, 50);
    [goToHistory setTitle:@"View Sent Messages" forState:UIControlStateNormal];
    goToHistory.layer.borderWidth = 1;
    goToHistory.layer.borderColor = [UIColor blackColor].CGColor;
    [goToHistory setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    goToHistory.layer.cornerRadius = 5;
    goToHistory.backgroundColor = [UIColor colorWithRed:.95 green:.95 blue:.99 alpha:.8];
    [goToHistory addTarget:self action:@selector(goHistory) forControlEvents:UIControlEventTouchUpInside];
    [goToHistory setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:180.0/255.0 green:254.0/255.0 blue:180.0/255.0 alpha:0.2]] forState:UIControlStateHighlighted];
    [menuLayer addSubview:goToHistory];
    
    CAGradientLayer *historyGradient = [CAGradientLayer layer];
    historyGradient.frame = goToSend.layer.bounds;
    historyGradient.colors = [NSArray arrayWithObjects:
                            (id)[UIColor colorWithWhite:1.0f alpha:0.1f].CGColor,
                            (id)[UIColor colorWithWhite:0.4f alpha:0.5f].CGColor,
                            nil];
    historyGradient.locations = [NSArray arrayWithObjects:
                               [NSNumber numberWithFloat:0.0f],
                               [NSNumber numberWithFloat:1.0f],
                               nil];
    historyGradient.cornerRadius = goToHistory.layer.cornerRadius;
    [goToHistory.layer addSublayer:historyGradient];
    
    
    
    
    UIButton *goToTrash = [[UIButton alloc] init];
    goToTrash = [UIButton buttonWithType:UIButtonTypeCustom];
    goToTrash.frame = CGRectMake(5, 210, 310, 50);
    [goToTrash setTitle:@"View Deleted Messages" forState:UIControlStateNormal];
    goToTrash.layer.borderWidth = 1;
    goToTrash.layer.borderColor = [UIColor blackColor].CGColor;
    [goToTrash setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    goToTrash.backgroundColor = [UIColor colorWithRed:.95 green:.40 blue:.40 alpha:.8];
    goToTrash.layer.cornerRadius = 5;
    [goToTrash setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:180.0/255.0 green:254.0/255.0 blue:180.0/255.0 alpha:0.2]] forState:UIControlStateHighlighted];
    [menuLayer addSubview:goToTrash];
    
    UIButton *goToOptions = [[UIButton alloc] init];
    goToOptions = [UIButton buttonWithType:UIButtonTypeCustom];
    goToOptions.frame = CGRectMake(5, 270, 310, 50);
    [goToOptions setTitle:@"Change API Key / Mailgun URL" forState:UIControlStateNormal];
    [goToOptions setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    goToOptions.layer.borderWidth = 1;
    goToOptions.layer.borderColor = [UIColor blackColor].CGColor;
    goToOptions.layer.cornerRadius = 5;
    goToOptions.backgroundColor = [UIColor colorWithRed:.95 green:.95 blue:.99 alpha:.8];
    [goToOptions addTarget:self action:@selector(goSettings) forControlEvents:UIControlEventTouchUpInside];
    [goToOptions setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:180.0/255.0 green:254.0/255.0 blue:180.0/255.0 alpha:0.2]] forState:UIControlStateHighlighted];
    [menuLayer addSubview:goToOptions];
    
    CAGradientLayer *optionsGradient = [CAGradientLayer layer];
    optionsGradient.frame = goToOptions.layer.bounds;
    optionsGradient.colors = [NSArray arrayWithObjects:
                              (id)[UIColor colorWithWhite:1.0f alpha:0.1f].CGColor,
                              (id)[UIColor colorWithWhite:0.4f alpha:0.5f].CGColor,
                              nil];
    optionsGradient.locations = [NSArray arrayWithObjects:
                                 [NSNumber numberWithFloat:0.0f],
                                 [NSNumber numberWithFloat:1.0f],
                                 nil];
    optionsGradient.cornerRadius = goToOptions.layer.cornerRadius;
    [goToOptions.layer addSublayer:optionsGradient];
    
    
    UIButton *goToOldSend = [[UIButton alloc] init];
    goToOldSend = [UIButton buttonWithType:UIButtonTypeCustom];
    goToOldSend.frame = CGRectMake(5, 330, 310, 50);
    [goToOldSend setTitle:@"Deprecated Send Message Form" forState:UIControlStateNormal];
    [goToOldSend setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    goToOldSend.layer.borderWidth = 1;
    goToOldSend.layer.borderColor = [UIColor blackColor].CGColor;
    goToOldSend.layer.cornerRadius = 5;
    goToOldSend.backgroundColor = [UIColor colorWithRed:.99 green:.99 blue:.95 alpha:.8];
    [goToOldSend addTarget:self action:@selector(goOldSend) forControlEvents:UIControlEventTouchUpInside];
    [goToOldSend setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:180.0/255.0 green:254.0/255.0 blue:180.0/255.0 alpha:0.2]] forState:UIControlStateHighlighted];
    [menuLayer addSubview:goToOldSend];
    
    UIImageView *menuMGLogo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Mailgun180white.png"]];
    menuMGLogo.frame = CGRectMake(50, 420, 90, 90);
    //menuMGLogo.backgroundColor = [UIColor greenColor];
    [menuLayer addSubview:menuMGLogo];
    
    UIImageView *menuTRLogo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"TR_logo.png"]];
    menuTRLogo.frame = CGRectMake(160, 420, 90, 90);
    //menuTRLogo.backgroundColor = [UIColor greenColor];
    [menuLayer addSubview:menuTRLogo];
    
    UILabel *customMGAppLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 510, self.view.frame.size.width, 40)];
    customMGAppLabel.text = @"CUSTOM MAILGUN APP BY TEDDYROWAN.COM";
    customMGAppLabel.font = [UIFont systemFontOfSize:12];
    customMGAppLabel.textColor = [UIColor blackColor];
    customMGAppLabel.textAlignment = NSTextAlignmentCenter;
    [menuLayer addSubview:customMGAppLabel];
    
    
    
    
}

- (void) loadSettingsLayer{
    settingsLayer = [[UIView alloc] init];
    settingsLayer.frame = self.view.frame;
    settingsLayer.center = CGPointMake(settingsLayer.center.x+320, settingsLayer.center.y);
    settingsLayer.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:settingsLayer];
    
    UILabel* settingsLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 25, 200, 60)];
    settingsLabel.text = @" APP SETTINGS ";
    settingsLabel.font = [UIFont boldSystemFontOfSize:18.0];
    settingsLabel.textAlignment = NSTextAlignmentCenter;
    settingsLabel.center = CGPointMake(self.view.center.x, settingsLabel.center.y);
    [settingsLayer addSubview:settingsLabel];
    
    //backButton = [[UIButton alloc] initWithFrame:CGRectMake(25, 35, 35, 35)];
    //backButton.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"back35.png"]];
    //[backButton addTarget:self action:@selector(closeSettings) forControlEvents:UIControlEventTouchUpInside];
    //[settingsLayer addSubview:backButton];
    
    backButton = [[UIButton alloc] init];
    backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //backButton.frame = CGRectMake(250, 35, 60, 40);
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
    [settingsLayer addSubview:showHideAPI];
    
    CAGradientLayer *apiGradient = [CAGradientLayer layer];
    apiGradient.frame = showHideAPI.layer.bounds;
    apiGradient.colors = [NSArray arrayWithObjects:
                              (id)[UIColor colorWithWhite:1.0f alpha:0.1f].CGColor,
                              (id)[UIColor colorWithWhite:0.4f alpha:0.5f].CGColor,
                              nil];
    apiGradient.locations = [NSArray arrayWithObjects:
                                 [NSNumber numberWithFloat:0.0f],
                                 [NSNumber numberWithFloat:1.0f],
                                 nil];
    apiGradient.cornerRadius = showHideAPI.layer.cornerRadius;
    [showHideAPI.layer addSublayer:apiGradient];
    
    
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
    cancelChanges.frame = CGRectMake(60, INIT_HEIGHT_BOX+2.75*SPACING, 200, 60);
    cancelChanges.backgroundColor = [UIColor redColor];
    cancelChanges.titleLabel.textColor = [UIColor whiteColor];
    [cancelChanges setTitle:@"DISCARD CHANGES" forState:UIControlStateNormal];
    [cancelChanges addTarget:self action:@selector(cancelSettingsChange) forControlEvents:UIControlEventTouchUpInside];
    cancelChanges.layer.cornerRadius = 5;
    cancelChanges.layer.borderColor = [UIColor blackColor].CGColor;
    cancelChanges.layer.borderWidth = 1;
    [cancelChanges setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:254.0/255.0 green:180.0/255.0 blue:180.0/255.0 alpha:0.8]] forState:UIControlStateHighlighted];
    cancelChanges.clipsToBounds = YES;
    [settingsLayer addSubview:cancelChanges];
    
    CAGradientLayer *cancelGradient = [CAGradientLayer layer];
    cancelGradient.frame = cancelChanges.layer.bounds;
    cancelGradient.colors = [NSArray arrayWithObjects:
                          (id)[UIColor colorWithWhite:1.0f alpha:0.1f].CGColor,
                          (id)[UIColor colorWithWhite:0.4f alpha:0.5f].CGColor,
                          nil];
    cancelGradient.locations = [NSArray arrayWithObjects:
                             [NSNumber numberWithFloat:0.0f],
                             [NSNumber numberWithFloat:1.0f],
                             nil];
    cancelGradient.cornerRadius = cancelChanges.layer.cornerRadius;
    [cancelChanges.layer addSublayer:cancelGradient];
    
    
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
    creditsLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, INIT_HEIGHT_LAB+4.8*SPACING, 280, 45)];
    creditsLabel.text = [[NSString stringWithFormat:@"Version %@.", versionText] uppercaseString];
    creditsLabel.textAlignment = NSTextAlignmentCenter;
    [settingsLayer addSubview:creditsLabel];
    
    
    UIImageView *settingsMGLogo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Mailgun180white.png"]];
    settingsMGLogo.frame = CGRectMake(50, 420, 90, 90);
    [settingsLayer addSubview:settingsMGLogo];
    
    UIImageView *settingsTRLogo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"TR_logo.png"]];
    settingsTRLogo.frame = CGRectMake(160, 420, 90, 90);
    [settingsLayer addSubview:settingsTRLogo];
    
    UILabel *customMGAppLabelSettings = [[UILabel alloc] initWithFrame:CGRectMake(0, 510, self.view.frame.size.width, 40)];
    customMGAppLabelSettings.text = @"CUSTOM MAILGUN APP BY TEDDYROWAN.COM";
    customMGAppLabelSettings.font = [UIFont systemFontOfSize:12];
    customMGAppLabelSettings.textColor = [UIColor blackColor];
    customMGAppLabelSettings.textAlignment = NSTextAlignmentCenter;
    [settingsLayer addSubview:customMGAppLabelSettings];
}

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

- (void) loadHistoryLayer{
    historyLayer = [[UIView alloc] initWithFrame:self.view.frame];
    historyLayer.frame = CGRectMake(0, 0, 320, 700);
    historyLayer.center = CGPointMake(historyLayer.center.x+320, historyLayer.center.y);
    historyLayer.backgroundColor = [UIColor whiteColor];
    
    historyScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 90, 320, 480)];
    historyScroll.layer.borderWidth = 1;
    historyScroll.layer.borderColor = [UIColor blackColor].CGColor;
    [historyLayer addSubview:historyScroll];
    
    int filledCapacity = [self findLargestHistory];
        
    for (int i = 1; i<=filledCapacity; i++){
        MGEmailPreviewCell *messageCell = [[MGEmailPreviewCell alloc] init];
        [messageCell awakeFromNib];
        messageCell.center = CGPointMake(160, 35 + messageCell.frame.size.height*(i-1));
        [messageCell populateWithRecipient:[histRecipient objectForKey:[NSString stringWithFormat:@"%d",i]]
                               withSubject:[histSubject objectForKey:[NSString stringWithFormat:@"%d",i]]
                               withMessage:[histMessage objectForKey:[NSString stringWithFormat:@"%d",i]]
                                  withDate:[histDate objectForKey:[NSString stringWithFormat:@"%d",i]]
                               withSuccess:[histStatus objectForKey:[NSString stringWithFormat:@"%d",i]]
                                 withNumber:i];
        [historyScroll addSubview:messageCell];
        
        CAGradientLayer *messageGradient = [CAGradientLayer layer];
        messageGradient.frame = messageCell.layer.bounds;
        messageGradient.colors = [NSArray arrayWithObjects:
                               (id)[UIColor colorWithWhite:1.0f alpha:0.1f].CGColor,
                               (id)[UIColor colorWithWhite:0.4f alpha:0.5f].CGColor,
                               nil];
        messageGradient.locations = [NSArray arrayWithObjects:
                                  [NSNumber numberWithFloat:0.0f],
                                  [NSNumber numberWithFloat:1.0f],
                                  nil];
        
        messageGradient.cornerRadius = messageCell.layer.cornerRadius;
        [messageCell.layer addSublayer:messageGradient];
        
        messageCell.popoutButton.titleLabel.text = [NSString stringWithFormat:@"%d", i];
        
        //[messageCell.popoutButton addTarget:self action:@selector(myTestWithAnInteger:) forControlEvents:UIControlEventTouchUpInside];
        [messageCell.popoutButton addTarget:self action:@selector(selectCell:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    NSLog(@"filled: %d", histMessage.filled);
    historyScroll.contentSize = CGSizeMake(320, histMessage.filled*70);
    [historyScroll setScrollEnabled:YES];
    [self.view addSubview:historyLayer];
    
    
    UILabel* sentMessagesLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 25, 200, 60)];
    sentMessagesLabel.text = @" SENT MESSAGES ";
    sentMessagesLabel.font = [UIFont boldSystemFontOfSize:18.0];
    sentMessagesLabel.textAlignment = NSTextAlignmentCenter;
    sentMessagesLabel.center = CGPointMake(self.view.center.x, sentMessagesLabel.center.y);
    [historyLayer addSubview:sentMessagesLabel];
    
    //historyBackButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 35, 35, 35)];
    //historyBackButton.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"back35.png"]];
    //[historyBackButton addTarget:self action:@selector(closeHistory) forControlEvents:UIControlEventTouchUpInside];
    //[historyLayer addSubview:historyBackButton];
    
    historyBackButton = [[UIButton alloc] init];
    historyBackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //historyBackButton.frame = CGRectMake(250, 35, 60, 40);
    historyBackButton.frame = CGRectMake(10, 35, 60, 40);
    historyBackButton.backgroundColor = [UIColor clearColor];
    [historyBackButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [historyBackButton setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [historyBackButton setTitle:@"MENU" forState:UIControlStateNormal];
    historyBackButton.titleLabel.font = [UIFont systemFontOfSize:14];
    historyBackButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    [historyBackButton addTarget:self action:@selector(closeHistory) forControlEvents:UIControlEventTouchUpInside];
    [historyLayer addSubview:historyBackButton];
    
}

- (void) loadNewSendingLayer{
    /* --- NEED TO EMBED ALL THIS IN A SCROLL VIEW AND SCROLL DOWN AS THE MESSAGE GETS LONGER --- */
    reSendingLayer = [[UIView alloc] initWithFrame:self.view.frame];
    reSendingLayer.center = CGPointMake(reSendingLayer.center.x+320, reSendingLayer.center.y);
    reSendingLayer.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:reSendingLayer];
    
    /* ----- ADD SEND / CANCEL / IMAGE ATTACH BUTTONS ----- */
    UIButton *reSendButton = [[UIButton alloc] init];
    reSendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    reSendButton.frame = CGRectMake(250, 40, 60, 40);
    reSendButton.backgroundColor = [UIColor clearColor];
    [reSendButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [reSendButton setTitle:@"  Send" forState:UIControlStateNormal];
    [reSendButton addTarget:self action:@selector(sendMessageNew) forControlEvents:UIControlEventTouchUpInside];
    [reSendingLayer addSubview:reSendButton];
    
    UIButton *reCancelButton = [[UIButton alloc] init];
    reCancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    reCancelButton.frame = CGRectMake(10, 40, 60, 40);
    reCancelButton.backgroundColor = [UIColor clearColor];
    [reCancelButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [reCancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [reCancelButton addTarget:self action:@selector(reShiftWindow) forControlEvents:UIControlEventTouchUpInside];
    [reSendingLayer addSubview:reCancelButton];
    
    UILabel *composeLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 40, 180, 40)];
    composeLabel.text = @"New Message";
    composeLabel.textColor = [UIColor blackColor];
    composeLabel.textAlignment = NSTextAlignmentCenter;
    [reSendingLayer addSubview:composeLabel];
    
    /* ----- ENTRY FIELDS ARE 32 PIX HIGH  ------ */
    int initHeight = 90;
    int fieldSpacing = 32;
    
    toEntryField = [[MGNewEntryField alloc] initWithHeight:30];
    toEntryField.frame = CGRectMake(0, initHeight, toEntryField.frame.size.width, toEntryField.frame.size.height);
    toEntryField.entryLabel.text = @"TO:";
    [reSendingLayer addSubview:toEntryField];
    
    ccEntryField = [[MGNewEntryField alloc] initWithHeight:30];
    ccEntryField.frame = CGRectMake(0, initHeight + 1*fieldSpacing, ccEntryField.frame.size.width, ccEntryField.frame.size.height);
    ccEntryField.entryLabel.text = @"CC:";
    [reSendingLayer addSubview:ccEntryField];
    
    fromEntryField = [[MGNewEntryField alloc] initWithHeight:30];
    fromEntryField.frame = CGRectMake(0, initHeight + 2*fieldSpacing, fromEntryField.frame.size.width, fromEntryField.frame.size.height);
    fromEntryField.entryLabel.text = @"FROM:";
    [reSendingLayer addSubview:fromEntryField];

    subjEntryField = [[MGNewEntryField alloc] initWithHeight:30];
    subjEntryField.frame = CGRectMake(0, initHeight + 3*fieldSpacing, subjEntryField.frame.size.width, subjEntryField.frame.size.height);
    subjEntryField.entryLabel.text = @"SUBJECT:";
    subjEntryField.entryView.autocorrectionType = UITextAutocorrectionTypeYes;
    subjEntryField.entryView.autocapitalizationType = UITextAutocapitalizationTypeSentences;
    [reSendingLayer addSubview:subjEntryField];
    
    
    /* --- MESSAGE FIELD:  ----- */
    //UITextView *messageEntryField = [[UITextView alloc] initWithFrame:CGRectMake(0, initHeight + 4*fieldSpacing, 320, 300)];
    messageEntryField = [[UITextView alloc] initWithFrame:CGRectMake(0, initHeight + 4*fieldSpacing, 320, 300)];
    messageEntryField.font = [UIFont systemFontOfSize:12];
    messageEntryField.delegate = (id)self;
    [reSendingLayer addSubview:messageEntryField];

}

// Should really bump these together by having the view as an input to the function
- (void) goSendMessage{
    [self.view bringSubviewToFront:reSendingLayer];
    [self shiftWindow];
}

- (void) goSettings{
    [self.view bringSubviewToFront:settingsLayer];
    [self shiftWindow];
}

- (void) goHistory{
    [self.view bringSubviewToFront:historyLayer];
    [self shiftWindow];
}

- (void) goOldSend{
    [self.view bringSubviewToFront:backgroundLayer];
    [self shiftWindow];
}

- (void) shiftWindow{
    [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionAllowUserInteraction  animations:^{
        menuLayer.center = CGPointMake(-160, menuLayer.center.y);
        settingsLayer.center = CGPointMake(160, settingsLayer.center.y);
        reSendingLayer.center = CGPointMake(160, reSendingLayer.center.y);
        historyLayer.center = CGPointMake(160, historyLayer.center.y);
        backgroundLayer.center = CGPointMake(160, backgroundLayer.center.y);
    } completion:^(BOOL finished) {}];
}

- (void) reShiftWindow{
    [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionAllowUserInteraction  animations:^{
        menuLayer.center = CGPointMake(160, menuLayer.center.y);
        settingsLayer.center = CGPointMake(480, settingsLayer.center.y);
        reSendingLayer.center = CGPointMake(480, reSendingLayer.center.y);
        historyLayer.center = CGPointMake(480, historyLayer.center.y);
        backgroundLayer.center = CGPointMake(480, backgroundLayer.center.y);
    } completion:^(BOOL finished) {}];
    
    [self.view endEditing:YES];
}


- (void)sendMessage{
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
- (void)sendMessageNew{
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
        //[self presentViewController:alert2 animated:YES completion:nil];
        [alert2 addAction:ok];
        [self addToHistory:message withSuccess:YES];
        [self addSentEntry];
    } failure:^(NSError *error) {
        NSLog(@"Error sending message. The error was: %@", [error userInfo]);
        [alert2 setMessage:@"Message Failed to Send."];
        [alert2 addAction:ok];
        //[self presentViewController:alert2 animated:YES completion:nil];
        [self addToHistory:message withSuccess:NO];
        [self addSentEntry];
    }];
}


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
            reSendingLayer.center = CGPointMake(reSendingLayer.center.x, reSendingLayer.center.y+120);
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
            reSendingLayer.center = CGPointMake(reSendingLayer.center.x, reSendingLayer.center.y-120);
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    if (backgroundLayer.frame.origin.x == 0){
        backgroundLayer.frame = self.view.frame;
    }
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

- (void) closeSettings{
    [self reShiftWindow];
    
    API_KEY = apiBox.textView.text;
    mailgunURL = urlBox.textView.text;
    titleLabel.text = [mailgunURL uppercaseString];
}

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


- (void)addToHistory:(MGMessage *)message withSuccess:(BOOL)success{
    [histMessage addEntry:message.text];
    [histSubject addEntry:message.subject];
    [histSender addEntry:message.from];
    
    [histRecipient addEntry:message.to[0]]; // for now only track the first recipient
    
    if (success){
        [histStatus addEntry:@"SENT"];
    } else {
        [histStatus addEntry:@"FAILED"];
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"MMM d, yyyy HH:mm:ss";
    [histDate addEntry:[formatter stringFromDate:[NSDate date]]];
}

- (void) closeHistory{
    [self reShiftWindow];
}


- (void) setStorageLimit:(int)limit{
    for (MGHistoryTracker* track in histArray){
        track.capacity = limit;
    }
}

- (void) clearTrackers{
    for (MGHistoryTracker* track in histArray){
        [track clearHistory];
    }
}

- (void) printTrackers{
    for (MGHistoryTracker* track in histArray){
        NSLog(@"Printing %@", track.title);
        [track printTracker];
    }
    
}

- (int) findLargestHistory{
    int largest = 0;
    
    for (MGHistoryTracker* track in histArray){
        if ([track checkFill] > largest){
            largest = [track checkFill];
        }
    }
    
    return largest;
}

- (void) addSentEntry{
    
    for (MGEmailPreviewCell* cell in [historyScroll subviews]){
        cell.center = CGPointMake(cell.center.x, cell.center.y + 70);
    }
    historyScroll.contentSize = CGSizeMake(historyScroll.contentSize.width, historyScroll.contentSize.height + 70);
    MGEmailPreviewCell *messageCell = [[MGEmailPreviewCell alloc] init];
    [messageCell awakeFromNib];
    messageCell.center = CGPointMake(160, 35);
    [messageCell populateWithRecipient:[histRecipient objectForKey:[NSString stringWithFormat:@"%d",1]]
                           withSubject:[histSubject objectForKey:[NSString stringWithFormat:@"%d",1]]
                           withMessage:[histMessage objectForKey:[NSString stringWithFormat:@"%d",1]]
                              withDate:[histDate objectForKey:[NSString stringWithFormat:@"%d",1]]
                           withSuccess:[histStatus objectForKey:[NSString stringWithFormat:@"%d",1]]
                            withNumber:0];
    [historyScroll addSubview:messageCell];
    
}


- (void)selectCell:(id) sender{
    UIButton *btn = (UIButton*) sender;
    int index = [btn.titleLabel.text intValue];
    NSLog(@"selected index: %d", index);
    [self loadMessageLayerWithIndex:index];
}

- (void)loadMessageLayerWithIndex:(int)index{
    messageView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:messageView];
    messageView.backgroundColor = [UIColor whiteColor];
    
    /*
     [messageCell populateWithRecipient:[histRecipient objectForKey:[NSString stringWithFormat:@"%d",i]]
     withSubject:[histSubject objectForKey:[NSString stringWithFormat:@"%d",i]]
     withMessage:[histMessage objectForKey:[NSString stringWithFormat:@"%d",i]]
     withDate:[histDate objectForKey:[NSString stringWithFormat:@"%d",i]]
     withSuccess:[histStatus objectForKey:[NSString stringWithFormat:@"%d",i]]
     withNumber:i];
     */
    
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 80, 150, 20)];
    dateLabel.text = @"SENT: ";
    dateLabel.font = [UIFont boldSystemFontOfSize:16];
    [messageView addSubview:dateLabel];

    UILabel *MVDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, 300, 30)];
    MVDateLabel.text = [histDate objectForKey:[NSString stringWithFormat:@"%d",index]];
    MVDateLabel.font = [UIFont systemFontOfSize:14];
    [messageView addSubview:MVDateLabel];
    
    
    UILabel *toLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 140, 150, 20)];
    toLabel.text = @"TO: ";
    toLabel.font = [UIFont boldSystemFontOfSize:16];
    [messageView addSubview:toLabel];
    
    UILabel *MVToLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 160, 300, 30)];
    MVToLabel.text = [histRecipient objectForKey:[NSString stringWithFormat:@"%d",index]];
    MVToLabel.font = [UIFont systemFontOfSize:14];
    [messageView addSubview:MVToLabel];
    
    
    UILabel *fromLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 200, 150, 20)];
    fromLabel.text = @"SENDER: ";
    fromLabel.font = [UIFont boldSystemFontOfSize:16];
    [messageView addSubview:fromLabel];
    
    UILabel *MVFromLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 220, 300, 30)];
    MVFromLabel.text = [histSender objectForKey:[NSString stringWithFormat:@"%d",index]];
    MVFromLabel.font = [UIFont systemFontOfSize:14];
    [messageView addSubview:MVFromLabel];
    
    
    UILabel *subjectLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 260, 150, 20)];
    subjectLabel.text = @"SUBJECT: ";
    subjectLabel.font = [UIFont boldSystemFontOfSize:16];
    [messageView addSubview:subjectLabel];
    
    UILabel *MVSubjectLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 280, 300, 30)];
    MVSubjectLabel.text = [histSubject objectForKey:[NSString stringWithFormat:@"%d",index]];
    MVSubjectLabel.font = [UIFont systemFontOfSize:14];
    [messageView addSubview:MVSubjectLabel];
    
    
    UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 320, 150, 20)];
    messageLabel.text = @"MESSAGE: ";
    messageLabel.font = [UIFont boldSystemFontOfSize:16];
    [messageView addSubview:messageLabel];
    
    UILabel *MVMessageLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 340, 300, 90)];
    MVMessageLabel.text = [histMessage objectForKey:[NSString stringWithFormat:@"%d",index]];
    MVMessageLabel.font = [UIFont systemFontOfSize:14];
    MVMessageLabel.numberOfLines = 0;
    [MVMessageLabel sizeToFit];
    [messageView addSubview:MVMessageLabel];
    
                      
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

@end
