//
//  GTJSettingManager.m
//  GoToJiraIssue
//
//  Created by Jason Bandy on 4/1/15.
//  Copyright (c) 2015 1und1. All rights reserved.
//

#import "GTJSettingManager.h"

NSString *const kJiraHostKey = @"oneandone.GoToJiraIssue.JiraHostKey";

NSString *const kJiraHostDefaultValue = @"https://dev-jira.1and1.org";

@implementation GTJSettingManager


+(NSString*)retrieveSettingForKey:(NSString*)key{
    NSString *returnValue = @"";
    if (key.length == 0) {
        return nil;
    }
    returnValue = [[NSUserDefaults standardUserDefaults]objectForKey:key];
    if (returnValue.length == 0) {
        returnValue = kJiraHostDefaultValue;
    }
    return returnValue;
}

+(void)setSettingWithStringKey:(NSString*)key andValue:(id)value{
    if (key.length == 0) {
        return;
    } else {
        if ([value isKindOfClass:[NSString class]]) {
            if ([(NSString*)value length]==0) {
                value = kJiraHostDefaultValue;
            }
        }
        [[NSUserDefaults standardUserDefaults]setObject:value forKey:key];
    }
}

@end
