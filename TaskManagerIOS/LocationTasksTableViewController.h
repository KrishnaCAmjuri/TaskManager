//
//  LocationTasksTableViewController.h
//  TaskManagerIOS
//
//  Created by KrishnaChaitanya Amjuri on 03/05/16.
//  Copyright © 2016 KrishnaChaitanya Amjuri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewTaskTableViewController.h"
#import "Task.h"
#import "Location.h"

@interface LocationTasksTableViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property(nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property(nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end
