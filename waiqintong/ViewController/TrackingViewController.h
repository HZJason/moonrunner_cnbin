//
//  TrackingViewController.h
//  waiqintong
//
//  Created by Apple on 11/10/15.
//  Copyright © 2015 cnbin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Location.h"

@interface TrackingViewController : UIViewController

@property (strong, nonatomic) NSArray *trackingArray;
@property (nonatomic, retain) NSOrderedSet *locations;

@end
