//
//  NSArray+NSArrayExtension.h
//  ksg QC
//
//  Created by Gang.Wang on 12-5-15.
//  Copyright (c) 2012年 Gang.Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (NSArrayExtension)
- (NSArray *) randomizedArray; 

+ (BOOL) isNilOrEmpty:(NSArray *) array;

- (NSString *) bondingAString:(NSString *) linkSymbol;
- (NSString *) bondingAString;

- (NSArray *) subarrayWithRangeEx:(NSRange)range;

- (NSArray *) subArrayWithAegularlySpaced:(NSUInteger) spaced;

@end


@interface NSMutableArray (NSArrayExtension)
+ (BOOL) isNilOrEmpty:(NSMutableArray *) array;

//- (NSString *) bondingAString:(NSString *) linkSymbol;
//- (NSString *) bondingAString;

- (NSArray *) subArrayWithAegularlySpaced:(NSUInteger) spaced;

@end