//
//  NSDictionary+NullReplacement.h
//  Instagram-Clone
//
//  Created by Matthias Vermeulen on 2/11/14.
//  Copyright (c) 2014 Noizy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (NullReplacement)

- (NSDictionary *)dictionaryByReplacingNullsWithBlanks;


@end
