//
//  addEventViewController.h
//  countdownapp
//
//  Created by Steve Ottenad on 9/24/13.
//  Copyright (c) 2013 Steve Ottenad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "countdownModal.h"

@interface addEventViewController : UIViewController<UIImagePickerControllerDelegate>{
    IBOutlet UITextField * eventName;
    IBOutlet UITextField * eventDate;

    IBOutlet UIButton *selectPhoto;
    IBOutlet UIImageView * imageThumb;
    NSDateFormatter *df;
    NSDateFormatter *tf;

}

@property (nonatomic, assign) id<countdownModal> delegate;

-(IBAction)createEvent: (id)sender;
-(IBAction)dismissAddEventModal: (id)sender;
-(IBAction) takePicture:(id) sender;

@end
