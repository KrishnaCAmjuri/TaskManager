//
//  Task.m
//  TaskManagerIOS
//
//  Created by KrishnaChaitanya Amjuri on 27/04/16.
//  Copyright © 2016 KrishnaChaitanya Amjuri. All rights reserved.
//

#import "Task.h"

#define TASKS_ERROR_DOMAIN                                          @"com.wrox.tasks"
#define DUEDATE_VALIDATION_ERROR_CODE                               1001
#define PRIORITY_DUEDATE_VALIDATION_ERROR_CODE                      1002

@implementation Task

// Insert code here to add functionality to your managed object subclass

- (NSNumber *)isOverdue {
    
    BOOL isTaskOverdue = NO;
    
    NSDate *todaysDate = [NSDate date];
    
    if (self.dueDate != nil) {
        if ([self.dueDate compare:todaysDate] == NSOrderedAscending) {
            isTaskOverdue = YES;
        }
    }
    
    return [NSNumber numberWithBool:isTaskOverdue];
}

- (void)awakeFromInsert {
    [super awakeFromInsert];
    
    NSDate *defaultDate = [[NSDate alloc] initWithTimeIntervalSinceNow:60*60*24*3];
    self.dueDate = defaultDate;
}

- (BOOL)validateDueDate: (id *)ioValue error:(NSError **)outError {
    
    if ([*ioValue compare:[NSDate date]] == NSOrderedAscending) {
        
        if (outError != NULL) {
            NSString *errorStr = @"Due date must be today or later";
            NSDictionary *userInfoDictionary = [NSDictionary dictionaryWithObject:errorStr forKey:@"ErrorString"];
            NSError *error = [[NSError alloc] initWithDomain:TASKS_ERROR_DOMAIN code:DUEDATE_VALIDATION_ERROR_CODE userInfo:userInfoDictionary];
            
            *outError = error;
        }
        
        return NO;
    }
    
    return YES;
}

//- (BOOL)validateAllData: (NSError **)outError
//{
//    NSDate *compareDate = [[NSDate alloc] initWithTimeIntervalSinceNow:3600*24*3];
//    
//    if ([self.dueDate compare:compareDate] == NSOrderedDescending && [self.priority intValue] == 3) {
//        if (outError != NULL) {
//            NSString *errorStr = @"Hi-Pri Tasks must have a due date within 2 days of today";
//            NSDictionary *userInfoDictionary = [NSDictionary dictionaryWithObject:errorStr forKey:@"ErrorString"];
//            
//            NSError *error = [[NSError alloc] initWithDomain:TASKS_ERROR_DOMAIN code:PRIORITY_DUEDATE_VALIDATION_ERROR_CODE userInfo:userInfoDictionary];
//            *outError = error;
//        }
//        return NO;
//    }
//    
//    return YES;
//}
//
//- (BOOL)validateForInsert:(NSError * _Nullable __autoreleasing *)error
//{
//    if ([super validateForInsert:error] == NO) {
//        return NO;
//    }
//    
//    if ([self validateAllData:error] == NO) {
//        return NO;
//    }
//    
//    return YES;
//}
//
//- (BOOL)validateForUpdate:(NSError * _Nullable __autoreleasing *)error
//{
//    if ([super validateForUpdate:error]) {
//        return NO;
//    }
//    
//    if ([self validateAllData:error]) {
//        return NO;
//    }
//    
//    return YES;
//}

@end








