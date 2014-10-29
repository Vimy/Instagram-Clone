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
    NSLog(@"Hoi %f", [self.latitude doubleValue]);
    return coordinate;
}

@end
