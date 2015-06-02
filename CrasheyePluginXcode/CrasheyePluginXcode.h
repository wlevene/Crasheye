//
//  CrasheyePluginXcode.h
//  CrasheyePluginXcode
//
//  Created by Gang.Wang on 5/4/15.
//  Copyright (c) 2015 Gang.Wang. All rights reserved.
//

#import <AppKit/AppKit.h>

@interface CrasheyePluginXcode : NSObject

+ (instancetype)sharedPlugin;

@property (nonatomic, strong, readonly) NSBundle* bundle;
@end



/*
 1
 ^@interface (\S+)\s*:\s*UIResponder\s*<UIApplicationDelegate>
 
 
 
 */