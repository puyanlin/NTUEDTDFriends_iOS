//
//  DonationTableViewController.m
//  friends
//
//  Created by Patrick@fuhu on 1/8/15.
//  Copyright (c) 2015 FUHU. All rights reserved.
//

#import "DonationTableViewController.h"
#import "GAI.h"
#import "GAIFields.h"
#import "GAIDictionaryBuilder.h"

#define TAG_INFO 100

@interface DonationTableViewController ()

@end

@implementation DonationTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self.tableView registerClass: [UITableViewCell class] forCellReuseIdentifier:@"infoCell"];
    
}
-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    // returns the same tracker you created in your app delegate
    // defaultTracker originally declared in AppDelegate.m
    id tracker = [[GAI sharedInstance] defaultTracker];
    
    // This screen name value will remain set on the tracker and sent with
    // hits until it is set to a new value or to nil.
    [tracker set:kGAIScreenName
           value:@"DonationTableViewController"];
    
    // manual screen tracking
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section==1||section==2||section==5) return 1;
    return 0;
}

-(NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(section==0){
        return @"個人或營利事業捐款於國立臺北教育大學，視為對政府之捐贈，收據可於列舉扣除額100％抵稅，不受金額限制。";
    }
    if(section==1){
        return @"信用卡捐款";
    }
    if(section==2){
        return @"銀行匯款與ATM轉帳";
    }
    if(section==3){
        return @"支票\n抬頭請寫「國立臺北教育大學校務基金401專戶」為收款人，並註明禁止背書轉讓，指定用於「數位科技設計系/玩具與遊戲設計研究所」，以掛號郵寄「106台北市和平東路二段134號國立臺北教育大學校友中心收」";
    }
    if(section==4){
        return @"現金\n請逕至國立臺北教育大學出納組捐款。";
    }
    return nil;
}

-(NSString*) tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    if(section==1){
        return @"填寫完畢後，傳真或送至校友中心，傳真電話：(02)27388427";
    }
    if(section==2){
        return @"匯款或轉帳後，將憑證及您的姓名、連絡電話及指定用於「數位科技設計系/玩具與遊戲設計研究所」，傳真至國立臺北教育大學校友中心，傳真電話：02-27388427";
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"infoCell" forIndexPath:indexPath];
    
    cell.accessoryType=UITableViewCellAccessoryNone;
    cell.textLabel.text=@"";
    
    UILabel* lblInformation;
    if(indexPath.section==1||indexPath.section==5){
        
        cell.textLabel.text=indexPath.section==1?@"捐款授權書":@"國立臺北教育大學校友中心";
        
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }else if(indexPath.section==2){
        
        if (![cell viewWithTag:TAG_INFO])
        {
            
            lblInformation = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, cell.contentView.frame.size.width-40, cell.contentView.frame.size.height)];
            lblInformation.font = [UIFont fontWithName:@"BradleyHandITCTT" size: 25.0];
            lblInformation.textColor = [UIColor blackColor];
            lblInformation.textAlignment = NSTextAlignmentLeft;
            lblInformation.numberOfLines = 0;
            lblInformation.backgroundColor = [UIColor clearColor];
            
            lblInformation.tag = TAG_INFO;
            
            [cell.contentView addSubview:lblInformation];
            
            
        }
        else
        {
            lblInformation = (UILabel *) [cell viewWithTag:TAG_INFO];
        }
        lblInformation.text=@"中國信託商業銀行\n國立臺北教育大學校務基金401專戶\n帳號：185-35000-4105";
        
    }
    
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==1||indexPath.section==5){
        NSURL *urlApp = [NSURL URLWithString:indexPath.section==1?@"http://site.puyan.idv.tw:8080/share.cgi?ssid=0Wtc3D8&fid=0Wtc3D8&ep=LS0tLQ==&open=normal":@"http://alumnus.ntue.edu.tw/donation2.php"];
        [[UIApplication sharedApplication] openURL:urlApp];
    }
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==2)
        return 80;
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}

@end
