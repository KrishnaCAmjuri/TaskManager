//
//  Task+CoreDataProperties.m
//  TaskManagerIOS
//
//  Created by KrishnaChaitanya Amjuri on 27/04/16.
//  Copyright © 2016 KrishnaChaitanya Amjuri. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Task+CoreDataProperties.h"

@implementation Task (CoreDataProperties)

@dynamic dueDate;
@dynamic isOverdue;
@dynamic priority;
@dynamic text;
@dynamic location;

@end
