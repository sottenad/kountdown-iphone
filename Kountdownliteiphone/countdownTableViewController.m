//
//  countdownTableViewController.m
//  CountdownApp-NonFB
//
//  Created by Steve Ottenad on 10/1/13.
//  Copyright (c) 2013 Steve Ottenad. All rights reserved.
//

#import "countdownTableViewController.h"
#import "MZFormSheetController.h"
#import "addEventViewController.h"
#import "eventDetailViewController.h"


@interface countdownTableViewController ()

@end

@implementation countdownTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Fetch the countdowns from persistent data store
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Countdown"];
    NSSortDescriptor *dateSort = [[NSSortDescriptor alloc] initWithKey:@"deadline" ascending:YES selector:nil];
    NSArray *sorters = [[NSArray alloc] initWithObjects:dateSort, nil];
    [fetchRequest setSortDescriptors:sorters];
    countdowns = [[managedObjectContext executeFetchRequest:fetchRequest error:nil]mutableCopy];
    
    //NSLog(@"%@", countdowns);
    
    /*
    UIBarButtonItem *addButton = [UIBarButtonItem alloc];
    addButton.title = @"Add";
    addButton.enabled = YES;
    addButton.target = self;
    addButton.action = @selector(addCountdown);
    self.navigationItem.rightBarButtonItem = addButton;
     */

    [UIColor colorWithRed: 127.0/255.0f green:127.0/255.0f blue:127.0/255.0f alpha:1.0];
    colors = [[NSArray alloc] initWithObjects:
                [UIColor colorWithRed:1/255.0f green:122/255.0f blue:255/255.0f alpha:1],
                [UIColor colorWithRed:253/255.0f green:58/255.0f blue:53/255.0f alpha:1],
                [UIColor colorWithRed:83/255.0f green:214/255.0f blue:104/255.0f alpha:1],
                [UIColor colorWithRed:254/255.0f green:146/255.0f blue:30/255.0f alpha:1]
                , nil];
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
     self.navigationItem.leftBarButtonItem = self.editButtonItem;
}

-(void) viewWillAppear:(BOOL)animated{
    [self reloadList];
    //[self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void) setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:animated];
    if (editing) {
        // you might disable other widgets here... (optional)
    } else {
        // re-enable disabled widgets (optional)
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return countdowns.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    NSManagedObject *countdown = [countdowns objectAtIndex:indexPath.row];
    UILabel *countdownTitle = (UILabel *)[cell viewWithTag:100];
    countdownTitle.text = [NSString stringWithFormat:@"%@", [countdown valueForKey:@"title"]];
    

    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    NSDate *eventDate = [countdown valueForKey:@"deadline"];
    [df setDateFormat:@"yyyy-MM-dd"];
    if(eventDate!=nil){
        NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *components = [gregorianCalendar components:NSDayCalendarUnit
                                                            fromDate:[NSDate date]
                                                              toDate: eventDate
                                                             options:0];
        NSString *daysApart = [NSString stringWithFormat:@"%li", (long)[components day]];
        
        int r = fmod((double)indexPath.row, 4.0);
        
        NSLog(@"%@ days",daysApart);
        UILabel *countdownDate = (UILabel *)[cell viewWithTag:101];
        if([daysApart  isEqual: @"1"]){
            countdownDate.text = @"1 day";
        }else{
            countdownDate.text = [NSString stringWithFormat:@"%@ days", daysApart ];
        }
        
        [countdownDate setTextColor:[colors objectAtIndex:r]];
        [countdownTitle setTextColor:[colors objectAtIndex:r]];
    }
    
    return cell;
}


-(void)addCountdown{
    
    //NSLog(@"clicked");
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"kountdown" bundle:[NSBundle mainBundle]];
    addEventViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"addCountdown"] ;
    vc.delegate = self;
    
    if(vc != nil){
        // present form sheet with view controller
        [[MZFormSheetBackgroundWindow appearance] setBackgroundBlurEffect:YES];
        [[MZFormSheetBackgroundWindow appearance] setBlurRadius:3.0];
        [[MZFormSheetBackgroundWindow appearance] setBackgroundColor:[UIColor clearColor]];
        // present form sheet with view controller
        MZFormSheetController *formSheet = [[MZFormSheetController alloc] initWithViewController:vc];
        formSheet.shouldDismissOnBackgroundViewTap = YES;
        formSheet.shouldCenterVertically = YES;
        formSheet.shouldCenterVerticallyWhenKeyboardAppears = YES;
        formSheet.transitionStyle = MZFormSheetTransitionStyleFade;
        formSheet.cornerRadius = 8.0;
        formSheet.portraitTopInset = 6.0;
        formSheet.landscapeTopInset = 6.0;
        formSheet.presentedFormSheetSize = CGSizeMake(270, 335);
        formSheet.willPresentCompletionHandler = ^(UIViewController *presentedFSViewController){
            presentedFSViewController.view.autoresizingMask = presentedFSViewController.view.autoresizingMask | UIViewAutoresizingFlexibleWidth;
        };
        
        [formSheet presentAnimated:YES completionHandler:^(UIViewController *presentedFSViewController) {
            //NSLog(@"completed");
            
            
        }];
        
    }else{
        NSLog(@"cant find the view");
        
    }
    
}

- (void)tableView: (UITableView *)tableView didSelectRowAtIndexPath: (NSIndexPath *)indexPath
{
    //[self performSegueWithIdentifier:@"toDetail" sender:nil];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObject *countdown = [countdowns objectAtIndex:indexPath.row];
    NSString *itemTitle = [NSString stringWithFormat:@"%@", [countdown valueForKey:@"title"]];
    
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Countdown"];
    NSPredicate *titlePredicate = [NSPredicate predicateWithFormat:@"(title == %@)", itemTitle];
    [fetchRequest setPredicate:titlePredicate];
    
    NSError *error;
    NSArray *objects = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    NSManagedObject *eventToDelete = [managedObjectContext objectWithID:[[objects objectAtIndex:0] objectID]];
    [managedObjectContext deleteObject:eventToDelete];
    [managedObjectContext save:nil];
    [countdowns removeObjectAtIndex:indexPath.row];
    
    
    NSLog(@"%@",objects);
    [self.tableView reloadData];
    
    /*
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
     */
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"toDetail"]) {
        
        //Get the row number
        NSIndexPath *path = [self.tableView indexPathForSelectedRow];
        int rowNum = path.row;
        //Grab the correct item from the array
        NSManagedObject *countdown = [countdowns objectAtIndex:rowNum];
        
        //Reference the view about to appear
        eventDetailViewController *evd = [segue destinationViewController];
        
        //Get the modulous for the color
        int r = fmod((double)rowNum, 4.0);
        
        //Assign all the view params
        evd.myDate = [NSString stringWithFormat:@"%@", [countdown valueForKey:@"deadline"]];
        evd.myTitle = [NSString stringWithFormat:@"%@", [countdown valueForKey:@"title"]];
        UIImage *mainImage = [[UIImage alloc] initWithData:[countdown valueForKey:@"photo"]];
        evd.fontColor = [colors objectAtIndex:r];
        evd.myImage = mainImage;

    }
    
}


-(void)loadTableData{
    // Fetch the countdowns from persistent data store
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Countdown"];
    countdowns = [[managedObjectContext executeFetchRequest:fetchRequest error:nil]mutableCopy];
    [self.tableView reloadData];
}

-(void)reloadList {
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Countdown"];
    NSSortDescriptor *dateSort = [[NSSortDescriptor alloc] initWithKey:@"deadline" ascending:YES selector:nil];
    NSArray *sorters = [[NSArray alloc] initWithObjects:dateSort, nil];
    [fetchRequest setSortDescriptors:sorters];
    countdowns = [[managedObjectContext executeFetchRequest:fetchRequest error:nil]mutableCopy];
    [self loadTableData];
    
}

-(NSManagedObjectContext *)managedObjectContext{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if([delegate performSelector:@selector(managedObjectContext)]){
        context = [delegate managedObjectContext];
    }
    return context;
}

@end
