//
//  GTJSettingManager.h
//  GoToJiraIssue
//
//  Created by Jason Bandy on 4/1/15.
//  Copyright (c) 2015 1und1. All rights reserved.
//

#import <Foundation/Foundation.h>
extern NSString *const kJiraHostKey;

@interface GTJSettingManager : NSObject

+(NSString*)retrieveSettingForKey:(NSString*)key;
+(void)setSettingWithStringKey:(NSString*)key andValue:(id)value;

@end
