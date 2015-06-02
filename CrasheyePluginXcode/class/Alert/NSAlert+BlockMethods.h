//
//  NSAlert+BlockMethods.h
//
//  Created by Jakob Egger on 22/11/13.
//

#import <Cocoa/Cocoa.h>

@interface NSAlert (BlockMethods)

-(void)compatibleBeginSheetModalForWindow:(NSWindow *)sheetWindow completionHandler:(void (^)(NSInteger returnCode))handler;

@end
