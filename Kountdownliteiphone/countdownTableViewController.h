//
//  countdownTableViewController.h
//  CountdownApp-NonFB
//
//  Created by Steve Ottenad on 10/1/13.
//  Copyright (c) 2013 Steve Ottenad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "countdownModal.h"

@interface countdownTableViewController : UITableViewController<countdownModal>{
    NSMutableArray *countdowns;
    NSArray *colors;
}

@end
