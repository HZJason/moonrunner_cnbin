//
//  PastRunsViewController.m
//  waiqintong
//
//  Created by Apple on 11/9/15.
//  Copyright © 2015 cnbin. All rights reserved.
//

#import "PastRunsViewController.h"
#import "RunDetailsViewController.h"
#import "MathController.h"
#import "Run.h"
#import "RunCell.h"

@interface PastRunsViewController ()

@end

@implementation PastRunsViewController

#pragma mark - Table View

- (void)viewDidLoad {
    
    [super viewDidLoad];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.runArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RunCell *cell = (RunCell *)[tableView dequeueReusableCellWithIdentifier:@"RunCell"];
    Run *runObject = [self.runArray objectAtIndex:indexPath.row];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    cell.dateLabel.text = [formatter stringFromDate:runObject.timestamp];
    
    cell.distanceLabel.text = [MathController stringifyDistance:runObject.distance.floatValue];
    
    return cell;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue destinationViewController] isKindOfClass:[RunDetailsViewController class]]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Run *run = [self.runArray objectAtIndex:indexPath.row];
        [(RunDetailsViewController *)[segue destinationViewController] setRun:run];
    
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
