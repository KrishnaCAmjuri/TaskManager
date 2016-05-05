//
//  EditDateViewController.m
//  TaskManagerIOS
//
//  Created by KrishnaChaitanya Amjuri on 29/04/16.
//  Copyright © 2016 KrishnaChaitanya Amjuri. All rights reserved.
//

#import "EditDateViewController.h"

@interface EditDateViewController ()

@property(nonatomic, strong) UIButton *dateButton;
@property(nonatomic, strong) NSDateFormatter *dateFormatter;
@property(nonatomic, strong) UIDatePicker *datePicker;

@end

@implementation EditDateViewController

- (void)ConfigureTheUI {
    _dateFormatter = [[NSDateFormatter alloc] init];
    [_dateFormatter setDateStyle:NSDateFormatterLongStyle];
    
    _dateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_dateButton setTitle:[_dateFormatter stringFromDate:[NSDate date]] forState:UIControlStateNormal];
    [_dateButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_dateButton setBackgroundColor:[UIColor whiteColor]];
    [_dateButton.layer setMasksToBounds:YES];
    _dateButton.layer.cornerRadius = 5;
    [_dateButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:_dateButton];
    
    _datePicker = [[UIDatePicker alloc] init];
//    [_datePicker setMinimumDate:[NSDate date]];
    [_datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
    _datePicker.datePickerMode = UIDatePickerModeDate;
    [_datePicker.layer setMasksToBounds:YES];
    [_datePicker setBackgroundColor:[UIColor whiteColor]];
    _datePicker.layer.cornerRadius = 5;
    [_datePicker setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:_datePicker];
    
    NSDictionary *views = [[NSDictionary alloc] initWithObjects:@[_dateButton, _datePicker] forKeys:@[@"dateButton", @"datePicker"]];
    
    NSMutableArray *constraintArray = [[NSMutableArray alloc] init];
    [constraintArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[dateButton(50)]-[datePicker(300)]-10-|" options:0 metrics:nil views:views]];
    [constraintArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[dateButton]-10-|" options:0 metrics:nil views:views]];
    
    [self.view addConstraints:constraintArray];

    NSMutableArray *datePickerConstraintArray = [[NSMutableArray alloc] init];
//    [datePickerConstraintArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|" options:0 metrics:nil views:views]];
    [datePickerConstraintArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[datePicker]-10-|" options:0 metrics:nil views:views]];
    
    [self.view addConstraints:datePickerConstraintArray];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithWhite:0.8 alpha:1.0]];
    
    [self ConfigureTheUI];
    // Do any additional setup after loading the view.
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleDone target:self action:@selector(saveDate)];
    
    if (self.managedTaskObject != nil) {
        NSDate *objectDate = self.managedTaskObject.dueDate;
        if (objectDate != nil) {
            self.datePicker.date = objectDate;
            [_dateButton setTitle:[_dateFormatter stringFromDate:objectDate] forState:UIControlStateNormal];
        }
    }
}

- (void)dateChanged: (UIDatePicker *)sender {
    NSLog(@"date: %@",sender.date);
    [_dateButton setTitle:[_dateFormatter stringFromDate:sender.date] forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)saveDate {
    
    self.managedTaskObject.dueDate = self.datePicker.date;
    
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:[[error userInfo] objectForKey:@"ErrorString"] message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
        
        [self.managedObjectContext rollback];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
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
