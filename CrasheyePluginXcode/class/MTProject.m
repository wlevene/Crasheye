//
//  MTProject.m
//  CrasheyePluginXcode
//
//  Created by Gang.Wang on 5/4/15.
//  Copyright (c) 2015 Gang.Wang. All rights reserved.
//

#import "MTProject.h"
#import <objc/runtime.h>

#import "MTPWorkspaceManager.h"

@implementation MTProject


+ (instancetype)projectForKeyWindow
{
    id workspace = [MTPWorkspaceManager workspaceForKeyWindow];
    
    id contextManager = [workspace valueForKey:@"_runContextManager"];
    for (id scheme in [contextManager valueForKey:@"runContexts"]) {
        NSString* schemeName = [scheme valueForKey:@"name"];
        if (![schemeName hasPrefix:@"Pods-"]) {
            NSLog(@">>>:%@", schemeName);
            NSString* path = [MTPWorkspaceManager directoryPathForWorkspace:workspace];
            return [[MTProject alloc] initWithName:schemeName path:path];
        }
    }
    
    return nil;
}

- (id)initWithName:(NSString*)name path:(NSString*)path
{
    if (self = [self init]) {
        NSLog(@"%@ %@", name, path);
        _projectName = name;
        _directoryPath = path;
        NSString* infoPath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@-Info.plist", _projectName, _projectName]];
        
        _infoDictionary = [NSDictionary dictionaryWithContentsOfFile:infoPath];
    }
    
    return self;
}

- (NSString *) projectFileDir
{
    return [NSString stringWithFormat:@"%@/%@.xcodeproj", self.directoryPath, self.projectName];
}

- (NSString *) projectFile
{
    return [NSString stringWithFormat:@"%@/%@.xcodeproj/project.pbxproj", self.directoryPath, self.projectName];
}

- (NSString*)workspacePath
{
    return [NSString stringWithFormat:@"%@/%@.xcworkspace", self.directoryPath, self.projectName];
}

- (BOOL)containsFileWithName:(NSString*)fileName
{
    NSString* filePath = [self.directoryPath stringByAppendingPathComponent:fileName];
    return [[NSFileManager defaultManager] fileExistsAtPath:filePath];
}

@end
