//
//  MTCodeConsole.h
//  CrasheyePluginXcode
//
//  Created by Gang.Wang on 5/4/15.
//  Copyright (c) 2015 Gang.Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

@interface MTCodeConsole : NSObject

+ (instancetype)consoleForKeyWindow;

- (void)appendText:(NSString*)text;
- (void)appendText:(NSString*)text color:(NSColor*)color;

- (void) replaceCharactersInRange:(NSRange)range withString:(NSString *)attrString;


- (void)log:(id)obj;
- (void)error:(id)obj;

@end
