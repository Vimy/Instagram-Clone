//
//  NSDictionary+NullReplacement.m
//  Instagram-Clone
//
//  Created by Matthias Vermeulen on 2/11/14.
//  Copyright (c) 2014 Noizy. All rights reserved.
//

#import "NSDictionary+NullReplacement.h"
#import "NSArray+NullReplacement.h"

@implementation NSDictionary (NullReplacement)


- (NSDictionary *)dictionaryByReplacingNullsWithBlanks
{
    const NSMutableDictionary *replaced = [self mutableCopy];
    const id nul = [NSNull null];
    const NSString *blank = @"";
    
    for (NSString *key in self)
    {
        id object = [self objectForKey:key];
        if (object == nul)
        {
            [replaced setObject:blank forKey:key];
        }
        else if ([object isKindOfClass:[NSDictionary class]])
        {
            [replaced setObject:[object dictionaryByReplacingNullsWithBlanks] forKey:key];
        }
        else if ([object isKindOfClass:[NSArray class]])
        {
            [replaced setObject:[object arrayByReplacingNullsWithBlanks] forKey:key];
        }
    }
    
    return [NSDictionary dictionaryWithDictionary:[replaced copy]];
}


@end
