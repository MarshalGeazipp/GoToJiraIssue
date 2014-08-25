//
//  GoToJiraIssue.m
//  GoToJiraIssue
//
//  Created by Sebastian Obermüller on 11.08.14.
//    Copyright (c) 2014 1und1. All rights reserved.
//

#import "GoToJiraIssue.h"

static GoToJiraIssue *sharedPlugin;

@interface GoToJiraIssue()

@property (nonatomic, strong) NSBundle *bundle;
@end


@implementation GoToJiraIssue

+ (void)pluginDidLoad:(NSBundle *)plugin
{
    static dispatch_once_t onceToken;
    NSString *currentApplicationName = [[NSBundle mainBundle] infoDictionary][@"CFBundleName"];
    if ([currentApplicationName isEqual:@"Xcode"]) {
        dispatch_once(&onceToken, ^{
            sharedPlugin = [[self alloc] initWithBundle:plugin];
        });
    }
}

- (id)initWithBundle:(NSBundle *)plugin
{
    if (self = [super init]) {
        // reference to plugin's bundle, for resource acccess
        self.bundle = plugin;
        
        [self registerClickListener];
    }

    return self;
}

- (void)registerClickListener
{
	[NSEvent addLocalMonitorForEventsMatchingMask:NSLeftMouseDownMask handler:^(NSEvent *event) {
        
		NSView *view = [[event.window contentView] hitTest:[event locationInWindow]];

		while (view != nil) {
            if ([view isMemberOfClass:NSClassFromString(@"NSTextField")] && [[view superview] isMemberOfClass:NSClassFromString(@"IDESourceControlLogItemView")]) {
                NSLog(@"found the log textfield!");
                NSTextField *tf = (NSTextField *)view;
                if ([self findIssueInText:tf.stringValue]) {
                    return event;
                }
            }
			view = [view superview];
		}
		return event;
	}];
}

- (BOOL)findIssueInText:(NSString *)text
{
    NSRange range = [text rangeOfString:@"MAMIOS-" options:NSCaseInsensitiveSearch];
    if (range.location != NSNotFound) {
        NSString *issueStr = [text substringWithRange:NSMakeRange(range.location, range.length+4)];
        // strip off whitespace and newlines
        issueStr = [issueStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        // validate the found string
        NSString *lastCharacter = [issueStr substringFromIndex:issueStr.length-1];
        if ([lastCharacter isEqualToString:@":"] || [lastCharacter isEqualToString:@"\""]) {
            issueStr = [issueStr substringToIndex:issueStr.length-1];
        }
        NSURL *issueUrl = [NSURL URLWithString:[NSString stringWithFormat:@"https://dev-jira.1and1.org/browse/%@", issueStr]];
        [[NSWorkspace sharedWorkspace] openURL:issueUrl];
        return YES;
    }
    return NO;
}

@end
