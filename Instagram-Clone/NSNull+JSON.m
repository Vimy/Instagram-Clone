//
//  NSNull+JSON.m
//  Instagram-Clone
//
//  Created by Matthias Vermeulen on 9/10/14.
//  Copyright (c) 2014 Noizy. All rights reserved.
//

#import "NSNull+JSON.h"

@implementation NSNull (JSON)

-(NSString*) stringValue {
    return nil;
}


-(NSNumber*) numberValue
{
    return nil;
}


-(float) floatValue
{
    return 0;
}


-(double) doubleValue
{
    return 0;
}


-(BOOL) boolValue
{
    return NO;
}


-(int) intValue
{
    return 0;
}


-(long) longValue
{
    return 0;
}


-(long long) longLongValue
{
    return 0;
}


-(unsigned long long) unsignedLongLongValue
{
    return 0;
}







@end
