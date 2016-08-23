//
//  ViewController.m
//  MailgunServer

// TO DO:
//   Find a way to attach images, hopefully from Photos Library. Looks to be not too bad to do.
    // https://developer.apple.com/library/ios/documentation/AudioVideo/Conceptual/CameraAndPhotoLib_TopicsForIOS/Articles/PickinganItemfromthePhotoLibrary.html
//   Add extra inputs for your name when sending / receiving?
//   Bit of reformatting to look more like Mail app

//   Add the ability to popout the sent messages into a full message view.

//   Refactor ViewController.m
        // Lots of duplicates for the Lbl stuff aka the preview shit
        // No comments..
        // Ordering of functions is fucking awful.

//   Add CC and multiple sending tracking status.
//   Add button in settings page for number of sent messages saved

//   Move message writing to it's own view that isn't just the default.
        // Do like an intro page then push everything to the side.

//   Settings page where you can customize the website and api key and such
    // Add NSUserDefaults to save their info
    // Add a TR logo right below the credits label

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
@synthesize toBox, fromBox, subjectBox, messageBox, sendButton, backgroundLayer, activeField, API_KEY, mailgunURL, lockView, locked, subjLbl, settingsButton, settingsLayer, backButton, toLbl, fromLbl, apiBox, urlBox, titleLabel, cancelChanges, urlLbl, apiLbl, creditsLabel, userPreferences, histDate, histSender, histMessage, histSubject, histRecipient, historyLayer, historyButton, historyBackButton, historyScroll, histStatus, histArray;

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
    [self printTrackers];
    
    backgroundLayer = [[UIView alloc] init];
    backgroundLayer.frame = self.view.frame;
    backgroundLayer.backgroundColor = [UIColor clearColor];
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
    
    lockView = [[UIButton alloc] initWithFrame:CGRectMake(25, 35, 35, 35)];
    lockView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"lock35.png"]];
    [lockView addTarget:self action:@selector(switchLock) forControlEvents:UIControlEventTouchUpInside];
    [backgroundLayer addSubview:lockView];
    locked = YES;
    
    settingsButton = [[UIButton alloc] initWithFrame:CGRectMake(260, 35, 35, 35)];
    settingsButton.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"settings35.png"]];
    [settingsButton addTarget:self action:@selector(openSettings) forControlEvents:UIControlEventTouchUpInside];
    [backgroundLayer addSubview:settingsButton];
    
    historyButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 520, 35, 35)];
    historyButton.backgroundColor = [UIColor redColor];//[UIColor colorWithPatternImage:[UIImage imageNamed:@"settings35.png"]];
    [historyButton addTarget:self action:@selector(openHistory) forControlEvents:UIControlEventTouchUpInside];
    [backgroundLayer addSubview:historyButton];
    
    
    
    [self loadSettingsLayer];
    [self loadHistoryLayer];
    
    
}

- (void) loadSettingsLayer{
    settingsLayer = [[UIView alloc] init];
    settingsLayer.frame = self.view.frame;
    settingsLayer.center = CGPointMake(settingsLayer.center.x+320, settingsLayer.center.y);
    settingsLayer.backgroundColor = [UIColor clearColor];
    [self.view addSubview:settingsLayer];
    
    UILabel* settingsLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 25, 200, 60)];
    settingsLabel.text = @" SETTINGS ";
    settingsLabel.font = [UIFont boldSystemFontOfSize:18.0];
    settingsLabel.textAlignment = NSTextAlignmentCenter;
    settingsLabel.center = CGPointMake(self.view.center.x, settingsLabel.center.y);
    [settingsLayer addSubview:settingsLabel];
    
    backButton = [[UIButton alloc] initWithFrame:CGRectMake(25, 35, 35, 35)];
    backButton.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"back35.png"]];
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
    [settingsLayer addSubview:apiBox];

    UILabel* urlLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, INIT_HEIGHT_LAB+1*SPACING, 280, 30)];
    urlLabel.text = @" DOMAIN URL:    ";
    urlLabel.font = [UIFont systemFontOfSize:12];
    [settingsLayer addSubview:urlLabel];
    
    urlBox = [[BorderedTextField alloc] init];
    urlBox.center = CGPointMake(self.view.center.x, INIT_HEIGHT_BOX + 1*SPACING);
    urlBox.textView.text = mailgunURL;
    urlBox.textView.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [settingsLayer addSubview:urlBox];
    
    cancelChanges = [[UIButton alloc] init];
    cancelChanges = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelChanges.frame = CGRectMake(60, INIT_HEIGHT_BOX+2.0*SPACING, 200, 60);
    cancelChanges.backgroundColor = [UIColor redColor];
    cancelChanges.titleLabel.textColor = [UIColor whiteColor];
    [cancelChanges setTitle:@"DISCARD CHANGES" forState:UIControlStateNormal];
    [cancelChanges addTarget:self action:@selector(cancelSettingsChange) forControlEvents:UIControlEventTouchUpInside];
    cancelChanges.layer.cornerRadius = 2;
    [cancelChanges setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:254.0/255.0 green:180.0/255.0 blue:180.0/255.0 alpha:0.8]] forState:UIControlStateHighlighted];
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
    
    creditsLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, INIT_HEIGHT_LAB+4*SPACING, 280, 90)];
    creditsLabel.text = [@"Created by Teddy Rowan\nVersion 1.0." uppercaseString];
    [creditsLabel setLineBreakMode:NSLineBreakByWordWrapping];
    creditsLabel.textAlignment = NSTextAlignmentCenter;
    creditsLabel.numberOfLines = 2;
    [settingsLayer addSubview:creditsLabel];
}

- (void) loadHistoryLayer{
    historyLayer = [[UIView alloc] initWithFrame:self.view.frame];
    historyLayer.frame = CGRectMake(0, 0, 320, 700);
    historyLayer.center = CGPointMake(historyLayer.center.x-320, historyLayer.center.y);
    
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
                               withSuccess:[histStatus objectForKey:[NSString stringWithFormat:@"%d",i]]];
        [historyScroll addSubview:messageCell];
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
    
    historyBackButton = [[UIButton alloc] initWithFrame:CGRectMake(260, 35, 35, 35)];
    historyBackButton.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"back35.png"]];
    [historyBackButton addTarget:self action:@selector(closeHistory) forControlEvents:UIControlEventTouchUpInside];
    [historyLayer addSubview:historyBackButton];
    
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

    
    /*
     Mailgun *mailgun = [Mailgun clientWithDomain:@"teddyrowan.com" apiKey:@"key-9a01fe9d60afece3eeda648f0d90206a"];
     UIImage *catImage = [UIImage imageNamed:@"sad_face.png"];
     MGMessage *message = [MGMessage messageFrom:@"Teddy Rowan <teddy@teddyrowan.com>"
     to:@"Edward Rowan <edward.rowan@alumni.ubc.ca>"
     subject:@"Figured out how to send images"
     body:@"But I still can't send PDFs... welp."];
     [message addImage:catImage withName:@"sad_face.png" type:PNGFileType];
     [mailgun sendMessage:message success:^(NSString *messageId) {
     NSLog(@"Message %@ sent successfully!", messageId);
     } failure:^(NSError *error) {
     NSLog(@"Error sending message. The error was: %@", [error userInfo]);
     }];
     */
}

// Move the background layer back into place and make sure the subjLbl message is there if it should be
- (void)textViewDidEndEditing:(UITextView *)theTextView{
    if (![subjectBox.textView hasText]) {
        subjLbl.hidden = NO;
    }
    
    if (theTextView == messageBox.textView){
        [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionAllowUserInteraction  animations:^{
            backgroundLayer.center = CGPointMake(backgroundLayer.center.x, backgroundLayer.center.y+210);
        } completion:^(BOOL finished) {}];    }
}

// Move the background layer if you're editting the message box so that you can see the whole box
- (void)textViewDidBeginEditing:(UITextView *)theTextView{
    if (theTextView == messageBox.textView){
        [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionAllowUserInteraction  animations:^{
             backgroundLayer.center = CGPointMake(backgroundLayer.center.x, backgroundLayer.center.y-210);
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

- (void) openSettings{
    [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionAllowUserInteraction  animations:^{
        backgroundLayer.center = CGPointMake(backgroundLayer.center.x-320, backgroundLayer.center.y);
    } completion:^(BOOL finished) {}];
    [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionAllowUserInteraction  animations:^{
        settingsLayer.center = CGPointMake(settingsLayer.center.x-320, settingsLayer.center.y);
    } completion:^(BOOL finished) {}];
}

- (void) closeSettings{
    [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionAllowUserInteraction  animations:^{
        backgroundLayer.center = CGPointMake(backgroundLayer.center.x+320, backgroundLayer.center.y);
    } completion:^(BOOL finished) {}];
    [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionAllowUserInteraction  animations:^{
        settingsLayer.center = CGPointMake(settingsLayer.center.x+320, settingsLayer.center.y);
    } completion:^(BOOL finished) {}];
    
    API_KEY = apiBox.textView.text;
    mailgunURL = urlBox.textView.text;
    titleLabel.text = [mailgunURL uppercaseString];
}

- (void) cancelSettingsChange{
    [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionAllowUserInteraction  animations:^{
        backgroundLayer.center = CGPointMake(backgroundLayer.center.x+320, backgroundLayer.center.y);
    } completion:^(BOOL finished) {}];
    [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionAllowUserInteraction  animations:^{
        settingsLayer.center = CGPointMake(settingsLayer.center.x+320, settingsLayer.center.y);
    } completion:^(BOOL finished) {}];
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

- (void) openHistory{
    [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionAllowUserInteraction  animations:^{
        backgroundLayer.center = CGPointMake(backgroundLayer.center.x+320, backgroundLayer.center.y);
    } completion:^(BOOL finished) {}];
    [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionAllowUserInteraction  animations:^{
        historyLayer.center = CGPointMake(historyLayer.center.x+320, historyLayer.center.y);
    } completion:^(BOOL finished) {}];
}

- (void) closeHistory{
    [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionAllowUserInteraction  animations:^{
        backgroundLayer.center = CGPointMake(backgroundLayer.center.x-320, backgroundLayer.center.y);
    } completion:^(BOOL finished) {}];
    [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionAllowUserInteraction  animations:^{
        historyLayer.center = CGPointMake(historyLayer.center.x-320, historyLayer.center.y);
    } completion:^(BOOL finished) {}];
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
                           withSuccess:[histStatus objectForKey:[NSString stringWithFormat:@"%d",1]]];
    [historyScroll addSubview:messageCell];
    
}


@end
