//
//  EditDateViewController.h
//  TaskManagerIOS
//
//  Created by KrishnaChaitanya Amjuri on 29/04/16.
//  Copyright © 2016 KrishnaChaitanya Amjuri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Task.h"

@interface EditDateViewController : UIViewController

@property(nonatomic, strong) Task *managedTaskObject;
@property(nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end
