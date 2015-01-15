//
//  JobTableViewController.m
//  friends
//
//  Created by Patrick@fuhu on 1/15/15.
//  Copyright (c) 2015 FUHU. All rights reserved.
//

#import "JobTableViewController.h"
#import <Parse/Parse.h>
#import "NewsDetailViewController.h"

#define TITLE_CATEGORIES @[@"資訊",@"設計",@"管理",@"工讀",@"其他"]
#define NO_JOB_DATA @"暫無職缺資料"

@interface JobTableViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,retain) NSMutableArray* arrayCSjobs;
@property (nonatomic,retain) NSMutableArray* arrayDesignjobs;
@property (nonatomic,retain) NSMutableArray* arrayManagerjobs;
@property (nonatomic,retain) NSMutableArray* arrayPTjobs;
@property (nonatomic,retain) NSMutableArray* arrayOtherjobs;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;
@end

@implementation JobTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self.tableView registerClass: [UITableViewCell class] forCellReuseIdentifier:@"OpptunitiesCell"];

}
-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.screenName = @"JobTableViewController";
}

-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [[PFQuery queryWithClassName:@"DTDJobs"] findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error){
            self.arrayCSjobs=[[NSMutableArray alloc] init];
            self.arrayDesignjobs=[[NSMutableArray alloc] init];
            self.arrayManagerjobs=[[NSMutableArray alloc] init];
            self.arrayPTjobs=[[NSMutableArray alloc] init];
            self.arrayOtherjobs=[[NSMutableArray alloc] init];
            
            for(PFObject* op in objects){
                if([op[@"Category"] isEqualToString:@"CS"]){
                    [self.arrayCSjobs addObject:op];
                }
                if([op[@"Category"] isEqualToString:@"DESIGN"]){
                    [self.arrayDesignjobs addObject:op];
                }
                if([op[@"Category"] isEqualToString:@"MANAGE"]){
                    [self.arrayManagerjobs addObject:op];
                }
                if([op[@"Category"] isEqualToString:@"PT"]){
                    [self.arrayPTjobs addObject:op];
                }
                if([op[@"Category"] isEqualToString:@"OTHER"]){
                    [self.arrayOtherjobs addObject:op];
                }
            }
            [self.loadingIndicator setHidden:true];

            [self.tableView reloadData];
        }
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return [self.arrayCSjobs count];
        case 1:
            return [self.arrayDesignjobs count];
        case 2:
            return [self.arrayManagerjobs count];
        case 3:
            return [self.arrayPTjobs count];
        case 4:
            return [self.arrayOtherjobs count];
    }
    return 0;
}

-(NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [TITLE_CATEGORIES objectAtIndex:section];
}
-(NSString*) tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    switch (section) {
        case 0:
            if(![self.arrayCSjobs count]) return NO_JOB_DATA;
            break;
        case 1:
            if(![self.arrayDesignjobs count]) return NO_JOB_DATA;
            break;
        case 2:
            if(![self.arrayManagerjobs count]) return NO_JOB_DATA;
            break;
        case 3:
            if(![self.arrayPTjobs count]) return NO_JOB_DATA;
            break;
        case 4:
            if(![self.arrayOtherjobs count]) return NO_JOB_DATA;
            break;
    }
    return nil;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* reuseIdentifier=@"OpptunitiesCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    if(cell==nil){
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    
    switch (indexPath.section) {
        case 0:
            cell.textLabel.text=[self.arrayCSjobs objectAtIndex:indexPath.row][@"Title"];
            break;
        case 1:
            cell.textLabel.text=[self.arrayDesignjobs objectAtIndex:indexPath.row][@"Title"];
            break;
        case 2:
            cell.textLabel.text=[self.arrayManagerjobs objectAtIndex:indexPath.row][@"Title"];
            break;
        case 3:
            cell.textLabel.text=[self.arrayPTjobs objectAtIndex:indexPath.row][@"Title"];
            break;
        case 4:
            cell.textLabel.text=[self.arrayOtherjobs objectAtIndex:indexPath.row][@"Title"];
            break;
    }
    
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    return cell;
}


-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    PFObject* obj;
    switch (indexPath.section) {
        case 0:
            obj=[self.arrayCSjobs objectAtIndex:indexPath.row];
            break;
        case 1:
            obj=[self.arrayDesignjobs objectAtIndex:indexPath.row];
            break;
        case 2:
           obj=[self.arrayManagerjobs objectAtIndex:indexPath.row];
            break;
        case 3:
            obj=[self.arrayPTjobs objectAtIndex:indexPath.row];
            break;
        case 4:
            obj=[self.arrayOtherjobs objectAtIndex:indexPath.row];
            break;
    }
    
    NewsDetailViewController* vc=[storyboard instantiateViewControllerWithIdentifier:@"NewsDetailViewController"];
    vc.title=obj[@"Title"];
    vc.pfObj=obj;
    [self.navigationController pushViewController:vc animated:TRUE];
}
@end
