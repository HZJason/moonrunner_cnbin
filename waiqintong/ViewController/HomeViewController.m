//
//  HomeViewController.m
//  waiqintong
//
//  Created by Apple on 11/9/15.
//  Copyright © 2015 cnbin. All rights reserved.
//

#import "HomeViewController.h"
#import "NewRunViewController.h"
#import "PastRunsViewController.h"

@interface HomeViewController ()

@property (strong, nonatomic) NSArray *runArray;

@end

@implementation HomeViewController


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Run" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timestamp" ascending:NO];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    self.runArray = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
 
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIViewController *nextController = [segue destinationViewController];
    if ([nextController isKindOfClass:[NewRunViewController class]]) {
        ((NewRunViewController *) nextController).managedObjectContext = self.managedObjectContext;
    } else if ([nextController isKindOfClass:[PastRunsViewController class]]) {
       ((PastRunsViewController *) nextController).runArray = self.runArray;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}

@end
