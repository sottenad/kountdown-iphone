//
//  eventDetailViewController.h
//  CountdownApp-NonFB
//
//  Created by Steve Ottenad on 10/2/13.
//  Copyright (c) 2013 Steve Ottenad. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface eventDetailViewController : UIViewController<UIDocumentInteractionControllerDelegate>{
    NSDate *countdownNSDate;
    UIDocumentInteractionController *dic;
}

@property UIImage *myImage;
@property NSString *myTitle;
@property NSString *myDate;
@property BOOL isScreenshot;

@property UIColor *fontColor;

@property IBOutlet UIView *mainView;
@property IBOutlet UIImageView *mainImageView;
@property IBOutlet UILabel *countdownTitle;
@property IBOutlet UILabel *countdownDate;
@property IBOutlet UIImageView *backgroundRow;
@property IBOutlet UIButton *screenShotButton;


-(void) updateTimer;
- (NSDate *)combineDate:(NSDate *)date withTime:(NSDate *)time;
-(IBAction)transformForScreenshot:(id)sender;


@end
