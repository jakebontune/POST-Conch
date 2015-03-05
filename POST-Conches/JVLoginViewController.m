//
//  JVLoginViewController.m
//  POST-Conches
//
//  Created by Joseph Ayo-Vaughan on 3/4/15.
//  Copyright (c) 2015 Joseph Ayo-Vaughan. All rights reserved.
//

#import "JVLoginViewController.h"
#import "JVSendJSONViewController.h"
#import "JVExtendedNSLogFuntionality.h"
#import "AFHTTPRequestOperationManager.h"

@interface JVLoginViewController ()
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) NSString *authToken;
@end

@implementation JVLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.loginButton setTitle:@"Log In" forState:UIControlStateNormal];
    [self.loginButton setTitle:@"Logging In..." forState:UIControlStateDisabled];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self loginUser:self.loginButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginUser:(id)sender {
    UIButton *loginButton = (UIButton *)sender;
    [loginButton setEnabled:NO];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:@"http://dev.yawasabere.com:3000/login" parameters:@{@"phoneNumber": @"123-456-7890", @"password": @"testtest"} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Logged in as %@", responseObject[@"user"][@"name"]);
        self.authToken = responseObject[@"userToken"];
        [self performSegueWithIdentifier:@"toSendJSON" sender:self];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error.description);
        NSLog(@"Perhaps server is down. Read error above for more info");
        [loginButton setTitle:@"Try again" forState:UIControlStateNormal];
        [loginButton setEnabled:YES];
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"toSendJSON"]) {
        JVSendJSONViewController *dest = segue.destinationViewController;
        dest.authToken = self.authToken;
    }
}

@end
