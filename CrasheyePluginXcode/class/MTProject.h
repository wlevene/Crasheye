//
//  MTProject.h
//  CrasheyePluginXcode
//
//  Created by Gang.Wang on 5/4/15.
//  Copyright (c) 2015 Gang.Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTProject : NSObject

@property (nonatomic, copy, readonly) NSString* directoryPath;
@property (nonatomic, copy, readonly) NSString* projectName;
@property (nonatomic, copy, readonly) NSDictionary* infoDictionary;
@property (nonatomic, readonly) NSString* workspacePath;

@property (nonatomic, copy, readonly) NSString* projectFile;
@property (nonatomic, copy, readonly) NSString* projectFileDir;

+ (instancetype)projectForKeyWindow;

- (id)initWithName:(NSString*)name path:(NSString*)path;


- (BOOL)containsFileWithName:(NSString*)fileName;

@end
