//
//  EditTextViewController.m
//  TaskManagerIOS
//
//  Created by KrishnaChaitanya Amjuri on 29/04/16.
//  Copyright © 2016 KrishnaChaitanya Amjuri. All rights reserved.
//

#import "EditTextViewController.h"

@interface EditTextViewController ()
{
    PaddingTextField *textField;
}
@end

@implementation EditTextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleDone target:self action:@selector(saveText)];
    
    [self.view setBackgroundColor:[UIColor colorWithWhite:0.8 alpha:1.0]];

    textField = [[PaddingTextField alloc] init];
    textField.text = [self.managedObject valueForKey:_keyString];
    textField.clearsOnBeginEditing = YES;
    textField.backgroundColor = [UIColor whiteColor];
    textField.textColor = [UIColor blackColor];
    textField.font = [UIFont fontWithName:@"Helvetica" size:16];
    textField.layer.cornerRadius = 5;
    [self.view addSubview:textField];
    
    [textField.layer setMasksToBounds:YES];
    [textField setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    NSDictionary *dic = [[NSDictionary alloc] initWithObjects:@[textField] forKeys:@[@"text"]];
    
    NSMutableArray *constraints = [[NSMutableArray alloc] init];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[text]-10-|" options:0 metrics:nil views:dic]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[text(50)]" options:0 metrics:nil views:dic]];

    [self.view addConstraints:constraints];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)saveText {
    
    [self.managedObject setValue:textField.text forKey:self.keyString];
    
    // save the context
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"not saved: %@", error.userInfo);
        [self.managedObjectContext rollback];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    [textField resignFirstResponder];
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

@implementation PaddingTextField

- (CGRect)textRectForBounds:(CGRect)bounds {
    
    CGRect newBounds = CGRectMake(bounds.origin.x + 10, bounds.origin.y, bounds.size.width - 20, bounds.size.height);
    return newBounds;
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    
    CGRect newBounds = CGRectMake(bounds.origin.x + 10, bounds.origin.y, bounds.size.width - 20, bounds.size.height);
    return newBounds;
}

@end
