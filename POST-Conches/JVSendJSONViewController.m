//
//  ViewController.m
//  POST-Conches
//
//  Created by Joseph Ayo-Vaughan on 3/4/15.
//  Copyright (c) 2015 Joseph Ayo-Vaughan. All rights reserved.
//

#import "JVSendJSONViewController.h"
#import "JVExtendedNSLogFuntionality.h"
#import "AFHTTPRequestOperationManager.h"

@interface JVSendJSONViewController ()
@property (weak, nonatomic) IBOutlet UITextView *venuesTextView;
@property (weak, nonatomic) IBOutlet UITextView *conchTextView;
@property (strong, nonatomic) NSString *venuesString;
@property (strong, nonatomic) NSString *conchString;
@property (strong, nonatomic) NSDictionary *conchDict;
@end

@implementation JVSendJSONViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    CGRect screenBounds = [[UIScreen mainScreen]bounds];
    
    UIView *blockUIView = [[UIView alloc]initWithFrame:screenBounds];
    blockUIView.backgroundColor = [UIColor clearColor];
    
    UIView *indicatorContainer = [[UIView alloc]initWithFrame:CGRectMake((screenBounds.size.width/2) - 50, (screenBounds.size.height/2) - 50, 100, 100)];
    indicatorContainer.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.8];
    indicatorContainer.layer.cornerRadius = 10;
    
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    spinner.frame = CGRectMake((indicatorContainer.frame.size.width/2) - 40, (indicatorContainer.frame.size.height/2) - 40, 80, 80);
    
    [spinner startAnimating];
    
    [blockUIView addSubview:indicatorContainer];
    [indicatorContainer addSubview:spinner];
    [self.view addSubview:blockUIView];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, kNilOptions), ^{
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager setRequestSerializer:[AFJSONRequestSerializer serializer]];
        [manager.requestSerializer setValue:self.authToken forHTTPHeaderField:@"authtoken"];
        
        [manager GET:[NSString stringWithFormat:@"http://dev.yawasabere.com:3000/venues?latitude=39.9631&limit=1&longitude=-75.1450&offset=0"] parameters:nil success:^(AFHTTPRequestOperation *operation, id venuesObject) {
            self.venuesString = [[venuesObject firstObject] description];
            
             self.conchDict = @{@"location": [venuesObject firstObject], @"coordinates": @[@"-75.1450", @"39.9631"], @"content": @"Hello there", @"tags": @[@"venue", @"place", @"location"]};
//            NSLog(@"venuesDict: %@", venuesDict);
            self.conchString = self.conchDict.description;
            
            [self setupTextViews];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [blockUIView removeFromSuperview];
            });
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"GET Venues Error: %@", error);
            dispatch_async(dispatch_get_main_queue(), ^{
                [blockUIView removeFromSuperview];
            });
        }];

    });
}

- (void)setupTextViews {
    self.venuesTextView.text = self.venuesString;
    self.conchTextView.text = self.conchString;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)POSTConch:(id)sender {
    CGRect screenBounds = [[UIScreen mainScreen]bounds];
    
    UIView *blockUIView = [[UIView alloc]initWithFrame:screenBounds];
    blockUIView.backgroundColor = [UIColor clearColor];
    
    UIView *indicatorContainer = [[UIView alloc]initWithFrame:CGRectMake((screenBounds.size.width/2) - 50, (screenBounds.size.height/2) - 50, 100, 100)];
    indicatorContainer.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.8];
    indicatorContainer.layer.cornerRadius = 10;
    
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    spinner.frame = CGRectMake((indicatorContainer.frame.size.width/2) - 40, (indicatorContainer.frame.size.height/2) - 40, 80, 80);
    
    [spinner startAnimating];
    
    [blockUIView addSubview:indicatorContainer];
    [indicatorContainer addSubview:spinner];
    [self.view addSubview:blockUIView];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setRequestSerializer:[AFJSONRequestSerializer serializer]];
    [manager.requestSerializer setValue:self.authToken forHTTPHeaderField:@"authtoken"];
    [manager POST:[NSString stringWithFormat:@"http://dev.yawasabere.com:3000/conches"] parameters:self.conchDict success:^(AFHTTPRequestOperation *operation, id conchObject) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [blockUIView removeFromSuperview];
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"POST Conches Error: %@", error);
        dispatch_async(dispatch_get_main_queue(), ^{
            [blockUIView removeFromSuperview];
        });
    }];
}
@end
