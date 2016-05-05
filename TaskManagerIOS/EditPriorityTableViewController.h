//
//  EditPriorityTableViewController.h
//  TaskManagerIOS
//
//  Created by KrishnaChaitanya Amjuri on 27/04/16.
//  Copyright © 2016 KrishnaChaitanya Amjuri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Task.h"

@interface EditPriorityTableViewController : UITableViewController

@property(nonatomic, strong) Task *managedTaskObject;
@property(nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end

@interface priorityTableViewCell : UITableViewCell

@end