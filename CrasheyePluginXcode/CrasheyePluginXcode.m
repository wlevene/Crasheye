//
//  CrasheyePluginXcode.m
//  CrasheyePluginXcode
//
//  Created by Gang.Wang on 5/4/15.
//  Copyright (c) 2015 Gang.Wang. All rights reserved.
//

#import "CrasheyePluginXcode.h"
#import "MTProject.h"


#import "XCProject.h"
#import "XCTarget.h"
#import "XCProjectBuildConfig.h"
#import "XCGroup.h"
#import "XCSourceFileDefinition.h"
#import "XCFrameworkDefinition.h"
#import "XCFrameworkPath.h"
#import "XCProject+SubProject.h"
#import "XCSourceFile.h"
#import "MTSharedXcode.h"

#import "MTCodeConsole.h"
#import "NSArray+NSArrayExtension.h"
#import "JSONKit.h"

#import "ZZArchive.h"
#import "ZZArchiveEntry.h"
#import "NSAlert+BlockMethods.h"
#import "RegexKitLite.h"


@class XCProjectBuildConfig;

static CrasheyePluginXcode *sharedPlugin;

@interface CrasheyePluginXcode()

@property (nonatomic, strong, readwrite) NSBundle *bundle;
@property (nonatomic, strong, readwrite) MTProject * mProject;

@property (retain) MTCodeConsole* xcodeConsole;

@property(nonatomic, assign) BOOL installHeader;
@property(nonatomic, assign)  BOOL installALib;

@property (nonatomic, strong, readwrite) NSString * CrasheyeSdkDownloadUrl;
@property (nonatomic, strong, readwrite) NSString * CrasheyeSdkCurrentVersion;


@property (nonatomic, strong, readwrite) NSString * CrasheyeSdkNewVersion;

@property (nonatomic, strong, readwrite) NSData * headerFileData;
@property (nonatomic, strong, readwrite) NSData * libFileData;

@end

@implementation CrasheyePluginXcode


+ (void)pluginDidLoad:(NSBundle *)plugin
{
    NSLog(@"Hello World CrasheyePluginXcode");
    static dispatch_once_t onceToken;
    NSString *currentApplicationName = [[NSBundle mainBundle] infoDictionary][@"CFBundleName"];
    if ([currentApplicationName isEqual:@"Xcode"]) {
        dispatch_once(&onceToken, ^{
            sharedPlugin = [[self alloc] initWithBundle:plugin];
        });
    }
    
}

+ (instancetype)sharedPlugin
{
    return sharedPlugin;
}

- (id)init
{
    if (self = [super init])
    {
        [[NSNotificationCenter defaultCenter]
         addObserver:self
         selector:@selector(applicationDidFinishLaunching:)
         name:NSApplicationDidFinishLaunchingNotification
         object:nil];
    }
    return self;
}


- (void)applicationDidFinishLaunching:(NSNotification *)notification
{
    self.mProject = [MTProject projectForKeyWindow];
    self.xcodeConsole = [MTCodeConsole consoleForKeyWindow];
}


- (id)initWithBundle:(NSBundle *)plugin
{
    if (self = [super init]) {
        // reference to plugin's bundle, for resource access
        
        
        self.bundle = plugin;
        
        // Create menu items, initialize UI, etc.
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self addMenuItems];
        }];
        
        // Sample Menu Item:
//        NSMenuItem *menuItem = [[NSApp mainMenu] itemWithTitle:@"Product"];
        
        
        
    }
    return self;
}

- (void)addMenuItems
{
    
    NSMenuItem* topMenuItem = [[NSApp mainMenu] itemWithTitle:@"Product"];
    
    NSLog(@"setup menu...%@",topMenuItem);
    if (topMenuItem) {
        NSLog(@"setup menu...1");
        [[topMenuItem submenu] addItem:[NSMenuItem separatorItem]];
        
        NSMenu *crasheyeMenu = [[NSMenu alloc] initWithTitle:@"Crasheye"];
        
        
        
        NSMenuItem *installMenuItem = [[NSMenuItem alloc] initWithTitle:@"Install & Update" action:@selector(doInstall) keyEquivalent:@""];
        //            NSMenuItem *loginMenuItem = [[NSMenuItem alloc] initWithTitle:@"[Crasheye]-Login" action:@selector(doCrasheye) keyEquivalent:@""];
        
        NSMenuItem *crasheyePage = [[NSMenuItem alloc] initWithTitle:@"www.crasheye.cn" action:@selector(visitHomePage) keyEquivalent:@""];
        
        NSMenuItem *aboutMenuItem = [[NSMenuItem alloc] initWithTitle:@"About" action:@selector(doAbout) keyEquivalent:@""];
        
        [installMenuItem setTarget:self];
        [crasheyePage setTarget:self];
        [aboutMenuItem setTarget:self];
        
        [crasheyeMenu addItem:installMenuItem];
        [crasheyeMenu addItem:[NSMenuItem separatorItem]];
        [crasheyeMenu addItem:crasheyePage];
        [crasheyeMenu addItem:aboutMenuItem];
        
        NSMenuItem *crasheyeMenuMenuItem = [[NSMenuItem alloc] initWithTitle:@"Crasheye" action:nil keyEquivalent:@""];
        [crasheyeMenuMenuItem setSubmenu:crasheyeMenu];
        [[topMenuItem submenu] addItem:crasheyeMenuMenuItem];
        
    }
}


+ (void)highlightItem:(int)line inTextView:(NSTextView*)textView
{
    NSUInteger lineNumber = line - 1;
    NSString* text = [textView string];
    
    NSRegularExpression* re =
    [NSRegularExpression regularExpressionWithPattern:@"\n"
                                              options:0
                                                error:nil];
    
    NSArray* result = [re matchesInString:text
                                  options:NSMatchingReportCompletion
                                    range:NSMakeRange(0, text.length)];
    
    if (result.count <= lineNumber) {
        return;
    }
    
    NSUInteger location = 0;
    NSTextCheckingResult* aim = result[lineNumber];
    location = aim.range.location;
    
    NSRange range = [text lineRangeForRange:NSMakeRange(location, 0)];
    
    [textView scrollRangeToVisible:range];
    
    [textView setSelectedRange:range];
}




#pragma mark - Menu Actions

- (void) visitHomePage
{
    NSURL* docsetURL = [NSURL URLWithString:@"http://reops.crasheye.cn/api/sdk/plugin/ios/toweb"];
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:docsetURL]
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse* response, NSData* xarData, NSError* connectionError) {
                           }
     ];
    
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://www.crasheye.cn"]];
}

- (void) doAbout
{
    
   
    NSAlert *alert = [[NSAlert alloc] init];
    [alert setMessageText:@"Crasheye"];
    [alert setInformativeText:@"welcome!"];
    [alert setAlertStyle:NSWarningAlertStyle];
    [alert runModal];
    return;
//    [self.xcodeConsole appendText:[self progressString:0]];
//    
//    for (int i = 0; i <= 10; i++)
//    {
//        [self performSelector:@selector(printfDownloadProgress1:) withObject:[NSNumber numberWithInt:i * 10] afterDelay:i];
//    }
}

-(void) printfDownloadProgress1:(NSNumber *) progress
{
    [self printfDownloadProgress:[progress intValue]];
}

-(NSString *) progressString:(int) progress
{
    int logLen = 11;
    
    int numberOfTen = 5;
    NSString * stringOfTen = @"          ";
    
    NSMutableString * flag = [NSMutableString stringWithString:@""];
    for(int i=0; i < numberOfTen ; i++) {
        flag = [NSMutableString stringWithFormat:@"%@%@", flag, stringOfTen];
    }
    
    
    logLen += [flag length];
    
    int v = (int)((float)progress / 10 * numberOfTen + 0.5);
    
    for(int i=0; i < v ; i++)
    {
        [flag replaceCharactersInRange:NSMakeRange(i, 1) withString:@"="];
    }
    
    
    NSString * log = [NSString stringWithFormat:@"[%3d:%@][100]", progress, flag];
    return log;
}

-(void) printfDownloadProgress:(int) progress
{
    NSString * log = [self progressString:progress];
    int logLen = (int)[log length];
    [self.xcodeConsole replaceCharactersInRange: NSMakeRange(0, logLen) withString:log];
}

- (void) clearOldFile
{
    XCProject* project = [[XCProject alloc] initWithFilePath:self.mProject.projectFileDir];

    NSArray * groups =[project groups];
    
    BOOL hasCrasheyeGroup = NO;
    for (XCGroup* group in groups)
    {
        if ([[group alias] isEqualToString:@"Crasheye"])
        {
            hasCrasheyeGroup = YES;
        }
    }
    
    if (!hasCrasheyeGroup)
    {
        NSArray * allfiles = [project files];
        for (XCSourceFile * file in allfiles)
        {
            NSString * fileName = [file name];
            //        NSLog(@"fileName:%@", fileName);
            
            if (fileName == nil ||
                [fileName length] <=0)
            {
                continue;
            }
            
            NSString * fullPath = [self.mProject.directoryPath stringByAppendingPathComponent:[file pathRelativeToProjectRoot]];
            
            if (fileName != nil &&
                [fileName containsString:@"Crasheye"])
            {
                if ([fileName hasSuffix:@"Crasheye.h"])
                {
                    
                    if ([[NSFileManager defaultManager] fileExistsAtPath:fullPath])
                    {
                        [[NSFileManager defaultManager] removeItemAtPath:fullPath error:nil];
                    }
                    
//                    NSString* productsGroupKey = [project productsGroupKeyForKey:[file key]];

                    
//                    NSLog(@"dsfsdfsdf:%@", [file key]);

                    [[project objects] removeObjectForKey:[file key]];
//                    [project removeFromProjectReferences:[file key] forProductsGroup:productsGroupKey];

//                    for (XCTarget* target in [project targets])
//                    {
//                        [target removeMemberWithKey:[file key]];
//                    }
                    
                    continue;
                }
                
                if ([fileName hasSuffix:@"libCrasheye.a"])
                {
                    if ([[NSFileManager defaultManager] fileExistsAtPath:fullPath])
                    {
                        [[NSFileManager defaultManager] removeItemAtPath:fullPath error:nil];
                    }
                     [[project objects] removeObjectForKey:[file key]];
//                    [[project objects] removeObjectForKey:[file buildFileKey]];
                    continue;
                }
            }
        }
    }
    
    [project save];

}

-(void) installPot
{
    NSURL* docsetURL = [NSURL URLWithString:@"http://reops.crasheye.cn/api/sdk/plugin/ios/install"];
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:docsetURL]
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse* response, NSData* xarData, NSError* connectionError) {
                           }
     ];
}


- (void) doInstall {
    
 
//    NSLog(@"ProjectName:%@", self.mProject.projectName);
//    NSLog(@"Workspace:%@", self.mProject.workspacePath);
//    NSLog(@"Project File:%@", self.mProject.projectFile);
//    NSLog(@"Installed Crasheye: %d",  [self.mProject hasCrasheyefile]);
    
    [self installPot];
    
    self.mProject = [MTProject projectForKeyWindow];
    self.xcodeConsole = [MTCodeConsole consoleForKeyWindow];
    
    if (self.mProject == nil)
    {
        return;
    }
    
    NSString * projectFile = self.mProject.projectFile;
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:projectFile])
    {
        [self.xcodeConsole appendText:@"Can not Auto Install & Update Crasheye SDK, Please Install & Update Creasheye SDK by manual\n"];
        return;
    }
    
    
    [self.xcodeConsole appendText:@"\n-------------------- Crasheye Xcode Plugin © --------------------\n"
                            color:[NSColor brownColor]];
    [self.xcodeConsole appendText:[NSString stringWithFormat:@"Begin install Crasheye SDK to \"%@\" project\n", self.mProject.projectName]];
    
    
    BOOL installed = [self isInstallCrasheye];
    
        [self downloadCrashSDKConfig:^{
          
            if (!installed ||
                (self.CrasheyeSdkCurrentVersion != self.CrasheyeSdkNewVersion))
            {
                if (!installed)
                {
                    self.mProject = [MTProject projectForKeyWindow];
                    self.xcodeConsole = [MTCodeConsole consoleForKeyWindow];
                    [self clearOldFile];
                }
                
                NSString * info = [NSString stringWithFormat:@"There is new version (%@) for Crasheye, Do you want to Install & Update now?", self.CrasheyeSdkNewVersion];
                
                NSAlert *alert = [NSAlert alertWithMessageText: @"Do you want to update Crasheye?"
                                                 defaultButton: @"Install & Update"
                                               alternateButton: @"Don't Install & Update"
                                                   otherButton: @"Cancel"
                                     informativeTextWithFormat: info];
                
                [alert compatibleBeginSheetModalForWindow: [NSApp keyWindow] completionHandler: ^(NSInteger returnCode){
                    if (returnCode == NSAlertDefaultReturn ) {
                        [self downloadCrashSDK:^{
                            [self configProjectBuildSetting];
////
                            [self addCrasheyeCodeToAppDelegateFile];
                            
                        
                            [self.xcodeConsole appendText:@"End install Crasheye SDK\n"];
                            [self.xcodeConsole appendText:@"-------------------- Crasheye Xcode Plugin © --------------------\n"];
                        }];
                    }
                    else if (returnCode == NSAlertAlternateReturn) {
                        
                        [self configProjectBuildSetting];
                        
                        [self.xcodeConsole appendText:@"User do not Install Crasheye SDK\n"];
                        [self.xcodeConsole appendText:@"-------------------- Crasheye Xcode Plugin © --------------------\n"];
                    }
                    else if (returnCode == NSAlertOtherReturn) {
                        [self.xcodeConsole appendText:@"User Canceled Install Crasheye SDK\n"];
                        [self.xcodeConsole appendText:@"-------------------- Crasheye Xcode Plugin © --------------------\n"];
                    }
                }];
            }
            
            
            if (self.CrasheyeSdkNewVersion == nil ||
                [self.CrasheyeSdkNewVersion length] <= 0 ||
                ([self.CrasheyeSdkCurrentVersion isEqualToString:self.CrasheyeSdkNewVersion]))
            {
                [self configProjectBuildSetting];
                [self addCrasheyeCodeToAppDelegateFile];
                
                [self.xcodeConsole appendText:@"Crasheye is lastest version :) \n"];
                [self.xcodeConsole appendText:@"End install Crasheye SDK\n"];
                [self.xcodeConsole appendText:@"-------------------- Crasheye Xcode Plugin © --------------------\n"];
                return ;
            }
            
        }];
}


- (void) configProjectBuildSetting
{
    XCProject* project = [[XCProject alloc] initWithFilePath:self.mProject.projectFileDir];
    [self.xcodeConsole appendText:@"Check & Repair Project Config:\n"];
    
    [self configOtherLinkerFlags:project];
    [self.xcodeConsole appendText:@"    1: Repair Project Build Config                              √\n"];
    
    [self addLibzAndcjiajiaToProject:project];
    [self.xcodeConsole appendText:@"    2: Repair libz & libc++ To Project                          √\n"];
    
    [self addCrashFileToProject:project];
    [self.xcodeConsole appendText:@"    3: Repair CrasheyeFiles To Project                          √\n"];
    
    
    [project save];
    
    [self addTransportSecurityInPlistFile];
    [self.xcodeConsole appendText:@"    4: Add TransportSecurity for rasheye.cn                     √\n"];
    [self.xcodeConsole appendText:@"Check & Repair Project Config Finish                            √\n"];
}


- (void) addTransportSecurityInPlistFile
{
    
    XCProject* project = [[XCProject alloc] initWithFilePath:self.mProject.projectFileDir];
    
    NSArray * allfiles = [project files];
    
    NSString * plistFile = nil;
    for (XCSourceFile * file in allfiles)
    {
        NSString * fileName = [file name];
//        NSLog(@"Crasheye fileName:%@", fileName);
        
        if (fileName == nil ||
            [fileName length] <=0)
        {
            continue;
        }
        
        
        NSString * fullPath = [self.mProject.directoryPath stringByAppendingPathComponent:[file pathRelativeToProjectRoot]];
        
        if ([fullPath containsString:@"UITests"]) {
            continue;
        }
        
        if (fileName != nil &&
            [fileName isEqualToString:@"Info.plist"])
        {
            plistFile = fullPath;
            NSLog(@"Crasheye xxx fileName:%@", fullPath);
            break;
        }
        
        
    }
    NSString *filePath = plistFile;
    NSMutableDictionary *plistdict = [NSMutableDictionary dictionaryWithContentsOfFile:filePath];
    
    NSMutableDictionary * NSAppTransportSecurity = [plistdict objectForKey:@"NSAppTransportSecurity"];
    if (NSAppTransportSecurity == nil) {
        NSAppTransportSecurity = [[NSMutableDictionary alloc] init];
    }
    
    
    NSMutableDictionary * NSExceptionDomains = [NSAppTransportSecurity objectForKey:@"NSExceptionDomains"];
    if (NSExceptionDomains == nil) {
        NSExceptionDomains = [[NSMutableDictionary alloc] init];
    }
    
    
    NSDictionary * crasheyDomain = @{@"NSExceptionAllowsInsecureHTTPLoads" : @YES,
                                            @"NSIncludesSubdomains": @YES};
    
    [NSExceptionDomains setObject:crasheyDomain forKey:@"crasheye.cn"];
    [NSAppTransportSecurity setObject:NSExceptionDomains forKey:@"NSExceptionDomains"];
    [plistdict setObject:NSAppTransportSecurity forKey:@"NSAppTransportSecurity"];
    
    
    [plistdict writeToFile:filePath atomically:YES];
    
}


- (void) addLibzAndcjiajiaToProject:(XCProject *) project
{
    XCGroup* group = [project groupWithPathFromRoot:nil];
    XCGroup * frameworksGroup = [group addGroupWithPath:@"Frameworks"];
    
    if (frameworksGroup == nil)
    {
        frameworksGroup = [project groupWithPathFromRoot:@"Frameworks"];
    }

    
    XCFrameworkDefinition* frameworkDefinition = [[XCFrameworkDefinition alloc] initWithFilePath:[XCFrameworkPath libzDylibPath] copyToDestination:NO];
    
    [frameworksGroup addFramework:frameworkDefinition toTargets:[project targets]];
    
    
    XCFrameworkDefinition* frameworkcPlusplus = [[XCFrameworkDefinition alloc] initWithFilePath:[XCFrameworkPath libcplusplusDylibPath] copyToDestination:NO];
    [frameworksGroup addFramework:frameworkcPlusplus toTargets:[project targets]];
}

- (void) addCrashFileToProject:(XCProject *) project
{
    
    XCGroup* group = nil;
    group = [project groupWithPathFromRoot:nil];
    
    if (!group)
    {
        NSArray * groups = [project rootGroups];
        
        if (groups != nil &&
            [groups count] == 1)
        {
            group = groups[0];
        }
    }
    
    if (!group) {
        return;
    }
    
    XCGroup * crasheyeGroup = [group addGroupWithPath:@"Crasheye"];
    
    if (crasheyeGroup == nil)
    {
        crasheyeGroup = [project groupWithPathFromRoot:@"Crasheye"];
    }
    
    NSString * crashDir = [self.mProject.directoryPath stringByAppendingPathComponent:@"Crasheye"];
//    NSString * aFile = [crashDir stringByAppendingPathComponent:@"libCrasheye.lib"];
//    NSString * hFile = [crashDir stringByAppendingPathComponent:@"Crasheye.header"];
    
    if (!self.installHeader && self.headerFileData != nil) {
        XCSourceFileDefinition * header = [[XCSourceFileDefinition alloc] initWithName:@"Crasheye.h" data:self.headerFileData type:SourceCodeHeader];
        
        [crasheyeGroup addSourceFile:header];
    }

    
    if (!self.installALib && self.libFileData != nil)
    {
//        XCFrameworkDefinition* frameworkDefinition = [[XCFrameworkDefinition alloc] initWithFilePath:aFile copyToDestination:NO];
//        [crasheyeGroup addFramework:frameworkDefinition];
        
        XCSourceFileDefinition* libFile = [[XCSourceFileDefinition alloc] initWithName:@"libCrasheye.a" data:self.libFileData type:Archive];
        [crasheyeGroup addSourceFile:libFile];
        
        XCSourceFile * libSourceFile = [project fileWithName:@"libCrasheye.a"];
        
        XCTarget* target = [project targetWithName:self.mProject.projectName];
       
        [target addMember:libSourceFile];
        for (NSString* configName in [target configurations])
        {
            XCProjectBuildConfig* configuration = [target configurationWithName:configName];
            NSMutableArray* headerPaths = [[NSMutableArray alloc] init];
            [headerPaths addObject:@"$(inherited)"];
            [headerPaths addObject:@"$(PROJECT_DIR)/Crasheye"];
            [configuration addOrReplaceSetting:headerPaths forKey:@"LIBRARY_SEARCH_PATHS"];
        }
    }
    
}

-(void) configOtherLinkerFlags:(XCProject *) project
{
    for (XCTarget* target in [project targets])
    {
        for (NSString* configName in [target configurations])
        {
            XCProjectBuildConfig* configuration = [target configurationWithName:configName];
            
            id oldlinkerFlags = [configuration valueForKey:@"OTHER_LDFLAGS"];
            
            NSMutableArray* linkerFlags = [[NSMutableArray alloc] init];
            
            if([oldlinkerFlags isKindOfClass:[NSArray class]])
            {
                [linkerFlags addObjectsFromArray:oldlinkerFlags];
                
            }
            else if ([oldlinkerFlags isKindOfClass:[NSString class]])
            {
                if (oldlinkerFlags != nil &&
                    [oldlinkerFlags length] > 0)
                {
                    [linkerFlags addObject:oldlinkerFlags];
                }
            }
            
            if (![linkerFlags containsObject:@"-licucore"])
            {
                [linkerFlags addObject:@"-licucore"];
            }
            
            if (![linkerFlags containsObject:@"-ObjC"])
            {
                [linkerFlags addObject:@"-ObjC"];
            }
            
            
            [configuration addOrReplaceSetting:linkerFlags forKey:@"OTHER_LDFLAGS"];
        }
    }
}

- (BOOL) isInstallCrasheye
{
    self.installHeader = NO;
    self.installALib = NO;
    
    XCProject* project = [[XCProject alloc] initWithFilePath:self.mProject.projectFileDir];
    
    NSArray * allfiles = [project files];
    for (XCSourceFile * file in allfiles)
    {
        NSString * fileName = [file name];
        //        NSLog(@"fileName:%@", fileName);
        
        if (fileName == nil ||
            [fileName length] <=0)
        {
            continue;
        }
        
        NSString * fullPath = [self.mProject.directoryPath stringByAppendingPathComponent:[file pathRelativeToProjectRoot]];
        
        if (fileName != nil &&
            [fileName containsString:@"Crasheye"])
        {
            NSLog(@"Check Crasheye is installed %@ %@", fileName, [file path]);
            if ([fileName hasSuffix:@"Crasheye.h"] &&
                [[NSFileManager defaultManager] fileExistsAtPath:fullPath])
            {
                
                if ([[NSFileManager defaultManager] fileExistsAtPath:fullPath isDirectory:nil])
                {
                    NSError * err = nil;
                    NSString * fileContext = [NSString stringWithContentsOfFile:fullPath encoding:NSUTF8StringEncoding error:&err];
                    if (err == nil)
                    {
                        NSArray * codesLineArray = [fileContext componentsSeparatedByString:@"\n"];
                        if (codesLineArray != nil &&
                            [codesLineArray count] > 0)
                        {
                            NSString * versionCode = codesLineArray[0];
                            
                            if (versionCode != nil &&
                                [versionCode length] > 0)
                            {
                                NSRange r_start = [versionCode rangeOfString:@"["];
                                NSRange r_end = [versionCode rangeOfString:@"]"];
                                
                                if (r_end.location > r_start.location)
                                {
                                    NSRange r = NSMakeRange(r_start.location + 1, r_end.location - r_start.location - 1);
                                    NSString * currentVersion = [versionCode substringWithRange:r];
                                    
                                    self.CrasheyeSdkCurrentVersion = currentVersion;
                                    NSLog(@"=======: %@", currentVersion);
                                }
                            }
                        }
                    }
                }
                
                self.installHeader = YES;
                continue;
            }
            
            if ([fileName hasSuffix:@"libCrasheye.a"] &&
                [[NSFileManager defaultManager] fileExistsAtPath:fullPath])
            {
                self.installALib = YES;
                continue;
            }
        }
    }
    
    return self.installHeader && self.installALib;
}

- (void) addCrasheyeCodeToAppDelegateFile
{
    XCProject* project = [[XCProject alloc] initWithFilePath:self.mProject.projectFileDir];
    NSArray * allfiles = [project files];
    for (XCSourceFile * file in allfiles)
    {
        NSString * fileName = [file name];
        if (fileName != nil)
        {
            if (![fileName isEqualToString:@"main.m"]) {
                continue;
            }
            
            NSString * headFullPath = nil;
            
            if ([file type] == SourceCodeObjC ||
                [file type] == SourceCodeObjCPlusPlus)
            {
                headFullPath = [self.mProject.directoryPath stringByAppendingPathComponent:[file pathRelativeToProjectRoot]];

                
                [self openMainCodeFile:headFullPath];
                
                return;
            }
        }
    }
}

- (void) openMainCodeFile:(NSString *) filePath
{
    id<NSApplicationDelegate> appDelegate = (id<NSApplicationDelegate>)[NSApp delegate];
    if ([appDelegate application:NSApp openFile:filePath])
    {
        [self performSelector:@selector(addCrasheyeCode:) withObject:filePath afterDelay:1];
    }
}

- (void) addCrasheyeCode:(NSString *) filePath
{
    
    NSError * err = nil;
    NSString * fileContent = [NSString stringWithContentsOfFile:filePath
                                                       encoding:NSUTF8StringEncoding
                                                          error:&err];
    if (err)
    {
        NSLog(@"err:%@", err);
        return;
    }

    
    if ( !fileContent ||
        [fileContent length] <= 0 )
        return;
    
    //    NSArray * codesLineArray = [fileContent componentsSeparatedByString:@"\n"];
    id<NSApplicationDelegate> appDelegate = (id<NSApplicationDelegate>)[NSApp delegate];
    if ([appDelegate application:NSApp openFile:filePath])
    {
        
        NSString * regStr = [NSString stringWithContentsOfFile:[[NSBundle bundleForClass:[self class]]
                                                                pathForResource:@"findmain"
                                                                ofType:@"reg"]
                                                      encoding:NSUTF8StringEncoding error:&err];
        
        
        NSLog(@"Crasheye  Add Code : %@",[fileContent stringByMatching:regStr]);
        NSRange entryFunRange = [fileContent rangeOfRegex:regStr];
        
        
        regStr = [NSString stringWithContentsOfFile:[[NSBundle bundleForClass:[self class]]
                                                     pathForResource:@"findfirstimport"
                                                     ofType:@"reg"]
                                           encoding:NSUTF8StringEncoding error:&err];
        
        NSRange firstImportRange = [fileContent rangeOfRegex:regStr];
        
        NSString * addHeaderCode = @"\n#import \"Crasheye.h\"\n";
    
    
        NSTextView * textView = [MTSharedXcode textView];
        if ( textView )
        {
            IDESourceCodeDocument * document = [MTSharedXcode sourceCodeDocument];
            if ( !document )
                return;
            
            [[document textStorage] beginEditing];
            
            if (entryFunRange.length == 0 &&
                entryFunRange.location >= LONG_MAX) {
                
            }else {
                if (![self isAddedImportCrasheyeInitCode:filePath])
                {
                   [[document textStorage] replaceCharactersInRange: NSMakeRange(entryFunRange.location + entryFunRange.length, 0) withString:@"\n    [Crasheye initWithAppKey:@\"<#Appkey #>\"];\n" withUndoManager:[document undoManager]];
                }
                
            }
            
            
            if (firstImportRange.length == 0 &&
                firstImportRange.location >= LONG_MAX) {
                
            }
            else
            {
                if (![self isAddedImportCrasheyeHeaderCode:filePath])
                {
                    [[document textStorage] replaceCharactersInRange: NSMakeRange(firstImportRange.location + firstImportRange.length, 0) withString:addHeaderCode withUndoManager:[document undoManager]];
                }
            }
            
            [[document textStorage] endEditing];
            
            [document saveDocument:nil];
            [CrasheyePluginXcode highlightItem:1 inTextView:[MTSharedXcode textView]];
        }
    }
}

-(BOOL) isAddedImportCrasheyeHeaderCode:(NSString *) filePath
{
    NSError * err = nil;
    NSString * hFileString = [NSString stringWithContentsOfFile:filePath
                                                       encoding:NSUTF8StringEncoding
                                                          error:&err];
    if (err)
    {
        NSLog(@"err:%@", err);
        return FALSE;
    }
    
    NSString * addHeaderCode = @"#import \"Crasheye.h\"";
    if (![hFileString containsString:addHeaderCode])
    {
        return FALSE;
    }
    
    return TRUE;
    
}


-(BOOL) isAddedImportCrasheyeInitCode:(NSString *) filePath
{
    NSError * err = nil;
    NSString * hFileString = [NSString stringWithContentsOfFile:filePath
                                                       encoding:NSUTF8StringEncoding
                                                          error:&err];
    if (err)
    {
        NSLog(@"err:%@", err);
        return FALSE;
    }
    
    NSString * addHeaderCode = @"Crasheye initWithAppKey";
    if (![hFileString containsString:addHeaderCode])
    {
        return FALSE;
    }
    
    return TRUE;
}


//
//- (void) addCrasheyeCodeToAppDelegateFile
//{
//    XCProject* project = [[XCProject alloc] initWithFilePath:self.mProject.projectFileDir];
//    NSArray * allfiles = [project files];
//    for (XCSourceFile * file in allfiles)
//    {
//        NSString * fileName = [file name];
//        if (fileName != nil)
//        {
//            NSString * headFullPath = nil;
//            
//            if ([file type] == SourceCodeObjC ||
//                [file type] == SourceCodeObjCPlusPlus)
//            {
//                headFullPath = [self.mProject.directoryPath stringByAppendingPathComponent:[file pathRelativeToProjectRoot]];
//                
//                NSError * err = nil;
//                NSString * hFileString = [NSString stringWithContentsOfFile:headFullPath
//                                                                   encoding:NSUTF8StringEncoding
//                                                                      error:&err];
//                if (err)
//                {
//                    NSLog(@"err:%@", err);
//                    continue;
//                }
//                
//                NSArray * codesLineArray = [hFileString componentsSeparatedByString:@"\n"];
//                
//                int line = 0;
//                BOOL findFun = NO;
//                int firstImportLine = 0;
//                BOOL kuohaoFind = NO;
//                for (NSString * lineCode in codesLineArray)
//                {
//                    line++;
//                    NSString * linCodeEx = [lineCode stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//                    
//                    if (findFun) {
//                        
//                        if (kuohaoFind) {
//                            break;
//                        }
//                        
//                        if (linCodeEx == nil ||
//                            [linCodeEx isEqualToString:@""])
//                        {
//                            continue;
//                        }
//                        
//                        if ([linCodeEx isEqualToString:@"{"])
//                        {
//                            break;
//                        }
//                    }
//                    
//                    if (firstImportLine == 0 &&
//                        [linCodeEx containsString:@"#import"])
//                    {
//                        firstImportLine = line;
//                    }
//
//                    
//                    // TODO... 规则可丰富
//                    if ([linCodeEx containsString:@"didFinishLaunchingWithOptions:(NSDictionary *)launchOptions"] ||
//                        [linCodeEx containsString:@"didFinishLaunchingWithOptions:(NSDictionary*)launchOptions"])
//                    {
//                        findFun = YES;
//                        if ([linCodeEx containsString:@"{"])
//                        {
//                            kuohaoFind = YES;
//                        }
//                    }
//                }
//                
//                if (!findFun)
//                {
//                    continue;
//                }
//                
//                NSString * addHeaderCode = @"#import \"Crasheye.h\"";
//                NSString * addCode = @"    [Crasheye initWithAppKey:@\"<#Appkey #>\"];";
//                NSMutableArray * newCodeArray = [NSMutableArray arrayWithArray:codesLineArray];
//                
//                if (![hFileString containsString:addHeaderCode])
//                {
//                    [newCodeArray insertObject:addHeaderCode atIndex:firstImportLine];
//                }
//                
//                if (![hFileString containsString:@"[Crasheye initWithAppKey:"])
//                {
//                    [newCodeArray insertObject:addCode atIndex:line];
//                }
//                
//                
//                NSString * newCodeString = [newCodeArray bondingAString:@"\n"];
//                
//                id<NSApplicationDelegate> appDelegate = (id<NSApplicationDelegate>)[NSApp delegate];
//                if ([appDelegate application:NSApp openFile:headFullPath])
//                {
//                    NSTextView * textView = [MTSharedXcode textView];
//                    if ( textView )
//                    {
//                        IDESourceCodeDocument * document = [MTSharedXcode sourceCodeDocument];
//                        if ( !document )
//                            return;
//                        
//                        [[
//                          document
//                          textStorage] beginEditing];
//                        
//                        //        [textView setString:@"123"];
//                        
//                        [[document textStorage] replaceCharactersInRange: NSMakeRange(0, textView.string.length) withString:newCodeString withUndoManager:[document undoManager]];
//                        
//                        [[document textStorage] endEditing];
//                        
//                        [document saveDocument:nil];
//                        
//                        
//                        int highlightline = (int)[newCodeArray indexOfObject:addCode];
//                        
//                        
//                        [CrasheyePluginXcode highlightItem:highlightline + 1 inTextView:[MTSharedXcode textView]];
//                        
//                        
//                        [self.xcodeConsole appendText:@"Add Crash Code √\n"];
//                        return;
//                    }
//                }
//            }
//        }
//    }
//}


// Sample Action, for menu item:

-(void) updateCrasheye
{
//    NSURL* docsetURL = [NSURL URLWithString:[NSString stringWithFormat:DOCSET_ARCHIVE_FORMAT, podName]];
//    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:docsetURL]
//                                       queue:[NSOperationQueue mainQueue]
//                           completionHandler:^(NSURLResponse* response, NSData* xarData, NSError* connectionError) {
//                               if (xarData) {
//                                   NSString* fileName = [NSString stringWithFormat:@"%@.xar", podName];
//                                   NSString *tmpFilePath = [NSString pathWithComponents:@[NSTemporaryDirectory(), fileName]];
//                                   [xarData writeToFile:tmpFilePath atomically:YES];
//                                   [self extractAndInstallDocsAtPath:tmpFilePath];
//                               }
}

- (void) downloadCrashSDKConfig:(void (^)()) handler
{
    NSURL* docsetURL = [NSURL URLWithString:@"http://www.crasheye.cn/api/sdk/ios"];
    
    
    [self.xcodeConsole appendText:@"Checking for updates...\n"];
    
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:docsetURL] queue:[NSOperationQueue mainQueue]  completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError)
        {
            [self.xcodeConsole appendText:[NSString stringWithFormat:@":( check Crasheye new version Failed:%@", connectionError]];
            self.CrasheyeSdkNewVersion = nil;
            self.CrasheyeSdkDownloadUrl = nil;
        }
        else
        {
            if (data)
            {
                NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                NSData* jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
                
                if (!jsonData)
                {
                    handler();
                    return;
                }
                
                NSDictionary * jsonDic = [jsonData objectFromJSONData];
                
                NSDictionary * result = [jsonDic objectForKey:@"result"];
                
                if (result)
                {
                    self.CrasheyeSdkNewVersion = [result objectForKey:@"version"];
                    self.CrasheyeSdkDownloadUrl = [result objectForKey:@"url"];
                    
                    NSLog(@"%@ %@", self.CrasheyeSdkNewVersion, self.CrasheyeSdkDownloadUrl);
                }
                
            }
        }
        
        handler();
    }];
}

- (void) downloadCrashSDK:(void (^)()) handler
{
        //NSURL* docsetURL = [NSURL URLWithString:@"http://www.crasheye.cn/downloads/sdk/ios/crasheye_ios_v1.2.3.zip"];
    
    if (self.CrasheyeSdkDownloadUrl == nil ||
        [self.CrasheyeSdkDownloadUrl length] <= 0)
    {
        return;
    }
    
    NSURL* docsetURL = [NSURL URLWithString:self.CrasheyeSdkDownloadUrl];
    [self.xcodeConsole appendText:@"Downloading... Crasheye SDK\nplease wait, this may take a few seconds\n"];

    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:docsetURL] queue:[NSOperationQueue mainQueue]  completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError)
        {
            [self.xcodeConsole appendText:[NSString stringWithFormat:@":( Downloading  Crasheye SDK Failed:%@", connectionError]];
        }
        else
        {
            if (data)
            {
                NSLog(@"Download Crasheye SDK OK %ld", [data length]);
                NSError * err = nil;
                ZZArchive* zip = [ZZArchive archiveWithData:data error:&err];
                
                if (err != nil)
                {
                    [self.xcodeConsole appendText:[NSString stringWithFormat:@"UnZip Crasheye SDK to local SDK Failed.. %@", err]];
                    return ;
                }
                
                NSString * crashDir = [self.mProject.directoryPath stringByAppendingPathComponent:@"Crasheye"];
//                NSString * aFile = [crashDir stringByAppendingPathComponent:@"libCrasheye.lib"];
//                NSString * hFile = [crashDir stringByAppendingPathComponent:@"Crasheye.header"];
                
                [[NSFileManager defaultManager] createDirectoryAtPath:crashDir withIntermediateDirectories:YES attributes:nil error:&err];
                
                if (err != nil)
                {
//                    [self.xcodeConsole appendText:[NSString stringWithFormat:@"Write Crasheye SDK to local SDK Failed.. %@", err]];
//                    return ;
                }
                
                for (ZZArchiveEntry* archiveEntry in zip.entries)
                {
                    if ([[archiveEntry fileName] isEqualToString:@"Crasheye.h"])
                    {
                        NSData * fileData = [archiveEntry newDataWithError:nil];
                        
                        self.headerFileData = fileData;
                        continue;
                    }
                    
                    if ([[archiveEntry fileName] isEqualToString:@"libCrasheye.a"])
                    {
                        NSData * fileData = [archiveEntry newDataWithError:nil];
                        
                        self.libFileData = fileData;
                        continue;
                    }
                }
                
                [self.xcodeConsole appendText:@"Download Crasheye Finish, Installing..."];
            }
        }
        
        handler();
    }];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
