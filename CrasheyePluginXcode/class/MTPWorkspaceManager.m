//
//  MTPWorkspaceManager.m
//  CrasheyePluginXcode
//
//  Created by Gang.Wang on 5/4/15.
//  Copyright (c) 2015 Gang.Wang. All rights reserved.
//

#import "MTPWorkspaceManager.h"

#import "MTProject.h"
#import "MTCodeConsole.h"

@implementation MTPWorkspaceManager


static NSString* const PODFILE = @"Podfile";

+ (NSArray*)installedPodNamesInCurrentWorkspace
{
    NSMutableArray* names = [NSMutableArray new];
    id workspace = [self workspaceForKeyWindow];
    
    id contextManager = [workspace valueForKey:@"_runContextManager"];
    for (id scheme in [contextManager valueForKey:@"runContexts"]) {
        NSString* schemeName = [scheme valueForKey:@"name"];
        if ([schemeName hasPrefix:@"Pods-"]) {
            [names addObject:[schemeName stringByReplacingOccurrencesOfString:@"Pods-" withString:@""]];
        }
    }
    return names;
}

+ (NSString*)currentWorkspaceDirectoryPath
{
    return [self directoryPathForWorkspace:[self workspaceForKeyWindow]];
}

+ (NSString*)directoryPathForWorkspace:(id)workspace
{
    NSString* workspacePath = [[workspace valueForKey:@"representingFilePath"] valueForKey:@"_pathString"];
    return [workspacePath stringByDeletingLastPathComponent];
}

#pragma mark - Private

+ (id)workspaceForKeyWindow
{
    return [self workspaceForWindow:[NSApp keyWindow]];
}

+ (id)workspaceForWindow:(NSWindow*)window
{
    NSArray* workspaceWindowControllers = [NSClassFromString(@"IDEWorkspaceWindowController") valueForKey:@"workspaceWindowControllers"];
    
    for (id controller in workspaceWindowControllers) {
        if ([[controller valueForKey:@"window"] isEqual:window]) {
            return [controller valueForKey:@"_workspace"];
        }
    }
    return nil;
}

@end
