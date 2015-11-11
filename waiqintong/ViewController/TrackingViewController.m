//
//  TrackingViewController.m
//  waiqintong
//
//  Created by Apple on 11/10/15.
//  Copyright © 2015 cnbin. All rights reserved.
//

#import "TrackingViewController.h"
#import <MAMapKit/MAMapKit.h>
#import "Tracking.h"
#import "Run.h"
#import "Location.h"

@interface TrackingViewController ()<MAMapViewDelegate, TrackingDelegate> {
    
 
}

@property (nonatomic, strong) MAMapView *mapView;

@property (nonatomic, strong) Tracking *tracking;

@end

@implementation TrackingViewController

@synthesize mapView  = _mapView;
@synthesize tracking = _tracking;

#pragma mark - MAMapViewDelegate

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if (annotation == self.tracking.annotation)
    {
        static NSString *trackingReuseIndetifier = @"trackingReuseIndetifier";
        
        MAAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:trackingReuseIndetifier];
        
        if (annotationView == nil)
        {
            annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:trackingReuseIndetifier];
        }
        
        annotationView.canShowCallout = NO;
        annotationView.image = [UIImage imageNamed:@"ball"];
        
        return annotationView;
    }
    
    return nil;
}

- (MAOverlayView *)mapView:(MAMapView *)mapView viewForOverlay:(id <MAOverlay>)overlay
{
    if (overlay == self.tracking.polyline)
    {
        MAPolylineView *polylineView = [[MAPolylineView alloc] initWithPolyline:overlay];
        
        polylineView.lineWidth   = 4.f;
        polylineView.strokeColor = [UIColor redColor];
        
        return polylineView;
    }
    
    return nil;
}

#pragma mark - TrackingDelegate

- (void)willBeginTracking:(Tracking *)tracking
{
    NSLog(@"%s", __func__);
}

- (void)didEndTracking:(Tracking *)tracking
{
    NSLog(@"%s", __func__);
}

#pragma mark - Handle Action

- (void)handleRunAction
{
    if (self.tracking == nil)
    {
    
       
    }
    
    [self setupTracking];
    [self.tracking execute];
}

#pragma mark - Setup

/* 构建mapView. */
- (void)setupMapView
{
    [MAMapServices sharedServices].apiKey = @"c771d23c3702ab978d9e174e71562b45";
    
    self.mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
    self.mapView.delegate = self;
    
  
    [self.view addSubview:self.mapView];
}

/* 构建轨迹回放. */
- (void)setupTracking
{
     self.mapView.showsUserLocation = NO;

    self.tracking.delegate = self;
    self.tracking.mapView  = self.mapView;
    self.tracking.duration = 5.f;
    self.tracking.edgeInsets = UIEdgeInsetsMake(50, 50, 50, 50);
}

- (void)setupNavigationBar
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Run"
                                                                              style: UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(handleRunAction)];
}
#pragma mark - Life Cycle

- (instancetype)init
{
    if (self = [super init])
    {
        self.title = @"轨迹回放";
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupNavigationBar];
    [self setupMapView];
    
    NSMutableArray * latitudeArray = [[NSMutableArray alloc]init];
    NSMutableArray * longitudeArray = [[NSMutableArray alloc]init];

    for (Location * location in self.trackingArray) {
        
        [latitudeArray addObject:location.latitude];
        [longitudeArray addObject:location.longitude];
    }
    
    CLLocationCoordinate2D commuterLotCoords[self.trackingArray.count];
    
    for (int i=0; i<self.trackingArray.count; i++)
    {
        commuterLotCoords[i].latitude =[[latitudeArray objectAtIndex:i]doubleValue];
        commuterLotCoords[i].longitude =[[longitudeArray objectAtIndex:i]doubleValue];
    }
    
    self.tracking = [[Tracking alloc] initWithCoordinates:commuterLotCoords count:self.trackingArray.count];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.barStyle    = UIBarStyleBlack;
    self.navigationController.navigationBar.translucent = NO;

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    self.mapView.frame = self.view.bounds;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
