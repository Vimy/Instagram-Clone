//
//  MapViewController.m
//  Instagram-Clone
//
//  Created by Matthias Vermeulen on 25/10/14.
//  Copyright (c) 2014 Noizy. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController () <MKMapViewDelegate>

@end

@implementation MapViewController

- (void)setMapView:(MKMapView *)mapView
{
    _mapView = mapView;
    self.mapView.delegate = self;
    [self updateMapViewAnnotations];
    NSLog(@"mapview");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)updateMapViewAnnotations
{
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView addAnnotations:self.photosByUser];
    [self.mapView showAnnotations:self.photosByUser animated:YES];

}



@end
