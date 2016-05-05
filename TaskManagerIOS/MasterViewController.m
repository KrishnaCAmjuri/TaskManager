//
//  MasterViewController.m
//  TaskManagerIOS
//
//  Created by KrishnaChaitanya Amjuri on 24/04/16.
//  Copyright © 2016 KrishnaChaitanya Amjuri. All rights reserved.
//

#import "MasterViewController.h"
#import "ViewTaskTableViewController.h"
#import "LocationTasksTableViewController.h"

@interface MasterViewController ()

@end

@implementation MasterViewController

#pragma mark - UI Related code

- (void)configureTheUserInterface {
    self.navigationItem.title = @"Master";
    
    UIBarButtonItem *spaceAdjustor = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *AllButton = [[UIBarButtonItem alloc] initWithTitle:@"All" style:UIBarButtonItemStylePlain target:self action:@selector(filterData:)];
    AllButton.tag = 0;
    UIBarButtonItem *LocationButton = [[UIBarButtonItem alloc] initWithTitle:@"Location" style:UIBarButtonItemStylePlain target:self action:@selector(filterData:)];
    LocationButton.tag = 1;
    UIBarButtonItem *HighPriButton = [[UIBarButtonItem alloc] initWithTitle:@"HighPri" style:UIBarButtonItemStylePlain target:self action:@selector(filterData:)];
    HighPriButton.tag = 2;
    UIBarButtonItem *AscButton = [[UIBarButtonItem alloc] initWithTitle:@"Asc" style:UIBarButtonItemStylePlain target:self action:@selector(filterData:)];
    AscButton.tag = 3;
    UIBarButtonItem *DescButton = [[UIBarButtonItem alloc] initWithTitle:@"Desc" style:UIBarButtonItemStylePlain target:self action:@selector(filterData:)];
    DescButton.tag = 4;
    
    [self setToolbarItems:@[AllButton, spaceAdjustor, LocationButton, spaceAdjustor, HighPriButton, spaceAdjustor, AscButton, spaceAdjustor, DescButton] animated:YES];
    [self.navigationController.toolbar setBarStyle:UIBarStyleDefault];
    
    self.navigationController.toolbarHidden = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 40;
    [_tableView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:_tableView];
    
    NSLayoutConstraint *table_top = [NSLayoutConstraint constraintWithItem:_tableView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
    NSLayoutConstraint *table_bottom = [NSLayoutConstraint constraintWithItem:_tableView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    NSLayoutConstraint *table_left = [NSLayoutConstraint constraintWithItem:_tableView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
    NSLayoutConstraint *table_right = [NSLayoutConstraint constraintWithItem:_tableView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
    
    [self.view addConstraints:@[table_top, table_left, table_right, table_bottom]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configureTheUserInterface];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSError *error;
    if ([self.fetchedResultsController performFetch:&error]) {
        [self.tableView reloadData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)filterData: (UIBarButtonItem *)sender {
    switch (sender.tag) {
        case 0:
        {
            [self clearAllFilters];
        }
            break;
        case 1:
        {
            [self locationButtonPressed];
        }
            break;
        case 2:
        {
            [self filterHighPriTasks];
        }
            break;
        case 3:
        {
            [self sortOrder:YES];
        }
            break;
        case 4:
        {
            [self sortOrder:NO];
        }
            break;
    
        default:
            break;
    }
}

- (void)locationButtonPressed {
    
    LocationTasksTableViewController *location = [[LocationTasksTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    location.managedObjectContext = self.managedObjectContext;
    [self.navigationController pushViewController:location animated:YES];
}

#pragma mark - Core Data related code

- (void)filterHighPriTasks {
    NSFetchRequest *fetchRequest = self.fetchedResultsController.fetchRequest;
    [NSFetchedResultsController deleteCacheWithName:nil];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"priority == 3"];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    if (![[self fetchedResultsController] performFetch:&error]) {
        NSLog(@"error while filtering: %@",[error userInfo]);
    }
    
    [self.tableView reloadData];
}

- (void)clearAllFilters {
    NSFetchRequest *fetchRequest = self.fetchedResultsController.fetchRequest;
    [NSFetchedResultsController deleteCacheWithName:nil];

    [fetchRequest setPredicate:nil];
    
    NSError *error = nil;
    if (![[self fetchedResultsController] performFetch:&error]) {
        NSLog(@"error while filtering: %@",[error userInfo]);
    }
    
    [self.tableView reloadData];
}

- (void)sortOrder: (BOOL)ascending {
    NSFetchRequest *fetchRequest = self.fetchedResultsController.fetchRequest;
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"text" ascending:ascending];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSError *error = nil;
    if (![[self fetchedResultsController] performFetch:&error]) {
        NSLog(@"error while sorting the data: %@",[error userInfo]);
    }
    
    [self.tableView reloadData];
}

- (void)insertNewObject: (id)sender {
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest] entity];
    Task *newTask = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
    
    //save the context
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"Unresolved error: %@",[error userInfo]);
    }
    
    ViewTaskTableViewController *taskObj = [[ViewTaskTableViewController alloc] init];
    taskObj.managedObjectContext = self.managedObjectContext;
    taskObj.managedTaskObject = newTask;
    [self.navigationController pushViewController:taskObj animated:YES];
}

- (NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Task" inManagedObjectContext:_managedObjectContext];
    [fetchRequest setEntity:entity];
    [fetchRequest setFetchBatchSize:20];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"text" ascending:NO];
    
    NSArray *sortDescriptors = @[sortDescriptor];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:_managedObjectContext sectionNameKeyPath:nil cacheName:@"Master"];
    self.fetchedResultsController = aFetchedResultsController;
    
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
    
    return _fetchedResultsController;
}

#pragma mark - TableView Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Task *managedObject = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    ViewTaskTableViewController *taskObj = [[ViewTaskTableViewController alloc] init];
    taskObj.managedObjectContext = _managedObjectContext;
    taskObj.managedTaskObject = managedObject;
    [self.navigationController pushViewController:taskObj animated:YES];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    Task *managedObject = [self.fetchedResultsController objectAtIndexPath:indexPath];

    cell.textLabel.text = managedObject.text;
    
    if (managedObject.isOverdue == [NSNumber numberWithBool:YES]) {
        cell.textLabel.textColor = [UIColor redColor];
    } else {
        cell.textLabel.textColor = [UIColor greenColor];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
