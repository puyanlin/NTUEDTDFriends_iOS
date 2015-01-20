//
//  VotingTableViewController.m
//  friends
//
//  Created by Patrick@fuhu on 1/19/15.
//  Copyright (c) 2015 FUHU. All rights reserved.
//

#import "VotingTableViewController.h"
#import "CandidateTableViewCell.h"
#import "CenterColorableTextCell.h"
#import "VoteValidationCell.h"
#import <Parse/Parse.h>

#define UNSELECT_ANYONE 25535

@interface VotingTableViewController ()

@property (nonatomic,assign) NSInteger selectIndex;
@property (nonatomic,strong) PFObject* mTicket;
@property (nonatomic,assign) ValidState validState;
@property (nonatomic,retain) NSString* typedSerial;

@property (nonatomic,assign) BOOL isVoting;

@end

@implementation VotingTableViewController
@synthesize selectIndex;
@synthesize mTicket;
@synthesize validState;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CandidateTableViewCell" bundle:nil] forCellReuseIdentifier:@"CandidateTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"CenterColorableTextCell" bundle:nil] forCellReuseIdentifier:@"CenterColorableTextCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"VoteValidationCell" bundle:nil] forCellReuseIdentifier:@"VoteValidationCell"];
    
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
    return validState==stateCorrect?4:3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section==0)
        return [self.arrayCandidates count];
    
    return 1;
}

-(NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(section==0)
        return @"請直接點選您支持的會長候選人，點按後將出現選舉章，送出投票前您都可以隨時修改您的選擇。";
    if(section==2) return @"投票序號";
    return nil;
}

-(NSString*) tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    if(section==1)
        return @"點選清除選擇可取消目前所有選擇，沒有選擇任何候選人的選票投出後將成為廢票。";
    return nil;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section==0){
        CandidateTableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:@"CandidateTableViewCell"];
        
        PFObject* obj=[self.arrayCandidates objectAtIndex:indexPath.row];
        NSString* title=[NSString stringWithFormat:@"%@ %@",[CIRCLE_NUMERS objectAtIndex:[obj[@"Number"] intValue]],obj[@"Name"]];
        cell.lblName.text=title;
        
        [cell.imgVoting setHidden:indexPath.row!=selectIndex];
        
        return cell;
    }else if(indexPath.section==1||indexPath.section==3){
        static NSString* reuseIdentifier=@"CenterColorableTextCell";
        CenterColorableTextCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        cell.lblText.text=indexPath.section==1?@"清除選擇":@"投票";
        
        if(indexPath.section!=1){
            [cell.lblText setTextColor:[UIColor redColor]];
            CALayer *btnLayer = [cell.lblText layer];
            [btnLayer setBorderWidth:2.0f];
            [btnLayer setMasksToBounds:YES];
            [btnLayer setCornerRadius:10.0f];
            [btnLayer setBorderColor:[UIColor redColor].CGColor];
            
            [cell.votingIndicator setHidden:!self.isVoting];
        }
        
        return cell;
    }else{
        static NSString* reuseIdentifier=@"VoteValidationCell";
        VoteValidationCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        cell.txtfieldSeriel.delegate=self;
        cell.accessoryType=UITableViewCellAccessoryNone;
        [cell.indicatorCheckSerial setHidden:TRUE];
        [cell.txtfieldSeriel setTextColor:[UIColor blackColor]];
        [cell.txtfieldSeriel setText:self.typedSerial];
        
        [cell.txtfieldSeriel addTarget:self
                                     action:@selector(textFieldDidChange:)
                           forControlEvents:UIControlEventEditingChanged];
        
        switch (validState) {
            case stateChecking:
                [cell.indicatorCheckSerial setHidden:FALSE];
                break;
            case stateCorrect:
                cell.accessoryType=UITableViewCellAccessoryCheckmark;
                [cell.txtfieldSeriel setTextColor:[UIColor greenColor]];
                [cell.txtfieldSeriel setEnabled:FALSE];
                break;
            case stateError:
                [cell.txtfieldSeriel setTextColor:[UIColor redColor]];
                break;
            case stateNormal:
            default:
                break;
        }
        
        return cell;
    }
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.isVoting) return;
    if(indexPath.section==0){
        selectIndex=indexPath.row;
        [tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    if(indexPath.section==1){
        selectIndex=UNSELECT_ANYONE;
        [tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    if(indexPath.section==3){
        self.isVoting=TRUE;
        [tableView reloadSections:[NSIndexSet indexSetWithIndex:3] withRowAnimation:UITableViewRowAnimationAutomatic];
        [mTicket setObject:[NSNumber numberWithInteger:selectIndex+1] forKey:@"selectNum"];//+1 for human read
        [mTicket saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if(succeeded){
                [self.navigationController popViewControllerAnimated:TRUE];
                
                [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:VotedKey];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
        }];
    }
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    validState=stateChecking;
    
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    PFQuery* validQuery=[PFQuery queryWithClassName:@"DTDMajorVoting"];
    [validQuery whereKey:@"objectId" equalTo:self.typedSerial];
    [validQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error&&[objects count]){
            mTicket=[objects firstObject];
            validState=stateCorrect;
            
            if([mTicket[@"selectNum"] integerValue]>0){ //had voted
                
                PFObject* obj=[self.arrayCandidates objectAtIndex:[mTicket[@"selectNum"] integerValue]-1];
                NSString* candidate=[NSString stringWithFormat:@"%@ %@",[CIRCLE_NUMERS objectAtIndex:[obj[@"Number"] intValue]],obj[@"Name"]];
                
                UIAlertView* alertView=[[UIAlertView alloc] initWithTitle:@"您已經投過票了" message:[NSString stringWithFormat:@"您已投給 %@，謝謝您",candidate] delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
                [alertView show];
                [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:VotedKey];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }else{
                [self.tableView reloadData];
            }
        }else{
            validState=stateError;
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        
    }];
    
    return [textField resignFirstResponder];
}

-(void) textFieldDidChange:(UITextField*) textfield{
    self.typedSerial=textfield.text;
    if(validState==stateError){
        validState=stateNormal;
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self.navigationController popViewControllerAnimated:TRUE];
}
@end
