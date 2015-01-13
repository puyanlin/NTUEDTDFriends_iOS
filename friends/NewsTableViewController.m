//
//  NewsTableViewController.m
//  friends
//
//  Created by Puyan on 2015/1/9.
//  Copyright (c) 2015年 FUHU. All rights reserved.
//

#import "NewsTableViewController.h"
#import <Parse/Parse.h>
#import "NewsDetailViewController.h"
#import "GAI.h"
#import "GAIFields.h"
#import "GAIDictionaryBuilder.h"

@interface NewsTableViewController ()

@end

@implementation NewsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    // returns the same tracker you created in your app delegate
    // defaultTracker originally declared in AppDelegate.m
    id tracker = [[GAI sharedInstance] defaultTracker];
    
    // This screen name value will remain set on the tracker and sent with
    // hits until it is set to a new value or to nil.
    [tracker set:kGAIScreenName
           value:@"NewsTableViewController"];
    
    // manual screen tracking
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (PFTableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
                        object:(PFObject *)obj{
    
    PFTableViewCell* cell=[super tableView:tableView cellForRowAtIndexPath:indexPath object:obj];

    
    cell.textLabel.text=obj[@"title"];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    PFObject* obj=[self.objects objectAtIndex:indexPath.row];
    NewsDetailViewController* vc=[storyboard instantiateViewControllerWithIdentifier:@"NewsDetailViewController"];
    vc.title=obj[@"title"];
    vc.pfObj=obj;
    [self.navigationController pushViewController:vc animated:TRUE];
}


@end
