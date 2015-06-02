//
//  XCFrameworkPath.m
//  CrasheyePluginXcode
//
//  Created by Gang.Wang on 5/5/15.
//  Copyright (c) 2015 Gang.Wang. All rights reserved.
//

#import "XCFrameworkPath.h"

@implementation XCFrameworkPath

static const NSString* SDK_PATH = @"/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk";

+ (NSString*)eventKitUIPath
{
    return [SDK_PATH stringByAppendingPathComponent:@"/System/Library/Frameworks/EventKitUI.framework"];
}

+ (NSString*)coreMidiPath
{
    return [SDK_PATH stringByAppendingPathComponent:@"/System/Library/Frameworks/CoreMIDI.framework"];
}

+ (NSString*)libzDylibPath
{
    return [SDK_PATH stringByAppendingPathComponent:@"/usr/lib/libz.dylib"];
}

@end
