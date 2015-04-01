//
//  GTJSettingPaneWindowController.m
//  GoToJiraIssue
//
//  Created by Jason Bandy on 4/1/15.
//  Copyright (c) 2015 1und1. All rights reserved.
//

#import "GTJSettingPaneWindowController.h"
#import "GTJSettingManager.h"

@interface GTJSettingPaneWindowController () <NSTextFieldDelegate>
@property (strong) IBOutlet NSTextField *tfHostName;

@end

@implementation GTJSettingPaneWindowController

- (void)windowDidLoad {
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    NSString *currentHostString = [GTJSettingManager retrieveSettingForKey:kJiraHostKey];
    [self.tfHostName setStringValue:currentHostString];
    self.tfHostName.delegate = self;

}


#pragma mark - NSTextFieldDelegate
-(BOOL)control:(NSControl *)control textShouldEndEditing:(NSText *)fieldEditor {
    if (control == self.tfHostName) {
        if (self.tfHostName.stringValue.length == 0) {
            [self.tfHostName setStringValue:[GTJSettingManager retrieveSettingForKey:kJiraHostKey]];
        }
    }
    return YES;
}

-(void)controlTextDidChange:(NSNotification *)notification {
    if ([notification object] == self.tfHostName) {
        [GTJSettingManager setSettingWithStringKey:kJiraHostKey andValue:self.tfHostName.stringValue];
    }
}

@end
