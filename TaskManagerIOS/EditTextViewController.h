//
//  EditTextViewController.h
//  TaskManagerIOS
//
//  Created by KrishnaChaitanya Amjuri on 29/04/16.
//  Copyright © 2016 KrishnaChaitanya Amjuri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface EditTextViewController : UIViewController 

@property(nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property(nonatomic, strong) NSManagedObject *managedObject;
@property(nonatomic, strong) NSString *keyString;

@end

@interface PaddingTextField : UITextField

@end