//
//  MainViewController.m
//  Emercuate
//
//  Created by 吴肇锋 on 1/30/16.
//  Copyright © 2016 RescueBots. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@property CLLocationManager *locationManager;
@property double longtitude;
@property double latitude;

- (IBAction)rescueButton:(id)sender;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        [self.locationManager requestWhenInUseAuthorization];
    
    [self.locationManager startUpdatingLocation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)unwindToMain:(UIStoryboardSegue *)segue {
}

- (IBAction)rescueButton:(id)sender {
    if(![MFMessageComposeViewController canSendText]) {
        UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your device doesn't support SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [warningAlert show];
        return;
    }
    
    NSArray *recipents = @[@"911"];
    
    [Information initialize];
    NSDictionary *info = [Information information];
    NSString *message = [NSString stringWithFormat:@"My name is %@ - I need help.\nAddress: %@\nRoom/Level: %@\nCondition: %@\nMedical ID: %@\nComments: %@\nLongtitude: %.10f\nLatitude: %.10f", [info objectForKey:@"Name"], [[info objectForKey:@"Address"] objectForKey:[Information chosenAddressName]][0], [[info objectForKey:@"Address"] objectForKey:[Information chosenAddressName]][1], [info objectForKey:@"Condition"], [info objectForKey:@"Medical ID"], [info objectForKey:@"Comments"], self.longtitude, self.latitude];
    
    MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
    messageController.messageComposeDelegate = self;
    [messageController setRecipients:recipents];
    [messageController setBody:message];
    
    // Present message view controller on screen
    [self presentViewController:messageController animated:YES completion:nil];
    
    
    
    //[CLLocationManager new];
    //manager.delegate = self;
    //manager.desiredAccuracy = kCLLocationAccuracyBest;
    //manager.distanceFilter = 0;
    //[manager requestLocation];
    //[manager startMonitoringSignificantLocationChanges];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult) result
{
    NSLog(@"result: %d", result);
    switch (result) {
        case MessageComposeResultCancelled:
        {
            UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to send SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [warningAlert show];
            break;
        }
            break;
            
        case MessageComposeResultFailed:
        {
            UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to send SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [warningAlert show];
            break;
        }
            
        case MessageComposeResultSent:
            break;
            
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    NSLog(@"%@", locations);
    self.longtitude = ((CLLocation *)[locations lastObject]).coordinate.longitude;
    self.latitude = ((CLLocation *)[locations lastObject]).coordinate.latitude;
    [manager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"failed: %@", error);
}

@end
