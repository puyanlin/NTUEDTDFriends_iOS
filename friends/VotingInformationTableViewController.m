//
//  VotingInformationTableViewController.m
//  friends
//
//  Created by Patrick@fuhu on 1/16/15.
//  Copyright (c) 2015 FUHU. All rights reserved.
//

#import "VotingInformationTableViewController.h"

#define CIRCLE_NUMERS @[@"①",@"②",@"③",@"④",@"⑤",@"⑥",@"⑦",@"⑧",@"⑨"]

@interface VotingInformationTableViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;
@property (strong,nonatomic) NSArray* arrayCandidate;
@property (nonatomic,assign) Boolean hasLoaded;

@end

@implementation VotingInformationTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self.tableView registerClass: [UITableViewCell class] forCellReuseIdentifier:@"CandiCell"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.screenName = @"VotingInformationTableViewController";
    
    PFQuery* qurey=[PFQuery queryWithClassName:@"DTDCandidate"];
    
    [qurey findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error){
            self.arrayCandidate=[objects copy];
            [self.tableView setScrollEnabled:TRUE];
            [self.loadingIndicator setHidden:TRUE];
            self.hasLoaded=TRUE;
            
            [self.tableView reloadData];
        }
    }];
}

#pragma mark - Table view data source

-(UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section==0&&self.hasLoaded){
        UILabel* lblVoted=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
        lblVoted.numberOfLines=0;
        Boolean voted=[[NSUserDefaults standardUserDefaults] boolForKey:VotedKey];
    
        lblVoted.text=voted?@"您已投票。":@"您尚未投票\n投票至7/30 24:00";
        lblVoted.textAlignment=NSTextAlignmentCenter;
        lblVoted.textColor=voted?[UIColor darkGrayColor]:[UIColor redColor];
        UIView* headerView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
        [headerView addSubview:lblVoted];
        return headerView;
    }
    return nil;
}
-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section==0)
        return 50;
    return 10;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    switch (section) {
        case 0:
            return 0;
        case 1:
            return [self.arrayCandidate count];
        default:
            break;
    }
    Boolean voted=[[NSUserDefaults standardUserDefaults] boolForKey:VotedKey];
    if(voted) return 0;
    return self.hasLoaded?1:0;
}
-(NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(section==1&&self.hasLoaded){
        return @"候選人";
    }
    return nil;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* reuseIdentifier=@"CandiCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    if(cell==nil){
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    
    if(indexPath.section==1){

        PFObject* obj=[self.arrayCandidate objectAtIndex:indexPath.row];
        
        NSString* title=[NSString stringWithFormat:@"%@ %@",[CIRCLE_NUMERS objectAtIndex:[obj[@"Number"] intValue]],obj[@"Name"]];
        cell.textLabel.text=title;
        
    }else{
        cell.textLabel.text=@"前往投票";
    }
    
    cell.accessoryType=indexPath.section==1?UITableViewCellAccessoryDetailButton: UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==1){
        CadidateDetailTableViewController* vc=[[CadidateDetailTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
        PFObject* obj=[self.arrayCandidate objectAtIndex:indexPath.row];
        vc.cadidateObj=obj;
        NSString* title=[NSString stringWithFormat:@"%@ %@",[CIRCLE_NUMERS objectAtIndex:[obj[@"Number"] intValue]],obj[@"Name"]];
        vc.title=title;
        [self.navigationController pushViewController:vc animated:TRUE];
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
