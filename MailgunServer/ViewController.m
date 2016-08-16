//
//  ViewController.m
//  MailgunServer

// TO DO:
//   Find a way to attach images, hopefully from Photos Library
//   Add extra inputs for your name when sending / receiving.
//   Error message on sending failure
//   Add source control support
//   Bit of reformatting to look more like Mail app
//   Alignment of SETTINGS / TEDDYROWAN.com text and icons

//   Settings page where you can customize the website and api key and such
    // Add API field
    // Add server address field
    // Add cancel field
    // Add NSUserDefaults to save their info
    // Tapping anywhere on the settings page brings back up the normal email sending view...

#import "ViewController.h"
#define INIT_HEIGHT_LAB 68
#define INIT_HEIGHT_BOX 110
#define SPACING 60
#define INIT_X 20

@interface ViewController ()

@end

@implementation ViewController
@synthesize toBox, fromBox, subjectBox, messageBox, sendButton, backgroundLayer, activeField, API_KEY, mailgunURL, lockView, locked, subjLbl, settingsButton, settingsLayer, backButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //[self registerForKeyboardNotifications];
    
    activeField = [[UITextView alloc] init];
    
    API_KEY = [[NSString alloc] initWithFormat:@"key-9a01fe9d60afece3eeda648f0d90206a"];
    mailgunURL = [[NSString alloc] initWithFormat:@"teddyrowan.com" ];
    
    
    backgroundLayer = [[UIView alloc] init];
    backgroundLayer.frame = self.view.frame;
    backgroundLayer.backgroundColor = [UIColor clearColor];
    [self.view addSubview:backgroundLayer];
    
    UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 25, 200, 60)];
    titleLabel.text = @" TEDDYROWAN.com ";
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
    [backgroundLayer addSubview:toBox];
    
    
    
    UILabel* fromLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, INIT_HEIGHT_LAB+1*SPACING, 280, 30)];
    fromLabel.text = @" FROM:    ";
    fromLabel.font = [UIFont systemFontOfSize:12];
    [backgroundLayer addSubview:fromLabel];
    
    fromBox = [[BorderedTextField alloc] init];
    fromBox.center = CGPointMake(self.view.center.x, INIT_HEIGHT_BOX+1*SPACING);
    fromBox.textView.text = @"teddy@teddyrowan.com";
    [backgroundLayer addSubview:fromBox];
    
    
    
    UILabel* subjLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, INIT_HEIGHT_LAB+2*SPACING, 280, 30)];
    subjLabel.text = @" SUBJECT:    ";
    subjLabel.font = [UIFont systemFontOfSize:12];
    [backgroundLayer addSubview:subjLabel];
    
    subjectBox = [[BorderedTextField alloc] init];
    subjectBox.center = CGPointMake(self.view.center.x, INIT_HEIGHT_BOX+2*SPACING);
    //subjectBox.textView.text = @"ENTER A SUBJECT...";
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
    
    // Do any additional setup after loading the view, typically from a nib.
    
    [self loadSettingsLayer];
}

- (void) loadSettingsLayer{
    settingsLayer = [[UIView alloc] init];
    settingsLayer.frame = self.view.frame;
    settingsLayer.center = CGPointMake(settingsLayer.center.x+320, settingsLayer.center.y);
    settingsLayer.backgroundColor = [UIColor clearColor];
    [self.view addSubview:settingsLayer];
    
    UILabel* settingsLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 35, 200, 60)];
    settingsLabel.text = @" SETTINGS ";
    settingsLabel.font = [UIFont boldSystemFontOfSize:18.0];
    settingsLabel.textAlignment = NSTextAlignmentCenter;
    settingsLabel.center = CGPointMake(self.view.center.x, settingsLabel.center.y);
    [settingsLayer addSubview:settingsLabel];
    
    backButton = [[UIButton alloc] initWithFrame:CGRectMake(25, 35, 35, 35)];
    backButton.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"back35.png"]];
    [backButton addTarget:self action:@selector(closeSettings) forControlEvents:UIControlEventTouchUpInside];
    [settingsLayer addSubview:backButton];
}

- (void)sendMessage{
    if (!locked){
        [self switchLock];
    } else {
        return;
    }
    
    // This works perfectly for now. Add images and cc and stuff after.
    Mailgun *mailgun = [Mailgun clientWithDomain:mailgunURL apiKey:API_KEY];
    [mailgun sendMessageTo:toBox.textView.text
                      from:fromBox.textView.text
                   subject:subjectBox.textView.text
                      body:messageBox.textView.text];
    
    
    
    /*[mailgun sendMessageTo:@"Edward Rowan <edward.rowan@alumni.ubc.ca>"
     from:@"Hollow Victory <HV@teddyrowan.com>"
     subject:@"iOS Sending Test"
     body:@"This gonna be crazy if it works."];
    */
    
    // WOOT WOOT SENDING A PICTURE WORKS
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
    if(![subjectBox.textView hasText]) {
        subjLbl.hidden = NO;
    }
    else{
        subjLbl.hidden = YES;
    }  
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
    backgroundLayer.frame = self.view.frame;
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
}


@end
