//
//  PastRunsViewController.h
//  waiqintong
//
//  Created by Apple on 11/9/15.
//  Copyright © 2015 cnbin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PastRunsViewController : UITableViewController

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSArray *runArray;

@end
