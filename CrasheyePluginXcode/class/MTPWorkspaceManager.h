//
//  MTPWorkspaceManager.h
//  CrasheyePluginXcode
//
//  Created by Gang.Wang on 5/4/15.
//  Copyright (c) 2015 Gang.Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTPWorkspaceManager : NSObject

+ (id)workspaceForKeyWindow;

+ (NSArray*)installedPodNamesInCurrentWorkspace;

+ (NSString*)currentWorkspaceDirectoryPath;

+ (NSString*)directoryPathForWorkspace:(id)workspace;

@end
