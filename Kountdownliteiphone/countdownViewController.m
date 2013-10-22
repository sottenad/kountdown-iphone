//
//  countdownViewController.m
//  CountdownApp-NonFB
//
//  Created by Steve Ottenad on 10/1/13.
//  Copyright (c) 2013 Steve Ottenad. All rights reserved.
//

#import "countdownViewController.h"

@interface countdownViewController ()

@end

@implementation countdownViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    /*
    // Create a new managed object
    NSManagedObjectContext *context = [self managedObjectContext];
    NSManagedObject *newReminder = [NSEntityDescription insertNewObjectForEntityForName:@"Countdown" inManagedObjectContext:context];
    NSDate *now = [NSDate date];
    [newReminder setValue:@"MyEvent" forKey:@"title"];
    [newReminder setValue:now forKey:@"deadline"];

    
    NSError *error = nil;
    // Save the object to persistent store
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
    
    [self populateLabel];
     */
}





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
