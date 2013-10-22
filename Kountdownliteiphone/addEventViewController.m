//
//  addEventViewController.m
//  countdownapp
//
//  Created by Steve Ottenad on 9/24/13.
//  Copyright (c) 2013 Steve Ottenad. All rights reserved.
//

#import "addEventViewController.h"
#import "MZFormSheetController.h"
#import "countdownModal.h"


@interface addEventViewController ()

@end

@implementation addEventViewController
@synthesize delegate;

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
    df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"LLLL dd yyyy"];

    tf = [[NSDateFormatter alloc] init];
    [tf setDateFormat:@"h:m"];
    
    //Mkae Date Picker
    CGRect pickerFrame = CGRectMake(0,700,0,0);
    UIDatePicker *myDatePicker = [[UIDatePicker alloc] initWithFrame:pickerFrame];
    [myDatePicker addTarget:self action:@selector(eventDatePickerChanged:) forControlEvents:UIControlEventValueChanged];
    myDatePicker.datePickerMode = UIDatePickerModeDate;
    NSDate *Date=[NSDate date];
    myDatePicker.minimumDate=Date;
    
    eventDate.inputView = myDatePicker;
    
}

- (void)eventDatePickerChanged:(id)sender
{
    eventDate.text = [df stringFromDate:[sender date]];
}




-(void)createEvent:(id)sender{
    
    NSLog(@"createevent");
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"LLLL d yyyy"];
    NSDate *dateFromString = [dateFormatter dateFromString:eventDate.text];
    
    tf = [[NSDateFormatter alloc] init];
    [tf setDateFormat:@"h:m"];

    UIImage *selectedPhoto = imageThumb.image;
    NSData *imageData = UIImagePNGRepresentation(selectedPhoto);
    
    // Create a new managed object
    NSManagedObjectContext *context = [self managedObjectContext];
    NSManagedObject *newReminder = [NSEntityDescription insertNewObjectForEntityForName:@"Countdown" inManagedObjectContext:context];
    [newReminder setValue:eventName.text forKey:@"title"];
    [newReminder setValue:dateFromString forKey:@"deadline"];
    [newReminder setValue:imageData forKey:@"photo"];
    
    NSError *error = nil;
    // Save the object to persistent store
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }else{
        NSLog(@"saved!");
        
    }
    
    [delegate reloadList];
    [self dismissViewControllerAnimated:YES completion:nil];
    
             
}

-(void) dismissAddEventModal:(id)sender{
    [self dismissFormSheetControllerAnimated:YES completionHandler:^(MZFormSheetController *formSheetController) {
        [delegate reloadList];
    }];

}

-(void) takePicture:(id) sender
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    [imagePicker shouldAutorotate];
    [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [imagePicker setDelegate:self];
    [self presentViewController:imagePicker animated:YES completion:nil];
}


-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [imageThumb setImage:image];
    [selectPhoto removeFromSuperview];
    [self dismissViewControllerAnimated:YES completion:nil];
    //[self dismissModalViewControllerAnimated:YES];
}



-(NSManagedObjectContext *)managedObjectContext{
    NSManagedObjectContext *context = nil;
    id mydelegate = [[UIApplication sharedApplication] delegate];
    if([mydelegate performSelector:@selector(managedObjectContext)]){
        context = [mydelegate managedObjectContext];
    }
    return context;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
