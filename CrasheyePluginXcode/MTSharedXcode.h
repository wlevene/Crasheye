//
//  MTSharedXcode.h
//  CrasheyePluginXcode
//
//  Created by Gang.Wang on 5/5/15.
//  Copyright (c) 2015 Gang.Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "xprivates.h"
#import <Cocoa/Cocoa.h>

@interface MTSharedXcode : NSObject

+ (id)currentEditor;
+ (IDEWorkspaceDocument *)workspaceDocument;
+ (IDESourceCodeDocument *)sourceCodeDocument;
+ (void)logSelection:(NSRange)range;

// IDE
+ (NSTextView *)textView;
+ (NSRange)charaterRangeFromSelectedRange:(NSRange)range;
// Edit
+ (void)replaceCharactersInRange:(NSRange)range withString:(NSString *)aString;
// Settings
+ (long long)tabWidth;
@end
