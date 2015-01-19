//
//  VotingTableViewController.m
//  friends
//
//  Created by Patrick@fuhu on 1/19/15.
//  Copyright (c) 2015 FUHU. All rights reserved.
//

#import "VotingTableViewController.h"
#import "CandidateTableViewCell.h"
#import <Parse/Parse.h>

#define UNSELECT_ANYONE -1

@interface VotingTableViewController ()

@property (nonatomic,assign) NSInteger selectIndex;

@end

@implementation VotingTableViewController
@synthesize selectIndex;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CandidateTableViewCell" bundle:nil] forCellReuseIdentifier:@"CandidateTableViewCell"];
    [self.tableView registerClass: [UITableViewCell class] forCellReuseIdentifier:@"ResetCell"];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    selectIndex=UNSELECT_ANYONE;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section==0)
        return [self.arrayCandidates count];
    
    return 1;
}

-(NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(section==0)
        return @"請直接點選您支持的會長候選人，點按後將出現選舉章，送出投票前您都可以隨時修改您的選擇";
    return nil;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section==0){
        CandidateTableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:@"CandidateTableViewCell"];
        
        PFObject* obj=[self.arrayCandidates objectAtIndex:indexPath.row];
        NSString* title=[NSString stringWithFormat:@"%@ %@",[CIRCLE_NUMERS objectAtIndex:[obj[@"Number"] intValue]],obj[@"Name"]];
        cell.lblName.text=title;
        
        [cell.imgVoting setHidden:indexPath.row!=selectIndex];
        
        return cell;
    }else{
        static NSString* reuseIdentifier=@"ResetCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
        
        if(cell==nil){
            cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        }
        cell.textLabel.text=indexPath.section==1?@"清除選擇":@"投票";
        
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        return cell;
    }
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==0){
        selectIndex=indexPath.row;
        [tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    if(indexPath.section==1){
        selectIndex=UNSELECT_ANYONE;
        [tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
