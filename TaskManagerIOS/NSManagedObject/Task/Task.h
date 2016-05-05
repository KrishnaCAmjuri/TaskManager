//
//  Task.h
//  TaskManagerIOS
//
//  Created by KrishnaChaitanya Amjuri on 27/04/16.
//  Copyright © 2016 KrishnaChaitanya Amjuri. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface Task : NSManagedObject

// Insert code here to declare functionality of your managed object subclass
- (NSNumber *)isOverdue;

@end

NS_ASSUME_NONNULL_END

#import "Task+CoreDataProperties.h"
