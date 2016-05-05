//
//  ViewTaskTableViewController.m
//  TaskManagerIOS
//
//  Created by KrishnaChaitanya Amjuri on 27/04/16.
//  Copyright © 2016 KrishnaChaitanya Amjuri. All rights reserved.
//

#import "ViewTaskTableViewController.h"
#import "EditPriorityTableViewController.h"
#import "EditLocationTableViewController.h"
#import "EditDateViewController.h"
#import "EditTextViewController.h"
#import "AppDelegate.h"

@interface ViewTaskTableViewController ()

@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSMutableArray *detailArray;

@end

@implementation ViewTaskTableViewController

- (void)setDataSourceForThis {
    
    if (self.managedTaskObject != nil) {
        // Refresh the context
        [self.managedObjectContext refreshObject:self.managedTaskObject mergeChanges:YES];
        
        if (self.detailArray == nil) {
            self.detailArray = [[NSMutableArray alloc] init];
        }
        [self.detailArray insertObject:self.managedTaskObject.text atIndex:0];
        
        NSString *priorityString = nil;
        
        switch ([self.managedTaskObject.priority intValue]) {
            case 0:
                priorityString = @"None";
                break;
            case 1:
                priorityString = @"Low";
                break;
            case 2:
                priorityString = @"Medium";
                break;
            case 3:
                priorityString = @"High";
                break;
            default:
                break;
        }
        
        [self.detailArray insertObject:priorityString atIndex:1];
        
        //date
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateStyle:NSDateFormatterLongStyle];
        
        [self.detailArray insertObject:[df stringFromDate:self.managedTaskObject.dueDate] atIndex:2];
        
        //location
        Location *locationObject = self.managedTaskObject.location;
        if (locationObject != nil) {
            [self.detailArray insertObject:locationObject.name atIndex:3];
        } else {
            [self.detailArray insertObject:@"Not Set" atIndex:3];
        }
        
        //others
        [self.detailArray insertObject:@"Hi-Pri Tasks" atIndex:4];
        [self.detailArray insertObject:@"Tasks due sooner than this one" atIndex:5];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Task Detail";

    [self setDataSourceForThis];
    _titleArray = @[@"Text", @"Priority", @"Due Date", @"Location"];
    self.tableView.rowHeight = 40;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self setDataSourceForThis];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        if (indexPath.row >= 4) {
            cell.textLabel.text = [_detailArray objectAtIndex:indexPath.row];
            cell.detailTextLabel.text = nil;
            cell.accessoryType = UITableViewCellAccessoryNone;
        } else {
            cell.textLabel.text = [_titleArray objectAtIndex:indexPath.row];
            cell.detailTextLabel.text = [_detailArray objectAtIndex:indexPath.row];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    } else {
        if (indexPath.row >= 4) {
            cell.textLabel.text = [_detailArray objectAtIndex:indexPath.row];
        } else {
            cell.textLabel.text = [_titleArray objectAtIndex:indexPath.row];
            cell.detailTextLabel.text = [_detailArray objectAtIndex:indexPath.row];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    
    // Configure the cell...
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
        {
            EditTextViewController *text = [[EditTextViewController alloc] init];
            text.managedObjectContext = self.managedObjectContext;
            text.managedObject = _managedTaskObject;
            text.keyString = @"text";
            [self.navigationController pushViewController:text animated:YES];
        }
            break;
        case 1:
        {
            EditPriorityTableViewController *prio = [[EditPriorityTableViewController alloc] init];
            prio.managedTaskObject = self.managedTaskObject;
            prio.managedObjectContext = self.managedObjectContext;
            [self.navigationController pushViewController:prio animated:YES];
        }
            break;
        case 2:
        {
            EditDateViewController *dateVc = [[EditDateViewController alloc] init];
            dateVc.managedObjectContext = self.managedObjectContext;
            dateVc.managedTaskObject = self.managedTaskObject;
            [self.navigationController pushViewController:dateVc animated:YES];
        }
            break;
        case 3:
        {
            EditLocationTableViewController *loc = [[EditLocationTableViewController alloc] init];
            loc.managedObjectContext = self.managedObjectContext;
            loc.managedTaskObject = self.managedTaskObject;
            [self.navigationController pushViewController:loc animated:YES];
        }
            break;
        case 4:
        {
            UIAlertController *highPriAlert = [UIAlertController alertControllerWithTitle:@"Hi-Pri Tasks" message:nil preferredStyle:UIAlertControllerStyleAlert];
            NSMutableString *message = [[NSMutableString alloc] init];
            
            NSFetchRequest *request = [[NSFetchRequest alloc] init];
            NSEntityDescription *entity = [NSEntityDescription entityForName:@"Task" inManagedObjectContext:_managedObjectContext];
            [request setEntity:entity];
            [request setFetchBatchSize:20];
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"priority == 3"];
            [request setPredicate:predicate];
            
            NSError *error = nil;
            NSArray *results = [self.managedObjectContext executeFetchRequest:request error:&error];
            
            for (Task *task in results) {
                [message appendString:task.text];
                [message appendString:@"\n"];
            }
            
            UIAlertAction *OkAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

            }];
            [highPriAlert addAction:OkAction];
            [highPriAlert setMessage:message];
            
            [self presentViewController:highPriAlert animated:YES completion:nil];
        }
            break;
        case 5:
        {
            UIAlertController *highPriAlert = [UIAlertController alertControllerWithTitle:@"Tasks due sooner" message:nil preferredStyle:UIAlertControllerStyleAlert];
            NSMutableString *message = [[NSMutableString alloc] init];
        
            NSFetchRequest *request = [[NSFetchRequest alloc] init];
            NSEntityDescription *entity = [NSEntityDescription entityForName:@"Task" inManagedObjectContext:_managedObjectContext];
            [request setEntity:entity];
            [request setFetchBatchSize:20];
            
            [request setPredicate:[NSPredicate predicateWithFormat:@"dueDate < %@",self.managedTaskObject.dueDate]];
            
            NSError *error;
            NSArray *results = [self.managedObjectContext executeFetchRequest:request error:&error];
            
            for (Task *task in results) {
                NSLog(@"task.text: %@", task.text);
                [message appendString:task.text];
                [message appendString:@"\n"];
            }
            
            UIAlertAction *OkAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

            }];
            [highPriAlert addAction:OkAction];
            [highPriAlert setMessage:message];
            
            [self presentViewController:highPriAlert animated:YES completion:nil];
        }
            break;
            
        default:
            break;
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
