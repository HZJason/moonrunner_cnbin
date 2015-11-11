//
//  RunDetailsViewController.m
//  waiqintong
//
//  Created by Apple on 11/9/15.
//  Copyright © 2015 cnbin. All rights reserved.
//

#import "RunDetailsViewController.h"
#import <MapKit/MapKit.h>
#import "MathController.h"
#import "Run.h"
#import "Location.h"
#import "MulticolorPolylineSegment.h"
#import "BadgeAnnotation.h"
#import "BadgeController.h"
#import "TrackingViewController.h"

static float const mapPadding = 1.1f;

@interface RunDetailsViewController ()<MKMapViewDelegate>

@property (strong, nonatomic) NSArray *colorSegmentArray;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *paceLabel;

@end

@implementation RunDetailsViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    TrackingViewController *nextController = [segue destinationViewController];
    nextController.locations = self.run.locations;
    nextController.trackingArray = self.run.locations.array;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureView];
    [self loadMap];
    self.mapView.delegate =self;
}

#pragma mark - Private

- (void)configureView
{
    self.distanceLabel.text = [MathController stringifyDistance:self.run.distance.floatValue];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    self.dateLabel.text = [formatter stringFromDate:self.run.timestamp];
    
    self.timeLabel.text = [NSString stringWithFormat:@"Time: %@",  [MathController stringifySecondCount:self.run.duration.intValue usingLongFormat:YES]];
    
    self.paceLabel.text = [NSString stringWithFormat:@"Pace: %@",  [MathController stringifyAvgPaceFromDist:self.run.distance.floatValue overTime:self.run.duration.intValue]];
    
}

- (void)loadMap
{
    if (self.run.locations.count > 0) {
        
        self.mapView.hidden = NO;
        [self.mapView setRegion:[self mapRegion]];
        [self.mapView addOverlays:self.colorSegmentArray];

    } else {
        
        self.mapView.hidden = YES;
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Error"
                                  message:@"Sorry, this run has no locations saved."
                                  delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
}

#pragma mark - Public

- (void)setRun:(Run *)newDetailRun
{
    if (_run != newDetailRun) {
        _run = newDetailRun;
        
        self.colorSegmentArray = [MathController colorSegmentsForLocations:newDetailRun.locations.array];
        NSLog(@"colorSegarray is %@",self.colorSegmentArray);
    }
}

#pragma mark - MKMapViewDelegate

- (MKCoordinateRegion)mapRegion
{
    MKCoordinateRegion region;
    Location *initialLoc = self.run.locations.firstObject;
    
    float minLat = initialLoc.latitude.floatValue;
    float minLng = initialLoc.longitude.floatValue;
    float maxLat = initialLoc.latitude.floatValue;
    float maxLng = initialLoc.longitude.floatValue;
    
    for (Location *location in self.run.locations) {
        if (location.latitude.floatValue < minLat) {
            minLat = location.latitude.floatValue;
        }
        if (location.longitude.floatValue < minLng) {
            minLng = location.longitude.floatValue;
        }
        if (location.latitude.floatValue > maxLat) {
            maxLat = location.latitude.floatValue;
        }
        if (location.longitude.floatValue > maxLng) {
            maxLng = location.longitude.floatValue;
        }
    }
    
    region.center.latitude = (minLat + maxLat) / 2.0f;
    region.center.longitude = (minLng + maxLng) / 2.0f;
    
    region.span.latitudeDelta = (maxLat - minLat) * mapPadding;
    region.span.longitudeDelta = (maxLng - minLng) * mapPadding;
    
    return region;
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id < MKOverlay >)overlay
{
    if ([overlay isKindOfClass:[MulticolorPolylineSegment class]]) {
        MulticolorPolylineSegment *polyLine = (MulticolorPolylineSegment *)overlay;
        MKPolylineRenderer *aRenderer = [[MKPolylineRenderer alloc] initWithPolyline:polyLine];
        aRenderer.strokeColor = polyLine.color;
        aRenderer.lineWidth = 3;
        return aRenderer;
    }
    
    return nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
