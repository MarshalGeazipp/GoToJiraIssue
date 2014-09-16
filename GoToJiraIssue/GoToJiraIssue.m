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
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"(MAMIOS|MMSNGR)-(\\d{1,4})"
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    NSArray *matches = [regex matchesInString:text
                                      options:0
                                        range:NSMakeRange(0, [text length])];
    
    if (matches.count) {
        for (NSTextCheckingResult *match in matches) {
            NSRange matchRange = [match range];
            NSString *issueStr = [text substringWithRange:matchRange];
//            NSLog(@"matchRange: %@", issueStr);
            [self openIssueInBrowser:issueStr];
        }
        return YES;
    }
    else {
        return NO;
    }
}

- (void)openIssueInBrowser:(NSString *)issueStr
{
    NSURL *issueUrl = [NSURL URLWithString:[NSString stringWithFormat:@"https://dev-jira.1and1.org/browse/%@", issueStr]];
    [[NSWorkspace sharedWorkspace] performSelector:@selector(openURL:) withObject:issueUrl afterDelay:0.1];
}

@end
