//
//  EditLocationTableViewController.h
//  TaskManagerIOS
//
//  Created by KrishnaChaitanya Amjuri on 27/04/16.
//  Copyright © 2016 KrishnaChaitanya Amjuri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Task.h"
#import "Location.h"

@interface EditLocationTableViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property(nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property(nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property(nonatomic, strong) Task *managedTaskObject;

@end

@interface EditLocationCell : UITableViewCell

@end