//
//  CadidateDetailTableViewController.m
//  friends
//
//  Created by Patrick@fuhu on 1/16/15.
//  Copyright (c) 2015 FUHU. All rights reserved.
//

#import "CadidateDetailTableViewController.h"
#import "UIImageView+WebCache.h"

@interface CadidateDetailTableViewController ()
@property (nonatomic,strong) NSArray* arrayExperience;
@property (nonatomic,retain) NSArray* arrayPolitics;
@end

@implementation CadidateDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self.tableView registerClass: [UITableViewCell class] forCellReuseIdentifier:@"CandiCellInfo"];
    [self.tableView registerClass: [UITableViewCell class] forCellReuseIdentifier:@"CandiCellExp"];
    [self.tableView registerClass: [UITableViewCell class] forCellReuseIdentifier:@"CandiCellPoli"];
    
    self.arrayExperience=self.cadidateObj[@"Experience"];
    self.arrayPolitics=self.cadidateObj[@"Politics"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

-(UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section==0){
        UIImageView *headIcon=[[UIImageView alloc] initWithFrame:CGRectMake(self.tableView.frame.size.width/2-75, 5, 150, 150)];
        UIView* headerView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 160)];
        
        [headIcon sd_setImageWithURL:[NSURL URLWithString:self.cadidateObj[@"ImageUrl"]]];
        
        headIcon.contentMode = UIViewContentModeScaleAspectFit;
        
        [headerView addSubview:headIcon];
    
        return headerView;
    }
    return nil;
}
-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section==0) return 160;
    return 20;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section==0) return 0;
    if(section==1) return 1;
    if(section==2) return [self.arrayExperience count];
    else return [self.arrayPolitics count];
}

-(NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
            break;
        case 1:
            return @"系友資料";
        case 2:
            return @"經歷";
        case 3:
            return @"政見";
        default:
            break;
    }
    return nil;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.section==1){
        static NSString* reuseIdentifier=@"CandiCellInfo";
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
        
        cell.textLabel.text=self.cadidateObj[@"Class"];
        cell.detailTextLabel.text=[NSString stringWithFormat:@"%@級",self.cadidateObj[@"Grade"]];
        
        return cell;
    }else if(indexPath.section==2){
        static NSString* reuseIdentifier=@"CandiCellExp";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
        
        if(cell==nil){
            cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        }
        
        cell.textLabel.text=[self.arrayExperience objectAtIndex:indexPath.row];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        return cell;
    }else{
        
        static NSString* reuseIdentifier=@"CandiCellPoli";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
        
        if(cell==nil){
            cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        }
        
        cell.textLabel.text=[self.arrayPolitics objectAtIndex:indexPath.row];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        return cell;
    }
}


@end
