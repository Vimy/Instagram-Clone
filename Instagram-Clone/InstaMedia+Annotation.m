//
//  InstaMedia+Annotation.m
//  
//
//  Created by Matthias Vermeulen on 29/10/14.
//
//

#import "InstaMedia+Annotation.h"

@implementation InstaMedia (Annotation)

- (CLLocationCoordinate2D)coordinate
{
    
    CLLocationCoordinate2D coordinate;
    
    coordinate.latitude = [self.latitude doubleValue];
    coordinate.longitude = [self.longitude doubleValue];
    NSLog(@"latitude %f", [self.latitude doubleValue]);
    NSLog(@"longitude %f", [self.longitude doubleValue]);
    NSLog(@"---------");
    return coordinate;
}

@end
