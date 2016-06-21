//
//  XCFrameworkPath.h
//  CrasheyePluginXcode
//
//  Created by Gang.Wang on 5/5/15.
//  Copyright (c) 2015 Gang.Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XCFrameworkPath : NSObject

+ (NSString*)eventKitUIPath;
+ (NSString*)coreMidiPath;
+ (NSString*)libzDylibPath;
+ (NSString*)libcplusplusDylibPath;

@end
