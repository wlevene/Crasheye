//
//  NSArray+NSArrayExtension.m
//  ksg QC
//
//  Created by Gang.Wang on 12-5-15.
//  Copyright (c) 2012年 Gang.Wang. All rights reserved.
//

#import "NSArray+NSArrayExtension.h"
//#import "NSObject+Extension.h"

//#import "header.h"

@implementation NSArray (NSArrayExtension)

- (NSArray *) randomizedArray {  
    NSMutableArray *results = [NSMutableArray arrayWithArray:self];  
    
    NSUInteger i = [results count];
    while(--i > 0) {  
        int j = rand() % (i+1);  
        [results exchangeObjectAtIndex:i withObjectAtIndex:j];  
    }  
    
    return [NSArray arrayWithArray:results];  
}  

+ (BOOL) isNilOrEmpty:(NSArray *) array
{
    if ((NSObject *)array == [NSNull null] ||
        !array ||
        [array count] <= 0) 
    {
        return TRUE;
    }
    
    return FALSE;
}

- (NSString *) bondingAString:(NSString *) linkSymbol
{
    NSString * result = @"";
    NSUInteger count = [self count];
    if (count == 1) 
    {
        id obj = [self objectAtIndex:0];
        if ([obj isKindOfClass:[NSString class]]) 
        {
            result = [result stringByAppendingFormat:@"%@", obj];
        }
        
        return result;
    }
    
    
    for (int i = 0; i < count; i++) 
    {
        id obj = [self objectAtIndex:i];
        if ([obj isKindOfClass:[NSString class]]) 
        {
            result = [result stringByAppendingFormat:@"%@", obj];
            
            if (i < count - 1) 
            {
                result = [result stringByAppendingFormat:@"%@", linkSymbol];
            }
        }
    }
    
    return result;
}

- (NSString *) bondingAString
{
    return [self bondingAString:@","];
}


- (NSArray *) subarrayWithRangeEx:(NSRange)range
{
    NSInteger local = range.location;
    NSInteger len = range.length;
    
    if (local < 0 ||
        local >= [self count])
    {
        return nil;
    }
    
    if(len > ([self count] - local))
    {
        len = ([self count] - local);
    }


    if ( len <= 0)
    {
        return nil;
    }

    return [self subarrayWithRange:NSMakeRange(local, len)];

}


- (NSArray *) subArrayWithAegularlySpaced:(NSUInteger) spaced
{
    if (spaced <= 0) {
        return nil;
    }
    
    float incrementor = (float)[self count] / (float)spaced;
    float tracking = 0.0f;
    
    NSMutableArray * result = [NSMutableArray array];
    NSMutableArray * addedIndex = [NSMutableArray array];
    
    for (int j = 0; j < (spaced < (self.count - 1) ? (self.count - 1) : spaced); j++)
    {
        tracking += incrementor;
        int index = (int)(tracking + 0.5);
        if (index < 0 ||
            index >= [self count])
        {
            continue;
        }
        
        if ([addedIndex containsObject:[NSNumber numberWithInt:index]])
        {
            continue;
        }
        
        [result addObject:[self objectAtIndex:index]];
        [addedIndex addObject:[NSNumber numberWithInt:index]];
    }
    
    if (result.count < spaced)
    {
        NSUInteger index = [result indexOfObject:[self firstObject]];
        if (index == NSNotFound)
        {
            [result insertObject:[self firstObject] atIndex:0];
        }
    }
    
    if (result.count < spaced)
    {
        NSUInteger index = [result indexOfObject:[self lastObject]];
        if (index == NSNotFound)
        {
            [result addObject:[self lastObject]];
        }
    }

    return result;
}

@end

@implementation NSMutableArray (NSArrayExtension)
+ (BOOL) isNilOrEmpty:(NSArray *) array
{
    if ((NSObject *)array == [NSNull null] ||
        !array ||
        [array count] <= 0) {
        return TRUE;
    }
    
    return FALSE;
}


- (NSArray *) subArrayWithAegularlySpaced:(NSUInteger) spaced
{
    if (spaced <= 0) {
        return nil;
    }
    
    float incrementor = (float)[self count] / (float)spaced;
    float tracking = 0.0f;
    
    NSMutableArray * result = [NSMutableArray array];
    NSMutableArray * addedIndex = [NSMutableArray array];
    
    for (int j = 0; j < (spaced < (self.count - 1) ? (self.count - 1) : spaced); j++)
    {
        tracking += incrementor;
        int index = (int)(tracking + 0.5);
        if (index < 0 ||
            index >= [self count])
        {
            continue;
        }
        
        if ([addedIndex containsObject:[NSNumber numberWithInt:index]])
        {
            continue;
        }
        
        [result addObject:[self objectAtIndex:index]];
        [addedIndex addObject:[NSNumber numberWithInt:index]];
    }
    
    if (result.count < spaced)
    {
        NSUInteger index = [result indexOfObject:[self firstObject]];
        if (index == NSNotFound)
        {
            [result insertObject:[self firstObject] atIndex:0];
        }
    }
    
    if (result.count < spaced)
    {
        NSUInteger index = [result indexOfObject:[self lastObject]];
        if (index == NSNotFound)
        {
            [result addObject:[self lastObject]];
        }
    }
    
    return result;
}


//- (NSString *) bondingAString:(NSString *) linkSymbol
//{
//    return [(NSArray *)self bondingAString:linkSymbol];
//}
//
//- (NSString *) bondingAString
//{
//    return [self bondingAString:@","];
//}
@end