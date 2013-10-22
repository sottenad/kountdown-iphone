//
//  eventDetailViewController.m
//  CountdownApp-NonFB
//
//  Created by Steve Ottenad on 10/2/13.
//  Copyright (c) 2013 Steve Ottenad. All rights reserved.
//

#import "eventDetailViewController.h"


@interface eventDetailViewController ()

@end

@implementation eventDetailViewController

@synthesize mainView, myDate, myImage, myTitle, fontColor, countdownTitle, countdownDate, mainImageView, isScreenshot;

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
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss ZZZ"];
    [df setTimeZone:[NSTimeZone systemTimeZone]];
    
    NSDateFormatter *tf = [[NSDateFormatter alloc] init];
    [tf setDateFormat:@"h:m"];
    [df setTimeZone:[NSTimeZone systemTimeZone]];    

    countdownNSDate = [df dateFromString:myDate];
    
    countdownTitle.text = myTitle;
    mainImageView.image = myImage;
    
    [countdownTitle setTextColor:fontColor];
    [countdownDate setTextColor:fontColor];
    
    [self updateTimer];
    
    if(!isScreenshot){
        NSTimer* myTimer = [NSTimer scheduledTimerWithTimeInterval: 1.0 target: self
                                                      selector: @selector(updateTimer) userInfo: nil repeats: YES];
    }

    
}

-(void) viewDidAppear:(BOOL)animated{
    
    if(isScreenshot){
        CGPoint np = self.view.center;
        int xCoord = np.x - 306;
        int yCoord = np.y - 306;
        
        //If Portrait
        CGRect grabRect = CGRectMake(xCoord,yCoord,612,612);
        
        UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
        if (UIInterfaceOrientationIsLandscape(orientation))
        {
            NSLog(@"landscape");
            grabRect = CGRectMake(yCoord,xCoord,612,612);
        }
        

        
        
        //for retina displays
        if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
            UIGraphicsBeginImageContextWithOptions(grabRect.size, NO, [UIScreen mainScreen].scale);
        } else {
            UIGraphicsBeginImageContext(grabRect.size);
        }
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGContextTranslateCTM(ctx, -grabRect.origin.x, -grabRect.origin.y);
        [self.view.layer renderInContext:ctx];
        UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        //UIImageWriteToSavedPhotosAlbum(viewImage, nil, nil, nil);
        [self saveImage:viewImage];
        
        
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                             NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString* path = [documentsDirectory stringByAppendingPathComponent:
                          @"test.igo" ];


        // URL TO THE IMAGE FOR THE DOCUMENT INTERACTION
        NSURL *igImageHookFile = [NSURL fileURLWithPath:[[NSString alloc] initWithFormat:@"file://%@", path]];
        dic.UTI = @"com.instagram.exclusivegram";
        [self setupDocumentControllerWithURL:igImageHookFile];
        
        // OPEN THE HOOK
        [dic presentOpenInMenuFromRect:self.view.frame inView:self.view animated:YES];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}

- (void)setupDocumentControllerWithURL:(NSURL *)url
{
    if (dic == nil)
    {
        dic = [UIDocumentInteractionController interactionControllerWithURL:url];
        dic.delegate = self;
    }
    else
    {
        dic.URL = url;
    }
}

- (void)saveImage: (UIImage*)image
{
    if (image != nil)
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                             NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString* path = [documentsDirectory stringByAppendingPathComponent:
                          @"test.igo" ];
        NSData* data = UIImagePNGRepresentation(image);
        [data writeToFile:path atomically:YES];
    }
    
}

-(void) updateTimer{
    NSTimeInterval secondsBetweenDates = [countdownNSDate timeIntervalSinceDate: [NSDate date]];
    double secondsInAMinute = 60;
    double secondsInAnHour = secondsInAMinute * 60;
    double secondsInADay = secondsInAnHour * 24;

    NSInteger minutesBetweenDates = secondsBetweenDates / secondsInAMinute;
    NSInteger hoursBetweenDates = secondsBetweenDates / secondsInAnHour;
    NSInteger daysBetweenDates = secondsBetweenDates / secondsInADay;
    
    NSString *daysString = [[NSString alloc] initWithFormat:@"%li Day%@", (long)daysBetweenDates, (daysBetweenDates == 1 ? @"" : @"s")];
    NSString *hoursString = [[NSString alloc] initWithFormat:@"%li Hour%@", (long)hoursBetweenDates%24, (hoursBetweenDates%24 == 1 ? @"" : @"s")];
    NSString *minutesString = [[NSString alloc] initWithFormat:@"%li Minute%@", (long)minutesBetweenDates%60, (minutesBetweenDates%60 == 1 ? @"" : @"s")];
    NSString *secondsString = [[NSString alloc] initWithFormat:@"%li Second%@", (long)secondsBetweenDates%60, ((NSInteger)secondsBetweenDates%60 == 1 ? @"" : @"s")];
    
    
    NSString *finalString = [[NSString alloc] initWithFormat:@"%@, %@, %@ & %@", daysString, hoursString, minutesString,secondsString];
    
    countdownDate.text = finalString;

}

-(void)takeScreenshot:(id)sender{

   
    
   // [self performSegueWithIdentifier:@"showScreenShot" sender:nil];

}


#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"toScreenshot"]) {
        eventDetailViewController *evd = [segue destinationViewController];
        //Assign all the view params
        evd.myDate = myDate;
        evd.myTitle = myTitle;
        UIImage *mainImage = myImage;
        evd.fontColor = fontColor;
        evd.myImage = mainImage;
        evd.isScreenshot = YES;
    }
}


-(void) transformForScreenshot:(id)sender{
    
    mainView.frame = CGRectMake(0, 125, 612, 612);
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSDate *)combineDate:(NSDate *)date withTime:(NSDate *)time {
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    unsigned unitFlagsDate = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    NSDateComponents *dateComponents = [gregorian components:unitFlagsDate fromDate:date];
    unsigned unitFlagsTime = NSHourCalendarUnit | NSMinuteCalendarUnit |  NSSecondCalendarUnit;
    NSDateComponents *timeComponents = [gregorian components:unitFlagsTime fromDate:time];
    
    [dateComponents setSecond:[timeComponents second]];
    [dateComponents setHour:[timeComponents hour]];
    [dateComponents setMinute:[timeComponents minute]];
    
    NSDate *combDate = [gregorian dateFromComponents:dateComponents];
    
    return combDate;
}



@end
